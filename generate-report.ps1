$csvPath = "./AdventureWorks_Sales_Data_2020.csv"
$today = (Get-Date).Date
$Culture = [System.Globalization.CultureInfo]::InvariantCulture

$filteredData = Import-Csv $csvPath | Where-Object {
    $parsed = [datetime]::ParseExact($_.OrderDate, "MM/dd/yy", $Culture)
    $parsed.Date -eq $today
}

Write-Host "✅ عدد الصفوف: $($filteredData.Count)"


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
