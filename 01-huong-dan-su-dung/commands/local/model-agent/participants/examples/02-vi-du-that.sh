# Vi du that: kho prompt cua team co file tu 2024, Chuyen 2026 - team chay
# Copilot harness, prompt cu "van gui duoc" nhung ket qua te han.

# 1. Tim benh:
grep -rn "@workspace" docs/prompts/ .github/

# 2. Prompt cu (❌ o Copilot harness - participant khong chay, model chi thay text):
#    @workspace liet ke cac endpoint API cua du an

# 3. viet lai, hai bien phap:
#    a) de Agent tu gather (ngan, hay dung):
liet ke cac endpoint API trong du an, tom tat theo tung module

#    b) gan context chinh xac bang # / Add Context:
#    (them #file:src/routes/ va cac folder lien quan trong Chat view, roi hoi)
liet ke endpoint trong #file:src/routes/index.ts va cac file no import

# 4. Verify - gui cung prompt o hai harness:
#    - Local harness (con ton tai): thay buoc @workspace thuc hien
#    - Copilot harness: khong co buoc participant; Agent tu goi tool tim file
#    => khac biet nay la bang chung "deprecated, not supported in Copilot harness"

# 5. Nhap cu phap song vao file huong dan noi bo:
#    / = chay lenh | # = gan file/selection | khong dung @ lam context
