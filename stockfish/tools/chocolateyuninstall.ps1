# version specific vars
$StockFishVersion       = '15.1'
$StockFishFileBaseName  = "stockfish_$($StockFishVersion)_win_x64_avx2"

# non-version specific vars
$ChessEnginesFolder     = Join-Path -Path $env:ProgramFiles -ChildPath 'ChessEngines'
$StockFishInstallFolder = Join-Path -Path $ChessEnginesFolder -ChildPath $StockFishFileBaseName
Remove-Item -Path $StockFishInstallFolder.FullName -Recurse -Force | Out-Null