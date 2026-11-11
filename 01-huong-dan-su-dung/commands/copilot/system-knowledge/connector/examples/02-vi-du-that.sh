# Vi du that: team can agent doc work-item tu cong cu quan ly vieu dang dung,
# khong muon tu viet va nuoi MCP server.

# 1. Mo Customizations editor (session Copilot harness):
#    Command Palette -> "Chat: Open Customizations"
#    Card MCP Servers -> Browse -> Copilot Connectors -> Connect
#    (Dich vu khong co trong danh sach? Do la he noi bo -> dung duong
#     MCP tu quan ly, xem commands/copilot/system-knowledge/mcp-add/)

# 2. Quay lai session Copilot, cau hoi can dung connector:
liet ke work-item moi nhat cua toi trong <ten-dich-vu> va tom tat noi dung

# Ky vong: agent goi tool cua connector (nhin thay trong tool activity),
# khac cau "toi khong co cach truy cap dich vu do".

# 3. Verify cheo harness (gui cung cau hoi o session Local neu con dung):
#    - Session Copilot: goi duoc tool -> connector chi phuc vu o day
#    - Session Local:   khong thay tool nao -> dung nhu docs ghi,
#      connector cap tool cho Copilot harness, khong cho Local

# 4. Ghi chu phan biet nhanh trong card MCP Servers:
#    "Connector: <name>"     -> do GitHub host, khong co file cua ban
#    dong khong mang nhan nay -> server ban tu khai bao (co file cau hinh)
