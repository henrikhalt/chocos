# On updates, the md5-hash must be changed. Everything else can be left as is.
$HbcdCheckSum          = '9e4880b5bfc2bd5b810fab2418bbad16'

# Leave as is on updates
$ErrorActionPreference = 'Stop';
$hbcdFile              = 'HBCD_PE_x64.iso'
$hbcdCheckSumType      = 'md5'
$hbcdDownloadDir       = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'
$hbcdTargetFullName    = Join-Path -Path $hbcdDownloadDir -ChildPath $hbcdFile

if (Test-Path -Path $hbcdTargetFullName -ErrorAction SilentlyContinue) {
  # Ensure it's the same file as the one we downloaded
  Write-Verbose "Getting MD5-hash of existing Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName'). This may take up to one minute..." -Verbose
  $hbcdCheckSumActual = Get-FileHash -Path $hbcdTargetFullName -Algorithm $hbcdCheckSumType
  if ($hbcdCheckSumActual.Hash -eq $hbcdCheckSum) {
    Remove-Item -Path $hbcdTargetFullName -Force -ErrorAction Stop
    Write-Host "Successfully removed Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName')."
  } 
  else {
    Write-Warning "The Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName') was found, but the checksum is incorrect. Delete it manually."
  }
} 
else {
  Write-Warning "The Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName') was not found. It is probably deleted manually already."
}