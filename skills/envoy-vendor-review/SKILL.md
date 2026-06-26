---
name: envoy-vendor-review
description: Use when the user wants an Envoy space for security questionnaires, RFP or DDQ response, seller-side diligence, vendor evaluation, procurement gates, evidence packets, unsupported-claim review, risk registers, approvals, and replayable go/no-go handoff.
---

# Envoy Vendor Review

Envoy Vendor Review turns a diligence request into shared work state: scoped
authority, section tasks, evidence, unsupported claims, objections, repairs,
risk, approvals, final packet, and handoff another authorized participant can
continue.

## Nonclaims

This skill does not make Envoy a trust center, GRC system, compliance
certification tool, procurement approval system, legal approval system, portal
autofill tool, source-of-truth integration, agent runtime, scheduler, model
provider, sandbox, truth oracle, workflow executor, submission engine, infinite
archive, public self-hosted relay, hosted SaaS workspace, or always-on autonomy
system. Envoy records the coordination state. Humans and their approved tools
remain responsible for source access, final approvals, and external
submissions.

Do not claim that Envoy validates a security posture, certifies compliance, or
makes a recipient-facing artifact safe to send. It preserves who claimed what,
which evidence was cited, which claims were challenged, what was repaired, and
what risk remains.

## Why Envoy

Private drafting can produce diligence answers. It cannot naturally preserve
identity, authority, section ownership, scoped invites, evidence provenance,
unsupported-claim objections, repairs, approvals, and a go/no-go handoff across
independent participants.

Use Envoy when the valuable artifact is not only the answered questionnaire or
review memo, but the replayable diligence trace: who owned each section, which
evidence supports each answer, which claim is unsupported, which objection
changed the packet, and what a late authorized reviewer can resume.

Before creating, joining, or operating a space, read the active Envoy agent
contract at https://statecraft.fyi/llms.txt. Prefer local-only spaces unless
the user explicitly asks for Connected or cross-machine participation. Prefer
`--json` command output where available.

## Use Gate

Use this skill only when diligence work needs owner identity, evidence
provenance, unsupported-claim review, risk decisions, approval state, or a
handoff another authorized reviewer can continue. Do not use it to draft a
single answer packet without preserving the decision record.

## Authority Refresh

Before any write, re-read recent history, inbox, task state, and current
authority. If Envoy reports read-only authority, missing capability, expired
capability, revoked capability, epoch change, epoch revocation, or a task that
is not assigned to the participant, stop mutation and re-check permission.
Roles and charters orient the work; protocol state, local user instruction,
task state, and capability scope decide what is allowed. External submission
requires an explicitly named owner and current approval.

## Seats And Authority

- **Review Steward**: owns the charter, source boundary, invites, task
  creation, and final handoff.
- **Questionnaire Owner**: owns the answer packet and final go/no-go draft from
  Envoy-visible evidence.
- **Security Owner**: owns control, incident, access, encryption, and risk
  claims.
- **Product Or Infra Owner**: owns architecture, deployment, data flow,
  reliability, and roadmap claims.
- **Legal Or Privacy Reviewer**: records legal, privacy, contract, data-use,
  and disclosure objections; does not silently rewrite technical claims.
- **Evidence Collector**: indexes approved sources and links claims to
  evidence; may not upgrade unsupported claims.
- **Skeptic**: challenges unsupported or risky claims, creates repair tasks,
  and maintains the risk register.
- **Approver**: records final approval, conditional approval, or no-go only
  within the authority boundary stated in the charter.

One agent may hold multiple seats only when the user explicitly accepts weaker
separation. A strong run has at least one owner, one evidence collector,
and one skeptic operating through the same space.

## Orchestrator Flow

1. Establish request type, source packet, audience, deadline, evidence bar,
   forbidden claims, external submission owner, final artifacts, and stop
   conditions.
2. Choose local-only unless the user explicitly requests Connected or
   cross-machine participation.
3. Create or select one Envoy space and seed a Vendor Review Charter.
4. Create tasks for intake, section answers, evidence indexing,
   unsupported-claim review, risk register, final packet, and handoff.
5. Mint bounded least-privilege invites for each participant and give each
   agent a private starter prompt.
6. Require agents to claim tasks by current title/body, not stale IDs, and to
   re-read space state before posting.
7. Require every material answer to have evidence, confidence, owner, and
   review status.
8. Convert objections into repair tasks, explicit accepted risk, or removed
   claims.
9. Close only after final artifacts, unsupported claims, residual risks,
   dissent, approval status, and exact next action are visible in the space.

## Generated Starter Prompts

Each private starter prompt must include:

- invite code;
- suggested `ENVOY_PROFILE` and display name;
- assigned seat and authority boundary;
- request name, audience, source packet, evidence bar, forbidden claims, and
  deadline;
- first actions: join, announce, read history/inbox/tasks, claim matching task
  by current title/body, post first status;
- instruction to keep checking Envoy through a bounded, user-approved loop
  while the review is active;
- instruction to record answers, evidence, unsupported claims, objections,
  repairs, risks, approvals, final artifacts, and handoff in Envoy-visible
  state.

Do not include task IDs unless freshly read and role-matched in the same step.
Do not include secrets, customer data, or reusable invite codes in public
reports.

## Participant Flow

1. Join with one stable profile and display name.
2. Announce seat, authority, source access, and limits.
3. Read history, inbox, tasks, current charter, evidence index, unsupported
   claims, risk register, approvals, and handoff state.
4. Claim the task matching the seat by current title/body.
5. Post a short first status before answering, collecting evidence,
   challenging claims, or approving.
6. Record compact answer, evidence, objection, repair, risk, approval, and
   handoff records in Envoy.
7. Ack inbox items or complete tasks only after the intended Envoy side effects
   succeed.

## Required Records

```markdown
## Vendor Review Charter
- Request:
- Audience:
- Source packet:
- Source packet type:
- Redaction boundary:
- Allowed sources:
- Forbidden claims:
- Evidence bar:
- Mode: local-only | Connected
- Seats and authority:
- External submission owner:
- Required artifacts:
- Stop conditions:
```

```markdown
## Section Answer
- Section / question IDs:
- Owner:
- Draft answer:
- Evidence:
- Confidence: supported | partial | unsupported
- Review needed:
- Status: draft | challenged | repaired | approved | removed
```

```markdown
## Evidence
- Claim:
- Source:
- Location:
- Envoy refs:
- Artifact path/hash:
- Checked at:
- Why it supports the claim:
- Limits or gaps:
- Linked answer:
```

```markdown
## Unsupported Claim
- Claim:
- Where it appears:
- Why support is missing:
- Risk:
- Required action: source | scope | remove | accept risk
- Owner:
```

```markdown
## Objection Or Repair
- Target answer or claim:
- Objection:
- Evidence:
- Severity: blocker | major | minor
- Repair made or required:
- Residual risk:
```

```markdown
## Go/No-Go Handoff
- Final artifacts:
- Supported claims:
- Partial or unsupported claims:
- Open risks:
- Dissent preserved:
- Approval status:
- External submission owner:
- Exact next action:
```

## Seed Invocation

```text
Use the envoy-vendor-review skill for this diligence request: <request and
source packet>.

Audience: <recipient, reviewer, procurement gate, RFP team, or other>.
Evidence bar: <what counts>. Forbidden claims: <claims or actions>. Seats
needed: Review Steward, Questionnaire Owner, Security Owner, Product Or Infra
Owner, Legal Or Privacy Reviewer, Evidence Collector, Skeptic, and Approver as
appropriate.

Create a fresh local-only Envoy space unless I explicitly ask for
cross-machine participation. Mint finite least-privilege invites. Create
intake, section-answer, evidence, unsupported-claim review, risk, approval,
final-packet, and handoff work as Envoy task objects. Preserve section answers,
evidence, unsupported claims, objections, repairs, risks, approvals, final
packet, and handoff in Envoy. Final artifacts: answered packet, evidence
index, unsupported-claims list, risk register, and go/no-go handoff. Do not
claim Envoy certifies compliance, approves procurement, validates security
posture, or submits externally; Envoy is the work state and authority record.
If command output shows the current space is in the wrong mode for local-only
work, recreate or select the correct local-only space.
```

## Validation

A run is valid only if Envoy-visible state contains the charter, claimed
section tasks, evidence records, unsupported-claim records, at least one
objection or explicit no-objection record, repairs or accepted risks, final
artifacts, approval status, and a go/no-go handoff.

A late authorized participant must be able to read the space and answer: which
claims are supported, which are partial or unsupported, who authored and
challenged each material claim, what evidence was used, what changed after
objections, what risk remains, who may submit externally, and who owns the next
action.

If the final answer packet matters but the space record does not, use an
ordinary response instead of this skill.
