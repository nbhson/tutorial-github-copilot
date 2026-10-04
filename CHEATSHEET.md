# Cheatsheet Muse (2026) — 1 trang

## CLI
`gh copilot suggest "task"` · `gh copilot explain "code"` · `gh copilot --version` · `gh extension install github/gh-copilot`
`copilot -p "task"` (Copilot CLI interactive) · `copilot --help`

## VS Code Chat
`Ctrl+I` inline chat · `Ctrl+Shift+I` quick chat · Chat view `Ctrl+Alt+I`
Participants: `@workspace` `@terminal` `@vscode` `@github`
Slashes: `/explain` `/fix` `/tests` `/doc` `/new` `/clear` `/help`
`Tab` nhận completion · `Alt+]` / `Alt+[` chuyển gợi ý · `Esc` từ chối

## Modes
`Ask` (hỏi, không sửa code) · `Edit` (sửa file chỉ định) · `Agent` (tự tìm file, chạy tool, sửa nhiều bước)
Custom agent via `*.agent.md` · Model picker: GPT-5 / Claude / Gemini / o-series · Premium requests (theo dõi quota)

## instructions/prompts/skills/MCP
`.github/muse-instructions.md` (repo-wide) · `*.instructions.md` + `applyTo` (theo glob)
`*.prompt.md` (slash tái dùng) · `*.agent.md` (custom agent) · `.github/skills/` (skills)
`.vscode/mcp.json` (MCP servers: GitHub, Playwright, Postgres, Fetch/Brave Search; secrets qua env)

```json
{
  "servers": {
    "github": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-github"], "env": { "GITHUB_TOKEN": "${GITHUB_TOKEN}" } }
  }
}
```

## Vòng chuẩn
Explore → Plan (duyệt) → Implement (phase-gate) → Verify (chạy tests + review fresh). Rule miss 2 lần → đưa vào instructions/policy.

## Coding agent
Gán issue cho Copilot trong GitHub → tự tạo branch + PR → review → merge.
`gh copilot suggest` hỗ trợ shell · Copilot code review tự comment trên PR.

## Review
Copilot code review trên PR (auto/manual) · `/review` trong Chat · policy/MCP-allowlist là luật chặn cuối.

## Tra cứu chi tiết từng lệnh
Index đầy đủ ~70 lệnh: [01-huong-dan-su-dung/commands/README.md](01-huong-dan-su-dung/commands/README.md)
- `/explain` → [commands/chat/explain/README.md](01-huong-dan-su-dung/commands/chat/explain/README.md)
- `/fix` → [commands/chat/fix/README.md](01-huong-dan-su-dung/commands/chat/fix/README.md)
- `/tests` → [commands/chat/tests/README.md](01-huong-dan-su-dung/commands/chat/tests/README.md)
- `/doc` → [commands/chat/doc/README.md](01-huong-dan-su-dung/commands/chat/doc/README.md)
- `@workspace` → [commands/chat-participants/workspace/README.md](01-huong-dan-su-dung/commands/chat-participants/workspace/README.md)
- `suggest` → [commands/cli/suggest/README.md](01-huong-dan-su-dung/commands/cli/suggest/README.md)
- Coding agent → [commands/coding-agent/assign-issue/README.md](01-huong-dan-su-dung/commands/coding-agent/assign-issue/README.md)
- Code review → [commands/review/auto-review/README.md](01-huong-dan-su-dung/commands/review/auto-review/README.md)
