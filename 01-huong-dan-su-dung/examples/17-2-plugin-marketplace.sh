# Bai 17 - plugins: them marketplace, doc manifest, cai co pin (~10 phut).
# Slash /plugin CHI ton tai trong session Copilot harness (VS Code / Agents window);
# dung binary `copilot` (Copilot CLI) ngoai terminal thi syntax tuong duong.

# 1. Them marketplace. Marketplace = 1 Git repo co file kai danh sach:
#    .github/plugin/marketplace.json
copilot plugin marketplace add github/copilot-plugins
#    awesome-copilot: built-in, khong remove duoc.
#    copilot-plugins: KHONG built-in -> phai add thu cong nhu tren.

# 2. Xem trong cho co gi, chua cai:
copilot plugin marketplace browse
#    (trong session: /plugin marketplace browse)

# 3. DOC plugin.json o root repo plugin TRUOC khi cai:
gh api repos/OWNER/REPO/contents/plugin.json --jq '.content' | base64 -d
#    - schema 1.0 la schema DONG: port chi co skills/ + mcp.json o root;
#    - agents / hooks / commands / rules / LSP phai nam trong namespace
#      com.github.copilot/; truong la o root -> bi bo qua hoac reject ca plugin.
#    - plugin co hooks/MCP = code chay tren MAY BAN -> kiem publisher + source (bai 16).

# 4. Cai dat, co the pin theo tag:
copilot plugin install OWNER/REPO            # hoac OWNER/REPO:PATH, git URL, local path
copilot plugin install OWNER/REPO@v1.2.0      # pin = @TAG hoac sha, khong dung --ref

# 5. Quan ly trong session Copilot harness:
#    /plugin list | install | update | enable | disable | uninstall

# Verify: /plugin list thay plugin moi; skill cua no bi dat namespace
#         /<plugin>:<skill> - vi du /my-plugin:test-runner.
# Xoa marketplace da them: /plugin marketplace remove (them --force neu can).
# Team: enterprise quan ly qua managed settings enabledPlugins +
#       strictKnownMarketplaces -> chi tiet o bai 16.
