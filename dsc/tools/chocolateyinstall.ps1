# variable
$DSCv3Version = '3.0.2'
$DSCv3ZipCheckSum = '1D9A4575C3E1609744055D18074DB5146F30CC8F2107C60C154A8997497659F2'

# static
$ErrorActionPreference = 'Stop';
$DSCv3InstallPath = Join-Path -Path $env:PROGRAMFILES -ChildPath 'dsc'
$Url = "https://github.com/PowerShell/DSC/releases/download/v$($DSCv3Version)/DSC-$($DSCv3Version)-x86_64-pc-windows-msvc.zip"

$UnzipArgs = @{
  PackageName   = $env:ChocolateyPackageName
  UnzipLocation = $DSCv3InstallPath
  Url           = $Url
  Checksum      = $DSCv3ZipCheckSum
  ChecksumType  = 'sha256'
  Force         = $true
}
Install-ChocolateyZipPackage @UnzipArgs

# add to path as well
Install-ChocolateyPath -PathToInstall $DSCv3InstallPath -PathType 'Machine'