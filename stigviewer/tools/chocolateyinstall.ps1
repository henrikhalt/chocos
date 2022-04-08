$StigvVersion      = '2-16'
$StigvChecksum     = 'C1444038B8E0A2617E6B3A56F8218B33B1907C951FCF1C833C83C6F558358AEC'
$StigvChecksumType = 'SHA256'
$StigvUrl          = "https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_STIGViewer_$($StigvVersion)_Win64.zip"

$Tools             = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Content           = Join-Path -Path (Split-Path -Parent $tools) -ChildPath 'content'
$Target            = Join-Path -Path $content -ChildPath 'STIG Viewer\STIG Viewer.exe'
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