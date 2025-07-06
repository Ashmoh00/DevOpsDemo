# ============================================
# 1) Load CSV Sales Data
# ============================================

# تأكد إن الملف في نفس المسار أو عدّل المسار لو حاب
$csvFile = "DevOpsDemo/AdventureWorks_Sales_Data_2020.csv"
if (-Not (Test-Path $csvFile)) {
    Write-Host "❌ CSV file not found at $csvFile"
    exit 1
}

$data = Import-Csv -Path $csvFile

# ============================================
# 2) Get today's date but with 2020 year
# ============================================
$today = Get-Date
$targetDate = Get-Date -Year 2020 -Month $today.Month -Day $today.Day

Write-Host "🔍 Filtering sales data for: $($targetDate.ToShortDateString())"

# ============================================
# 3) Filter sales for that date
# ============================================

# ملاحظة: تأكد من اسم العمود OrderDate وصيغته
$filtered = $data | Where-Object { $_.OrderDate -like "*$($targetDate.ToString('MM/dd/yyyy'))*" }

if ($filtered.Count -eq 0) {
    Write-Host "⚠️ No data found for this date!"
} else {
    Write-Host "✅ Found $($filtered.Count) rows for $($targetDate.ToShortDateString())"
}

# ============================================
# 4) Calculate total sales
# ============================================
$totalSales = ($filtered | Measure-Object -Property SalesAmount -Sum).Sum
Write-Host "💰 Total Sales: $totalSales"

# ============================================
# 5) Generate HTML Report
# ============================================

$html = @"
<html>
<head>
  <title>Sales Report</title>
  <style>
    table, th, td { border: 1px solid black; border-collapse: collapse; }
    th, td { padding: 6px; }
  </style>
</head>
<body>
  <h1>📈 AdventureWorks Sales Report</h1>
  <p><strong>Report Date:</strong> $($targetDate.ToShortDateString())</p>
  <p><strong>Total Sales:</strong> $$totalSales</p>
  <h2>Details</h2>
  <table>
    <tr>
      <th>OrderID</th>
      <th>OrderDate</th>
      <th>SalesAmount</th>
    </tr>
"@

foreach ($row in $filtered) {
    $html += "<tr><td>$($row.OrderID)</td><td>$($row.OrderDate)</td><td>$($row.SalesAmount)</td></tr>"
}

$html += @"
  </table>
</body>
</html>
"@

$html | Out-File -Encoding utf8 "report.html"
Write-Host "✅ HTML report generated: report.html"

# ============================================
# 6) Optional: Convert to PDF using wkhtmltopdf
# ============================================
# تأكد إن wkhtmltopdf مثبت في جهازك لو بتجرب محلي
# لو بتشغل في GitHub Actions، تأكد تركب الأداة أول
# & "C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf.exe" report.html report.pdf
Write-Host "🚀 Done!"
