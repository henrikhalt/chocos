# version specific vars
$StockFishVersion       = '16'

# non-version specific vars
$ChessEnginesFolder     = Join-Path -Path $env:ProgramFiles -ChildPath 'ChessEngines'
$StockFishInstallFolder = Join-Path -Path $ChessEnginesFolder -ChildPath "stockfish_$StockFishVersion"

if (Get-Item -Path $StockFishInstallFolder -ErrorAction Ignore) {
    try {
        Write-Host "Removing the StockFish engine in '$StockFishInstallFolder'..." -ForegroundColor Yellow
        Remove-Item -Path $StockFishInstallFolder -Recurse -Force | Out-Null
        #Get-Item -Path $StockFishInstallFolder | Remove-Item -Recurse -Force | Out-Null
        Write-Host "Removed the StockFish engine in '$StockFishInstallFolder'."
    }
    catch {
        Write-Warning "Failed to remove the StockFish engine from '$StockFishInstallFolder'" -WarningAction Continue
        exit 1
    }  
}