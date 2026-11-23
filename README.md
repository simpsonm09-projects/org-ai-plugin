# org-ai-plugin

The shared OpenCode layer for the `simpsonm09-projects` organization, and the Claude Code and GitHub Copilot CLI plugin that registers the same skills.

This repository lives in `simpsonm09-projects/org-ai-plugin`. Work happens on a branch
with a pull request into `main`.
See [`repo-standard`](https://github.com/simpsonm09-projects/repo-standard)
for the branch model and the protection rules, and the
[documentation index](docs/README.md) for the repository's docs.

It is CLI-first and contributes no MCP server. It contributes the shared skills every repository in the organization should have, and nothing personal. The `service-integrations` registry is general and portable; accounts, boards, workspaces, clusters, identities, and bundles live in the personal layer, which the org skills defer to. `maxstack` composes this layer above the faithful PStack port and below the personal layer.

## Contents

- `layer.json` describes the layer: its name, kind, config fragment, and plugin files.
- `opencode.fragment.jsonc` is the fragment `maxstack` merges into the workspace config.
- `index.ts` and `package.json` are the OpenCode plugin entrypoint. `index.ts` registers the skills.
- `.claude-plugin/plugin.json` is the Claude Code manifest. Claude Code reads the same `skills/` tree.
- `.github/plugin/plugin.json` is the GitHub Copilot CLI manifest. It registers the same skills and declares no hooks.
- `skills/` holds the skills the plugin registers.
- `workspace-instructions.md` contains the layer's always-on working agreements. Every session pays for this text, so detailed procedures belong in skills.

## Plugin and skills

The layer is configuration and a plugin at the same time. `maxstack`'s `Install-Workspace.ps1` merges the fragment into `opencode.jsonc` and copies the files named in `layer.json` into `.opencode/plugins/org-ai-plugin`, where OpenCode loads the plugin. The plugin registers every `skills/<id>/SKILL.md` through `ctx.skill.transform`. Claude Code can load that tree through a junction from `.claude/plugins/<name>`, or from a direct copy at that path.

| Skill | Purpose |
| --- | --- |
| `service-integrations` | The general integration registry: which CLI owns an external-service job, the command, and the best practices. |
| `repo-tasks` | Run, build, test, or verify a repository through its `justfile`. |
| `repo-standard` | The gates, the definition of done, and the branch and pull request flow. |
| `local-services` | The container stack on this machine: Docker, Portainer, Infisical, and DbGate. |
| `review-session-history` | Mine stored sessions for recurring corrections, cluster and rank the themes, and route each to a named skill edit. |
| `machine-inventory` | The fleet machine classes: id, role, storage class, and capability flags, from the public [`sakuragaoka-homelab/machine-inventory`](https://github.com/sakuragaoka-homelab/machine-inventory) records. |

To add a skill, create `skills/<id>/SKILL.md` with `name` and `description` frontmatter. The plugin picks it up on the next install and restart.

## How it gets loaded

This repository is not installed on its own. [`maxstack`](https://github.com/simpsonm09-projects/maxstack)'s `scripts/Install-Workspace.ps1 -Apply` copies the files listed in `layer.json` into `<workspace>/.opencode/plugins/org-ai-plugin` and `<workspace>/.claude/plugins/org-ai-plugin`.

- OpenCode needs no setting. It finds the workspace `.opencode` folder by walking up from the repository or worktree.
- Claude Code must be started with `--plugin-dir <workspace>/.claude/plugins`. In T3 Code that goes in the Claude provider instance's "Launch arguments". Without it a Claude Code session has no skills.
- GitHub Copilot CLI loads the plugin folder, which is the directory that holds `.github/plugin/plugin.json`.

maxstack's [`docs/t3-setup.md`](https://github.com/simpsonm09-projects/maxstack/blob/main/docs/t3-setup.md) is the full reference. A new session is needed after each install.

## Accounts and access

Agents use the owner's own accounts. There is no organization App, no installation token, no per-repository access level, and no client-side shell gate. Protection comes from the rulesets (no bypass actors, required checks), the Lefthook hooks, and the standards. A write an agent should not make fails at GitHub, not in a plugin.

## MCP servers

The org layer contributes no MCP server. `opencode.fragment.jsonc` is empty. Every shared service is reached through a CLI documented in the `service-integrations` registry. Keep an MCP server for a job only when no CLI covers it, and add it on demand.

GitHub, Postman and its `newman` runner, library docs, browsers, Kubernetes, secrets, tool versions, container runtime, repository tasks, and scanning are handled by `gh`, `postman`, `newman`, `npx ctx7`, `@playwright/cli`, the `chrome-devtools` CLI, `kubectl`, `helm`, and `kustomize`, `infisical`, `mise`, `docker`, `just`, and `trivy`. The Agent Vault brokers a service credential to a tool through a local proxy, and `with-vault` is the path to a brokered service. `with-secrets` puts the values for one command into its environment. Code search uses the local `grep` tool, and repo tasks use `just`. See the `service-integrations` registry for the owner of each job and the `local-services` skill for the container stack. Accounts, boards, workspaces, clusters, identities, bundles, and personal services such as Discord and email live in the personal layer, which this layer defers to.

## Layering

Precedence is personal over org over the PStack base. A layer overrides a same-key server from a lower layer. `maxstack` records the repo and commit of every layer in `stack.lock.json`.

## Layer shapes

A layer can contribute configuration, a plugin, or both. This layer contributes a plugin and an empty config fragment. A layer that only contributes configuration needs no `index.ts`. Add a plugin entry when the layer has something to register, not before.

## Local checks

Install the pinned tools, then run what CI runs.

```bash
mise install
just deps        # bun install --frozen-lockfile
just fmt-check   # bun fmt --check over the JavaScript and TypeScript
just lint        # oxlint through Bun
just test        # node --test over tests/
```

The suite covers the skill loader and layer contract, the published file list, and the workspace instructions.

## License

MIT. See [`LICENSE`](LICENSE).
