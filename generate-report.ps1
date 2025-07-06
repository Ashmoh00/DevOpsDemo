$csvPath = "./AdventureWorks_Sales_Data_2020.csv"

# صيغة التاريخ MM/dd/yy
$today = (Get-Date).Date

$filteredData = Import-Csv $csvPath | Where-Object {
    try {
        $formats = @("MM/dd/yy", "M/d/yy", "MM/dd/yyyy", "yyyy-MM-dd")
        $parsed = $null
        $success = [datetime]::TryParseExact($_.OrderDate, $formats, $null, [System.Globalization.DateTimeStyles]::None, [ref]$parsed)
        if ($success) {
            $parsed.Date -eq $today
        } else {
            $false
        }
    } catch {
        $false
    }
}

# التحقق إذا فيه بيانات
Write-Host "✔️ Found $($filteredData.Count) rows for $today"

# بناء HTML
$htmlPath = "./report.html"
$htmlContent = @"
<html>
<head><title>Sales Report</title></head>
<body>
  <h1>Daily Sales Report</h1>
  <p>Data for $today</p>
  <table border='1'>
    <tr><th>OrderDate</th><th>OrderNumber</th><th>ProductKey</th><th>OrderQuantity</th></tr>
"@

foreach ($row in $filteredData) {
  $htmlContent += "<tr><td>$($row.OrderDate)</td><td>$($row.OrderNumber)</td><td>$($row.ProductKey)</td><td>$($row.OrderQuantity)</td></tr>`n"
}

$htmlContent += @"
  </table>
</body>
</html>
"@

Set-Content -Path $htmlPath -Value $htmlContent

# تحويل إلى PDF
$outputPdf = "./report.pdf"
& wkhtmltopdf $htmlPath $outputPdf

Write-Host "✅ PDF report generated: $outputPdf"
