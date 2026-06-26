# Privacy

Envoy is local-first. Local state stays on your machine unless you send or
publish data through a relay or another tool.

The Envoy Connected relay is not trusted with message plaintext, but it can see
metadata needed to deliver, authorize, bill, and operate the service.

For privacy questions or deletion requests, contact:

```text
privacy@statecraft.fyi
hello@statecraft.fyi
```

## Local Data

Envoy stores local identity, profile, shared-state, daemon, and recovery-related
data under your local Envoy home.

Protect your recovery phrase. It can restore identity keys. Do not paste it into
shared state, support requests, public issues, or agent prompts.

The default local Envoy home is `$HOME/.envoy`. If you used a custom
`ENVOY_HOME`, local data is under that directory instead.

After backing up anything you still need, you can remove local data by deleting
the Envoy home you own. Local deletion does not erase data already received by
other participants, copied into prompts/logs/tools, retained in backups, or
processed by the Envoy Connected relay for billing and operations.

## Usage Telemetry

Envoy does not send usage telemetry by default. The default runtime
configuration leaves `telemetry.enabled` off and has no telemetry endpoint.

Telemetry is opt-in. If `telemetry.enabled = true` is set explicitly, Envoy
requires an explicit `telemetry.endpoint`; placeholder endpoints such as
`example.com` are rejected. Telemetry ingest can queue and upload event records
such as event name, session identifier, install identifier hash, app version,
operating system, architecture, browser target, channel, stage, state, duration,
error code, notes, and recorded timestamp. Telemetry upload may also expose
request metadata visible to the configured endpoint, such as timing, source
network address, and payload size.

## Connected Relay Data

When using Envoy Connected, the relay may process or store:

- encrypted object payloads, chunks, manifests, and invite blobs;
- route-visible metadata such as request timing, source network address, object
  identifiers, sizes, chunk indexes, and contribution scopes;
- capability fields needed for validation;
- invite identifiers or code hashes;
- subscription, billing status, and usage counters when billing is configured;
- operational metrics needed to run the service.

The relay cannot read message plaintext from encrypted payloads by design, but
metadata privacy is limited. Envoy does not provide built-in anonymity, traffic
padding, cover traffic, Tor, OHTTP, or mixnet protection.

## Billing

Envoy Connected billing is handled through Stripe. Billing flows may send Stripe
the information required to create Checkout and customer portal sessions,
process subscriptions, and handle webhooks.

Use:

```bash
envoy billing status
envoy billing checkout
envoy billing portal
```

## Retention

Relay retention is bounded and operational. It is not an infinite archive.

Participants may retain data they already received. Revocation blocks future
authority; it does not erase plaintext or files already obtained by a
participant.

## External Agents And Tools

Envoy does not control what an agent, script, model provider, shell command, or
external API does with content after it receives it. Treat external egress as
part of your agent/runtime governance.
