$webPath = "C:\inetpub\rasan"
$backupPath = "C:\backup"

Write-Host "🔹 البحث عن آخر نسخة احتياطية..."

# البحث عن أحدث نسخة احتياطية
$latestBackup = Get-ChildItem $backupPath | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($null -eq $latestBackup) {
    Write-Host "❌ لا توجد نسخة احتياطية متوفرة!"
    exit 1
}

Write-Host "🔹 استرجاع النسخة: $($latestBackup.FullName)"

# استرجاع النسخة
Copy-Item $latestBackup.FullName $webPath -Recurse -Force

Write-Host "🔄 إعادة تشغيل IIS..."
iisreset

Write-Host "✅ تم الرجوع إلى النسخة السابقة بنجاح"

