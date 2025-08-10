# deploy\run.ps1
$WebPath      = "C:\inetpub\rasan"
$BackupRoot   = "C:\backup"
$TimeStamp    = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupDir    = Join-Path $BackupRoot "rasan_$TimeStamp"
$RepoSitePath = Resolve-Path (Join-Path $PSScriptRoot "..\site")
$LogFile      = Join-Path $BackupRoot "deploy-latest.log"

"=== $(Get-Date) START DEPLOY ===" | Out-File $LogFile -Encoding utf8

try {
    if (!(Test-Path $RepoSitePath)) { throw "Site folder not found: $RepoSitePath" }
    if (!(Test-Path $WebPath))      { throw "IIS path not found: $WebPath" }

    if (!(Test-Path $BackupRoot)) { New-Item -ItemType Directory -Path $BackupRoot | Out-Null }

    "Backup $WebPath -> $BackupDir" | Tee-Object -FilePath $LogFile -Append
    Copy-Item $WebPath $BackupDir -Recurse -Force -ErrorAction Stop

    "Clean $WebPath" | Tee-Object -FilePath $LogFile -Append
    Get-ChildItem -Path $WebPath -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    "Deploy $RepoSitePath -> $WebPath" | Tee-Object -FilePath $LogFile -Append
    Copy-Item (Join-Path $RepoSitePath "*") $WebPath -Recurse -Force -ErrorAction Stop

    "iisreset" | Tee-Object -FilePath $LogFile -Append
    iisreset | Out-Null

    "=== SUCCESS ===" | Tee-Object -FilePath $LogFile -Append
}
catch {
    "ERROR: $($_.Exception.Message)" | Tee-Object -FilePath $LogFile -Append
    throw
}
