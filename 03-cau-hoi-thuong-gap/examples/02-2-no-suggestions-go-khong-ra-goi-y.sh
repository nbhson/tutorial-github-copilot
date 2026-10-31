# Ctrl+Shift+P -> "Copilot: Check Status" / "Enable Completions"
printf 'def add(a, b):\n' > /tmp/copilot-test.py && code /tmp/copilot-test.py
# Verify: file test có gợi ý mà file dự án không -> do exclusion
