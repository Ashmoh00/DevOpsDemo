# تأكد من المسار صح
$csvPath = "./AdventureWorks_Sales_Data_2020.csv"

# صيغة اليوم والشهر فقط
$today = Get-Date -Format "MM/dd"

# جرب فلترة التواريخ التي تبدأ بـ اليوم والشهر
$filteredData = Import-Csv $csvPath | Where-Object {
    $_.OrderDate.StartsWith($today)
}

Write-Host "✅ التاريخ المستخدم: $today"
Write-Host "✅ عدد الصفوف المطابقة: $($filteredData.Count)"

# اطبع أول 5 صفوف كاختبار
$filteredData | Select-Object -First 5 | Format-Table
