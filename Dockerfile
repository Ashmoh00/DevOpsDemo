FROM mcr.microsoft.com/powershell
COPY script.ps1 /script.ps1
CMD ["pwsh", "/script.ps1"]
