# Chess Package doesn't have any software itself, but is a collection of 
# chess related packages using dependencies in it's nuspec. As such, there 
# isn't so much to uninstall, other than to successfully unregister the package. 
$DependencyPackages = & "$($PSScriptRoot)\dependencypackages.ps1"
Write-Warning "Chess Package was successfully unregistered. However, as Chess Package is just a collection of dependencies, the following dependency packages may be uninstalled individually, if that's what you want: $DependencyPackages" -WarningAction Continue
