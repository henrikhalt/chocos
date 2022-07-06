$KitsRootReg1   = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Kits\Installed Roots'
$KitsRootReg2   = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows Kits\Installed Roots'
$Key11          = 'KitsRoot11'
$Key10          = 'KitsRoot10'

# The same Windows ADK may write it's KitsRoot11-key or KitsRoot10-key, telling where the ADK is installed - 
# to either $KitsRootReg1 or $KitsRootReg2. On Windows Server 2022 it seems to get written to the former, on 
# Windows 11 the latter. Try until found. 

# The line below doesn't work because of backwards compatibility - the Get-ItemPropertyValue cmdlet 
# was introduced in PowerShell 5, and does not exist on test system
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

if ($null -eq $KitsRoot) {
  Write-Warning -Message "Unable to find installation of Windows ADK from the registry - trying the standard filesystem locations"
  
  $ProgramFilesx86 = ${env:ProgramFiles(x86)}
  $ProgramFiles = $env:ProgramFiles

  $PossibleADKPath1 = Join-Path -Path $ProgramFilesx86 -ChildPath "Assessment and Deployment Kit\Deployment Tools\$($env:PROCESSOR_ARCHITECTURE)\Oscdimg"
  $PossibleADKPath2 = Join-Path -Path $ProgramFiles -ChildPath "Assessment and Deployment Kit\Deployment Tools\$($env:PROCESSOR_ARCHITECTURE)\Oscdimg"

  if (Test-Path -Path $PossibleADKPath1 -ErrorAction Ignore) {
    [system.string]$ADKPath = $PossibleADKPath1
  }
  elseif (Test-Path -Path $PossibleADKPath2 -ErrorAction Ignore) {
    [system.string]$ADKPath = $PossibleADKPath2
  }
  else {
    throw "Unable to find the Path to ADK - remove the path manually"
  }
}
else {
  [system.string]$ADKPath = Join-Path -Path $KitsRoot -ChildPath "Assessment and Deployment Kit\Deployment Tools\$($env:PROCESSOR_ARCHITECTURE)\Oscdimg"
}


# Get the PATH variable
Update-SessionEnvironment
$EnvPath = $env:PATH
if ($EnvPath.ToLower().Contains($ADKPath.ToLower())) {
  # remove any instances of ';;' before we count elements
  $EnvPath = $EnvPath.replace(';;',';')
  
  # Create a control count. We're removing only one element, if for 
  # some reason that doesn't check out, abort the operation
  $ControlCount = (($envPath.split(';')).count-1)

  # remove the path
  $NewPath = $EnvPath.replace("$ADKPath",'')

  # remove the remaining double ';'
  $NewPath = $NewPath.replace(';;',';')
  
  # Make sure the new value contains only one less element than before
  if (($NewPath.split(';').count) -eq $ControlCount) {
    $VariableType = [System.EnvironmentVariableTarget]::Machine
    Install-ChocolateyEnvironmentVariable -variableName 'Path' -variableValue $NewPath -variableType $VariableType
  }
  else {
    throw "Unable to remove the path of oscdimg.exe from PATH environment variable, remove manually"
  }
}