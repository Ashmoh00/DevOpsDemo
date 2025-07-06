# ========================================
# 🚀 generate-report.ps1
# ========================================

Write-Host "🚀 Starting Daily Sales Report Script..."

# ========================================
# 1) تأكد من وجود ملف CSV
# ========================================
$csvPath = "./AdventureWorks_Sales_Data_2020.csv"

if (-Not (Test-Path $csvPath)) {
    Write-Host "❌ CSV file not found at path: $csvPath"
    exit 1
}

Write-Host "✅ Found CSV file: $csvPath"

# ========================================
# 2) حدد التاريخ المستهدف
# ========================================
$today = Get-Date -Format "MM/dd"
Write-Host "📅 Filter Date: $today"

# ========================================
# 3) قراءة البيانات وتطبيق الفلترة
# ========================================
$filteredData = Import-Csv $csvPath | Where-Object {
    $_.OrderDate -like "$today*"
}

Write-Host "🔍 Number of rows found: $($filteredData.Count)"

if ($filteredData.Count -eq 0) {
    Write-Host "⚠️ No data found for today. A placeholder report will be generated."
}

# ========================================
# 4) بناء محتوى HTML
# ========================================
$htmlPath = "./report.html"

$htmlContent = @"
<html>
<head>
  <title>Daily Sales Report</title>
  <style>
    table, th, td { border: 1px solid black; border-collapse: collapse; padding: 6px; }
    th { background-color: #eee; }
  </style>
</head>
<body>
  <h1>📈 Daily Sales Report</h1>
  <p><strong>Date:</strong> $today</p>
  <p><strong>Total Records:</strong> $($filteredData.Count)</p>
  <table>
    <tr>
      <th>OrderDate</th>
      <th>OrderNumber</th>
      <th>ProductKey</th>
      <th>OrderQuantity</th>
    </tr>
"@

if ($filteredData.Count -gt 0) {
    foreach ($row in $filteredData) {
        $htmlContent += "<tr>"
        $htmlContent += "<td>$($row.OrderDate)</td>"
        $htmlContent += "<td>$($row.OrderNumber)</td>"
        $htmlContent += "<td>$($row.ProductKey)</td>"
        $htmlContent += "<td>$($row.OrderQuantity)</td>"
        $htmlContent += "</tr>`n"
    }
} else {
    $htmlContent += "<tr><td colspan='4'>No data found for this date.</td></tr>`n"
}

$htmlContent += @"
  </table>
</body>
</html>
"@

# ========================================
# 5) حفظ HTML
# ========================================
Set-Content -Path $htmlPath -Value $htmlContent -Encoding UTF8

Write-Host "✅ HTML report saved: $htmlPath"

# ========================================
# 6) تحويل HTML إلى PDF
# ========================================
$outputPdf = "./report.pdf"

try {
    & wkhtmltopdf $htmlPath $outputPdf
    Write-Host "✅ PDF report generated: $outputPdf"
} catch {
    Write-Host "❌ Error generating PDF. Make sure wkhtmltopdf is installed and in PATH."
    exit 1
}

# ========================================
# 7) عرض الملفات الناتجة
# ========================================
Write-Host "📂 Generated files:"
Get-ChildItem -Path . -Filter "report.*" | Format-Table Name, Length
