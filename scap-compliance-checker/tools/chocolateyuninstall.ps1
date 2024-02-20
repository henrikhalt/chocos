$ErrorActionPreference = 'Stop';
$PackageArgs = @{
  PackageName   = $env:ChocolateyPackageName
  SoftwareName  = 'SCAP Compliance Checker*'  
  FileType      = 'EXE' 
  SilentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  ValidExitCodes= @(0, 3010, 1605, 1614, 1641)
}

[array]$Key = Get-UninstallRegistryKey -SoftwareName $PackageArgs['SoftwareName']

if ($Key.Count -eq 1) {
  $Key | ForEach-Object { 
    $PackageArgs['file'] = "$($_.UninstallString)" 
    Uninstall-ChocolateyPackage @packageArgs
  }
} 
elseif ($Key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} 
elseif ($Key.Count -gt 1) {
  Write-Warning "$($Key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $Key | ForEach-Object { 
    Write-Warning "- $($_.DisplayName)"
  }
}