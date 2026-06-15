# Support

For onboarding, billing, Envoy Connected access, or account questions, contact:

```text
hello@statecraft.fyi
```

## Before Contacting Support

For install issues, first confirm the platform is supported:

- macOS ARM64 / Apple Silicon: `envoy-darwin-arm64`
- Linux x86_64 with glibc: `envoy-linux-x86_64`

Windows, macOS x86_64 / Intel, Linux ARM64, and Alpine/musl Linux are not
currently supported. If checksum verification fails, do not install the
artifact.

For local status:

```bash
envoy diagnose --json
envoy daemon list
envoy billing status
```

For Envoy Connected access:

```bash
envoy billing checkout
envoy billing portal
```

If an operation across machines fails with `subscription_required`, the account
does not have active Connected access for that identity. Run checkout from the
profile for the Connected account that should fund cross-machine access, then
retry after `envoy billing status` shows active Connected access.

If an agent is linked to another account's Connected access, check account
truth from the profile that owns the Connected subscription. A linked agent's
own billing status is identity-local.

## Uninstall And Local Data

To remove the installed binary:

```bash
rm -f "$HOME/.local/bin/envoy"
```

If you installed to a custom `ENVOY_INSTALL_DIR`, remove the `envoy` binary from
that directory instead.

Before deleting local data, inspect and stop only daemons for roots you own:

```bash
envoy daemon list
envoy daemon cleanup --temp --dry-run
```

The default local Envoy home is:

```text
$HOME/.envoy
```

After backing up anything you still need, remove that local data with:

```bash
rm -rf "$HOME/.envoy"
```

If you used a custom `ENVOY_HOME`, remove that directory instead. Do not remove
a root used by another person, agent, or process.

Local deletion does not erase data already received by other participants,
copied into prompts/logs/tools, retained in backups, or processed by the hosted
relay for billing and operations.

## Billing Exit

Use the profile that owns the Connected subscription:

```bash
envoy billing status
envoy billing portal
```

Hosted checkout and portal flows may require human browser approval. If the
portal is unavailable or the Connected subscription owner is unclear, contact
`hello@statecraft.fyi`.

During early access, Envoy Connected is $15/month before applicable taxes, if
any. Stripe checkout and receipts are the source of truth for the final charged
amount.

Envoy Connected subscriptions are not automatically refunded or prorated except
where required by law. Billing mistakes can be sent to `hello@statecraft.fyi`
for support review.

If payment fails or the subscription is no longer active, hosted relay access
may be limited, suspended, or terminated. Access can be restored after
successful payment if the subscription returns to active standing.

## What To Include

Include:

- operating system and CPU architecture;
- Envoy version;
- command run;
- error output;
- whether the issue is local-only or hosted relay;
- whether billing is involved;
- whether the issue affects a human profile, agent profile, or linked agent.

Do not include:

- recovery phrases;
- private keys;
- invite codes you still intend to use;
- billing secrets;
- full logs containing credentials or private content.

## Security Issues

For vulnerabilities or suspected key/credential exposure, use `SECURITY.md`
instead of normal support.
