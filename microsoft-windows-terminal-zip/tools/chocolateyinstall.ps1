# version specific vars
$WTVersion       = '1.22.10352.0'
$WTChecksum      = 'C2CF549A567F60DAF291DC87D06F69E74935426E96A5ED0F04845D8ABE5504DD'

# non-version specific vars
$WTChecksumType   = 'SHA256'
$WTUrl            = "https://github.com/microsoft/terminal/releases/download/v$($WTVersion)/Microsoft.WindowsTerminal_$($WTVersion)_x64.zip"
$WTTargetRootPath = Join-Path -Path $env:ProgramFiles -ChildPath 'WindowsTerminal'
$WTTargetSubPath  = Join-Path -Path $WTTargetRootPath -ChildPath "terminal-$($WTVersion)"
$WTTargetPath     = Join-Path -Path $WTTargetSubPath -ChildPath 'WindowsTerminal.exe'

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

# The zip-installation is a zip file to extract to the Program Files folder. 
try {
    $InstallChocolateyZipPackageParams = @{
        PackageName    = $env:ChocolateyPackageName
        UnzipLocation  = $WTTargetRootPath
        Url            = $WTUrl
        Checksum       = $WTChecksum
        ChecksumType   = $WTChecksumType
        ErrorAction    = 'Stop'
    }
    Install-ChocolateyZipPackage @InstallChocolateyZipPackageParams

    # add the "terminal-$($WTVersion)" folder to $env:Path 
    Install-ChocolateyPath -PathToInstall $WTTargetSubPath -PathType 'Machine'

    # create a shortcut in the Start Menu and pin to taskbar
    $InstallChocolateyShortcutParams = @{
        ShortcutFilePath = Join-Path -Path $env:ProgramData -ChildPath 'Microsoft\Windows\Start Menu\Programs\Windows Terminal.lnk'
        TargetPath       = $WTTargetPath
        IconLocation     = $WTTargetPath
        PinToTaskbar     = $true
        Description      = "Microsoft Windows Terminal"
    }
    Install-ChocolateyShortcut @InstallChocolateyShortcutParams

    
    # if the above worked, remove any previous installation
    $OldVersions = @(Get-ChildItem -Path $WTTargetRootPath -Directory | Where-Object {
        $_.Name -match "terminal-" -and $_.Name -ne "terminal-$($WTVersion)"
    })
    if($OldVersions.count -gt 0) {
        foreach($OldVersion in $OldVersions) {
            # remove the folder
            Remove-Item -Path $OldVersion.FullName -Recurse -Force | Out-Null
            
            # Remove the old path from the $env:Path machine variable.
            # 1. if the old path ended with a \, we may have a ";\;". If it didn't, we may how a double ;;
            # 2. if the path was at the end, we may have a trailing ;\ or a trailing ;
            # 3. if the path was at the start, we may have a leading ; or a leading \; 
            $NewPath = $env:Path -replace [regex]::escape($OldVersion.FullName), ''
            $NewPath = ($NewPath -replace ';\\;', ';') -replace ';;', ';'           # 1
            $NewPath = ($NewPath -replace ';\\$', '') -replace ';$', ''             # 2 
            $NewPath = ($NewPath -replace '^\\;', '') -replace '^;', ''             # 3 
            # set the new path
            [System.Environment]::SetEnvironmentVariable("Path", $NewPath, [System.EnvironmentVariableTarget]::Machine)
        }
    }
}
catch {
    throw $_
}