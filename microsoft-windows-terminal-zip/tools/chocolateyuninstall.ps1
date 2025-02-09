# remove the installation
if(Test-Path -Path $WTTargetRootPath -ErrorAction Ignore) {
  Remove-Item -Path $WTTargetRootPath -Recurse -Force | Out-Null
}
# remove the shortcut
$ShortcutLink = Join-Path -Path $env:ProgramData -ChildPath 'Microsoft\Windows\Start Menu\Programs\Windows Terminal.lnk'
if(Test-Path -Path $ShortcutLink -ErrorAction Ignore) {
  Remove-Item -Path $ShortcutLink -Force | Out-Null
}