# Trong Copilot harness session (VS Code):
/plugin list
/plugin marketplace add acme/agent-toolbox
/plugin install code-style@acme-agent-toolbox
/plugin enable code-style
/plugin disable code-style
/plugin update
/plugin uninstall code-style

# Cac lenh /plugin tren day theo bang cheat sheet VS Code; tren Copilot CLI, docs
# 11/2026 chi cam kham /plugin dashboard | /plugin flags | /plugin marketplace.
# Thu autocomplete go "/plugin " truoc khi dung lenh.

#Ngoai terminal (Copilot CLI, docs GitHub):
copilot plugin list
copilot plugin install acme/agent-toolbox
copilot plugin install code-style@acme-agent-toolbox   # dinh ban: them @TAG hoac sha
copilot plugin update
copilot plugin enable code-style
copilot plugin disable code-style
copilot plugin uninstall code-style
# Docs khong liet ke "copilot plugin validate" / "recommendations": muon kiem
# manifest thi install thu bang duong dan local (copilot plugin install ./my-plugin).
copilot plugin marketplace add github/copilot-plugins   # copilot-plugins KHONG con built-in

# Ky vong: /plugin list hien plugin da cai; skill cua plugin goi dang /plugin:skill
