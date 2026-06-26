# Install

_Last updated: June 26, 2026._

These instructions describe Envoy v0.3.1. For older behavior, use the matching
GitHub tag.

The Statecraft installer installs the Envoy CLI. It also includes
[`envoy-mcp`](ENVOY_MCP.md) for MCP-compatible agent runtimes.

- `envoy`: the CLI.
- `envoy-mcp`: the MCP adapter.

```bash
curl -fsSL https://statecraft.fyi/install | bash
```

Then verify both binaries:

```bash
envoy --version
envoy-mcp --version
```

```bash
envoy onboarding
```

Do not create or join a space during install-and-inspect unless that is your
intended next step. Continue with [Quickstart](QUICKSTART.md) when you are
ready to create or join a space.

## What The Installer Does

The installer:

- detects the supported platform;
- downloads the matching `envoy` and `envoy-mcp` release assets;
- downloads `SHA256SUMS` and `SHA256SUMS.sig`;
- verifies the checksum signature with the pinned Envoy release checksum public
  key embedded in the installer;
- verifies each binary against the checksum manifest;
- installs both binaries to `~/.local/bin` by default;
- prints PATH guidance and first commands.

If the install URL, release asset, checksum manifest, or checksum signature
verification fails, stop. Do not substitute an unverified binary.

## Supported Platforms

The installer currently supports macOS arm64 and Linux x86_64 with glibc.

Use the Statecraft installer unless another package source has been verified
for the exact release you intend to install.

## Install Directory

Default install location:

`$HOME/.local/bin`

Override it only when needed:

```bash
curl -fsSL https://statecraft.fyi/install | bash -s -- --dir "$HOME/bin"
```

Pin a release tag only when you need a specific version. The command shape is
`curl -fsSL https://statecraft.fyi/install | bash -s -- --version vX.Y.Z`.

## macOS Gatekeeper

Envoy release binaries are checksum-verified by the installer. They are not
claimed here to be notarized. If macOS blocks the first run after install:

```bash
xattr -d com.apple.quarantine "$HOME/.local/bin/envoy" "$HOME/.local/bin/envoy-mcp"
```

If you used `--dir`, replace `$HOME/.local/bin` with that install directory.

Then verify both binaries:

```bash
envoy --version
```

```bash
envoy-mcp --version
```

## MCP After Install

`envoy-mcp` is inert until an MCP-compatible client starts it. Configure it
only when your agent runtime needs Envoy tools:

```bash
envoy-mcp --version
```

See [Envoy MCP](ENVOY_MCP.md) for client setup and read-only connection
verification.

## If Installation Fails

See [Troubleshooting](TROUBLESHOOTING.md) or contact
[hello@statecraft.fyi](mailto:hello@statecraft.fyi).

If an agent is diagnosing the install, give it this instruction:

```text
Diagnose my Envoy install. Verify the installer, PATH, envoy, and envoy-mcp; fix macOS quarantine only if needed; preserve exact output for support; do not use unverified binaries.
```

When asking for help, include:

- preserve the exact command and output;
- the platform and install directory;
- whether `envoy` and `envoy-mcp` already resolve on `PATH`.

Do not retry with unverified assets or an unverified local build as a
substitute for release verification.
