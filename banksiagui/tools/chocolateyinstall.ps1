# version specific vars
$BanksiaGuiVersion       = '0.58'
$BanksiaGuiChecksum      = '6CCBCC79C31229C66BB03B33C3CF1E9853201F0235A99E1570FBA997A0CC95E5'

# non-version specific vars
$BanksiaGuiChecksumType  = 'SHA256'
$BanksiaGuiUrl           = "https://banksiagui.com/dl/BanksiaGui-$BanksiaGuiVersion-win64.zip"
   

# Installation instruction: "To run the app, just download, unzip and click the program. You need a 64-bit OS, Windows, macOS, or Linux."
$InstChocoZipPkgParams = @{
    PackageName    = $env:ChocolateyPackageName
    UnzipLocation  = $env:ProgramFiles 
    Url            = $BanksiaGuiUrl
    Checksum       = $BanksiaGuiChecksum
    ChecksumType   = $BanksiaGuiChecksumType
}
Install-ChocolateyZipPackage @InstChocoZipPkgParams

# Create a shortcut in the Start Menu
$ShortcutTargetFolder = Join-Path -Path $env:ProgramFiles -ChildPath "BanksiaGui-$BanksiaGuiVersion-win64"
$ShortcutTargetPath   = Join-Path -Path $ShortCutTargetFolder -ChildPath "BanksiaGUI.exe"
$InstallChocolateyShortcutParams = @{
    ShortcutFilePath = Join-Path -Path $env:ProgramData -ChildPath "Microsoft\Windows\Start Menu\Programs\BanksiaGui.lnk"
    TargetPath       = $ShortcutTargetPath
    IconLocation     = $ShortcutTargetPath
    Description      = "BanksiaGui is a feature-rich chess GUI that can be used with UCI-compliant chess engines, such as Stockfish and Leela Chess Zero"
}
Install-ChocolateyShortcut @InstallChocolateyShortcutParams