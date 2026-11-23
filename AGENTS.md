# org-ai-plugin working agreements

The shared OpenCode layer for the `simpsonm09-projects` organization, and the Claude Code and GitHub Copilot CLI plugin that registers the same skills.

## Ground rules

- The layer contributes no MCP server. Reach a shared service through its CLI, documented in the `service-integrations` registry. Add a server only when no CLI covers the job.
- Keep `layer.json`, `package.json`, and `opencode.fragment.jsonc` in sync. The contract test checks them. The file list in `layer.json` and `package.json` must match the runtime exactly; `tests/package-layout.test.ts` checks it.
- A skill id must match its directory and carry a non-empty third-person description.
- Keep the registry general and portable. Defer accounts, boards, workspaces, clusters, identities, and bundles to the personal layer.
- No personal content, secret, or machine path is committed.
- Agents use the owner's own accounts. There is no organization App, installation token, per-repository access level, or client-side shell gate. The rulesets, required checks, and hooks are the boundary; do not reintroduce a gate in this plugin.

## Commands

- `just install`, `just deps`, `just fmt-check`, `just lint`, `just complexity`, `just test`, `just check`, `just agent-files`.

## Repo facts

- Language and toolchain: TypeScript, Node, and `@opencode/plugin`. Bun installs (`bun.lock`), formats and lints; Node runs the `node:test` suite.
- `index.ts` registers every `skills/<id>/SKILL.md`. `.claude-plugin/plugin.json` and `.github/plugin/plugin.json` are the Claude Code and Copilot manifests; neither declares hooks.
- `maxstack` composes this layer above the PStack base and below the personal layer.
- Skills: `service-integrations`, `repo-tasks`, `repo-standard`, `local-services`, `review-session-history`, `machine-inventory`.
- The README covers the contents, the layering, and the layer contract.
- Hooks: `just hooks` installs the shared Lefthook jobs from `simpsonm09-projects/.github` at the `hooks-v3` tag; `lefthook-local.yml` is git-ignored. Never skip a hook: no `LEFTHOOK=0`, no `--no-verify`, and never create `lefthook-local.yml` (C7.11). The ruleset is the real gate.

## Skills

The plugin registers the skills under `skills/`. General best practices come from the PStack base. This layer adds the shared integration skills.
