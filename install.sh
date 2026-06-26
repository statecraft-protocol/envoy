#!/usr/bin/env bash
# install.sh - Install the Envoy CLI and MCP adapter binaries.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/install.sh | bash -s -- --help
#
# What it does:
#   1. Detects the supported platform.
#   2. Downloads the matching CLI and MCP adapter binaries from GitHub Releases.
#   3. Verifies SHA256SUMS with the pinned release signing key.
#   4. Verifies SHA256 checksum from the required SHA256SUMS manifest.
#   5. Installs to ~/.local/bin/envoy and ~/.local/bin/envoy-mcp.
#   6. Suggests PATH additions if needed.
#   7. Prints first commands for humans and agents.
#
# Environment variables:
#   ENVOY_INSTALL_DIR   Override install directory (default: ~/.local/bin)
#   ENVOY_VERSION       Pin a specific release tag (default: v0.3.1)

set -euo pipefail

REPO="${ENVOY_RELEASE_REPO:-statecraft-protocol/envoy}"
if [[ -n "${HOME:-}" ]]; then
    DEFAULT_INSTALL_DIR="${HOME}/.local/bin"
else
    DEFAULT_INSTALL_DIR=""
fi
INSTALL_DIR="${ENVOY_INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"
VERSION="${ENVOY_VERSION:-v0.3.1}"
SUPPORTED_PLATFORMS="macOS arm64 and Linux x86_64 with glibc"
SUPPORTED_PLATFORM_HELP_URL="https://github.com/statecraft-protocol/envoy/blob/v0.3.1/docs/INSTALL.md"
CHECKSUM_MANIFEST_NAME="SHA256SUMS"
CHECKSUM_SIGNATURE_NAME="SHA256SUMS.sig"
CHECKSUM_SIGNATURE_NAMESPACE="envoy-release-checksums-v1@statecraft.fyi"
CHECKSUM_SIGNATURE_PRINCIPAL="envoy-release"
# Production release checksum signing public key. The corresponding private key
# is held outside the repo by the release signer.
ENVOY_RELEASE_CHECKSUM_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeVK5EDP2zgidmolX5Xpehp7JqENtbPAF2egFUGqPSv envoy-release@statecraft.fyi"
ENVOY_TMP_DIR=""
ENVOY_INSTALL_TMP_FILE=""
ENVOY_MCP_INSTALL_TMP_FILE=""

# Helpers

usage() {
    cat <<'EOF'
envoy installer

USAGE
    curl -fsSL https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/install.sh | bash
    curl -fsSL https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/install.sh | bash -s -- [OPTIONS]

OPTIONS
    --help              Show this help message
    --dir DIR           Install envoy and envoy-mcp to DIR instead of ~/.local/bin
    --version VERSION   Install a specific release tag (e.g. vX.Y.Z)

ENVIRONMENT
    ENVOY_INSTALL_DIR   Same as --dir
    ENVOY_VERSION       Same as --version (tag name, e.g. vX.Y.Z)
EOF
    exit 0
}

info()  { printf '  > %s\n' "$*"; }
ok()    { printf '  > %s\n' "$*"; }
warn()  { printf '  > %s\n' "$*" >&2; }
fatal() { printf '  > ABORTED: %s\n' "$*" >&2; exit 1; }
fatal_lines() {
    local summary="$1"
    shift
    printf '  > ABORTED: %s\n' "$summary" >&2
    for line in "$@"; do
        printf '    %s\n' "$line" >&2
    done
    exit 1
}

cleanup_install() {
    if [[ -n "${ENVOY_TMP_DIR:-}" && -d "${ENVOY_TMP_DIR}" ]]; then
        rm -rf "${ENVOY_TMP_DIR}"
    fi
    if [[ -n "${ENVOY_INSTALL_TMP_FILE:-}" && -f "${ENVOY_INSTALL_TMP_FILE}" ]]; then
        rm -f "${ENVOY_INSTALL_TMP_FILE}"
    fi
    if [[ -n "${ENVOY_MCP_INSTALL_TMP_FILE:-}" && -f "${ENVOY_MCP_INSTALL_TMP_FILE}" ]]; then
        rm -f "${ENVOY_MCP_INSTALL_TMP_FILE}"
    fi
}

validate_release_repo() {
    local repo="$1"
    if [[ ! "$repo" =~ ^[A-Za-z0-9][A-Za-z0-9-]*/[A-Za-z0-9][A-Za-z0-9._-]*$ ]] ||
        [[ "$repo" == *".."* ]]; then
        fatal "ENVOY_RELEASE_REPO must be a GitHub owner/repo value, not a URL or path: ${repo}"
    fi
}

install_source_kind() {
    local asset_dir="${ENVOY_INSTALL_ASSET_DIR:-}"
    local base_url="${ENVOY_INSTALL_BASE_URL:-}"

    if [[ -n "$asset_dir" && -n "$base_url" ]]; then
        fatal "Set only one alternate install source: ENVOY_INSTALL_ASSET_DIR or ENVOY_INSTALL_BASE_URL."
    fi
    if [[ -n "$asset_dir" ]]; then
        echo "asset-dir"
    elif [[ -n "$base_url" ]]; then
        echo "base-url"
    else
        echo "public"
    fi
}

validate_asset_dir() {
    local asset_dir="$1"

    if [[ -z "$asset_dir" ]]; then
        fatal "ENVOY_INSTALL_ASSET_DIR must name a local release asset directory."
    fi
    case "$asset_dir" in
        *$'\n'*|*$'\r'*)
            fatal "ENVOY_INSTALL_ASSET_DIR must be a single directory path."
            ;;
    esac
    if [[ "$asset_dir" != /* ]]; then
        fatal "ENVOY_INSTALL_ASSET_DIR must be an absolute directory path: ${asset_dir}"
    fi
    case "$asset_dir" in
        */../*|*/..)
            fatal "ENVOY_INSTALL_ASSET_DIR must not contain '..' path traversal: ${asset_dir}"
            ;;
    esac
    if [[ ! -d "$asset_dir" ]]; then
        fatal "ENVOY_INSTALL_ASSET_DIR must be a directory: ${asset_dir}"
    fi

    ( cd "$asset_dir" && pwd -P )
}

validate_asset_base_url() {
    local url="$1"
    local rest authority path host port segment
    local host_re='^([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9.-]*[A-Za-z0-9])$'
    local -a segments=()

    if [[ -z "$url" ]]; then
        fatal "ENVOY_INSTALL_BASE_URL must be a HTTPS release asset base URL."
    fi
    case "$url" in
        *$'\n'*|*$'\r'*)
            fatal "ENVOY_INSTALL_BASE_URL must be a single HTTPS URL."
            ;;
    esac
    if [[ "$url" =~ [[:space:]] ]]; then
        fatal "ENVOY_INSTALL_BASE_URL must not contain whitespace: ${url}"
    fi
    if [[ "$url" != https://* ]]; then
        fatal "ENVOY_INSTALL_BASE_URL must use https://: ${url}"
    fi
    if [[ "$url" == *\?* || "$url" == *\#* ]]; then
        fatal "ENVOY_INSTALL_BASE_URL must be a release asset base URL without query strings or fragments: ${url}"
    fi
    if [[ "$url" == *%* || "$url" == *\\* ]]; then
        fatal "ENVOY_INSTALL_BASE_URL must not contain encoded or backslash path components: ${url}"
    fi

    while [[ "$url" == */ ]]; do
        url="${url%/}"
    done

    rest="${url#https://}"
    authority="${rest%%/*}"
    path=""
    if [[ "$rest" == */* ]]; then
        path="${rest#*/}"
    fi

    if [[ -z "$authority" ]]; then
        fatal "ENVOY_INSTALL_BASE_URL must include a host: ${url}"
    fi
    if [[ "$authority" == *"@"* ]]; then
        fatal "ENVOY_INSTALL_BASE_URL must not contain userinfo: ${url}"
    fi

    host="$authority"
    port=""
    if [[ "$authority" == *:* ]]; then
        host="${authority%%:*}"
        port="${authority#*:}"
        if [[ -z "$port" || ! "$port" =~ ^[0-9]+$ ]]; then
            fatal "ENVOY_INSTALL_BASE_URL has an invalid port: ${url}"
        fi
    fi
    if [[ -z "$host" || ! "$host" =~ $host_re ]] ||
        [[ "$host" == *..* ]]; then
        fatal "ENVOY_INSTALL_BASE_URL has an invalid host: ${url}"
    fi

    if [[ -n "$path" ]]; then
        if [[ "$path" == /* || "$path" == *"//"* ]]; then
            fatal "ENVOY_INSTALL_BASE_URL has an invalid path layout: ${url}"
        fi
        IFS='/' read -r -a segments <<< "$path"
        for segment in "${segments[@]}"; do
            if [[ -z "$segment" || "$segment" == "." || "$segment" == ".." ]]; then
                fatal "ENVOY_INSTALL_BASE_URL path must not contain empty, '.', or '..' segments: ${url}"
            fi
        done
    fi

    echo "$url"
}

# Argument parsing

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            usage
            ;;
        --dir)
            if [[ $# -lt 2 || -z "${2:-}" || "$2" == --* ]]; then
                fatal "--dir requires a value"
            fi
            INSTALL_DIR="$2"
            shift 2
            ;;
        --dir=*)
            INSTALL_DIR="${1#--dir=}"
            if [[ -z "$INSTALL_DIR" ]]; then
                fatal "--dir requires a value"
            fi
            shift
            ;;
        --version)
            if [[ $# -lt 2 || -z "${2:-}" || "$2" == --* ]]; then
                fatal "--version requires a value"
            fi
            VERSION="$2"
            shift 2
            ;;
        --version=*)
            VERSION="${1#--version=}"
            if [[ -z "$VERSION" ]]; then
                fatal "--version requires a value"
            fi
            shift
            ;;
        --)
            shift
            if [[ $# -gt 0 ]]; then
                fatal "Unexpected positional argument: $1. Use --help for usage."
            fi
            break
            ;;
        *)
            fatal "Unknown option: $1. Use --help for usage."
            ;;
    esac
done

# Platform detection

detect_os() {
    local os
    os="$(uname -s)"
    case "$os" in
        Linux)   echo "linux" ;;
        Darwin)  echo "darwin" ;;
        *)
            fatal_lines \
                "Unsupported OS: $os." \
                "Current signed public binaries are ${SUPPORTED_PLATFORMS}." \
                "See ${SUPPORTED_PLATFORM_HELP_URL}."
            ;;
    esac
}

detect_arch() {
    local arch
    arch="$(uname -m)"
    case "$arch" in
        x86_64|amd64)   echo "x86_64" ;;
        aarch64|arm64)   echo "arm64" ;;
        *)
            fatal_lines \
                "Unsupported architecture: $arch." \
                "Current signed public binaries are ${SUPPORTED_PLATFORMS}." \
                "See ${SUPPORTED_PLATFORM_HELP_URL}."
            ;;
    esac
}

require_linux_glibc() {
    local glibc_version=""
    if command -v getconf > /dev/null 2>&1; then
        glibc_version="$(getconf GNU_LIBC_VERSION 2>/dev/null || true)"
        if [[ "$glibc_version" == glibc* ]]; then
            info "Detected libc: ${glibc_version}"
            return 0
        fi
    fi

    local ldd_version=""
    if command -v ldd > /dev/null 2>&1; then
        ldd_version="$(ldd --version 2>&1 | head -n 1 || true)"
        case "$ldd_version" in
            *musl*|*Musl*)
                fatal_lines \
                    "Unsupported Linux libc: musl detected." \
                    "Current signed public binaries are ${SUPPORTED_PLATFORMS}." \
                    "Alpine/musl is not supported." \
                    "See ${SUPPORTED_PLATFORM_HELP_URL}."
                ;;
            *GLIBC*|*glibc*|*"GNU libc"*)
                info "Detected libc: ${ldd_version}"
                return 0
                ;;
        esac
    fi

    warn "Could not confirm glibc. Envoy Linux support requires x86_64 with glibc; Alpine/musl is not supported."
}

# Download

build_url() {
    local artifact="$1"
    validate_release_repo "$REPO"
    if [[ "$VERSION" == "latest" ]]; then
        echo "https://github.com/${REPO}/releases/latest/download/${artifact}"
    else
        echo "https://github.com/${REPO}/releases/download/${VERSION}/${artifact}"
    fi
}

build_asset_url() {
    local base_url="$1" artifact="$2"
    if ! base_url="$(validate_asset_base_url "$base_url")"; then
        return 1
    fi
    echo "${base_url}/${artifact}"
}

fetch_install_asset() {
    local source_kind="$1" source_ref="$2" dest="$3" asset="$4"

    case "$source_kind" in
        asset-dir)
            if [[ ! -f "$source_ref" ]]; then
                fatal_lines "Local release asset directory is missing ${asset}:" "$source_ref"
            fi
            if [[ -L "$source_ref" ]]; then
                fatal "Local release asset must be a regular file, not a symlink: ${asset}. Aborting before install."
            fi
            cp "$source_ref" "$dest"
            ;;
        public|base-url)
            download "$source_ref" "$dest"
            ;;
        *)
            fatal "Unknown install source kind: ${source_kind}"
            ;;
    esac
}

artifact_name() {
    local os="$1" arch="$2"
    case "${os}/${arch}" in
        darwin/arm64)
            echo "envoy-darwin-arm64"
            ;;
        linux/x86_64)
            echo "envoy-linux-x86_64"
            ;;
        darwin/x86_64)
            fatal_lines \
                "Unsupported platform: macOS x86_64/Intel." \
                "Current signed public binaries are ${SUPPORTED_PLATFORMS}." \
                "See ${SUPPORTED_PLATFORM_HELP_URL}."
            ;;
        linux/arm64)
            fatal_lines \
                "Unsupported platform: Linux arm64." \
                "Current signed public binaries are ${SUPPORTED_PLATFORMS}." \
                "See ${SUPPORTED_PLATFORM_HELP_URL}."
            ;;
        *)
            fatal_lines \
                "Unsupported platform: ${os}/${arch}." \
                "Current signed public binaries are ${SUPPORTED_PLATFORMS}." \
                "See ${SUPPORTED_PLATFORM_HELP_URL}."
            ;;
    esac
}

mcp_artifact_name() {
    local envoy_artifact="$1"
    case "$envoy_artifact" in
        envoy-*)
            printf 'envoy-mcp-%s\n' "${envoy_artifact#envoy-}"
            ;;
        *)
            fatal "Unsupported Envoy artifact for MCP mapping: ${envoy_artifact}"
            ;;
    esac
}

download() {
    local url="$1" dest="$2"
    if command -v curl > /dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -fsSL --retry 3 --retry-delay 2 -o "$dest" "$url"
    elif command -v wget > /dev/null 2>&1; then
        wget -q -O "$dest" "$url"
    else
        fatal "Neither curl nor wget found. Install one and retry."
    fi
}

# Checksum verification

require_ssh_signature_verifier() {
    hash -r 2>/dev/null || true
    if ! type -P ssh-keygen > /dev/null 2>&1; then
        fatal_lines \
            "OpenSSH ssh-keygen with signature verification is required. Aborting before install." \
            "Install OpenSSH 8.0+ and retry, or manually verify ${CHECKSUM_MANIFEST_NAME} and ${CHECKSUM_SIGNATURE_NAME} with the pinned Envoy release key before installing."
    fi

    local probe
    probe="$(ssh-keygen -Y check-novalidate -n "$CHECKSUM_SIGNATURE_NAMESPACE" -s /dev/null < /dev/null 2>&1 || true)"
    case "$probe" in
        *"Could not verify signature."*|*"Couldn't parse signature"*)
            return 0
            ;;
    esac

    fatal_lines \
        "OpenSSH ssh-keygen does not appear to support -Y signature verification. Aborting before install." \
        "Install OpenSSH 8.0+ and retry, or manually verify ${CHECKSUM_MANIFEST_NAME} and ${CHECKSUM_SIGNATURE_NAME} with the pinned Envoy release key before installing." \
        "ssh-keygen output: ${probe}"
}

verify_checksum_signature() {
    local manifest_path="$1" signature_path="$2"

    require_ssh_signature_verifier

    if [[ ! "$ENVOY_RELEASE_CHECKSUM_PUBLIC_KEY" =~ ^ssh-(ed25519|rsa|ecdsa-sha2-nistp(256|384|521))[[:space:]] ]]; then
        fatal "Installer is missing a valid pinned release checksum public key. Aborting before install."
    fi
    if [[ ! -s "$signature_path" ]]; then
        fatal "Missing checksum signature ${CHECKSUM_SIGNATURE_NAME}. Aborting before install."
    fi

    local allowed_signers allowed_dir output
    allowed_dir="${ENVOY_TMP_DIR:-${TMPDIR:-/tmp}}"
    allowed_signers="$(mktemp "${allowed_dir%/}/envoy-allowed-signers.XXXXXX")"
    printf '%s namespaces="%s" %s\n' \
        "$CHECKSUM_SIGNATURE_PRINCIPAL" \
        "$CHECKSUM_SIGNATURE_NAMESPACE" \
        "$ENVOY_RELEASE_CHECKSUM_PUBLIC_KEY" \
        > "$allowed_signers"

    if ! output="$(
        ssh-keygen -Y verify \
            -f "$allowed_signers" \
            -I "$CHECKSUM_SIGNATURE_PRINCIPAL" \
            -n "$CHECKSUM_SIGNATURE_NAMESPACE" \
            -s "$signature_path" \
            < "$manifest_path" 2>&1
    )"; then
        rm -f "$allowed_signers"
        fatal_lines \
            "Checksum signature verification failed. Aborting before install." \
            "The ${CHECKSUM_MANIFEST_NAME} trust root is the pinned Envoy release signing key, not only the GitHub release account." \
            "$output"
    fi

    rm -f "$allowed_signers"
    ok "Checksum signature verified (OpenSSH)."
}

sha256_file() {
    local path="$1"
    if command -v sha256sum > /dev/null 2>&1; then
        sha256sum "$path" | awk '{print $1}'
    elif command -v shasum > /dev/null 2>&1; then
        shasum -a 256 "$path" | awk '{print $1}'
    else
        fatal "No sha256sum or shasum found. Cannot verify download. Aborting before install."
    fi
}

validate_checksum_manifest() {
    local manifest_path="$1"
    local line checksum artifact extra count=0
    local seen_artifacts=""

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        checksum=""
        artifact=""
        extra=""
        read -r checksum artifact extra <<< "$line"
        if [[ -z "$checksum" || -z "$artifact" || -n "$extra" ]]; then
            fatal "Checksum manifest has invalid line: $line. Aborting before install."
        fi
        if [[ ! "$checksum" =~ ^[0-9a-fA-F]{64}$ ]]; then
            fatal "Checksum manifest has invalid SHA-256 for ${artifact}. Aborting before install."
        fi
        if [[ "$artifact" == */* ]]; then
            fatal "Checksum manifest artifact entries must be basenames only: ${artifact}. Aborting before install."
        fi
        if [[ -n "$seen_artifacts" ]] &&
            printf '%s\n' "$seen_artifacts" | grep -Fx -- "$artifact" >/dev/null; then
            fatal "Checksum manifest contains duplicate artifact entry: ${artifact}. Aborting before install."
        fi
        seen_artifacts="${seen_artifacts}${artifact}"$'\n'
        count=$((count + 1))
    done < "$manifest_path"

    if [[ "$count" -eq 0 ]]; then
        fatal "Checksum manifest contains no artifact entries. Aborting before install."
    fi
}

verify_checksum() {
    local binary_path="$1" manifest_path="$2" artifact="$3"

    validate_checksum_manifest "$manifest_path"

    local line checksum manifest_artifact extra expected="" matches=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        read -r checksum manifest_artifact extra <<< "$line"
        if [[ "$manifest_artifact" == "$artifact" ]]; then
            expected="$checksum"
            matches=$((matches + 1))
        fi
    done < "$manifest_path"

    if [[ -z "$expected" ]]; then
        fatal "Checksum manifest does not contain ${artifact}. Aborting before install."
    fi
    if [[ "$matches" -ne 1 ]]; then
        fatal "Checksum manifest contains ${matches} entries for ${artifact}; expected exactly one. Aborting before install."
    fi
    expected="$(printf '%s' "$expected" | tr 'A-F' 'a-f')"

    local actual
    actual="$(sha256_file "$binary_path")"

    if [[ "$expected" != "$actual" ]]; then
        fatal_lines \
            "Checksum mismatch!" \
            "Artifact: $artifact" \
            "Expected: $expected" \
            "Actual:   $actual" \
            "The download may be corrupted or tampered with. Aborting before install."
    fi
    ok "Checksum verified (SHA-256)."
}

# PATH helpers

path_contains_dir() {
    local dir="$1"
    printf '%s' "$PATH" | tr ':' '\n' | grep -Fqx -- "$dir"
}

ensure_on_path() {
    local dir="$1"
    if path_contains_dir "$dir"; then
        return 0
    fi

    warn "$dir is not in your PATH."
    echo ""
    echo "  For this shell/session:"
    echo "    export PATH=\"${dir}:\$PATH\""
    echo ""
    echo "  To persist it, add one of these to your shell config:"
    echo ""

    local shell_name
    shell_name="$(basename "${SHELL:-/bin/sh}")"
    case "$shell_name" in
        zsh)
            echo "    echo 'export PATH=\"${dir}:\$PATH\"' >> ~/.zshrc"
            echo ""
            echo "  Then reload: source ~/.zshrc"
            ;;
        bash)
            echo "    echo 'export PATH=\"${dir}:\$PATH\"' >> ~/.bashrc"
            echo ""
            echo "  Then reload: source ~/.bashrc"
            ;;
        fish)
            echo "    fish_add_path \"${dir}\""
            ;;
        *)
            echo "    export PATH=\"${dir}:\$PATH\""
            ;;
    esac
    echo ""
}

print_install_result() {
    local dir="$1"
    echo ""
    echo "  Result:"
    echo "  -------"
    echo "    envoy      ${dir}/envoy"
    echo "    envoy-mcp  ${dir}/envoy-mcp"
    if path_contains_dir "$dir"; then
        echo "    PATH       ready for this shell"
        echo ""
        echo "  Next:"
        echo "    envoy onboarding"
        echo ""
        echo "  SUCCESS: Envoy installed and ready on PATH."
    else
        echo "    PATH       needs update before this shell can run envoy by name"
        echo ""
        echo "  Next:"
        echo "    export PATH=\"${dir}:\$PATH\""
        echo "    envoy onboarding"
        echo ""
        echo "  SUCCESS: Envoy installed. PATH update required before this shell can run envoy by name."
    fi
}

resolve_existing_path() {
    local path="$1"
    if command -v realpath >/dev/null 2>&1; then
        realpath "$path" 2>/dev/null && return 0
    fi
    if command -v readlink >/dev/null 2>&1; then
        readlink -f "$path" 2>/dev/null && return 0
    fi
    local dir base
    dir="$(dirname "$path")"
    base="$(basename "$path")"
    ( cd "$dir" 2>/dev/null && printf '%s/%s\n' "$(pwd -P)" "$base" )
}

binary_version_line() {
    local path="$1"
    if [[ ! -x "$path" ]]; then
        return 0
    fi
    ( "$path" --version 2>/dev/null || true ) | sed -n '1p'
}

print_binary_detail() {
    local label="$1" path="$2" inspect_version="${3:-1}" version digest
    echo "  ${label}: ${path}"
    if [[ "$inspect_version" == "1" ]]; then
        version="$(binary_version_line "$path")"
        if [[ -n "$version" ]]; then
            echo "  ${label} version: ${version}"
        fi
    fi
    digest="$(sha256_file "$path" 2>/dev/null || true)"
    if [[ -n "$digest" ]]; then
        echo "  ${label} sha256: ${digest}"
    fi
}

detect_path_shadowing_for_binary() {
    local dir="$1" binary="$2"
    local installed="${dir}/${binary}"
    local resolved installed_real resolved_real

    resolved="$(command -v "$binary" 2>/dev/null || true)"
    if [[ -z "$resolved" || ! -e "$installed" ]]; then
        return 0
    fi

    installed_real="$(resolve_existing_path "$installed" 2>/dev/null || printf '%s\n' "$installed")"
    resolved_real="$(resolve_existing_path "$resolved" 2>/dev/null || printf '%s\n' "$resolved")"
    if [[ "$installed_real" == "$resolved_real" ]]; then
        return 0
    fi

    warn "Your PATH resolves ${binary} to a different binary than the one just installed."
    echo ""
    print_binary_detail "Installed" "$installed"
    print_binary_detail "Resolved" "$resolved" 0
    echo ""
    echo "  Use this install first in the current shell:"
    echo "    export PATH=\"${dir}:\$PATH\""
    echo "    hash -r 2>/dev/null || true"
    echo "    command -v ${binary}"
    echo ""
}

detect_path_shadowing() {
    local dir="$1"
    detect_path_shadowing_for_binary "$dir" envoy
    detect_path_shadowing_for_binary "$dir" envoy-mcp
}

print_macos_gatekeeper_guidance() {
    local dir="$1"

    echo ""
    echo "  macOS Gatekeeper:"
    echo "  ------------------"
    echo "    Envoy release binaries are checksum-verified by this installer but not notarized."
    echo "    If macOS blocks first run after install:"
    echo "      xattr -d com.apple.quarantine \"${dir}/envoy\" \"${dir}/envoy-mcp\""
    echo "      \"${dir}/envoy\" --version"
    echo "      \"${dir}/envoy-mcp\" --version"
}

ensure_install_dir_ready() {
    local dir="$1" mkdir_output probe prefix

    if [[ -z "$dir" ]]; then
        fatal "Install directory is unset. Set HOME, ENVOY_INSTALL_DIR, or pass --dir DIR."
    fi

    if ! mkdir_output="$(mkdir -p "$dir" 2>&1)"; then
        fatal_lines "Install directory cannot be created before download:" "$dir" "$mkdir_output"
    fi
    if [[ ! -d "$dir" ]]; then
        fatal_lines "Install target is not a directory:" "$dir"
    fi
    if [[ ! -w "$dir" ]]; then
        fatal_lines "Install directory is not writable before download:" "$dir"
    fi

    prefix="${dir%/}"
    if [[ -z "$prefix" ]]; then
        prefix="/"
    fi
    if ! probe="$(mktemp "${prefix}/.envoy.write-test.XXXXXX" 2>&1)"; then
        fatal_lines "Install directory cannot create temporary files before download:" "$dir" "$probe"
    fi
    rm -f "$probe"
}

rollback_verified_binary_install() {
    local install_dir="$1" backup_dir="$2" envoy_backed="$3" mcp_backed="$4" envoy_new="$5" mcp_new="$6"
    local failed=0

    if [[ "$envoy_new" == "1" ]]; then
        command rm -f "${install_dir}/envoy" || failed=1
    fi
    if [[ "$mcp_new" == "1" ]]; then
        command rm -f "${install_dir}/envoy-mcp" || failed=1
    fi

    if [[ "$envoy_backed" == "1" ]]; then
        command rm -f "${install_dir}/envoy" || failed=1
        command mv -f "${backup_dir}/envoy" "${install_dir}/envoy" || failed=1
    fi
    if [[ "$mcp_backed" == "1" ]]; then
        command rm -f "${install_dir}/envoy-mcp" || failed=1
        command mv -f "${backup_dir}/envoy-mcp" "${install_dir}/envoy-mcp" || failed=1
    fi

    if [[ "$failed" == "0" ]]; then
        command rmdir "$backup_dir" 2>/dev/null || true
    else
        warn "Install rollback could not fully restore prior binaries. Backup retained at ${backup_dir}"
    fi

    return "$failed"
}

install_verified_binaries() {
    local install_dir="$1" tmp_binary="$2" tmp_mcp_binary="$3"
    local envoy_final="${install_dir}/envoy"
    local mcp_final="${install_dir}/envoy-mcp"
    local backup_dir envoy_backed=0 mcp_backed=0 envoy_new=0 mcp_new=0

    ENVOY_INSTALL_TMP_FILE="$(mktemp "${install_dir}/.envoy.tmp.XXXXXX")" || return 1
    ENVOY_MCP_INSTALL_TMP_FILE="$(mktemp "${install_dir}/.envoy-mcp.tmp.XXXXXX")" || return 1

    if ! cp "$tmp_binary" "$ENVOY_INSTALL_TMP_FILE"; then
        return 1
    fi
    if ! cp "$tmp_mcp_binary" "$ENVOY_MCP_INSTALL_TMP_FILE"; then
        return 1
    fi
    if ! chmod 0755 "$ENVOY_INSTALL_TMP_FILE"; then
        return 1
    fi
    if ! chmod 0755 "$ENVOY_MCP_INSTALL_TMP_FILE"; then
        return 1
    fi

    backup_dir="$(mktemp -d "${install_dir}/.envoy.install-backup.XXXXXX")" || return 1

    if [[ -e "$envoy_final" ]]; then
        if ! mv -f "$envoy_final" "${backup_dir}/envoy"; then
            rollback_verified_binary_install "$install_dir" "$backup_dir" "$envoy_backed" "$mcp_backed" "$envoy_new" "$mcp_new" || true
            return 1
        fi
        envoy_backed=1
    fi
    if [[ -e "$mcp_final" ]]; then
        if ! mv -f "$mcp_final" "${backup_dir}/envoy-mcp"; then
            rollback_verified_binary_install "$install_dir" "$backup_dir" "$envoy_backed" "$mcp_backed" "$envoy_new" "$mcp_new" || true
            return 1
        fi
        mcp_backed=1
    fi

    if ! mv -f "$ENVOY_INSTALL_TMP_FILE" "$envoy_final"; then
        rollback_verified_binary_install "$install_dir" "$backup_dir" "$envoy_backed" "$mcp_backed" "$envoy_new" "$mcp_new" || true
        return 1
    fi
    ENVOY_INSTALL_TMP_FILE=""
    envoy_new=1

    if ! mv -f "$ENVOY_MCP_INSTALL_TMP_FILE" "$mcp_final"; then
        rollback_verified_binary_install "$install_dir" "$backup_dir" "$envoy_backed" "$mcp_backed" "$envoy_new" "$mcp_new" || true
        return 1
    fi
    ENVOY_MCP_INSTALL_TMP_FILE=""
    mcp_new=1

    command rm -f "${backup_dir}/envoy" "${backup_dir}/envoy-mcp" 2>/dev/null || true
    command rmdir "$backup_dir" 2>/dev/null || true
}

# Main

main() {
    echo ""
    echo "  Envoy Installer"
    echo "  ----------------"
    echo ""

    local os arch
    if ! os="$(detect_os)"; then
        return 1
    fi
    if ! arch="$(detect_arch)"; then
        return 1
    fi
    info "Detected platform: ${os}/${arch}"

    local artifact mcp_artifact source_kind source_root binary_ref mcp_binary_ref checksum_ref signature_ref
    if ! artifact="$(artifact_name "$os" "$arch")"; then
        return 1
    fi
    if ! mcp_artifact="$(mcp_artifact_name "$artifact")"; then
        return 1
    fi
    if [[ "$os" == "linux" && "$arch" == "x86_64" ]]; then
        require_linux_glibc
    fi

    if ! source_kind="$(install_source_kind)"; then
        return 1
    fi
    case "$source_kind" in
        public)
            if ! binary_ref="$(build_url "$artifact")"; then
                return 1
            fi
            if ! mcp_binary_ref="$(build_url "$mcp_artifact")"; then
                return 1
            fi
            if ! checksum_ref="$(build_url "$CHECKSUM_MANIFEST_NAME")"; then
                return 1
            fi
            if ! signature_ref="$(build_url "$CHECKSUM_SIGNATURE_NAME")"; then
                return 1
            fi
            if [[ "$VERSION" != "latest" ]]; then
                info "Pinned version: $VERSION"
            fi
            ;;
        base-url)
            if ! source_root="$(validate_asset_base_url "${ENVOY_INSTALL_BASE_URL:-}")"; then
                return 1
            fi
            binary_ref="${source_root}/${artifact}"
            mcp_binary_ref="${source_root}/${mcp_artifact}"
            checksum_ref="${source_root}/${CHECKSUM_MANIFEST_NAME}"
            signature_ref="${source_root}/${CHECKSUM_SIGNATURE_NAME}"
            info "Release asset base URL: ${source_root}"
            ;;
        asset-dir)
            if ! source_root="$(validate_asset_dir "${ENVOY_INSTALL_ASSET_DIR:-}")"; then
                return 1
            fi
            binary_ref="${source_root}/${artifact}"
            mcp_binary_ref="${source_root}/${mcp_artifact}"
            checksum_ref="${source_root}/${CHECKSUM_MANIFEST_NAME}"
            signature_ref="${source_root}/${CHECKSUM_SIGNATURE_NAME}"
            info "Local release asset directory: ${source_root}"
            ;;
        *)
            fatal "Unknown install source kind: ${source_kind}"
            ;;
    esac

    ensure_install_dir_ready "$INSTALL_DIR"

    # Download to temp files. Final installation does not begin until both
    # binaries and the signed manifest have verified.
    local tmp_binary tmp_mcp_binary tmp_manifest tmp_signature
    ENVOY_TMP_DIR="$(mktemp -d)"
    tmp_binary="${ENVOY_TMP_DIR}/envoy"
    tmp_mcp_binary="${ENVOY_TMP_DIR}/envoy-mcp"
    tmp_manifest="${ENVOY_TMP_DIR}/${CHECKSUM_MANIFEST_NAME}"
    tmp_signature="${ENVOY_TMP_DIR}/${CHECKSUM_SIGNATURE_NAME}"
    trap cleanup_install EXIT

    if [[ "$source_kind" == "asset-dir" ]]; then
        info "Reading ${artifact} from local release asset directory..."
    else
        info "Downloading from ${binary_ref}..."
    fi
    if ! fetch_install_asset "$source_kind" "$binary_ref" "$tmp_binary" "$artifact"; then
        fatal_lines "Download failed. Check your network and that the release exists at:" "$binary_ref"
    fi
    if [[ "$source_kind" == "asset-dir" ]]; then
        info "Reading ${mcp_artifact} from local release asset directory..."
    else
        info "Downloading MCP adapter from ${mcp_binary_ref}..."
    fi
    if ! fetch_install_asset "$source_kind" "$mcp_binary_ref" "$tmp_mcp_binary" "$mcp_artifact"; then
        fatal_lines "MCP adapter download failed. Check your network and that the release exists at:" "$mcp_binary_ref"
    fi

    if [[ "$source_kind" == "asset-dir" ]]; then
        info "Reading checksum manifest from local release asset directory..."
    else
        info "Downloading checksum manifest..."
    fi
    if ! fetch_install_asset "$source_kind" "$checksum_ref" "$tmp_manifest" "$CHECKSUM_MANIFEST_NAME"; then
        fatal_lines "Checksum manifest download failed. Envoy releases must publish ${CHECKSUM_MANIFEST_NAME}:" "$checksum_ref"
    fi

    if [[ "$source_kind" == "asset-dir" ]]; then
        info "Reading checksum signature from local release asset directory..."
    else
        info "Downloading checksum signature..."
    fi
    if ! fetch_install_asset "$source_kind" "$signature_ref" "$tmp_signature" "$CHECKSUM_SIGNATURE_NAME"; then
        fatal_lines "Checksum signature download failed. Envoy releases must publish ${CHECKSUM_SIGNATURE_NAME}:" "$signature_ref"
    fi

    verify_checksum_signature "$tmp_manifest" "$tmp_signature"
    verify_checksum "$tmp_binary" "$tmp_manifest" "$artifact"
    verify_checksum "$tmp_mcp_binary" "$tmp_manifest" "$mcp_artifact"

    if ! install_verified_binaries "$INSTALL_DIR" "$tmp_binary" "$tmp_mcp_binary"; then
        fatal "Install transaction failed before completing both Envoy binary replacements."
    fi
    rm -rf "$ENVOY_TMP_DIR"
    ENVOY_TMP_DIR=""
    ok "Installed to ${INSTALL_DIR}/envoy"
    ok "Installed to ${INSTALL_DIR}/envoy-mcp"

    # PATH check
    ensure_on_path "$INSTALL_DIR"
    detect_path_shadowing "$INSTALL_DIR"
    if [[ "$os" == "darwin" ]]; then
        print_macos_gatekeeper_guidance "$INSTALL_DIR"
    fi

    # Quickstart
    echo ""
    echo "  Verify:"
    echo "  -------"
    echo "    envoy --version"
    echo "    envoy-mcp --version"
    echo "    envoy onboarding"
    echo ""
    echo "  Get started:"
    echo "  ------------"
    echo "    envoy quickstart         # human: create a local space and invite"
    echo "    envoy onboarding         # human: learn the local/relay model"
    echo "    envoy docs               # human: find repo and installed docs"
    echo ""
    echo "  MCP clients:"
    echo "  ------------"
    echo "    Use absolute paths for desktop clients that do not inherit your shell PATH:"
    echo "      command: ${INSTALL_DIR}/envoy-mcp"
    echo "      args: [\"--envoy-bin\", \"${INSTALL_DIR}/envoy\", \"--profile\", \"agent-researcher\"]"
    echo ""
    echo "  Agent guidance:"
    echo "  ---------------"
    echo "    Read https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/llms.txt first."
    echo "    Create a space only when the user asks."
    echo ""
    echo "  Repo:   https://github.com/statecraft-protocol/envoy"
    echo "  Agents:"
    echo "    https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/llms.txt"
    echo "    https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/llms-full.txt"
    echo "    https://github.com/statecraft-protocol/envoy/blob/v0.3.1/llms.txt"
    echo "    https://github.com/statecraft-protocol/envoy/blob/v0.3.1/llms-full.txt"

    print_install_result "$INSTALL_DIR"
}

if [[ "${ENVOY_INSTALL_SH_LIBRARY:-0}" != "1" ]]; then
    main
fi
