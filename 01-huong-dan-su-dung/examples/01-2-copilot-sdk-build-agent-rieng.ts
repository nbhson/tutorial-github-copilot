// examples/copilot-review.ts — chạy: npx tsx examples/copilot-review.ts
import { CopilotClient } from "@github/copilot-sdk";

// Auth qua env: GITHUB_TOKEN (KHÔNG hardcode — mục 2.2).
const client = new CopilotClient({
  token: process.env.GITHUB_TOKEN!,
  model: "auto",  // hoặc model hiện hành trong picker — đừng pin tên cũ
  allowedTools: ["read", "grep", "github-read"],  // allowlist hẹp: không terminal/deploy
});

const session = await client.createSession({
  instructions: [
    "Review git diff, trả tối đa 10 findings dạng checklist.",
    "Chỉ flag lỗi thực sự (bug, security). Đừng over-engineer.",
    "KHÔNG sửa files, KHÔNG chạy shell, chỉ đọc + báo cáo.",
  ].join("\n"),
});

for await (const msg of session.ask("Review diff main...HEAD của repo ./")) {
  if (msg.type === "text") process.stdout.write(msg.text);
}
await session.close();
