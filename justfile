# Cross-platform task runner for humans and agents. `just --list` shows every
# recipe. Keep each recipe a thin call to a portable tool or a script under
# scripts/. See https://github.com/simpsonm09-projects/repo-standard/blob/main/docs/task-runner.md
set windows-shell := ["powershell.exe", "-NoLogo", "-NoProfile", "-Command"]

# List the recipes.
default:
    @just --list

# Install the pinned tools.
install:
    mise install

# Install the dependencies from the lockfile.
deps:
    mise exec -- bun install --frozen-lockfile

# Format JavaScript and TypeScript with Bun.
fmt:
    mise exec -- bun fmt index.ts access.mjs gate.mjs hooks lib bin pi tests scripts

# Check JavaScript and TypeScript formatting with Bun.
fmt-check:
    mise exec -- bun fmt --check index.ts access.mjs gate.mjs hooks lib bin pi tests scripts

# Lint JavaScript and TypeScript, through Bun with an oxlint fallback.
lint:
    mise exec -- bun scripts/lint.ts

# Run the AI-slop gate.
aislop:
    npx --yes aislop@0.16.1 ci

# Run the test suite. The suite is node:test, so Node runs it until the Bun port lands.
test:
    mise exec -- node --test

# Run the focused cross-platform regression on this host. The portable workflow runs
# this recipe on `main` and weekly, not on the required pull request path.
test-portable:
    mise exec -- node --test tests/portable.test.ts tests/gate.test.ts tests/shared-decision.test.ts tests/location.test.ts tests/fleet.test.ts tests/hook-entry.test.ts tests/codex-hooks.test.ts

# Run the tests and write an lcov report to coverage/lcov.info.
coverage:
    mise exec -- bun install --frozen-lockfile
    mise exec -- node scripts/coverage.mjs

# Enforce the format and lint rules on the .mjs files flint's patterns do not reach.
# The shared lint workflow runs this recipe, so a defect in a runtime module fails CI.
complexity:
    mise exec -- bun scripts/check-mjs.mjs

# Everything CI requires.
check: fmt-check lint complexity test

# Install the guarded git hook.
hooks:
    git config --local core.hooksPath .githooks

# Check the .agents/skills tree and its .claude/skills links.
agent-files:
    mise exec -- bun scripts/agent-files.mjs

# Check the bundled resolver against the reviewed source object in the standard clone.
check-gate-resolver:
    mise exec -- node scripts/refresh-gate-resolver.mjs --check

# Refresh the bundled resolver from the reviewed source object. This never fetches.
refresh-gate-resolver:
    mise exec -- node scripts/refresh-gate-resolver.mjs

# Historical alias for `check`, kept for the support template.
verify: check

# Prune remote-tracking refs and delete local branches merged into main.
prune:
    mise exec -- node scripts/prune.mjs
