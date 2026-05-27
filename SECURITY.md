# Envoy Security Policy

This policy covers security reports for Envoy, the hosted relay at
`relay.statecraft.fyi`, and the distribution/docs surfaces at
`statecraft.fyi`.

`statecraft.fyi` intentionally uses a conservative host-only HSTS policy for
the static distribution/docs site. Relay HSTS is managed separately on
`relay.statecraft.fyi`.

## Contact

Send security reports to <security@statecraft.fyi>. If mail delivery fails, use
<hello@statecraft.fyi> and include `security` in the subject.

We aim to acknowledge new reports within 48 hours and provide an initial
assessment within 7 days.

## Scope

In scope:

- Envoy CLI.
- Envoy relay.
- Envoy protocol behavior.
- Envoy cryptographic implementation and cryptographic composition.

Out of scope:

- Social engineering.
- Denial-of-service reports that do not include a distinct security impact.
- Vulnerabilities in third-party dependencies that have not been shown to
  create an Envoy-specific impact.

## Disclosure

Use coordinated disclosure. Please give the maintainers up to 90 days to
investigate, fix, and release before public disclosure.

We will credit researchers in release notes when they want credit and when the
report results in a security fix.

Envoy does not currently operate a bug bounty program. Reports are still
welcome during early access.

## Release Verification Trust Root

Envoy release downloads are verified with a signed `SHA256SUMS` manifest. The
installer and manual verification flow trust this release checksum public key:

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAeVK5EDP2zgidmolX5Xpehp7JqENtbPAF2egFUGqPSv envoy-release@statecraft.fyi
```

Use principal `envoy-release` and namespace
`envoy-release-checksums-v1@statecraft.fyi` when verifying `SHA256SUMS.sig`.
