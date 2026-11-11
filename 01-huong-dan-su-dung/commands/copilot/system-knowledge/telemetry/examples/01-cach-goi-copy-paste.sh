# Duong consent: Settings → search "telemetry" / "copilot data" → xem on/off va ai quan
# Duong OTel cho Copilot CLI (khong can collector):
export COPILOT_OTEL_ENABLED=true
export COPILOT_OTEL_FILE_EXPORTER_PATH="$HOME/.copilot/otel-export.jsonl"
copilot   # chay mot phien ngan
# Ky vong: doc duoc trang thai consent; file export xuat hien sau phien chay
# Verify: unset 2 bien env roi chay lai — file khong tang them la dung cong tac
