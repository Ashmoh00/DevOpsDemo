# تحديد المسارات
$webPath = "C:\inetpub\rasan"
$backupPath = "C:\backup"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = Join-Path $backupPath "rasan_$timestamp"

Write-Host "🔹 بدء النسخ الاحتياطي..."

# إنشاء نسخة احتياطية
if (!(Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath
}

Copy-Item $webPath $backupFolder -Recurse -Force
Write-Host "✅ تم النسخ الاحتياطي إلى: $backupFolder"

Write-Host "🔹 نشر النسخة الجديدة..."

# نسخ الملفات الجديدة إلى موقع IIS
Copy-Item ".\site\*" $webPath -Recurse -Force

Write-Host "🔄 إعادة تشغيل IIS..."
iisreset

Write-Host "✅ تم النشر بنجاح"
