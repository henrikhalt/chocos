$ErrorActionPreference = 'Stop';
$DSCv3InstallPath = Join-Path -Path $env:PROGRAMFILES -ChildPath 'dsc'
$RemoveArgs = @{
  Path = $DSCv3InstallPath
  Force = $true
  Recurse = $true
  ErrorAction = 'Stop'
}
Remove-Item @RemoveArgs

#! The uninstall-ChocolateyPath is documented, but not implemented? 
# Uninstall-ChocolateyPath -PathToUninstall $DSCv3InstallPath -PathType 'Machine'

#! Manual removal from PATH machine variable.
# Get the Machine Path from the Registry ($env:Path mixes user and machine paths - we don't want to duplicate user paths into machine paths)
$MachinePath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Remove the specific path from the Machine Path
$NewPath = $MachinePath -replace [regex]::escape($DSCv3InstallPath), ''

# Clean up formatting
$NewPath = ($NewPath -replace ';\\;', ';') -replace ';;', ';' 
$NewPath = ($NewPath -replace ';\\$', '') -replace ';$', ''  
$NewPath = ($NewPath -replace '^\\;', '') -replace '^;', ''  

# Set the updated Machine Path
[System.Environment]::SetEnvironmentVariable("Path", $NewPath, [System.EnvironmentVariableTarget]::Machine)