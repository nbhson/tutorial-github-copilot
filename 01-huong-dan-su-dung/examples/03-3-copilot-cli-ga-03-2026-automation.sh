# Copilot CLI độc lập (agent trong terminal):
copilot --plan "chia nhỏ issue X"        # chỉ lập kế hoạch
copilot --mode autopilot "implement + test"  # tự chạy — bọc sandbox + --max-ai-credits
copilot --plan --mode autopilot "..."    # plan xong tự chuyển autopilot
# gh extension (gợi ý/giải thích lệnh — vẫn dùng được trong script):
gh copilot suggest "ffmpeg nén 4K→1080p"   # in lệnh copy-paste được
