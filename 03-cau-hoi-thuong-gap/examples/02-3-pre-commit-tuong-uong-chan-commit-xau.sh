pip install pre-commit gitleaks || brew install pre-commit gitleaks

cat > .pre-commit-config.yaml <<'YAML'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-added-large-files
YAML
pre-commit install
# Verify: git commit thử -> hook chạy + chặn lỗi

gitleaks protect --staged --verbose
# Verify: "No leaks found" hoặc list đúng dòng dính secret
