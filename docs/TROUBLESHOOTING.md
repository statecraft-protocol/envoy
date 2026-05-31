# Troubleshooting

_Last updated: May 28, 2026._

Use this page for first checks, common errors, recovery cautions, and support
contact.

## Support

Contact [hello@statecraft.fyi](mailto:hello@statecraft.fyi).

When contacting support, include the exact command, full output, operating
system, install method, and whether Envoy Connected is involved.

## First Checks

```bash
envoy --version
```

```bash
envoy status
```

```bash
envoy diagnose
```

If the issue is specific to an MCP-compatible runtime, also check
`envoy-mcp --version`.

If an agent is diagnosing the issue, give it this instruction:

```text
Diagnose my Envoy issue safely. Preserve exact commands and output, identify whether this involves Local or Connected, and do not retry destructive actions.
```

## Advanced Isolated Test

For isolated testing without changing your main identity, use a fresh profile.
A profile is separate local identity state:

```bash
envoy --profile troubleshooting-smoke quickstart --human
```

## Error Codes

When a command reports an error code, use that code first and keep the full
output with the failed command. Do not retry destructive actions just because a
message looks recoverable.

## Common Cases

| Symptom | Meaning | Next action |
| --- | --- | --- |
| Connected access prompt during local-only work | The active space or invite was created for [Connected](CONNECTED_BILLING.md) use. | Create or join a fresh local-only space. |
| Connected access prompt during cross-machine work | Connected access is inactive for the subscription-owner profile. | Run `envoy billing status`, then checkout if you intend to use [Connected](CONNECTED_BILLING.md). |
| Cross-machine invite cannot be completed | The space or invite is not reachable through [Connected](CONNECTED_BILLING.md). | Activate Connected access and create a fresh invite before sharing across machines. |
| Connected invite is not found (`hosted_relay_invite_not_found`) | Invite is not available through the Connected relay. | Ask the inviter for a fresh Connected invite. |
| Authority changed (`epoch_revoked`) | Local authority is stale. | Stop, reread authority and space state, then retry only with current permission. |
| Missing or expired capability (`capability_missing`, `capability_expired`) | Local state may be durable, but relay access is not current. | Run `envoy diagnose`, reread roster/permissions, or ask an admin for repair. |
| Message is too large | Message body is too large for the current send flow. | Attach a compact reference or store the artifact separately. |
| Corruption or checksum warning | Existing local state failed integrity checks. | Stop before destructive cleanup; back up and inspect before retrying. |

## Stale Progress

Inspection commands show state. They do not complete work.

If progress looks stale, reread recent history, task state, and member state
before retrying an action.

## State And Recovery

If Envoy reports corruption, access denial, or confused local state, stop
before destructive cleanup. Preserve the exact command and output.

Run recovery commands only when you intentionally want local recovery and can
handle recovery material safely. The [Security Model](SECURITY_MODEL.md)
describes the recovery boundary. Use `envoy recover` in an interactive
terminal, or pipe recovery material to `envoy recover --stdin` without pasting
that material into prompts or shared logs.

Use reset only when you intentionally want local cleanup with a backup:

`envoy reset --yes --backup`

`reset --yes --backup` is profile-scoped and local only. It does not cancel
Envoy Connected, delete relay data, or unlink billing relationships.

If an agent is helping with recovery or reset, give it this instruction:

```text
Help me diagnose and recover Envoy local state safely. Preserve exact commands and output, do not ask me to paste recovery material into chat, back up before cleanup, and ask before any reset.
```

## Use Extra Care

Pause before continuing when recovery material, billing, deletion, reset,
daemon control, or local cleanup is involved.
