$StigvVersion      = '3-4-0'
$StigvChecksum     = '82F86FB562F4751F1443D7838EA0FC0819422C76890B403174CD881149057C91'
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