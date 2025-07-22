# المسارات
$source = "C:\actions-runner\_work\Ashmoh00\DevOpsDemo
$destination = "C:\inetpub\rasan"
$backupDir = "C:\backup"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = Join-Path $backupDir "rasan_$timestamp"

# إنشاء مجلد النسخ الاحتياطي
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

# نسخ الملفات الحالية إلى النسخة الاحتياطية
Copy-Item -Path "$destination\*" -Destination $backupPath -Recurse -Force

Write-Host "✅ Backup created at: $backupPath"

# نسخ الملفات الجديدة من GitHub إلى IIS
Copy-Item -Path "$source\*" -Destination $destination -Recurse -Force

Write-Host "🚀 Deployment completed successfully to IIS!"
