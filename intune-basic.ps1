. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force

Write-Host "Initializing that chocolatey goodness"
choco feature enable -n allowGlobalConfirmation
choco feature enable -n allowEmptyChecksums

choco install belarcadvisor 
choco install adobereader 
choco install microsoft-teams
