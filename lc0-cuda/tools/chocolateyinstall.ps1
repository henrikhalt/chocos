# version specific vars
$Lc0Version         = '0.32.0'
$Lc0Checksum        = '92eae73dd4f6752310c174b9d67e9dae81c6a80c75673aaf8e5529b8d3477981'

# non-version specific vars
$Lc0ChecksumType    = 'SHA256'
$Lc0Url             = "https://github.com/LeelaChessZero/lc0/releases/download/v$Lc0Version/lc0-v$Lc0Version-windows-gpu-nvidia-cuda11.zip"
$ChessEnginesFolder = Join-Path -Path $env:ProgramFiles -ChildPath 'ChessEngines'
$Lc0InstallFolder   = Join-Path -Path $ChessEnginesFolder -ChildPath "lc0_$Lc0Version"

$InstChocoZipPkgParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $Lc0InstallFolder 
    Url            = $Lc0Url
    Checksum       = $Lc0Checksum
    ChecksumType   = $Lc0ChecksumType
}
Install-ChocolateyZipPackage @InstChocoZipPkgParams
Write-Host "Leela Chess Zero v$Lc0Version installed to '$Lc0InstallFolder'.`nNote that you may install 'chess-package' to get a GUI and a collection of chess engines" -ForegroundColor Yellow