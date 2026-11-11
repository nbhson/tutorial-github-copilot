# 1. Truoc khi luu: soat xem chat co dinh token/key nao khong
# 2. Nen phan dai (neu chat 30+ turns)
/compact nen chat nay thanh ban gon de luu, giu nguyen file va quyet dinh ve retry
# 3. Luu ra file: Command Palette -> Chat: Export Chat... -> docs/chats/retry-api-client.json
Chat: Export Chat...
# Verify: mo file, doc lai 1 luot; grep -iE "token|secret|password" file -> 0 ket qua
