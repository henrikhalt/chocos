# version specific vars
$StockFishVersion       = '16'
$StockFishChecksum      = '93F7095C3EE370E8D8FC90BA9AF995001578F0339ED43CF963B9D5B4246FFD58'

# non-version specific vars
$StockFishChecksumType  = 'SHA256'
$StockFishUrl           = "https://github.com/official-stockfish/Stockfish/releases/download/sf_$StockFishVersion/stockfish-windows-x86-64-avx2.zip"
$ChessEnginesFolder     = Join-Path -Path $env:ProgramFiles -ChildPath 'ChessEngines'
$StockFishInstallFolder = Join-Path -Path $ChessEnginesFolder -ChildPath "stockfish_$StockFishVersion"

$InstChocoZipPkgParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $StockFishInstallFolder 
    Url            = $StockFishUrl
    Checksum       = $StockFishChecksum
    ChecksumType   = $StockFishChecksumType
}
Install-ChocolateyZipPackage @InstChocoZipPkgParams

# Move contents of the folder 'stockfish' one level down, and remove the folder 'stockfish' as it's not needed
Get-ChildItem -Path (Join-Path -Path $StockFishInstallFolder -ChildPath 'stockfish') | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $StockFishInstallFolder -Force | Out-Null
}
Get-Item -Path (Join-Path -Path $StockFishInstallFolder -ChildPath 'stockfish') | Remove-Item -Force | Out-Null

Write-Host "StockFish $StockFishVersion installed to '$StockFishInstallFolder'.`nNote that you may install 'chess-package' to get a GUI and a collection of chess engines" -ForegroundColor Yellow