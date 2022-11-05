$StockFishVersion       = '15'
$StockFishFileBaseName  = "stockfish_$($StockFishVersion)_win_x64"
$StockFishInstallFolder = Join-Path -Path $env:ProgramFiles -ChildPath $StockFishFileBaseName
Remove-Item -Path $StockFishInstallFolder.FullName -Recurse -Force | Out-Null