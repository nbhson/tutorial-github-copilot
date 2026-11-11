# Tinh huong: team co 3 skill review code trong repo acme/agent-toolbox (co .github/plugin/marketplace.json)

# Buoc 1: them marketplace cua team (marketplace = Git repo thoi, khong can "cho" nao ca)
/plugin marketplace add acme/agent-toolbox

# Buoc 2: cai va kiem tra
/plugin install code-style@acme-agent-toolbox
/plugin list

# Buoc 3: go `/` trong session — skill cua plugin mang namespace /plugin:code-style

# Verify: thu muc ~/.copilot/installed-plugins/acme-agent-toolbox/code-style ton tai
# Sau khi xong: copilot plugin list de doi chieu phia CLI
