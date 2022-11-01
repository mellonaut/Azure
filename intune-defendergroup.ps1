# Set up Chocolatey
# Download the boxstarter bootstrap
Set-ExecutionPolicy -Bypass 
. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force

Write-Host "Initializing that chocolatey goodness"
choco feature enable -n allowGlobalConfirmation
choco feature enable -n allowEmptyChecksums

choco install belarcadvisor
choco install adobereader 
# choco install microsoft-teams
# choco install microsoft-monitoring-agent

# Sysmon w/ custom configuration
mkdir "C:\sysmon";
Invoke-WebRequest -Uri "https://github.com/mellonaut/sysmon/raw/main/sysmon.zip" -OutFile "C:\sysmon\sysmon.zip";
Expand-Archive "c:\sysmon\sysmon.zip" -DestinationPath "C:\sysmon";
cd "c:\sysmon";
c:\sysmon\sysmon.exe -acceptEula -i c:\sysmon\sysmonconfig.xml


# Azure Monitoring Agent
iwr https://go.microsoft.com/fwlink/?linkid=2192409 -o azuremonitoringagent.msi
msiexec /i ./azuremonitoringagent.msi /qn

Set-WindowsExplorerOptions -EnableShowFileExtensions
Disable-BingSearch
Disable-GameBarTips

write-host "Setting a nice wallpaper"
$web_dl = new-object System.Net.WebClient
$wallpaper_url = "https://tessier-ashpool.s3.us-east-1.amazonaws.com/corevalues.png"
$wallpaper_file = "C:\Users\Public\Pictures\desktop.jpg"
$web_dl.DownloadFile($wallpaper_url, $wallpaper_file)
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Users\Public\Pictures\desktop.jpg" /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_DWORD /d "0" /f 
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v StretchWallpaper /t REG_DWORD /d "2" /f 
reg add "HKEY_CURRENT_USER\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f

# Disable Invasive Privacy Settings
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1


# Update security settings
#Disable LLMNR
Write-Host -ForegroundColor Green "Disabling LLMNR"
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient”
REG ADD  “HKLM\Software\policies\Microsoft\Windows NT\DNSClient” /v ” EnableMulticast” /t REG_DWORD /d “0” /f

# # Disable NBT-NS
# Write-Host -ForegroundColor Green "Disabling NBT-NS"
# $regkey = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces"
# Get-ChildItem $regkey |foreach { Set-ItemProperty -Path "$regkey\$($_.pschildname)" -Name NetbiosOptions -Value 2 -Verbose}

Write-Host -ForegroundColor Green "Enabling SMB signing as always"
# Enable SMB signing as 'always'
$Parameters = @{
    RequireSecuritySignature = $True
    EnableSecuritySignature = $True
    EncryptData = $True
    Confirm = $false
}
Set-SmbServerConfiguration @Parameters

# Disable Powershell 2.0 to prevent downgrade attacks
Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root



Register-PSRepository -Default -InstallationPolicy Trusted
Register-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module -Name PSWindowsUpdate
# Get-WUInstall -AcceptAll -AutoReboot

Get-WUInstall -AcceptAll -IgnoreReboot


Write-Host "Removing Roblox and Clippy..." -ForegroundColor "Yellow"

function removeApp {
	Param ([string]$appName)
	Write-Output "Trying to remove $appName"
	Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
	Get-AppXProvisionedPackage -Online | Where DisplayName -like $appName | Remove-AppxProvisionedPackage -Online
}

$applicationList = @(
	"Microsoft.BingFinance"
	"Microsoft.3DBuilder"
	"Microsoft.BingFinance"
	"Microsoft.BingNews"
	"Microsoft.BingSports"
	"Microsoft.BingWeather"
	"Microsoft.CommsPhone"
	"Microsoft.Getstarted"
	"Microsoft.WindowsMaps"
	"*MarchofEmpires*"
	"Microsoft.GetHelp"
	"Microsoft.Messaging"
	"*Minecraft*"
	"Microsoft.MicrosoftOfficeHub"
	"Microsoft.OneConnect"
	"Microsoft.WindowsPhone"
	"*Solitaire*"
	"Microsoft.MicrosoftStickyNotes"
	"Microsoft.Office.Sway"
	"Microsoft.XboxApp"
	"Microsoft.XboxIdentityProvider"
	"Microsoft.ZuneMusic"
	"Microsoft.ZuneVideo"
	"Microsoft.NetworkSpeedTest"
	"Microsoft.FreshPaint"
	"Microsoft.Print3D"
	"*Autodesk*"
	"*BubbleWitch*"
    "king.com*"
    "G5*"
	"*Dell*"
	"*Facebook*"
	"*Keeper*"
	"*Netflix*"
	"*Twitter*"
	"*Plex*"
	"*.EclipseManager"
	"ActiproSoftwareLLC.562882FEEB491" # Code Writer
	"*.AdobePhotoshopExpress"
	"Microsoft.ZuneMusic"
	
);