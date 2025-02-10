# version specific vars
$WTVersion       = '1.22.10352.0'
$WTChecksum      = 'FA08F1E5C41F7003BBE659444C6FE5E3F59F77730AB482DB44DEA8087C999225'

# not in use p.t., but may be useful when we discover os specific requirements
# Get the windows version. We need version number with build, and the "CaptionVersion", like 10, 11, 12(?) 2019, 2022, 2025 etc
$WinType=[PSObject]@{
    Version = [Environment]::OSVersion.Version
    CaptionVersion = ''
}
$OSCaption = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption; Write-Verbose "OSCaption: $OSCaption"
if ($OSCaption -match "\b(10|11|12|2019|2022|2025)\b") {
    $WinType.CaptionVersion = $matches[0]
}
else {
    throw "Windows Terminal does not support $OSCaption."
}

<#
    This package has dependencies to: 
        - vcredist140
        - microsoft-vclibs-140-00
        - microsoft-ui-xaml
    When these are installed, we should be able to appx-provision the package in
#>
$InvokeWebRequestParams=@{
    Uri = "https://github.com/microsoft/terminal/releases/download/v$($WTVersion)/Microsoft.WindowsTerminal_$($WTVersion)_8wekyb3d8bbwe.msixbundle"
    OutFile = $(Join-Path -Path $env:TEMP -ChildPath "Microsoft.WindowsTerminal_$($WTVersion)_8wekyb3d8bbwe.msixbundle")
}
Invoke-WebRequest @InvokeWebRequestParams
Add-AppxProvisionedPackage -PackagePath $InvokeWebRequestParams['OutFile'] -Online -SkipLicense | Out-Null