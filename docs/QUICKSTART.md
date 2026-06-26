# Quickstart

_Last updated: June 26, 2026._

Use Envoy when work needs shared state across humans, agents, sessions, or
machines. A space is invite-only and carries messages, tasks, evidence,
authority, provenance, events, and history. For the underlying model, see
[State vs context](../README.md#state-vs-context).

## Install And Inspect

Install Envoy:

```bash
curl -fsSL https://statecraft.fyi/install | bash
```

Check the CLI:

```bash
envoy --version
```

```bash
envoy-mcp --version
```

Open the onboarding guide:

```bash
envoy onboarding
```

Installation does not create or join a space. Choose the next command
intentionally. For installer behavior and verification details, see
[Install](INSTALL.md).

## Create A Local Space

Local mode is free and accountless. It is the default for same-machine,
offline-first, and private local workflows.

```bash
envoy quickstart
```

Use the returned `space_id` for later commands such as
`envoy history SPACE_ID --limit 20` and
`envoy task list --space SPACE_ID`.

Save recovery material if Envoy prints it. Do not paste real recovery material
into prompts or shared logs. See [Troubleshooting](TROUBLESHOOTING.md) before
using recovery or reset commands.

## Invite A Participant

Create an invite:

`envoy invite SPACE_ID`

Join from another local profile on the same machine:

`envoy join INVITE_CODE`

Invite codes are bearer invitations. Treat them like secrets until they expire
or are fully redeemed.

If you are simulating multiple participants on one machine, use profiles so
each participant has its own local identity.

If an agent is helping with local setup, give it this instruction:

```text
Create a local Envoy invite for this space, explain who should redeem it, and tell me exactly what invite code to send. Keep the invite private.
```

## Check The Space

Use tasks for work that should survive handoff. Use messages for short status
or coordination:

Start by inspecting state with `envoy history SPACE_ID --limit 20` and
`envoy task list --space SPACE_ID`.

Then create work with
`printf '%s' "Draft the migration plan" | envoy task create --space SPACE_ID --stdin`.
Send short status only when useful with
`envoy send --space SPACE_ID "Ready to work."`.

Use history, tasks, and member state to inspect progress. If an agent is doing
the work, give it this instruction:

```text
Use this Envoy space as the source of truth. Read recent history, tasks, and member state, then create one task for the next piece of work and show me the updated state.
```

## Use MCP

The installer also includes `envoy-mcp` for MCP-compatible agent runtimes.
Configure it only when your runtime needs typed Envoy tools. See
[Envoy MCP](ENVOY_MCP.md).

## Cross-Machine Spaces

Use [Envoy Connected](CONNECTED_BILLING.md) only when participants need to join
from other machines:

```bash
envoy quickstart --cross-machine
```

If an agent is setting up a cross-machine space, give it this instruction:

```text
Set up a cross-machine Envoy space for me. Verify Connected status first, create the space only when Connected access is active or tell me the exact checkout step, and show only the invite I should send.
```

Activating Connected does not convert existing local-only spaces into Connected
spaces. Create the space with `--cross-machine` when cross-machine redemption
is required. Cross-machine quickstart prints a one-use expiring invite by
default, including role, use count, expiry, relay expiry, and a revoke command.
See [Connected And Billing](CONNECTED_BILLING.md) for billing, invite, and
reachability details.

If you see a Connected access prompt while working locally, the active space or
invite was created for Connected use. Create or join a fresh local-only space
instead.
