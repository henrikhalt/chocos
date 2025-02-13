# version specific vars
$WTVersion       = '1.22.10352.0'
$WTTargetRootPath = Join-Path -Path (Join-Path -Path "$($env:ProgramFiles)" -ChildPath 'WindowsTerminal') -ChildPath "terminal-$($WTVersion)"
$ShortcutLink     = Join-Path -Path "$($env:ProgramData)" -ChildPath 'Microsoft\Windows\Start Menu\Programs\Windows Terminal.lnk'

if(Test-Path -Path "$WTTargetRootPath" -ErrorAction Ignore) {
  Remove-Item -Path "$WTTargetRootPath" -Recurse -Force | Out-Null
}
if(Test-Path -Path "$ShortcutLink" -ErrorAction Ignore) {
  Remove-Item -Path "$ShortcutLink" -Force | Out-Null
}