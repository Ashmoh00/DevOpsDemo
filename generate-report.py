import pandas as pd
from datetime import datetime

# 1) اقرأ الملف CSV
df = pd.read_csv("AdventureWorks Sales Data 2020.csv", parse_dates=["OrderDate"])

# 2) احسب التاريخ المستهدف
today = datetime.today()
target_date = today.replace(year=2020)

# 3) فلتر البيانات
filtered = df[df["OrderDate"].dt.date == target_date.date()]

# 4) احسب الإجماليات
total_quantity = filtered["OrderQuantity"].sum()
num_orders = filtered["OrderNumber"].nunique()

# 5) أنشئ تقرير HTML
with open("report.html", "w") as f:
    f.write(f"""
    <html>
        <head><title>Daily Sales Report</title></head>
        <body>
            <h1>Daily Sales Report</h1>
            <p>Date Compared: {target_date.strftime('%Y-%m-%d')}</p>
            <p>Total Orders: {num_orders}</p>
            <p>Total Quantity: {total_quantity}</p>
        </body>
    </html>
    """)

print("✅ Report generated successfully!")
