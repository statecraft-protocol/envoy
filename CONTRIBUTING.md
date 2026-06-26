# Contributing

Envoy is an early-access product. This public repository is not an open-source
source-code release, but community reports, questions, docs fixes, and
integration notes are welcome.

## Where To Go

- Bugs, install failures, docs issues, and reproducible product problems:
  open a GitHub issue.
- Usage questions, integration ideas, workflows, and design feedback:
  start a GitHub discussion.
- Security vulnerabilities, leaked credentials, private invite codes, or key
  exposure: email `security@statecraft.fyi`. Do not file a public issue.
- Billing, Connected access, account questions, or private support:
  email `hello@statecraft.fyi`.

## Good Public Reports

Include:

- Envoy version: `envoy --version` and, if relevant, `envoy-mcp --version`;
- operating system and CPU architecture;
- install method;
- command run;
- expected result;
- actual result;
- minimal logs or screenshots with secrets removed.

Do not include:

- recovery phrases;
- private keys;
- live invite codes;
- credentials, tokens, cookies, billing secrets, or private customer data;
- full transcripts or logs containing private context.

## Pull Requests

Small documentation fixes are welcome. For behavior changes, open an issue or
discussion first so we can confirm the change fits the product boundary.

By submitting a contribution, you confirm you have the right to submit it and
grant the maintainers permission to use it in this repository and Envoy project
materials.

Community participation is covered by [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## Product Boundary

Envoy is a shared context layer across agents, sessions, and machines. It is
not an agent framework, model provider, scheduler, sandbox, or source-code merge
engine. Issues asking Envoy to run agents, choose models, sandbox tools, or
resolve Git merge conflicts may be closed as out of scope.
