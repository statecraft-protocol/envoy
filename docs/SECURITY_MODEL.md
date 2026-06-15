# Envoy Security Model

_Last updated: May 28, 2026._

Envoy gives every participant a shared space for durable work across sessions
and tools.
With [Connected](CONNECTED_BILLING.md), that space can span machines.

A space carries messages, tasks, authority, provenance, encrypted objects, and
history, so a later actor can read the current state from the space and
continue work instead of reconstructing it from scattered chats, prompts, or
local files.

Cross-machine reachability is covered in
[Connected And Billing](CONNECTED_BILLING.md).

This page states the public security model and user-visible limits. For the
product architecture shape, start with
[State vs context](../README.md#state-vs-context).

## What Envoy Protects

- Space authority is separate from message text. A prompt or chat message does
  not grant permission by itself.
- Spaces are invite-only. Members act through local identities and explicit
  space authority.
- Object plaintext is encrypted before it reaches the Connected relay.
- The relay can help with reachability and access checks without being trusted
  with message or artifact plaintext.
- Important actions are tied to identity, authority, and durable state so later
  participants can understand what happened.

## What The Relay Can See

The relay still sees service metadata needed to operate
[Connected](CONNECTED_BILLING.md) spaces:

- network and request metadata needed for abuse control and reliability;
- public identifiers needed for delivery and access checks;
- encrypted object metadata such as size, timing, and routing information;
- invite, membership, revocation, and billing state needed to run the service.

Envoy does not claim metadata invisibility, anonymity, or traffic analysis
resistance. The same metadata boundary is described from a privacy angle in the
[Privacy Policy](../PRIVACY.md).

## Cryptographic Posture

Envoy uses standard cryptographic building blocks for identity, authenticated
encryption, hashing, key derivation, and capability-scoped authorization. The
implementation uses maintained Rust cryptography libraries.

The public contract is the product behavior exposed through the Envoy CLI,
[MCP adapter](ENVOY_MCP.md), [Connected](CONNECTED_BILLING.md) relay,
[install path](INSTALL.md), [privacy policy](../PRIVACY.md), and security
policy.

Envoy has not completed an independent external cryptographic audit as of
May 28, 2026.

## Current Limits

Envoy does not provide:

- endpoint compromise protection after a device or agent runtime is controlled;
- sandboxing for agents or external tools;
- anonymity, cover traffic, padding, mixnets, or Tor-style transport privacy;
- guaranteed availability if the relay withholds, delays, or partitions data;
- automatic erasure of plaintext already seen by an authorized participant;
- cryptographic enforcement of no-forward, no-download, watermark, or similar
  policies after plaintext reaches a client;
- complete recovery of every local artifact from a recovery phrase alone.

Revocation is future-facing. It can block future authority and access, but it
cannot erase data a participant already received.

## How To Evaluate Envoy

Use the product through the documented CLI and MCP surfaces. Treat the security
claims above as the public boundary:

- plaintext is protected from the relay;
- authority is explicit and separate from message text;
- shared state persists across handoff, subject to the recovery and relay
  limits described here;
- relay-visible metadata remains visible;
- endpoint, participant, and agent behavior remain the user's responsibility.

Security reports are covered by [Envoy Security Policy](../SECURITY.md).

## Related Public Docs

- [State vs context](../README.md#state-vs-context)
- [Quickstart](QUICKSTART.md)
- [Envoy MCP](ENVOY_MCP.md)
- [Privacy Policy](../PRIVACY.md)
