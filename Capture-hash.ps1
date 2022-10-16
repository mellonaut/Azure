# On VMWare
# D:\Setup.exe for tools so you can copy and paste

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
PowerShell.exe -ExecutionPolicy Bypass
Install-Script -name Get-WindowsAutopilotInfo -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
Get-WindowsAutopilotInfo -Online

# Will prompt for creds, intune admin or above