$StigvVersion      = '2-15'
$StigvChecksum     = 'AC8CF9E2E0BF73BA0FBD82D151DBC49F387E596ECD060BE84AE5A9C4631D6EF5'
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