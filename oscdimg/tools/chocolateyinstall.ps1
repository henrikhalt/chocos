$KitsRootReg1 = 'HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots'
$KitsRootreg2 = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots'
$Key         = 'KitsRoot10'
$OscdimgDestinationPath = "$($ENV:SystemRoot)\"

$KitsRoot = Get-ItemPropertyValue -Path $KitsRootReg1 -Name $Key -ErrorAction SilentlyContinue
if ($null -eq $KitsRoot) {
  $KitsRoot = Get-ItemPropertyValue -Path $KitsRootReg2 -Name $Key -ErrorAction SilentlyContinue
}
if ($null -eq $KitsRoot) {
  throw "Unable to find installation of Windows ADK. This package requires Windows ADK to be installed"
} else {
  $OscdimgSourcePath = Join-Path -Path $KitsRoot -ChildPath "Assessment and Deployment Kit\Deployment Tools\$($env:PROCESSOR_ARCHITECTURE)\Oscdimg\oscdimg.exe"
  if (Test-Path -Path $OscdimgSourcePath) {
    Copy-Item -Path $OscdimgSourcePath -Destination $OscdimgDestinationPath -Force | Out-Null
  }
  else {
    throw "Unable to find oscdimg.exe at '$OscdimgSourcePath'"
  }
}