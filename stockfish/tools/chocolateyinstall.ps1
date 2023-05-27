$StockFishVersion       = '15.1'
$StockFishChecksum      = '8C8F76742065A18789B8F5A74561ABCC9F0A0589478607CAA1FAB2450694657B'
$StockFishChecksumType  = 'SHA256'
$StockFishFileBaseName  = "stockfish_$($StockFishVersion)_win_x64_avx2"
$StockFishUrl           = "https://stockfishchess.org/files/$StockFishFileBaseName.zip"
$ChessEnginesFolder     = Join-Path -Path $env:ProgramFiles -ChildPath 'ChessEngines'
# StockFish zip-file root contains a single folder with name = $StockFishFileBaseName, so it can be directly unzipped to the ChessEngines folder
$InstChocoZipPkgParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $ChessEnginesFolder 
    Url            = $StockFishUrl
    Checksum       = $StockFishChecksum
    ChecksumType   = $StockFishChecksumType
}
Install-ChocolateyZipPackage @InstChocoZipPkgParams
Write-Host "StockFish installed to '$ChessEnginesFolder'. Note that you may also install the *chess-package* to get a GUI and a collection of chess engines"