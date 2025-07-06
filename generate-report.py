import pandas as pd
from datetime import datetime
import pdfkit

# 1) اقرأ البيانات
df = pd.read_csv("AdventureWorks Sales Data 2020.csv", parse_dates=["OrderDate"])

# 2) احسب التاريخ المستهدف
today = datetime.today()
target_date = today.replace(year=2020)

# 3) فلترة البيانات
filtered = df[df["OrderDate"].dt.date == target_date.date()]

total_quantity = filtered["OrderQuantity"].sum()
num_orders = filtered["OrderNumber"].nunique()

# 4) جهز HTML
html = f"""
<html>
<head>
    <title>Daily Sales Report</title>
</head>
<body>
    <h1>📈 Daily Sales Report</h1>
    <p><strong>Date Compared:</strong> {target_date.strftime('%Y-%m-%d')}</p>
    <p><strong>Total Orders:</strong> {num_orders}</p>
    <p><strong>Total Quantity:</strong> {total_quantity}</p>
</body>
</html>
"""

with open("report.html", "w") as f:
    f.write(html)

print("✅ HTML generated!")

# 5) توليد PDF (لا تحتاج config في Linux)
pdfkit.from_file("report.html", "report.pdf")

print("✅ PDF generated successfully!")
