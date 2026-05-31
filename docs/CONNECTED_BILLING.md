# Connected And Billing

_Last updated: May 28, 2026._

Envoy Local is free and accountless. Envoy Connected adds relay-backed
cross-machine reachability for spaces. For the local-first model, see the
[Architecture Primer](ARCHITECTURE_PRIMER.md).

Connected is access and transport. It is not authority inside a space. Space
authority still comes from identity, membership, roles, current space
permissions, and explicit local instruction. See the
[Security Model](SECURITY_MODEL.md) for the public trust boundary.

## What Connected Adds

Connected gives a space a reachable address so participants on different
machines can join, send work, and continue together through the Envoy Connected
relay.

The relay is not trusted with message plaintext. It can still see metadata
needed to operate the service, including timing, request metadata, object sizes,
encrypted object metadata, invite delivery metadata, access metadata, and
billing activity. The metadata boundary is described in the
[Privacy Policy](PRIVACY_POLICY.md).

## Early Access Pricing

During early access:

- Envoy Local: free.
- Envoy Connected: `$15/month` before applicable taxes, if any.
- Invited participants: can participate in a Connected-funded space without
  each having their own subscription, when the space grants them authority.

The subscription owner funds the cross-machine space. Invited participants do
not gain extra authority from billing state.

## Billing Commands

Inspect current account/access state:

```bash
envoy billing plans
```

```bash
envoy billing status
```

Start checkout when you intend to activate Connected:

```bash
envoy billing checkout
```

Open account management from the subscription owner profile:

```bash
envoy billing portal
```

If an agent is checking access for you, give it this instruction:

```text
Check my Envoy Connected status, tell me whether Local or Connected access is active, and do not start checkout or open the billing portal unless I explicitly confirm.
```

## Invite Rules

For normal cross-machine setup, create a Connected space and share the invite
printed by that command:

```bash
envoy quickstart --human --cross-machine
```

Connected quickstart creates a one-use expiring invite by default. The output
shows the granted role, current uses, invite expiry, relay publication expiry,
and a revocation command. The local invite uses the standard default expiry
unless an explicit TTL is supplied by a lower-level invite command. The relay
lookup for a published invite expires after seven days, and the inviter can
revoke the invite earlier.

`envoy quickstart --reusable` is a local handoff mode. It does not publish to
Envoy Connected and cannot be combined with `--cross-machine`,
`--publish-invite`, or `--open`.

### Additional Connected Invites

Create another cross-machine invite only when an existing Connected space needs
another participant. Today `envoy invite <space-id>` publishes through Envoy
Connected only for explicit reusable Connected invite intent: `--max-uses 0` on
a space that was created with Connected enabled. Finite `envoy invite` codes are
for local or same-daemon handoff; do not treat them as another cross-machine
publication path.

Public and reusable invite codes are bearer invitations, so prefer short TTLs
and least-privilege roles. Use unlimited `--max-uses 0` only when you explicitly
accept the risk of a reusable code; without `--ttl`, standard invites still
inherit the default five-minute expiry.

If an agent is creating the invite, give it this instruction:

```text
Create a fresh cross-machine invite for this space with the shortest practical TTL and least-privilege role. Confirm Connected status first, then show only the invite I should send.
```

Advanced controls:

| Option | Meaning |
| --- | --- |
| `--max-uses 0` | Make the invite reusable. |
| `--ttl duration` | Set when the invite expires. |
| `--role read|write` | Set the role granted to participants who redeem it. |

```text
envoy invite <space-id> --max-uses 0 --ttl 30m --role read
```

Activating Connected does not convert existing local-only spaces into Connected
spaces. Create the space with `--cross-machine` when participants need to
coordinate across machines; the [Quickstart](QUICKSTART.md) shows the command.

## When Connected Is Required

If a cross-machine operation asks for Connected access, run checkout from the
subscription-owner profile and retry only after status shows active Connected
access.

If you see a Connected access prompt while working locally, do not run checkout.
The active space or invite was created for Connected use; create or join a
fresh local-only space.

If join reports that an invite is not available through Connected access, ask
the inviter to create a fresh Connected invite after confirming billing status.

## Linked Access

Linked access lets a Connected subscription owner share Connected reachability
with another local identity, usually an agent profile. It is a billing
relationship only. It does not join a space, grant space authority, or change
the participant's role inside any space.

If an agent is handling linked access, give it this instruction:

```text
Show the receiving profile fingerprint and subscription-owner profile first. Link this local identity to my Connected subscription only after I confirm both, then verify status. Do not join spaces or change roles.
```

Before linking, verify which profile is receiving access and which profile owns
the subscription.

From the identity that should receive Connected access, copy its fingerprint:

```bash
envoy fingerprint
```

From the Connected subscription owner profile, link that fingerprint:

`envoy billing link-agent --fingerprint FINGERPRINT`

Check the linked identity:

```bash
envoy billing status
```

Unlink from the subscription owner profile:

`envoy billing unlink-agent --fingerprint FINGERPRINT`

For the exact billing command flags, see the
[CLI Reference](CLI_REFERENCE.md#envoy-billing).
