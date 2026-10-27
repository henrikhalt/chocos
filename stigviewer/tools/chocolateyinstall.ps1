$StigvVersion      = '3-8-1'
$StigvChecksum     = '5407F3F94CE89A48D74A83043D7220BD2A9B8874E1418A9FE706089C1EC1B8ED'
$StigvChecksumType = 'SHA256'
$StigvUrl          = "https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_STIGViewer-win32_x64-$($StigvVersion).zip"  # <-- the format of the file name keeps changing...
$Tools             = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Content           = Join-Path -Path (Split-Path -Parent $tools) -ChildPath 'content'
$Target            = Join-Path -Path $content -ChildPath 'STIG Viewer 3.exe'
$Shortcutdir       = @{$true='CommonPrograms';$false='Programs'}[($PSVersionTable.PSVersion -gt '2.0.0.0')]
$Shortcut          = Join-Path ([System.Environment]::GetFolderPath($shortcutdir)) 'STIG Viewer.lnk'

$InstChocoZipPkgParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $Content
    Url            = $StigvUrl
    Checksum       = $StigvChecksum
    ChecksumType   = $StigvChecksumType
}
Install-ChocolateyZipPackage @InstChocoZipPkgParams

Install-ChocolateyShortcut -ShortcutFilePath $Shortcut -TargetPath $Target