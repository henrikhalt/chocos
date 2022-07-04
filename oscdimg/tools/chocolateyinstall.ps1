$KitsRootReg1    = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Kits\Installed Roots'
$KitsRootReg2    = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots'
$Key             = 'KitsRoot10'
$OscdimgDestPath = "$($ENV:SystemRoot)\"

# The same Windows ADK may write it's KitsRoot10-key - telling where the ADK is installed - 
# to either $KitsRootReg1 or $KitsRootReg2. On Windows Server 2022 it seems to get written
# to the former, on Windows 11 the latter. Try until found 

# The line below doesn't work because of backwards compatibility
# $KitsRoot = Get-ItemPropertyValue -Path $KitsRootReg1 -Name $Key -ErrorAction SilentlyContinue
$KitsRootKey = Get-Item -Path $KitsRootReg1 -ErrorAction SilentlyContinue
# ensure the .GetValue() method exists
if ($KitsRootKey -is [Microsoft.Win32.RegistryKey]) {
  $KitsRoot = $KitsRootKey.GetValue("$Key")
}
  
if ($null -eq $KitsRoot) {
  # The line below doesn't work because of backwards compatibility
  # $KitsRoot = Get-ItemPropertyValue -Path $KitsRootReg2 -Name $Key -ErrorAction SilentlyContinue
  $KitsRootKey = Get-Item -Path $KitsRootReg2 -ErrorAction SilentlyContinue
  if ($KitsRootKey -is [Microsoft.Win32.RegistryKey]) {
    $KitsRoot = $KitsRootKey.GetValue("$Key")
  }
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