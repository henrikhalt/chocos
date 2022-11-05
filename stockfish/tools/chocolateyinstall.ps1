$StockFishVersion      = '15'
$StockFishChecksum     = '92C609A1D449BA2C31682E533F633D064774CBE0C71A5CA550108599462B779F'
$StockFishChecksumType = 'SHA256'
$StockFishFileBaseName = "stockfish_$($StockFishVersion)_win_x64"
$StockFishUrl          = "https://stockfishchess.org/files/$StockFishFileBaseName.zip"

$InstChocoZipPkgParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $env:ProgramFiles 
    Url            = $StockFishUrl
    Checksum       = $StockFishChecksum
    ChecksumType   = $StockFishChecksumType
}
Install-ChocolateyZipPackage @InstChocoZipPkgParams