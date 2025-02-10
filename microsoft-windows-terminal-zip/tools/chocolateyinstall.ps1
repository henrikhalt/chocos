# version specific vars
$WTVersion       = '1.22.10352.0'
$WTChecksum      = 'C2CF549A567F60DAF291DC87D06F69E74935426E96A5ED0F04845D8ABE5504DD'

# non-version specific vars
$WTChecksumType   = 'SHA256'
$WTUrl            = "https://github.com/microsoft/terminal/releases/download/v$($WTVersion)/Microsoft.WindowsTerminal_$($WTVersion)_x64.zip"
$WTSourceRootPath = Join-Path -Path $env:Temp -ChildPath "terminal-$($WTVersion)"
$WTTargetRootPath = Join-Path -Path $env:ProgramFiles -ChildPath 'WindowsTerminal'
$WTTargetPath     = Join-Path -Path $WTTargetRootPath -ChildPath 'WindowsTerminal.exe'

# not in use p.t., but may be useful when we discover os specific requirements
# Get the windows version. We need version number with build, and the "CaptionVersion", like 10, 11, 12(?) 2019, 2022, 2025 etc
$WinType=[PSObject]@{
    Version = [Environment]::OSVersion.Version
    CaptionVersion = ''
}
$OSCaption = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption; Write-Verbose "OSCaption: $OSCaption"
if ($OSCaption -match "\b(10|11|12|2019|2022|2025)\b") {
    $WinType.CaptionVersion = $matches[0]
}
else {
    throw "Windows Terminal does not support $OSCaption."
}
 
# The zip-installation is a zip file to extract to the Program Files folder. However, at the root of the zip is a folder named terminal-$($WTVersion)
$InstallChocolateyZipPackageParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $env:Temp
    Url            = $WTUrl
    Checksum       = $WTChecksum
    ChecksumType   = $WTChecksumType
}
Install-ChocolateyZipPackage @InstallChocolateyZipPackageParams

# remove any previous installation
if(Test-Path -Path $WTTargetRootPath -ErrorAction Ignore) {
    Remove-Item -Path $WTTargetRootPath -Recurse -Force | Out-Null
}
Copy-Item -Path $WTSourceRootPath -Destination $WTTargetRootPath -Recurse -Force | Out-Null
Write-Host "Deployment moved to $($env:ProgramFiles)\WindowsTerminal"

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