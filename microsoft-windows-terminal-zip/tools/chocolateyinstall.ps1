# version specific vars
$WTVersion       = 'v1.22.10352.0'
$WTChecksum      = 'C2CF549A567F60DAF291DC87D06F69E74935426E96A5ED0F04845D8ABE5504DD'

# non-version specific vars
$WTChecksumType  = 'SHA256'
$WTUrl           = "https://github.com/microsoft/terminal/releases/download/$($WTVersion)/Microsoft.WindowsTerminal_$($WTVersion)_x64.zip"

# The zip-installation is a zip file to extract to the Program Files folder.
$InstallChocolateyZipPackageParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $env:Temp
    Url            = $WTUrl
    Checksum       = $WTChecksum
    ChecksumType   = $WTChecksumType
}
Install-ChocolateyZipPackage @InstallChocolateyZipPackageParams

# the files should now be in $env:temp\Microsoft.WindowsTerminal_$($WTVersion)_x64\terminal-$($WTVersion)\
$WTSourceRootPath = Join-Path -Path $env:Temp -ChildPath "Microsoft.WindowsTerminal_$($WTVersion)_x64\terminal-$($WTVersion)"
$WTTargetRootPath = Join-Path -Path $env:ProgramFiles -ChildPath 'WindowsTerminal'
$WTTargetPath = Join-Path -Path $WTTargetRootPath -ChildPath 'WindowsTerminal.exe'

# remove any previous installation
if(Test-Path -Path $WTTargetRootPath -ErrorAction Ignore) {
    Remove-Item -Path $WTTargetRootPath -Recurse -Force | Out-Null
}
Copy-Item -Path $WTSourceRootPath -Destination $WTTargetRootPath -Recurse -Force | Out-Null

# add the WindowsTerminal folder to $env:Path
$PathType = [System.EnvironmentVariableTarget]::Machine
Install-ChocolateyPath -PathToInstall $WTTargetRootPath -PathType $PathType

# create a shortcut in the Start Menu
$InstallChocolateyShortcutParams = @{
    ShortcutFilePath = Join-Path -Path $env:ProgramData -ChildPath 'Microsoft\Windows\Start Menu\Programs\Windows Terminal.lnk'
    TargetPath       = $WTTargetPath
    IconLocation     = $WTTargetPath
    Description      = "Microsoft Windows Terminal"
}
Install-ChocolateyShortcut @InstallChocolateyShortcutParams