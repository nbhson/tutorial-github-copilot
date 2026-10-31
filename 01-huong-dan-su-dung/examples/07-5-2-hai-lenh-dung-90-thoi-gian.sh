# suggest: gợi ý lệnh shell:
gh copilot suggest "xoa cac git branch local da merge vao main"
gh copilot suggest "tim file >100MB trong repo hien tai"

# explain: giải thích lệnh khó trước khi chạy:
gh copilot explain "docker run -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16"
gh copilot explain "git rebase -i HEAD~3"

# Alias cho gọn (thêm vào ~/.zshrc hoặc ~/.bashrc):
alias cps='gh copilot suggest'
alias cpe='gh copilot explain'
