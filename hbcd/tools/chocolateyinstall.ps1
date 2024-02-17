# On updates, the md5-hash must be changed. Everything else can be left as is.
$HbcdCheckSum          = '9e4880b5bfc2bd5b810fab2418bbad16'

# Leave as is on updates
$ErrorActionPreference = 'Stop';
$HbcdPackageName       = 'hbcd'
$HbcdFile              = 'HBCD_PE_x64.iso'
$HbcdDownloadUrl       = "https://www.hirensbootcd.org/files/$HbcdFile"
$HbcdCheckSumType      = 'md5'
$HbcdDownloadDir       = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'
$HbcdTargetFullName    = Join-Path -Path $HbcdDownloadDir -ChildPath $HbcdFile

$GetChocolateyWebFileParams = @{
    PackageName    = $HbcdPackageName
    Url            = $HbcdDownloadUrl
    FileFullPath   = $HbcdTargetFullName
    Checksum       = $HbcdCheckSum
    ChecksumType   = $HbcdCheckSumType
  }
  Get-ChocolateyWebFile @GetChocolateyWebFileParams
  Write-Verbose "Hiren's BootCD PE x64 ISO file was downloaded to: $HbcdTargetFullName"