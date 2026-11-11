#!/usr/bin/env node
// W2 — move commands/ theo bucket.tsv + rewrite link MỘT PASS (không sed lặp `../`).
// Chạy từ thư mục tutorial-github-copilot: `node plan-update/scripts/w2-move.js`
// Nguyên tắc "move trước, sửa sau": file không đổi MỘT CHỮ nào ngoài chuỗi path của link.
// Quy tắc link (plan-update/04 §5): link resolve được ở vị trí MỚI -> giữ nguyên
// (group index `../README.md`, sibling cùng bucket, examples nội bộ); link gãy -> resolve
// theo vị trí CŨ, map qua bảng move, tính lại relative từ vị trí mới.
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const REPO = process.cwd(); // tutorial-github-copilot
const CMDS = "01-huong-dan-su-dung/commands";
const GROUPS = ["chat-session", "model-agent", "code-actions", "system-knowledge"];
function git(cmd) { return execSync(`git -C "${REPO}" ${cmd}`, { encoding: "utf8" }); }

// ---------- 0. doc bucket.tsv ----------
const rows = fs.readFileSync(path.join(REPO, CMDS, "bucket.tsv"), "utf8").trim().split("\n")
  .map(l => l.split("\t")).map(([slug, group, bucket]) => ({ slug, group, bucket }));
if (rows.length !== 47) { console.error(`bucket.tsv phai co 47 dong, co ${rows.length}`); process.exit(1); }
const dirMap = new Map(); // old dir -> new dir (slug + moi file con trong slug)
for (const r of rows) {
  if (r.bucket === "REMOVE") continue;
  if (!GROUPS.includes(r.group)) { console.error("nhom la: " + r.group); process.exit(1); }
  if (!process.env.SKIP_MOVE && !fs.existsSync(path.join(REPO, CMDS, r.group, r.slug))) { console.error("slug thieu: " + r.group + "/" + r.slug); process.exit(1); }
  dirMap.set(`${CMDS}/${r.group}/${r.slug}`, `${CMDS}/${r.bucket}/${r.group}/${r.slug}`);
}

// ---------- 1. move ----------
if (!process.env.SKIP_MOVE) {
  git(`rm -r --quiet "${CMDS}/system-knowledge/extensions"`); // REMOVE (Copilot Extensions retired)
  for (const r of rows) {
    if (r.bucket === "REMOVE") continue;
    const dst = `${CMDS}/${r.bucket}/${r.group}`;
    fs.mkdirSync(path.join(REPO, dst), { recursive: true });
    git(`mv "${CMDS}/${r.group}/${r.slug}" "${dst}/${r.slug}"`);
  }
  for (const g of GROUPS) { // group README -> ban dau o copilot/<group>
    const dst = `${CMDS}/copilot/${g}/README.md`;
    if (fs.existsSync(path.join(REPO, dst))) continue;
    git(`mv "${CMDS}/${g}/README.md" "${dst}"`);
    try { fs.rmSync(path.join(REPO, CMDS, g), { recursive: true }); } catch (e) {} // dir con sot (untracked)
  }
  // copy group README cho bucket khac co slug trong nhom do -> 9 group README
  const needed = new Set(rows.filter(r => r.bucket !== "REMOVE").map(r => `${r.bucket}/${r.group}`));
  for (const bg of needed) {
    const dst = `${CMDS}/${bg}/README.md`;
    if (fs.existsSync(path.join(REPO, dst))) continue;
    fs.copyFileSync(path.join(REPO, `${CMDS}/${bg.split("/")[0] ? "copilot/" + bg.split("/")[1] : ""}/README.md`), path.join(REPO, dst));
    git(`add "${dst}"`);
  }
}

// ---------- 2. vi tri moi -> vi tri cu ----------
function oldDirOfNew(relDir) {
  const m = relDir.match(new RegExp(`^${CMDS}/(copilot|local|cloud)/(${GROUPS.join("|")})(?:/(.*))?$`));
  if (!m) return relDir;
  return m[3] ? `${CMDS}/${m[2]}/${m[3]}` : `${CMDS}/${m[2]}`; // slug/con-(duoc-lai) hoac group README
}

// ---------- 3. rewrite link trong moi file .md (tru plan-update) ----------
function listMd(dir) {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (e.name === ".git" || e.name === "plan-update") continue;
    const p = path.join(dir, e.name);
    if (e.isDirectory()) out.push(...listMd(p));
    else if (e.name.endsWith(".md")) out.push(p);
  }
  return out;
}
let changedFiles = 0, changedLinks = 0; const stillBroken = [];
for (const abs of listMd(REPO)) {
  const rel = path.relative(REPO, abs);
  const src = fs.readFileSync(abs, "utf8");
  const newDir = path.dirname(rel);
  const bm = newDir.match(new RegExp(`^${CMDS}/(copilot|local|cloud)/(${GROUPS.join("|")})(?:/[^/]+)?$`));
  const readerBG = bm ? [bm[1], bm[2]] : null;
  const out = src.replace(/\]\((?!https?:|#|mailto:)([^)\s]+)(\s+"[^"]*")?\)/g, (m0, targetRaw, title = "") => {
    const [tgtPart, ...fragParts] = decodeURIComponent(targetRaw).split("#");
    const fragS = fragParts.length ? "#" + fragParts.join("#") : "";
    if (!tgtPart) return m0; // anchor-only trong file khac — khong phai duong dan
    if (fs.existsSync(path.resolve(REPO, newDir, tgtPart))) return m0; // van song -> giu nguyen
    const oldTarget = path.normalize(path.join(oldDirOfNew(newDir), tgtPart));
    let mapped = null;
    for (const [oldD, newD] of dirMap)
      if (oldTarget === oldD || oldTarget.startsWith(oldD + "/")) { mapped = newD + oldTarget.slice(oldD.length); break; }
    if (!mapped) {
      const gm = oldTarget.match(new RegExp(`^${CMDS}/(${GROUPS.join("|")})(/README\\.md)?$`));
      if (gm && readerBG) { // group index: ../README.md -> index nhom CUA BUCKET MINH
        const cand = `${CMDS}/${readerBG[0]}/${readerBG[1]}/README.md`;
        mapped = fs.existsSync(path.join(REPO, cand)) ? cand : `${CMDS}/copilot/${gm[1]}/README.md`;
      }
    }
    if (!mapped) {
      // truong hop tong: link tung ton tai o vi tri CU (nao do ngoai commands/, root file...)
      // -> chi can doi chieu sau, giu nguyen dich den
      const oldAbs = path.resolve(REPO, oldTarget);
      if (fs.existsSync(oldAbs)) mapped = path.normalize(oldTarget);
    }
    if (mapped && fs.existsSync(path.join(REPO, mapped))) {
      changedLinks++;
      return `](${path.relative(newDir, mapped).split(path.sep).join("/")}${fragS}${title})`;
    }
    stillBroken.push(`${rel}: ${m0}`);
    return m0;
  });
  if (out !== src) { fs.writeFileSync(abs, out); changedFiles++; }
}
console.log(`files rewritten: ${changedFiles}, links fixed: ${changedLinks}, still broken: ${stillBroken.length}`);
stillBroken.forEach(b => console.log("  BROKEN " + b));
