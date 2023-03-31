$ErrorActionPreference = 'Stop';
$hbcdPackageName       = 'hbcd'
$hbcdVersion           = '1.0.2' # not really in use, but as a ref for the checksum
$hbcdFile              = 'HBCD_PE_x64.iso'
$hbcdDownloadUrl       = "https://www.hirensbootcd.org/files/$hbcdFile"
$hbcdCheckSum          = 'BEC7304FE2EB11DE495B9EA7B73C38AA'
$hbcdCheckSumType      = 'md5'
$hbcdDownloadDir       = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'
$hbcdTargetFullName    = Join-Path -Path $hbcdDownloadDir -ChildPath $hbcdFile

$GetChocolateyWebFileParams = @{
  PackageName    = $hbcdPackageName
  Url            = $hbcdDownloadUrl
  FileFullPath   = $hbcdTargetFullName
  Checksum       = $hbcdCheckSum
  ChecksumType   = $hbcdCheckSumType
}

<#
# May be implemted in the future - how is 'choco install -f' handled?
if ($Force) {
  $GetChocolateyWebFileParams += @{
    ForceDownload = $true
  }
}
#>

Write-Verbose "Hiren's BootCD PE x64 ISO file will be downloaded to: $hbcdTargetFullName"
Get-ChocolateyWebFile @GetChocolateyWebFileParams