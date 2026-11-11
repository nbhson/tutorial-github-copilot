# Check 3 giây trước khi attach:
git check-ignore secrets/stripe.key && echo "IGNORED" || echo "COI CHUNG: file nay dang track!"
