# --- Settings ---
$WebPath     = "C:\inetpub\rasan"   # مسار موقع IIS
$BackupRoot  = "C:\backup"          # مجلد النسخ الاحتياطي
$TimeStamp   = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupDir   = Join-Path $BackupRoot "rasan_$TimeStamp"

# مسار ملفات الموقع داخل الريبو (المجلد "site" جنب مجلد "deploy")
$RepoSitePath = Resolve-Path (Join-Path $PSScriptRoot "..\site")

# --- Logging ---
$LogFile = Join-Path $BackupRoot "deploy-$TimeStamp.log"
"== DEPLOY START $(Get-Date) ==" | Out-File -FilePath $LogFile -Encoding utf8

try {
    # تأكد من وجود المسارات
    if (!(Test-Path $RepoSitePath)) { throw "Site folder not found: $RepoSitePath" }
    if (!(Test-Path $WebPath))      { throw "IIS path not found: $WebPath" }

    # إنشاء مجلد النسخ الاحتياطي إن لم يوجد
    if (!(Test-Path $BackupRoot)) { New-Item -ItemType Directory -Path $BackupRoot | Out-Null }

    # 1) عمل نسخة احتياطية من الموقع الحالي
    "Backing up $WebPath -> $BackupDir" | Tee-Object -FilePath $LogFile -Append
    Copy-Item -Path $WebPath -Destination $BackupDir -Recurse -Force -ErrorAction Stop

    # 2) نسخ النسخة الجديدة من الريبو إلى IIS
    "Deploying from $RepoSitePath -> $WebPath" | Tee-Object -FilePath $LogFile -Append
    # تفريغ الموقع الحالي (اختياري؛ علشان إزالة ملفات قديمة غير موجودة بالنسخة الجديدة)
    Get-ChildItem -Path $WebPath -Force | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    Copy-Item -Path (Join-Path $RepoSitePath "*") -Destination $WebPath -Recurse -Force -ErrorAction Stop

    # 3) إعادة تشغيل IIS
    "Restarting IIS..." | Tee-Object -FilePath $LogFile -Append
    iisreset | Out-Null

    "== DEPLOY SUCCESS ==" | Tee-Object -FilePath $LogFile -Append
}
catch {
    "ERROR: $($_.Exception.Message)" | Tee-Object -FilePath $LogFile -Append
    throw
}
