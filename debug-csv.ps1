# ============================================
# توليد تقرير HTML بسيط
# ============================================

$htmlPath = "./report.html"

$htmlContent = @"
<html>
<head><title>Test Report</title></head>
<body>
  <h1>✅ Daily Report</h1>
  <p>Date: $today</p>
  <table border='1'>
    <tr>
      <th>OrderDate</th>
      <th>OrderNumber</th>
      <th>ProductKey</th>
      <th>OrderQuantity</th>
    </tr>
"@

foreach ($row in $filteredData) {
    $htmlContent += "<tr>
      <td>$($row.OrderDate)</td>
      <td>$($row.OrderNumber)</td>
      <td>$($row.ProductKey)</td>
      <td>$($row.OrderQuantity)</td>
    </tr>`n"
}

$htmlContent += @"
  </table>
</body>
</html>
"@

Set-Content -Path $htmlPath -Value $htmlContent
Write-Host "✅ HTML report generated: $htmlPath"
