# Cài + test:
pip install pre-commit && pre-commit install
echo 'OPENAI_API_KEY="sk-fake123456789"' > fake-secret.txt
git add fake-secret.txt && git commit -m "test"  # phải FAIL ở gitleaks
git reset HEAD fake-secret.txt && rm fake-secret.txt
