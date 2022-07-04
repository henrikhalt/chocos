$OscdimgPath = Join-Path -Path "$($ENV:SystemRoot)" -ChildPath 'oscdimg.exe'
if (Test-Path -Path $OscdimgPath -ErrorAction SilentlyContinue) {
  try {
    Remove-Item -Path $OscdimgPath -Force -ErrorAction Stop
    Write-Verbose "OscdImg.exe was successfully removed from $($ENV:SystemRoot)"
  }
  catch {
    throw "Unable to remove file '$OscdimgPath'"
  }
} 
else {
  Write-Verbose "OscdImg.exe was already removed from $($ENV:SystemRoot)"
}