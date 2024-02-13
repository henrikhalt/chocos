# version specific vars
$BanksiaGuiVersion       = '0.58'

# non-version specific vars
$BanksiaGuiInstallFolder = Join-Path -Path $env:ProgramFiles -ChildPath "BanksiaGui-$BanksiaGuiVersion-win64"

# Remove the installation folder. There is no uninstall - just remove the folder
if (Get-Item -Path $BanksiaGuiInstallFolder -ErrorAction Ignore) {
    try {
        Remove-Item -Path $BanksiaGuiInstallFolder -Recurse -Force | Out-Null
    }
    catch {
        Write-Warning "Failed to remove the BanksiaGui folder: '$BanksiaGuiInstallFolder'" -WarningAction Continue
        exit 1
    }  
}

# Remove the shortcut from the Start Menu
$ShortcutFilePath = Join-Path -Path $env:ProgramData -ChildPath "Microsoft\Windows\Start Menu\Programs\BanksiaGui.lnk"
if (Get-Item -Path $ShortcutFilePath -ErrorAction Ignore) {
    try {
        Remove-Item -Path $ShortcutFilePath -Force | Out-Null
    }
    catch {
        Write-Warning "Failed to remove the BanksiaGui shortcut '$ShortcutFilePath'" -WarningAction Continue
        exit 1
    }  
}