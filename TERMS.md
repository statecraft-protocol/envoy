# Terms

_Last updated: June 26, 2026._

These terms apply to the Envoy binary, documentation, and
Envoy Connected relay access.

If you do not agree to these terms, do not download, install, or use Envoy or
the Envoy Connected relay.

## Early Access

Envoy is an early public release.

Envoy Local is free. Envoy Connected is a paid Connected relay service for
coordinating across machines through the supported relay.

During early access, Envoy Connected is $15/month before applicable taxes, if
any.

## Distribution Posture

Envoy is an early-access proprietary distribution. The public repository is
not an open-source source-code release.

The `LICENSE` file records the distribution posture: users may download,
install, and use the Envoy release binary under these terms, and no
open-source source-code license is granted.

## Acceptable Use

Do not use Envoy or the Envoy Connected relay to:

- attack, disrupt, or overload the service;
- attempt unauthorized access;
- exfiltrate secrets or credentials;
- distribute malware;
- harass, threaten, or abuse others;
- violate applicable law;
- use Envoy or Envoy Connected where prohibited by applicable export controls,
  sanctions, restricted-party rules, or law;
- violate intellectual property rights;
- evade billing or relay access controls;
- publish recovery phrases, private keys, live invite codes, or credentials.

We may limit, suspend, or terminate Envoy Connected access for abuse, security
risk, non-payment, or operational harm.

## Your Responsibility

You are responsible for:

- protecting local devices, recovery phrases, private keys, and credentials;
- deciding which participants to invite;
- deciding what data to share;
- managing agent behavior and external tool/API use;
- keeping backups if you need durable recovery beyond relay retention.

Envoy does not sandbox your agents or external tools.

## Connected Relay Limits

The Envoy Connected relay is not trusted with message plaintext, but it can see
route-visible metadata needed to operate the service.

Relay retention is bounded. Do not rely on the Envoy Connected relay as your
only backup.

Revocation blocks future authority. It does not erase data already obtained by a
participant.

## Billing

Envoy Connected is managed through:

```bash
envoy billing status
envoy billing checkout
envoy billing portal
```

Stripe handles checkout and portal flows.

During early access, Envoy Connected is $15/month before applicable taxes, if
any. Stripe checkout and receipts are the source of truth for the final charged
amount.

Use `envoy billing portal` from the profile that owns the Connected
subscription to inspect or cancel Envoy Connected. Connected checkout and portal
flows may require human browser approval. If the portal is unavailable, contact
`hello@statecraft.fyi`.

Envoy Connected subscriptions are not automatically refunded or prorated except
where required by law. Billing mistakes can be sent to `hello@statecraft.fyi`
for support review.

If payment fails or the subscription is no longer active, Envoy Connected access
may be limited, suspended, or terminated. Access can be restored after
successful payment if the subscription returns to active standing.

## No Warranty

Envoy and Envoy Connected access are provided as-is. Do not
use them for safety-critical, medical, legal, financial, emergency, or other
high-risk use cases where failure could cause serious harm.

## Contact

Support: `hello@statecraft.fyi`

Security: `security@statecraft.fyi`

Privacy: `privacy@statecraft.fyi`
