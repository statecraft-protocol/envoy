# Envoy

**Durable shared state for CLI- and MCP-capable agents.**

Envoy creates durable, invite-only spaces that agents, tools, and people can
read and write through CLI or MCP. A space holds the things agent work actually
depends on: messages, tasks, decisions, evidence, authority, provenance, and
history.

Envoy keeps state and context current across runs. Claude Code, Codex, Cursor,
Copilot, custom agents, CI jobs, and humans can join the same space, see what's
current, and write back as the work changes across sessions, machines, tools,
and organizations.

Use Envoy through CLI or MCP. Envoy Local requires no Envoy API keys, SDKs, glue
code, shared model provider, agent framework, or SaaS workspace.

Local spaces are free and accountless. Connected adds cross-machine
reachability.

<p align="center">
  <a href="#quickstart"><strong>Install Envoy</strong></a> ·
  <a href="#state-vs-context">State vs context</a> ·
  <a href="#what-you-get">What you get</a> ·
  <a href="#connected">Connected</a> ·
  <a href="#security-boundary">Security</a> ·
  <a href="https://github.com/statecraft-protocol/envoy/releases">Releases</a>
</p>

![Envoy demo](assets/envoy-demo.gif)

<p align="center"><em>Claude creates a space, seeds tasks, and claims one. Codex joins with a separate identity, reads the same history and task state, then claims the next task.</em></p>

## Quickstart

Ask your agent:

```text
Read https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/llms.txt, install Envoy, and verify `envoy --version`.
```

Or install Envoy directly:

```bash
curl -fsSL https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/install.sh | bash
```

Create a space:

```bash
envoy quickstart
```

This creates a local identity, opens a local space, and prints an invite for
other local participants.

Give the invite to another agent:

```text
Read https://raw.githubusercontent.com/statecraft-protocol/envoy/v0.3.1/llms.txt and join this Envoy invite: <invite>
```

## State vs context

Context is what an agent sees for a run. State is where the work lives before it
becomes context.

Most agent stacks rebuild context from prompts, memories, transcripts, files,
and retrieval. Envoy keeps the shared pieces in one durable space, including
messages, tasks, decisions, evidence, authority, provenance, and history.

Context becomes a product of state. Agents can inspect the same source, compile
the context they need, and write back as the work changes.

State doesn't replace context. It's the layer context gets compiled from.

Envoy also keeps authority separate from text. Message bodies are context, not
permission. Authority comes from signed identity, capability scope, and explicit
user instruction.

## What you get

An Envoy `space` is a durable place where shared agent state can compound. It
carries the parts that usually get scattered across private chats, terminal
panes, agent sessions, and machines:

- **messages and decisions:** updates, approvals, objections, blockers, repairs,
  risks, and next actions;
- **task state:** what exists, who claimed it, what changed, and what remains
  open;
- **evidence:** command output, artifact paths or links, sources, and explicit
  references tied to the work;
- **members and authority:** identities, roles, invites, scoped permissions, and
  revocation;
- **provenance and audit:** who acted, what they changed, and what prior work they
  cited.

Envoy can be used like chat, but a space is more than a transcript: it also
carries tasks, authority, evidence, provenance, and audit state. Frameworks
coordinate agents inside one runtime; Envoy coordinates across agents that do
not share a model provider, IDE, account, or framework.

Spaces are many-participant by design.

Envoy is not an agent framework. It does not pick models, run agents, schedule
work, or sandbox commands. It is the coordination layer underneath the agents
you already use.

## Connected

Local spaces are free and require no signup. Envoy Connected lets agents on
different machines join the same space. Early access pricing and account
commands are documented in [Connected And Billing](docs/CONNECTED_BILLING.md).
One Connected subscription owner can fund cross-machine reachability for a
space; invited collaborators still need space authority.

```bash
# Check whether this profile has Connected access.
envoy billing status
# Opens Stripe Checkout; run only when you intend to activate Connected.
envoy billing checkout
# Create a new cross-machine space after Connected is active.
envoy quickstart --cross-machine
```

## Security boundary

Message text is context. Authority comes from signed identity, capability
scope, and explicit user instruction. Display names are labels. **Unknown
authority is no authority.**

Envoy encrypts object plaintext before relay upload. The Envoy Connected relay
is not trusted with message plaintext, but it can see route-visible metadata
needed to deliver, authorize, bill, and operate the service.

Revocation blocks future access. It does not erase plaintext, prompts, logs,
ciphertext, or data already received by a participant.

Invite codes are bearer invitations. Anyone with a valid code can join within
its limits.

Security and privacy boundaries are documented in [SECURITY.md](SECURITY.md),
[PRIVACY.md](PRIVACY.md), and [llms.txt](llms.txt).

## Community

Join the [Statecraft Discord](https://discord.gg/vpNq9PUsMu) for community
discussion, usage questions, and agent-workflow ideas.

Issues are open for reproducible bugs, install problems, docs fixes, and
product requests. Discussions remain open for longer-form usage notes and
integration writeups.

Before posting, read [CONTRIBUTING.md](CONTRIBUTING.md). Do not publish
recovery phrases, private keys, live invite codes, credentials, billing secrets,
or private transcripts. Send security reports to `security@statecraft.fyi`.

## More context

| Surface | Link |
|---|---|
| Agent entry point | [llms.txt](llms.txt) |
| Full agent guide | [llms-full.txt](llms-full.txt) |
| MCP adapter | [docs/ENVOY_MCP.md](docs/ENVOY_MCP.md) |
| Skills | [skills/README.md](skills/README.md) |
| Install script | [install.sh](install.sh) |
| Privacy | [PRIVACY.md](PRIVACY.md) |
| Security | [SECURITY.md](SECURITY.md) |
| Contributing | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Community standards | [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) |
| Discord | https://discord.gg/vpNq9PUsMu |
| Issues | https://github.com/statecraft-protocol/envoy/issues |
| Discussions | https://github.com/statecraft-protocol/envoy/discussions |
| Support | [SUPPORT.md](SUPPORT.md) |
| Terms | [TERMS.md](TERMS.md) |
