# Cai + test Recipe B (pre-commit + gitleaks), bai 07 muc 4:
# File dinh kem: examples/07-4-recipe-b-precommit-gitleaks.yaml (dat ten .pre-commit-config.yaml)
pip install pre-commit && pre-commit install
echo 'OPENAI_API_KEY="sk-fake123456789"' > fake-secret.txt
git add fake-secret.txt && git commit -m "test"  # phai FAIL o gitleaks
git reset HEAD fake-secret.txt && rm fake-secret.txt
