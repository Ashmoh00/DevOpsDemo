$backupDir = "C:\backup"

# استرجاع أحدث نسخة
$latestBackup = Get-ChildItem $backupDir | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if ($latestBackup -ne $null) {
    $destination = "C:\inetpub\rasan"
    Copy-Item -Path "$($latestBackup.FullName)\*" -Destination $destination -Recurse -Force
    Write-Host "✅ Rolled back to: $($latestBackup.Name)"
} else {
    Write-Host "❌ No backup found!"
}
