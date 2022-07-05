$KitsRootReg1 = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Kits\Installed Roots'
$KitsRootReg2 = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots'
$Key11        = 'KitsRoot11'
$Key10        = 'KitsRoot10'

# The same Windows ADK may write it's KitsRoot10-key or KitsRoot11-key, telling where the ADK is installed - 
# to either $KitsRootReg1 or $KitsRootReg2. On Windows Server 2022 it seems to get written to the former, on 
# Windows 11 the latter. Try until found. 

# The line below doesn't work because of backwards compatibility - the Get-ItemPropertyValue does not exist on test system
# $KitsRoot = Get-ItemPropertyValue -Path $KitsRootReg1 -Name $Key -ErrorAction SilentlyContinue

$KitsRootKey = Get-Item -Path $KitsRootReg1 -ErrorAction SilentlyContinue
# ensure the .GetValue() method exists
if ($KitsRootKey -is [Microsoft.Win32.RegistryKey]) {
  # try the key 'KitsRoot11'
  $KitsRoot = $KitsRootKey.GetValue("$Key11")
  if ($null -eq $KitsRoot) {
    # try the key 'KitsRoot10'
    $KitsRoot = $KitsRootKey.GetValue("$Key10")
  }
}

# if $KitsRoot is still $null, move on to the wow6432Node key
if ($null -eq $KitsRoot) {
  $KitsRootKey = Get-Item -Path $KitsRootReg2 -ErrorAction SilentlyContinue
  if ($KitsRootKey -is [Microsoft.Win32.RegistryKey]) {
    # try the key 'KitsRoot11'
    $KitsRoot = $KitsRootKey.GetValue("$Key11")
    if ($null -eq $KitsRoot) {
      # try the key 'KitsRoot10'
      $KitsRoot = $KitsRootKey.GetValue("$Key10")
    }
  }
}

# all the previous should be able to run without any exceptions being thrown, but
# if $KitsRoot is still $null, en exception must be thrown at this point
if ($null -eq $KitsRoot) {
  throw "Unable to find installation of Windows ADK"
} 
else {
  $OscdimgSourceFolder = Join-Path -Path $KitsRoot -ChildPath "Assessment and Deployment Kit\Deployment Tools\$($env:PROCESSOR_ARCHITECTURE)\Oscdimg"
  $OscdimgSourcePath = Join-Path -Path $OscdimgSourceFolder -ChildPath 'oscdimg.exe'
  if (Test-Path -Path $OscdimgSourcePath -ErrorAction SilentlyContinue) {
    $PathType = [System.EnvironmentVariableTarget]::Machine
    Write-Host "The path '$OscdimgSourceFolder' will be added to PATH"
    Install-ChocolateyPath -pathToInstall $OscdimgSourceFolder -pathType $PathType
  }
  else {
    throw "Unable to find '$OscdimgSourcePath'"
  }
}