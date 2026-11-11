#!/usr/bin/env node
// W7 QA — kiểm link tương đối trong mọi .md (bỏ http/#/mailto), tuỳ chọn kiểm anchor.
// Dùng: node plan-update/scripts/linkcheck.js [--anchors] [--quiet]
// Exit 0 = 0 link gãy; exit 1 = có gãy (in file:dong -> target).
const fs = require("fs");
const path = require("path");

const REPO = process.cwd();
const CHECK_ANCHORS = process.argv.includes("--anchors");
const QUIET = process.argv.includes("--quiet");
const SKIP_DIRS = new Set([".git", "node_modules", ".git.bak"]);
const SKIP_PREFIX = ["plan-update/"]; // thư mục kế hoạch, không phải nội dung khoá học

function listMd(dir, out = []) {
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (SKIP_DIRS.has(e.name)) continue;
    const abs = path.join(dir, e.name);
    const rel = path.relative(REPO, abs).split(path.sep).join("/");
    if (e.isDirectory()) { if (!SKIP_PREFIX.some(p => (rel + "/").startsWith(p))) listMd(abs, out); }
    else if (e.name.endsWith(".md")) out.push(abs);
  }
  return out;
}

// slice code block ra khỏi text để không bắt prompt mẫu trong ``` như link
function stripCode(src) { return src.replace(/```[\s\S]*?```/g, m => "\n".repeat(m.split("\n").length - 1)); }

function anchorOk(fileAbs, anchor) {
  if (!fs.existsSync(fileAbs)) return false;
  const slug = s => s.toLowerCase()
    .normalize("NFD").replace(/[\u0300-\u036f]/g, "")
    .replace(/[^\p{L}\p{N}\s-]/gu, "").replace(/\s/g, "-").trim(); // GitHub: moi space -> 1 dash, khong gop
  const want = slug(decodeURIComponent(anchor));
  return stripCode(fs.readFileSync(fileAbs, "utf8"))
    .split("\n").some(l => /^#{1,6}\s/.test(l) && slug(l.replace(/^#{1,6}\s*/, "")) === want);
}

const broken = [], badAnchor = [];
for (const abs of listMd(REPO)) {
  const rel = path.relative(REPO, abs).split(path.sep).join("/");
  const dir = path.dirname(abs);
  const lines = stripCode(fs.readFileSync(abs, "utf8")).split("\n");
  lines.forEach((line, i) => {
    for (const m of line.matchAll(/\]\((?!https?:|#|mailto:)([^)\s]+)/g)) {
      const [tgt, anchor] = m[1].split("#");
      if (!tgt) continue;
      const resolved = path.resolve(dir, decodeURIComponent(tgt));
      if (!fs.existsSync(resolved)) { broken.push(`${rel}:${i + 1} -> ${m[1]}`); continue; }
      if (CHECK_ANCHORS && anchor && fs.statSync(resolved).isFile() && resolved.endsWith(".md")) {
        if (!anchorOk(resolved, anchor)) badAnchor.push(`${rel}:${i + 1} #${anchor} (trong ${tgt})`);
      }
    }
  });
}

if (!QUIET) {
  broken.forEach(b => console.log("BROKEN  " + b));
  badAnchor.forEach(b => console.log("ANCHOR  " + b));
}
console.log(`linkcheck: ${broken.length} link gãy, ${badAnchor.length} anchor sai (quét ${listMd(REPO).length} file .md)`);
process.exit(broken.length || (CHECK_ANCHORS && badAnchor.length) ? 1 : 0);
