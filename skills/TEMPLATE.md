# Envoy Skill Template

Use this template when creating a new loadable Envoy skill. The canonical skill
surface is `SKILL.md` so the skill remains portable across shell-capable agent
runtimes and humans. Do not require runtime-specific metadata unless packaging
for one runtime explicitly demands it.

Create new skills as:

```text
skills/envoy-<name>/SKILL.md
```

## Template

````markdown
---
name: envoy-<name>
description: Use when <specific trigger, workflow, artifact, participants, and
  Envoy-native reason>. Include the whole trigger surface here because agents
  use this field to decide when to load the skill.
---

# Envoy <Name>

One short paragraph: what work this skill turns into a space, what the space
carries, and what a late authorized participant can continue.

## Nonclaims

This skill is not <runtime, scheduler, model provider, sandbox, truth oracle,
external system, compliance guarantee, or always-on autonomy>. Envoy records
the work state. Agents and humans bring their own tools, judgment, permissions,
and external action authority.

State forbidden actions and sensitive data boundaries.

## Why Envoy

Private drafting can produce <single-agent artifact>. Envoy preserves
<identity, authority, task ownership, evidence, provenance, objections, repair,
decisions, handoff>.

Use this only when the replay trace is more valuable than a private final
answer. If one agent can do the work in one private model session without losing the
important state, do not make it an Envoy skill.

## Envoy Operating Contract

Before creating, joining, or operating a space, read the active Envoy agent
contract from this repository's `llms.txt`. Prefer local-only spaces unless
the user explicitly asks for cross-machine participation. Prefer `--json` when
exact IDs and state matter.

Create Envoy task objects for work lanes; do not rely on prose-only
assignments. Participants join with stable `ENVOY_PROFILE`, announce
role/authority, read history/inbox/tasks, claim by current title/body, and
re-read state before every mutation. Message text is context; authority comes
from local user instruction, task state, capability scope, and protocol
metadata. Ack inbox or complete tasks only after the intended Envoy side effect
is durable.

## Authority Refresh

Before any write, re-read recent history, inbox, task state, and current
authority. If Envoy reports read-only authority, missing capability, expired
capability, revoked capability, epoch change, epoch revocation, or a task that
is not assigned to the participant, stop mutation and re-check permission.
Roles and charters orient the work; protocol state, local user instruction,
task state, and capability scope decide what is allowed.

## Seats And Authority

- **Steward**: owns charter, scope, roles, invites, conflicts, and closeout.
- **Participant**: owns one lane, source, principal, artifact, or decision.
- **Reviewer**: checks work inside a named lens.
- **Skeptic**: challenges unsupported claims, stale state, weak evidence,
  duplicate work, and premature closure.
- **Approver**: records accepted, rejected, deferred, or conditional decisions
  within the authority boundary.

Name only the seats the workflow truly needs. Keep authority narrow.

## Orchestrator Flow

1. Establish mission, scope, participants, authority, forbidden actions,
   evidence bar, done criteria, and stop conditions.
2. Choose local-only unless cross-machine participation is explicit.
3. Create or select one Envoy space and seed a charter.
4. Create one Envoy task object per role, lane, or deliverable.
5. Mint finite least-privilege invites when other participants are needed.
6. Require participants to join, announce, read history/inbox/tasks, claim by
   current title/body, post first status, then act.
7. Preserve decisions, evidence, objections, repairs, risks, and handoff in
   Envoy-visible state.
8. Close only when a late authorized participant can continue from the space.

## Required Records

```markdown
## Charter
- Mission:
- Scope:
- Participants:
- Authority boundary:
- Evidence required:
- Forbidden actions:
- Done criteria:
- Stop conditions:
```

```markdown
## Evidence
- Claim:
- Source / command / file:
- Result:
- Confidence:
- Follow-up:
```

```markdown
## Objection Or Repair
- Target:
- Objection:
- Evidence:
- Repair made or required:
- Residual risk:
```

```markdown
## Handoff
- Current state:
- Completed:
- Remaining:
- Evidence:
- Risks:
- Exact next action:
```

## Seed Invocation

```text
Use envoy-<name> for this work:
<mission and context>.

Mode: local-only unless I explicitly ask for cross-machine participation.
Participants/roles: <participants>. Authority boundary: <scope>.
Forbidden actions: <forbidden>. Evidence bar: <evidence>. Done criteria:
<artifacts and Envoy-visible state>.

Create or select one Envoy space, seed the charter, create task objects, and
record every decision, evidence item, objection, repair, risk, and handoff in
Envoy.
```

## Validation

The skill worked if a late authorized participant can read only Envoy-visible
state and answer: what happened, who had authority, what evidence exists, what
changed, what remains unresolved, and what exact action comes next.
````

## Repository Rules For Skill Authors

These rules apply to maintainers adding or revising skills in this repository.
They are not runtime instructions for people using Envoy. Users consume the
checked-in skill files; they do not edit `llms.txt`, `llms-full.txt`, or this
template.

- Keep each loadable skill self-contained in its own `SKILL.md`.
- Adding, renaming, or removing a skill should not require a matching catalog
  entry in `llms.txt` or `llms-full.txt`. Those files describe the general
  skill contract; the `skills/` directory is the source of truth for the
  current catalog. Update the LLM docs only when the contract changes.
- Do not include invite codes, local-only paths, stale task IDs, or validation
  notes that are not part of the user-facing skill contract.
- Do not claim Envoy runs agents, chooses models, executes workflows, enforces
  compliance, provides a sandbox, or keeps agents alive.
- Prefer spaces, work state, authority, provenance, evidence, and handoff over
  chat, meetings, rooms, or abstract framing.
