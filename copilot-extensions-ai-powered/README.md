# GitHub Copilot Extensions & AI-Powered Platform (2025 → 2026)

> **Audience:** Developers and org admins who already use Copilot Chat and want the extension ecosystem, custom agents, Copilot in GitHub Actions, Enterprise capabilities, and the Copilot CLI.
> **Last verified:** 2026-10-27 · Sources: github.blog changelog, docs.github.com/copilot, code.visualstudio.com/docs/copilot

## What this file covers

1. [Copilot Extensions — General Availability](#1-copilot-extensions--general-availability-2025)
2. [Custom Copilot agents](#2-custom-copilot-agents)
3. [Copilot in GitHub Actions](#3-copilot-in-github-actions)
4. [Copilot Enterprise advanced features](#4-copilot-enterprise-advanced-features)
5. [Copilot CLI](#5-copilot-cli)
6. [Copilot in GitHub Mobile](#6-copilot-in-github-mobile)
7. [Best practices](#7-best-practices)
8. [Sources](#8-sources)

---

## 1. Copilot Extensions — General Availability (2025)

**Copilot Extensions went GA on February 19, 2025** (github.blog changelog, 2025-02-19). An extension is a **GitHub App registered with Copilot** that surfaces as an `@-mention` in Copilot Chat — `@sentry`, `@linear`, `@stackspot` — callable with natural language.

What GA changed:

- **Native third-party tokens** replaced the older `X-GitHub-Token` auth model — fewer API round trips, simpler auth flows for extension authors.
- **Availability across surfaces:** Copilot Chat in VS Code, Visual Studio, JetBrains, and on github.com — plus **GitHub Mobile**, so you can query third-party tools from your phone.
- **Where to find them:** GitHub Marketplace → Copilot Extensions; org admins can allow/block extensions per org.

```text
Install flow (copy-paste):
1. github.com → Marketplace → search the extension (e.g. "Sentry")
2. Install the GitHub App → grant repo/org access
3. In Copilot Chat: @sentry list recent issues in acme/api
4. Verify: type "@" in Chat → the participant appears
```

Copilot Extensions ≠ VS Code extensions. An extension bundles **tools + (optionally) MCP servers + chat participants**; a VS Code extension is editor tooling. See lesson [09 — Extensions & Marketplaces](../01-huong-dan-su-dung/09-extensions-marketplaces.md) for packaging and org policy.

---

## 2. Custom Copilot agents

Beyond marketplace extensions, you can build your own agents on three levels:

| Level | What you build | Where it lives |
|---|---|---|
| **Prompt file** | Reusable instruction template (`.prompt.md`) | `.github/prompts/` |
| **Custom agent** | Agent definition with tools + instructions (`.agent.md`) | `.github/agents/` |
| **Extension (GitHub App)** | Full server-side participant with own API calls | GitHub Marketplace / private app |

Notes for 2025/2026:

- **Agent Skills** (`SKILL.md`) are the preferred packaging over legacy `.prompt.md` files for agent-facing behavior (prompt files are deprecated for the Agent Host path).
- **Third-party coding agents** — Claude Code and Codex — can run **alongside Copilot's cloud agent** on github.com, working asynchronously on issues/PRs ("Agent HQ" direction announced at GitHub Universe 2025).
- **Copilot coding agent** (assign an issue to Copilot) is GA for paid subscribers and works from github.com, VS Code, and GitHub Mobile.

---

## 3. Copilot in GitHub Actions

Two distinct things people mean by "Copilot in Actions":

### 3.1. Running agents from CI workflows

The **Copilot CLI** and the Copilot SDK can be invoked inside Actions runners (ephemeral, sandboxed, non-interactive):

```yaml
# .github/workflows/copilot-triage.yml (skeleton)
- name: Copilot CI triage
  env:
    GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    npm i -g @github/copilot
    copilot -p "Analyze the failing CI run $RUN_URL, open an issue with root cause + fix suggestion"
```

Rules: pin the CLI version in CI, run with the narrowest token scopes, and treat output as untrusted input (review before auto-merge).

### 3.2. Copilot-assisted workflow authoring

Copilot Chat in VS Code and on github.com can draft and explain Actions workflow YAML (`/diagnose` failed runs, generate a workflow from a natural-language description). Treat generated workflows like generated code — review before commit.

---

## 4. Copilot Enterprise advanced features

What Enterprise (and partly Business) adds on top of Pro:

| Capability | Plan | What it does |
|---|---|---|
| **Model gating / policy** | Business/Enterprise | Org allowlists models (interns → mini tier, seniors → flagship) |
| **BYOK** (Bring Your Own Key) | Enterprise | Azure/OpenAI keys for data residency + own billing |
| **Content exclusion** | Business/Enterprise | Exclude files/paths from suggestion & context (repo/org/enterprise scope) |
| **Managed settings (fail-closed)** | Enterprise | Admin-controlled sandbox/telemetry/model policy; deny > ask > allow |
| **Audit logs + MCP policies** | Business/Enterprise | Per-user/repo logs of tool calls; MCP allowlist (`allowedMcpServers`) |
| **Usage-based billing controls** | All paid (2026) | AI Credits (1 credit = $0.01), paid-usage policy on by default — cap it in settings |
| **Copilot knowledge bases / code review policies** | Enterprise | Curated context + code review effort defaults |

Check the current feature matrix before promising anything to a team: https://docs.github.com/en/copilot/reference/copilot-feature-matrix

---

## 5. Copilot CLI

The Copilot CLI is a **terminal-native coding agent** — separate from the older `gh copilot` (suggest/explain shell commands):

- **Public preview:** September 2025. **GA: February 25, 2026** (github.blog changelog) for paid Copilot subscribers.
- Three modes: interactive agent, one-shot prompt, and command mode; supports MCP servers (repo `.mcp.json` + `~/.copilot/mcp-config.json`; since CLI v1.0.39 it no longer reads `.vscode/mcp.json`).
- `/model` can detect local Ollama models; auto model selection (efficiency / balance / intelligence tiers) is available.
- Install: `npm install -g @github/copilot` (or `gh extension install github/gh-copilot` for the legacy suggest/explain tool).

```bash
copilot                     # interactive agent session in terminal
copilot -p "fix the failing test in src/auth.spec.ts"
copilot --version
```

---

## 6. Copilot in GitHub Mobile

Copilot Chat ships inside the GitHub Mobile app and mirrors the github.com chat surface:

- **Ask about a repo/PR/issue** you have access to; read agent-produced PRs and **approve workflow runs** on the go.
- **Copilot Extensions work on Mobile** (public preview since 2025): `@sentry`, `@linear` etc. are available from the chat input.
- **Copilot coding agent + Mobile** = "delegate while working, approve while commuting": assign an issue from your IDE, review/merge from your phone when CI is green.
- Limitations: it is a review/decision surface, not a coding surface — no IDE, no local files.

```text
GitHub Mobile → open repo/PR/issue → Copilot icon → ask or review
Verify: mobile app → Copilot tab → pick repo → ask "summarize open PRs assigned to me"
```

---

## 7. Best practices

1. **Pick the right surface:** autocomplete/Chat for inline work; extensions for SaaS reach; coding agent for async issue work; CLI for terminal-native flows.
2. **Keep extensions allowlisted at org level.** Every extension runs with your permissions — vet before install, pin versions.
3. **Prefer Agent Skills over deprecated prompt files** for new agent-facing automation.
4. **Gate models and cap credits:** default mid/mini tier, flagship only for hard tasks; review usage dashboards weekly (AI Credits: 1 credit = $0.01).
5. **Use Mobile for review, not for coding.** Approve PRs and workflow runs from the phone; write code where the context is.
6. **In CI, pin versions and scopes.** Copilot CLI in Actions should run sandboxed with least-privilege tokens.
7. **Extensions ≠ MCP servers.** An extension may bundle MCP servers + participants; review both when you install one.

---

## 8. Sources

- Copilot Extensions GA (2025-02-19): https://github.blog/changelog/2025-02-19-announcing-the-general-availability-of-github-copilot-extensions/
- Extensions on GitHub Mobile (public preview): https://github.com/orgs/community/discussions/142240
- Third-party coding agents: https://docs.github.com/copilot/concepts/agents/about-third-party-coding-agents
- Copilot coding agent GA: https://github.com/orgs/community/discussions/159068
- Copilot CLI GA (2026-02-25): https://github.blog/changelog/2026-02-25-github-copilot-cli-is-now-generally-available/
- Copilot CLI docs: https://docs.github.com/copilot/how-tos/copilot-cli/use-copilot-cli/overview
- Agents overview (Copilot, third-party, custom): https://github.com/features/copilot/agents
- Copilot docs hub: https://docs.github.com/copilot · VS Code: https://code.visualstudio.com/docs/copilot
- Internal cross-references: [bài 09 — Extensions & Marketplaces](../01-huong-dan-su-dung/09-extensions-marketplaces.md) · [bài 12 — SDK/CI](../01-huong-dan-su-dung/12-copilot-sdk-ci-cd-automation.md) · [bài 17 — Agent Customizations hub](../01-huong-dan-su-dung/17-agent-customizations-hub.md)

---

*Added 2026-10-27 as part of the version-sensitivity sweep. Companion (Vietnamese) lesson: `01-huong-dan-su-dung/09-extensions-marketplaces.md`.*
