# Chess Package doesn't have any software itself, but is a collection of 
# chess related packages using dependencies in it's nuspec
$DependencyPackages = & "$($PSScriptRoot)\dependencypackages.ps1"
Write-Host "Chess Package successfully installed the following collection of dependency packages: $DependencyPackages"