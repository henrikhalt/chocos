$SccVersion            = '5.9'
$SccZipCheckSum        = '3629988E8CF36930CE3DC922287C485906056E2301FD93E0A353A1B2994C088A'

$ErrorActionPreference = 'Stop';
$SccUnzipDir           = Join-Path -Path $env:TEMP -ChildPath 'NIWCASCC'
$SccInstallerDir       = Join-Path -Path $SccUnzipDir -ChildPath "scc-$($SccVersion)_Windows"
$SccInstallExe         = Join-Path -Path $SccInstallerDir -ChildPath "SCC_$($SccVersion)_Windows_Setup.exe"
$SccSilentFilePath     = Join-Path -Path $SccInstallerDir -ChildPath 'SCC.inf'
$Url                   = "https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/scc-$($SccVersion)_Windows_bundle.zip"
$SccSilentFilecontent  = @"
[Setup]
Lang=english
Dir=C:\Program Files\SCAP Compliance Checker $SccVersion
Group=SCAP Compliance Checker $SccVersion
NoIcons=0
SetupType=custom
Components=core,Content\NIST_USGCB_SCAP_Content,Content\DISA_STIG_SCAP_Content 
Task=
"@

$SccLic = @"
  --------------------    TERMS OF USE    -----------------------
  
  IN NO EVENT SHALL THE UNITED STATES NAVY (OR GOVERNMENT) OR ANY 
  EMPLOYEES THEREOF BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, 
  SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST 
  PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND/ OR ITS 
  DOCUMENTATION, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE, 
  NOR SHALL THE UNITED STATES NAVY (OR GOVERNMENT) OR ANY EMPLOYEES
  THEREOF ASSUME ANY LEGAL LIABILITY OR RESPONSIBILITY FOR THE 
  ACCURACY, COMPLETENESS, OR USEFULNESS OF THIS SOFTWARE AND/OR ITS 
  DOCUMENTATION.

  THE UNITED STATES NAVY (OR GOVERNMENT) SPECIFICALLY DISCLAIMS ANY 
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
  SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER 
  IS PROVIDED "AS IS". THE UNITED STATES NAVY (OR GOVERNMENT) HAS NO
  OBLIGATION HEREUNDER TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, 
  ENHANCEMENTS, OR MODIFICATIONS. ANY REPRODUCTION OF THIS WORK MUST 
  INCLUDED THE ABOVE NOTICES AND THE FOLLOWING NOTICE: "PORTIONS OF 
  THIS SOFTWARE ARE OFFICIAL WORKS OF THE U.S. GOVERNMENT. THE U.S. 
  GOVERNMENT MAY PUBLISH OR REPRODUCE THIS SOFTWARE, OR ALLOW OTHERS 
  TO DO SO, FOR ANY PURPOSE WHATSOEVER."

  FOR MORE INFORMATION CONTACT:
  OFFICE OF INTELLECTUAL PROPERTY
  NAVAL INFORMATION WARFARE CENTER PACIFIC
  SAN DIEGO, CA 92152`n
"@

# Using less than TLS1.2, the download fails. Ensure TLS1.2 is used
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Print the license agreement itself 
$SccLic | Write-Host -ForegroundColor Yellow

# Unzip the package
$UnzipArgs = @{
  PackageName   = $env:ChocolateyPackageName
  UnzipLocation = $SccUnzipDir
  Url           = $Url
  Checksum      = $SccZipCheckSum
  ChecksumType  = 'sha256'
}
Install-ChocolateyZipPackage @UnzipArgs

# Add the inf-file
$SccSilentFilecontent | Out-File -FilePath $SccSilentFilePath -Encoding ASCII -Force

# Install
$PackageArgs = @{
  PackageName   = $env:ChocolateyPackageName
  File          = $SccInstallExe
  SoftwareName  = "SCAP Compliance Checker $SccVersion"
  SilentArgs    = "/LOADINF=""$SccSilentFilePath"" /VERYSILENT /SUPPRESSMSGBOXES"
  ValidExitCodes= @(0, 3010, 1641)
}
Install-ChocolateyInstallPackage @PackageArgs