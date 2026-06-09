param(
    [string]$Source,
    [string]$Backup
)

Write-Host "Taking Backup..."

if (!(Test-Path $Backup)) {
    New-Item -ItemType Directory -Path $Backup
}

robocopy $Source $Backup /MIR

Write-Host "Backup Completed"