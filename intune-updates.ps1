Register-PSRepository -Default -InstallationPolicy Trusted
Register-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module -Name PSWindowsUpdate
Get-WUInstall -AcceptAll -AutoReboot

# Get-WUInstall -AcceptAll –IgnoreReboot