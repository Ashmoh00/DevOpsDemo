# ================================
# generate-report.ps1
# ================================

# Import required modules
Import-Module ImportExcel -ErrorAction Stop

# Paths
$CsvPath = "AdventureWorks_Sales_Data_2020.csv"
$OutputPath = "report.pdf"

# Get today's date in 2020
$today = Get-Date
$filterDate = Get-Date -Year 2020 -Month $today.Month -Day $today.Day

Write-Host "Filtering orders for date: $($filterDate.ToShortDateString())"

# Read CSV and filter
$data = Import-Csv $CsvPath | Where-Object {
    ($_.'OrderDate' -like "$($filterDate.ToString('yyyy-MM-dd'))*")
}

if ($data.Count -eq 0) {
    Write-Host "No orders found for $filterDate"
} else {
    Write-Host "$($data.Count) orders found"
}

# Prepare basic HTML content
$html = @"
<html>
<head><title>Daily Sales Report</title></head>
<body>
<h2>Daily Sales Report for $($filterDate.ToShortDateString())</h2>
<p>Total Orders: $($data.Count)</p>
<table border='1' cellpadding='5' cellspacing='0'>
<tr>
<th>OrderDate</th><th>OrderNumber</th><th>ProductKey</th><th>OrderQuantity</th>
</tr>
"@

foreach ($row in $data) {
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

# Save HTML temporarily
$htmlFile = "report.html"
$html | Out-File -FilePath $htmlFile -Encoding utf8

# Convert HTML to PDF using wkhtmltopdf
# NOTE: wkhtmltopdf must be in PATH on GitHub Actions runner
$null = & wkhtmltopdf $htmlFile $OutputPath

Write-Host "PDF Report generated: $OutputPath"

# Clean up
Remove-Item $htmlFile -Force
