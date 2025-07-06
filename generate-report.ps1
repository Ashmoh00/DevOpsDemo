# ================================
# generate-report.ps1
# ================================

Write-Host "🚀 Starting Sales Report Script..."

# ======================================
# 1) مسار ملف البيانات
# ======================================
$CsvPath = "AdventureWorks_Sales_Data_2020.csv"

if (-Not (Test-Path $CsvPath)) {
    Write-Host "❌ CSV file not found: $CsvPath"
    exit 1
}

# ======================================
# 2) قراءة البيانات
# ======================================
$data = Import-Csv $CsvPath

Write-Host "📄 First 5 rows in CSV:"
$data | Select-Object -First 5 | Format-Table

# ======================================
# 3) التاريخ المستهدف (اليوم مع سنة 2020)
# ======================================
$today = Get-Date
$filterDate = Get-Date -Year 2020 -Month $today.Month -Day $today.Day

Write-Host "📅 Target date to filter: $($filterDate.ToShortDateString())"

# ======================================
# 4) فلترة البيانات حسب التنسيق MM/dd/yy
# ======================================
$filtered = $data | Where-Object {
    try {
        $orderDate = [DateTime]::ParseExact($_.OrderDate, 'MM/dd/yy', $null)
        $orderDate.Month -eq $filterDate.Month -and
        $orderDate.Day -eq $filterDate.Day -and
        $orderDate.Year -eq 2020
    } catch {
        $false
    }
}

Write-Host "✅ Number of rows found: $($filtered.Count)"

if ($filtered.Count -gt 0) {
    Write-Host "📄 Sample rows:"
    $filtered | Select-Object -First 5 | Format-Table
} else {
    Write-Host "⚠️ No rows matched! Please check date format."
}

# ======================================
# 5) توليد HTML من البيانات
# ======================================
$html = @"
<html>
<head>
  <title>Daily Sales Report</title>
  <style>
    table, th, td { border: 1px solid black; border-collapse: collapse; }
    th, td { padding: 6px; }
  </style>
</head>
<body>
  <h1>📈 Daily Sales Report</h1>
  <p><strong>Date Compared:</strong> $($filterDate.ToShortDateString())</p>
  <p><strong>Total Orders:</strong> $($filtered.Count)</p>
  <table>
    <tr>
      <th>OrderDate</th>
      <th>OrderNumber</th>
      <th>ProductKey</th>
      <th>OrderQuantity</th>
    </tr>
"@

foreach ($row in $filtered) {
    $html += "<tr>"
    $html += "<td>$($row.OrderDate)</td>"
    $html += "<td>$($row.OrderNumber)</td>"
    $html += "<td>$($row.ProductKey)</td>"
    $html += "<td>$($row.OrderQuantity)</td>"
    $html += "</tr>"
}

$html += @"
  </table>
</body>
</html>
"@

# حفظ HTML مؤقت
$htmlFile = "report.html"
$html | Out-File -FilePath $htmlFile -Encoding utf8

Write-Host "✅ HTML report generated: $htmlFile"

# ======================================
# 6) تحويل HTML إلى PDF
# ======================================
# تأكد أن wkhtmltopdf موجود في PATH في Actions أو جهازك المحلي
$OutputPath = "report.pdf"
& wkhtmltopdf $htmlFile $OutputPath

Write-Host "✅ PDF report generated: $OutputPath"

# ======================================
# 7) تنظيف الملف المؤقت
# ======================================
Remove-Item $htmlFile -Force

Write-Host "🎉 All done! Report is ready."
