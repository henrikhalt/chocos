# version specific vars
$Lc0Version         = '0.30.0'

# non-version specific vars
$ChessEnginesFolder = Join-Path -Path $env:ProgramFiles -ChildPath 'ChessEngines'
$Lc0InstallFolder   = Join-Path -Path $ChessEnginesFolder -ChildPath "lc0_$Lc0Version"

if (Get-Item -Path $Lc0InstallFolder -ErrorAction Ignore) {
    try {
        Write-Host "Trying to remove Lc0 engine in '$Lc0InstallFolder'..." -ForegroundColor Yellow
        Remove-Item -Path $Lc0InstallFolder -Recurse -Force | Out-Null
        Write-Host "Removed Lc0 engine in '$Lc0InstallFolder'."
    }
    catch {
        Write-Warning "Failed to remove the Lc0 engine from '$Lc0InstallFolder'" -WarningAction Continue
        exit 1
    }  
}