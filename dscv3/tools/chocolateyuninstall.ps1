$ErrorActionPreference = 'Stop';
$DSCv3InstallPath = Join-Path -Path $env:PROGRAMFILES -ChildPath 'dscv3'
$RemoveArgs = @{
  Path = $DSCv3InstallPath
  Force = $true
  Recurse = $true
  ErrorAction = 'Stop'
}
Remove-Item @RemoveArgs

#! The uninstall-ChocolateyPath is documented, but not implemented? 
# Uninstall-ChocolateyPath -PathToUninstall $DSCv3InstallPath -PathType 'Machine'

#! Manual removal from $env:Path machine variable.
$NewPath = $env:Path -replace [regex]::escape($DSCv3InstallPath), ''
# 1. if the path ended with a \, we may have a ";\;". If it didn't, we may how a double ;;
$NewPath = ($NewPath -replace ';\\;', ';') -replace ';;', ';'           # 1
# 2. if the path was at the end, we may have a trailing ;\ or a trailing ;
$NewPath = ($NewPath -replace ';\\$', '') -replace ';$', ''             # 2 
# 3. if the path was at the start, we may have a leading ; or a leading \; 
$NewPath = ($NewPath -replace '^\\;', '') -replace '^;', ''             # 3 

# set the new path
[System.Environment]::SetEnvironmentVariable("Path", $NewPath, [System.EnvironmentVariableTarget]::Machine)