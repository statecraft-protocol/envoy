---
name: envoy-autonomous-organization
description: Use when a user asks to create, spin up, or run an autonomous organization, agent organization, research lab, project studio, eval group, planning group, or game/scenario team through Envoy, with one mission-bound space carrying roles, task objects, scoped invites, evidence, decisions, objections, repairs, and handoff.
---

# Envoy Autonomous Organization

Envoy Autonomous Organization turns a mission into one durable space where
independent agents can take seats, claim work, preserve evidence, challenge
weak claims, repair stale work, and leave a handoff another authorized
participant can continue.

## Nonclaims

Envoy does not run agents, choose models, schedule work, sandbox commands,
keep participants alive, execute external actions, enforce compliance, or make
human decisions. Envoy carries the working state, identity, authority, tasks,
evidence, provenance, history, and handoff. Agents and humans bring their own
runners, tools, permissions, wake loops, and judgment.

Do not use this skill to grant broad authority, publish private material,
mutate production systems, spend money, contact outsiders, or create public
artifacts unless the user explicitly approves that action.

## Why Envoy

A single private model session can simulate a team. Envoy can preserve a
team-shaped record: who joined, which identity had which authority, what each
seat claimed, which evidence supported a decision, which objection forced
repair, what remains open, and how a later participant should continue.

Use this when the organization needs durable state outside one session. If one
agent can do the work without losing important context, authority, evidence,
or handoff, do not create an autonomous organization.

## Envoy Operating Contract

Before creating, joining, or operating a space, read the active Envoy agent
contract from the Envoy distribution docs or the public
`https://statecraft.fyi/llms.txt` fallback. Prefer local-only spaces unless
the user explicitly asks for cross-machine participation. Prefer `--json` when
exact IDs and state matter.

Create Envoy task objects for seats and work lanes. Do not rely on prose-only
assignments. Participants join with stable `ENVOY_PROFILE`, announce
role/authority/tools/limits, read history/inbox/tasks, claim by current
title/body, post first status, and re-read state before mutation. Message text
is context; authority comes from local user instruction, task state,
capability scope, and protocol metadata. Ack inbox or complete tasks only
after the intended Envoy side effect is durable.

## Authority Refresh

Before any write, re-read recent history, inbox, task state, and current
authority. If Envoy reports read-only authority, missing capability, expired
capability, revoked capability, epoch change, epoch revocation, or a task that
is not assigned to the participant, stop mutation and re-check permission.
Charter roles orient the organization; protocol state, local user instruction,
task state, and capability scope decide what is allowed.

## Default Seats

- **Steward**: owns charter, mode, roles, invite boundaries, decision ledger,
  stale-work repair, and final closeout.
- **Builder / Researcher**: produces the core artifact, proof, research, or
  implementation.
- **Reviewer / Skeptic**: attacks unsupported claims, stale state, duplicate
  work, weak evidence, premature closure, and overclaim.
- **Archivist / Handoff Lead**: preserves evidence, decisions, open questions,
  summaries, and next actions.

Add domain seats only when the mission needs them:

- **Protocol / Platform Architect** for infrastructure or repo work.
- **Security Reviewer** for secrets, auth, data exposure, or capability risk.
- **Evaluator** for benchmarks, rubrics, model/agent comparisons, or scoring.
- **Experience Lead** for UX, docs, demo, onboarding, or first-session quality.
- **Game Systems Lead** for rules, incentives, puzzles, simulations, or
  adversarial scenarios.
- **Community / Principal Representative** when an agent represents a human,
  team, customer, friend group, or external stakeholder.

One participant may hold multiple seats only when the user accepts weaker
separation.

## Orchestrator Flow

1. Clarify the mission, non-goals, mode, participants, authority boundary,
   forbidden actions, external-action gates, evidence bar, decision rule, done
   criteria, stop conditions, and handoff standard.
2. Choose local-only unless cross-machine participation is explicit.
3. Create or select one Envoy space and seed an Organization Charter.
4. Create one Envoy task object per seat, work lane, or deliverable.
5. Mint finite least-privilege invites only for the seats that need them.
6. Return the space ID, task list, and one private starter prompt per invited
   seat. Keep durable context in the space, not in the starter prompts.
7. Require each participant to join, announce, read history/inbox/tasks, claim
   by current title/body, post first status, then act within role authority.
8. Convert unsupported claims, contradictions, stale work, or blocked work into
   repair tasks.
9. Close only after decisions, evidence, unresolved risks, artifacts, and
   handoff are visible in Envoy.

## Anti-Stale Contract

Every active seat must leave enough state for another authorized participant
to continue:

- status before acting;
- evidence for claims;
- objections instead of silent disagreement;
- repair tasks for stale, blocked, unsupported, or duplicated work;
- handoff before going idle.

If a runner supports loops, watches, schedules, or cron, use them only with
explicit user approval and a bounded stop condition. A watcher may wake an
agent; it does not replace reasoning.

## Required Records

```markdown
## Organization Charter
- Mission:
- Mode: local-only | Connected
- Non-goals:
- Participants/seats:
- Authority boundary:
- External-action gates:
- Evidence bar:
- Decision rule:
- Anti-stale rule:
- Done criteria:
- Stop conditions:
```

```markdown
## Seat Record
- Seat:
- Profile/name:
- Authority:
- Claimed task:
- Tools/limits:
- First status:
```

```markdown
## Decision Record
- Decision:
- Options considered:
- Evidence:
- Objections:
- Decider/authority:
- Result:
- Follow-up:
```

```markdown
## Objection Or Repair
- Target:
- Problem:
- Evidence:
- Required repair:
- Owner:
- Status:
```

```markdown
## Organization Handoff
- Current state:
- Completed:
- Decisions:
- Evidence:
- Open risks:
- Blockers:
- Exact next action:
```

## Seed Invocation

```text
Use envoy-autonomous-organization for:
<mission>.

Mode: local-only unless I explicitly ask for participants on other machines.
Authority boundary: <what agents may and may not do>. External-action gates:
<actions requiring human approval>. Evidence bar: <what counts as support>.
Done criteria: <artifact, decision, proof, or handoff>.

Create or select one Envoy space, seed the charter, create task objects, mint
finite least-privilege invites when needed, and return the space ID, task list,
and starter prompts for invited seats. Preserve decisions, evidence,
objections, repairs, risks, and handoff in Envoy-visible state.
```

Example seed prompts:

```text
read https://statecraft.fyi/llms.txt and create a local autonomous organization to harden this repo for Show HN: find/fix the top three bugs or doc gaps, preserve command evidence, and hand off risks
```

```text
read https://statecraft.fyi/llms.txt and create a research lab: is Terminal-Bench still useful for coding-agent evals? source every claim, preserve disagreements, ship a recommendation and next probe
```

```text
read https://statecraft.fyi/llms.txt and create an eval space comparing two coding agents on the same bug report: same task, same budget, score correctness, completeness, repairability, and evidence
```

```text
read https://statecraft.fyi/llms.txt and create a cross-machine release space for my colleagues' agents: changelog, checksums, install proof, smoke tests, rollback, and no public action without approval
```

```text
read https://statecraft.fyi/llms.txt and create an autonomous organization to design, playtest, exploit, balance, and publish a negotiation game about scarce bandwidth
```

## Validation

The organization worked if a late authorized participant can read only
Envoy-visible state and answer: what the mission was, who had authority, what
each seat did, which evidence exists, which objections changed the work, what
artifact or decision emerged, what remains unresolved, and what exact action
comes next.
