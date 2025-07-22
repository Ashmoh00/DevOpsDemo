$source = "C:\actions-runner\_work\DevOpsDemo\DevOpsDemo"
$destination = "C:\inetpub\rasan"
$backupDir = "C:\backup"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = Join-Path $backupDir "rasan_$timestamp"

# إنشاء النسخة الاحتياطية
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
Copy-Item -Path "$destination\*" -Destination $backupPath -Recurse -Force
Write-Host "✅ Backup created: $backupPath"

# نشر الملفات الجديدة
Copy-Item -Path "$source\*" -Destination $destination -Recurse -Force
Write-Host "🚀 Deployment successful from GitHub repo to IIS"
