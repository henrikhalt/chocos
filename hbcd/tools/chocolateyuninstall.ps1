﻿$ErrorActionPreference = 'Stop';
#$hbcdVersion           = '1.0.2' 
$hbcdFile              = 'HBCD_PE_x64.iso'
$hbcdCheckSum          = 'BEC7304FE2EB11DE495B9EA7B73C38AA'
$hbcdCheckSumType      = 'md5'
$hbcdDownloadDir       = Join-Path -Path $env:USERPROFILE -ChildPath 'Downloads'
$hbcdTargetFullName    = Join-Path -Path $hbcdDownloadDir -ChildPath $hbcdFile

if (Test-Path -Path $hbcdTargetFullName -ErrorAction SilentlyContinue) {
  # Ensure it's the same file as the one we downloaded
  Write-Verbose "Getting MD5-hash of existing Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName'). This may take up to one minute..." -Verbose
  $hbcdCheckSumActual = Get-FileHash -Path $hbcdTargetFullName -Algorithm $hbcdCheckSumType
  if ($hbcdCheckSumActual.Hash -eq $hbcdCheckSum) {
    Write-Host "Removing Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName')..."
    Remove-Item -Path $hbcdTargetFullName -Force -ErrorAction Stop
    Write-Host "Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName') was deleted."
  } else {
    Write-Warning "The Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName') was found, but the checksum is incorrect. Delete it manually."
  }
} else {
  Write-Warning "The Hiren's BootCD PE x64 ISO file ('$hbcdTargetFullName') was not found. It is probably deleted manually already."
}