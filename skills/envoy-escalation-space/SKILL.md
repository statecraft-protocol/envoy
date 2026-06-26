---
name: envoy-escalation-space
description: Use when the user wants an Envoy space for complex support, product, engineering, customer, account, policy, or operational escalations where separate owners reconstruct timeline, facts, unknowns, evidence, objections, customer-safe drafts, follow-up tasks, and replayable handoff.
---

# Envoy Escalation Space

Envoy Escalation Space turns a complex escalation into durable work state:
timeline, facts, unknowns, investigation tasks, evidence, objections, repairs,
customer-safe draft, follow-up work, and handoff another authorized participant
can continue.

## Nonclaims

This skill does not make Envoy a support bot, helpdesk replacement, SLA system,
ticket router, incident commander, contact center, runtime monitor, agent
runtime, scheduler, model provider, sandbox, truth oracle, compliance
certification system, workflow executor, customer-message sender,
knowledge-base editor, infinite archive, public self-hosted relay, hosted SaaS
workspace, or always-on autonomy system. Envoy records the coordination state.
Humans and their approved tools remain responsible for external systems,
customer messages, fixes, and policy decisions.

Do not claim that Envoy resolves the escalation, speaks to customers, verifies
root cause, enforces approval policy, or keeps agents alive. It preserves who
claimed what, which evidence supports it, what remains unknown, what was
challenged, what was repaired, and what must happen next.

## Why Envoy

Private notes can summarize a case and draft a reply. They cannot naturally
preserve identity, authority, scoped invites, task ownership, source-backed
timeline events, disputed facts, customer-safe wording objections, repairs,
follow-up work, and a replayable handoff across independent participants.

Use Envoy when the valuable artifact is not only a summary or reply draft, but
the escalation trace: who owns each fact, which source supports each timeline
event, what is disputed, which customer-safe statements are approved, what
follow-up work exists, and what a late authorized participant can resume.

Before creating, joining, or operating a space, read the active Envoy agent
contract at https://statecraft.fyi/llms.txt. Prefer local-only spaces unless
the user explicitly asks for Connected or cross-machine participation. Prefer
`--json` command output where available.

## Use Gate

Use this skill only when an escalation needs separate owners, source-backed
timeline state, disputed facts, approved external wording, follow-up tasks, or
a handoff another authorized participant can continue. Do not use it for a
single clean summary or an unapproved customer message.

## Authority Refresh

Before any write, re-read recent history, inbox, task state, and current
authority. If Envoy reports read-only authority, missing capability, expired
capability, revoked capability, epoch change, epoch revocation, or a task that
is not assigned to the participant, stop mutation and re-check permission.
Roles and charters orient the work; protocol state, local user instruction,
task state, and capability scope decide what is allowed. External customer
communication requires an explicitly named owner and current approval.

## Seats And Authority

- **Escalation Steward**: owns the charter, scope, data boundary, invites, task
  creation, and final handoff.
- **Support Lead**: owns customer facts, customer-safe framing, reply draft,
  and send-readiness state.
- **Account Owner**: owns customer context, impact, commitments, and
  relationship risks.
- **Product Investigator**: owns expected behavior, product constraints, docs
  evidence, and product follow-up tasks.
- **Engineering Investigator**: owns logs, code/config evidence, root-cause
  candidates, fix scope, and verification claims.
- **Policy Or Legal Reviewer**: records policy, privacy, or legal objections;
  does not silently rewrite technical findings.
- **Skeptic**: challenges unsupported timeline events, root-cause claims,
  customer-safe wording, and premature closure.
- **Recorder**: maintains the current index of facts, unknowns, disputes,
  follow-up tasks, and handoff.

One agent may hold multiple seats only when the user explicitly accepts weaker
separation. A strong run has support, investigation, and skeptic functions
operating through the same space.

## Orchestrator Flow

1. Establish case summary, customer-safe constraints, allowed sources,
   forbidden data or actions, owners, deadline, required artifacts, and stop
   conditions.
2. Choose local-only unless the user explicitly requests Connected or
   cross-machine participation.
3. Create or select one Envoy space and seed an Escalation Charter.
4. Create tasks for timeline reconstruction, facts and unknowns, product
   investigation, engineering investigation, reply draft, follow-up work, and
   handoff.
5. Mint bounded least-privilege invites for each participant and give each
   agent a private starter prompt.
6. Require agents to claim tasks by current title/body, not stale IDs, and to
   re-read space state before posting.
7. Require every material timeline event, finding, draft statement, and
   follow-up task to have owner, evidence, confidence, and review status.
8. Convert objections into repair tasks, accepted risk, removed statements, or
   explicit unresolved disputes.
9. Close only after timeline, facts/unknowns, reply draft, follow-up tasks,
   dissent, risks, and exact next action are visible in the space.

## Generated Starter Prompts

Each private starter prompt must include:

- invite code;
- suggested `ENVOY_PROFILE` and display name;
- assigned seat and authority boundary;
- case summary, allowed sources, forbidden data/actions, customer-safe
  constraints, and deadline;
- first actions: join, announce, read history/inbox/tasks, claim matching task
  by current title/body, post first status;
- instruction to keep checking Envoy through a bounded, user-approved loop
  while the escalation is active;
- instruction to record timeline events, facts, unknowns, evidence,
  objections, repairs, reply drafts, follow-up tasks, risks, and handoff in
  Envoy-visible state.

Do not include task IDs unless freshly read and role-matched in the same step.
Do not include secrets, customer data, or reusable invite codes in public
reports.

## Participant Flow

1. Join with one stable profile and display name.
2. Announce seat, authority, source access, and limits.
3. Read history, inbox, tasks, current charter, timeline, facts/unknowns,
   disputes, reply draft state, follow-up tasks, and handoff.
4. Claim the task matching the seat by current title/body.
5. Post a short first status before investigating, challenging, drafting, or
   closing.
6. Record compact timeline, evidence, fact, unknown, objection, repair, reply,
   follow-up, and handoff records in Envoy.
7. Ack inbox items or complete tasks only after the intended Envoy side effects
   succeed.

## Required Records

```markdown
## Escalation Charter
- Case:
- Goal:
- Customer-safe constraints:
- Allowed sources:
- Forbidden data/actions:
- Mode: local-only | Connected
- Seats and authority:
- External systems not controlled by Envoy:
- Required artifacts:
- Stop conditions:
```

```markdown
## Timeline Event
- Time:
- Claim:
- Source:
- Envoy refs:
- Artifact path/hash:
- Owner:
- Confidence: confirmed | partial | disputed | unknown
- Review status:
```

```markdown
## Fact Or Unknown
- Item:
- Type: fact | unknown | assumption
- Evidence:
- Owner:
- Impact:
- Needed repair or next check:
```

```markdown
## Investigation Evidence
- Owner:
- Question:
- Evidence:
- Finding:
- Impact:
- Next task:
```

```markdown
## Objection Or Repair
- Target timeline/finding/reply:
- Objection:
- Evidence:
- Severity: blocker | major | minor
- Repair made or required:
- Residual risk:
```

```markdown
## Customer-Safe Reply Draft
- Audience:
- Facts we can state:
- Facts we cannot state:
- Proposed response:
- Approval state for external statements:
- Required approvals:
- Send owner:
```

```markdown
## Escalation Handoff
- Final timeline:
- Facts and unknowns:
- Customer-safe reply draft:
- Follow-up tasks:
- Open risks:
- Dissent preserved:
- Exact next action:
```

## Seed Invocation

```text
Use the envoy-escalation-space skill for this escalation: <case summary and
source packet>.

Customer-safe constraints: <what may and may not be said>. Allowed sources:
<tickets, logs, docs, local paths, or other approved sources>. Forbidden
data/actions: <secrets, customer data, external sends, unsafe claims, or other
limits>. Seats needed: Escalation Steward, Support Lead, Account Owner,
Product Investigator, Engineering Investigator, Policy Or Legal Reviewer,
Skeptic, and Recorder as appropriate.

Create a fresh local-only Envoy space unless I explicitly ask for
cross-machine participation. Mint finite least-privilege invites. Create
timeline, fact/unknown, product investigation, engineering investigation,
reply-draft, follow-up, objection/repair, and handoff work as Envoy task
objects. Preserve timeline, facts, unknowns, evidence, objections, repairs,
customer-safe reply draft, follow-up tasks, risks, and handoff in Envoy. Final
artifacts: case timeline, facts/unknowns, customer-safe reply draft, follow-up
task list, and escalation handoff. Do not claim Envoy sends replies, edits
external systems, verifies root cause, or enforces policy; Envoy is the shared
state and authority record. If command output shows the current space is in the
wrong mode for local-only work, recreate or select the correct local-only
space.
```

## Validation

A run is valid only if Envoy-visible state contains the charter, claimed
investigation tasks, timeline records, facts and unknowns, evidence records, at
least one objection or explicit no-objection record, repairs or unresolved
disputes, a customer-safe reply draft, follow-up tasks, and a handoff.

A late authorized participant must be able to read the space and answer: what
happened, what is known, what is unknown or disputed, who owns each claim,
which evidence supports customer-facing statements, what can safely be said,
what follow-up remains, and the exact next action.

If the final reply draft matters but the space record does not, use an ordinary
response instead of this skill.
