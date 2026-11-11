# Viec: dang code trong IDE, can dung lai tai lieu trong space
# Copilot in the cloud: space goi duoc tu IDE NHUNG qua GitHub MCP, va bi cat nguon
# Claude Code: agent doc file trong repo tai cho (khong co khai niem space)

# Prerequisites (chen vao cau hinh MCP server):
#   "url": "https://api.githubcopilot.com/mcp/"
#   "headers": { "X-MCP-Toolsets": "default,copilot_spaces" }
#   (hoac dung URL rieng cho toolset: https://api.githubcopilot.com/mcp/x/copilot_spaces)

# 1. Mo Chat, chon Agent (space chi dung duoc o agent mode)
# 2. Kiem tool: bam icon Tools -> muc GitHub MCP -> phai co list_copilot_spaces + get_copilot_space
# 3. Hoi:
"Dung Copilot space 'Checkout Flow Redesign' cua to-chuc myorg: tom tat ke hoach implementation.
 Liet ke nguon da doc; neu khong thay nguon nao thi noi ro."

# GIOI HAN can biet (docs ghi rang buoc):
#   - Tu IDE: KHONG thay "repo context" va "uploaded files" cua space
#     -> muon dung hai loai do thi hoi tren GitHub.com
#   - Space chi duoc doc qua MCP -> phai bat toolset copilot_spaces

# Ky vong: agent liet ke duoc space va tom tat dung nguon trong space
# Verify: mo lai tung nguon tren github.com/copilot/spaces de doi chieu
