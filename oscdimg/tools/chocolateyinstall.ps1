$KitsRootReg1    = 'HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots'
$KitsRootReg2    = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots'
$Key             = 'KitsRoot10'
$OscdimgDestPath = "$($ENV:SystemRoot)\"

# The same Windows ADK may write it's KitsRoot10-key - telling where the ADK is installed - 
# to either $KitsRootReg1 or $KitsRootReg2. On Windows Server 2022 it seems to get written
# to the former, on Windows 11 the latter. Try until found 
$KitsRoot = Get-ItemPropertyValue -Path $KitsRootReg1 -Name $Key -ErrorAction SilentlyContinue
if ($null -eq $KitsRoot) {
  $KitsRoot = Get-ItemPropertyValue -Path $KitsRootReg2 -Name $Key -ErrorAction SilentlyContinue
}

if ($null -eq $KitsRoot) {
  throw "Unable to find installation of Windows ADK. This package requires Windows ADK to be installed"
} 
else {
  $OscdimgSourcePath = Join-Path -Path $KitsRoot -ChildPath "Assessment and Deployment Kit\Deployment Tools\$($env:PROCESSOR_ARCHITECTURE)\Oscdimg\oscdimg.exe"
  if (Test-Path -Path $OscdimgSourcePath) {
    Copy-Item -Path $OscdimgSourcePath -Destination $OscdimgDestPath -Force | Out-Null
  }
  else {
    throw "Unable to find oscdimg.exe at '$OscdimgSourcePath'"
  }
}