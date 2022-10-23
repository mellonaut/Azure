. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; Get-Boxstarter -Force

Write-Host "Initializing that chocolatey goodness"
choco feature enable -n allowGlobalConfirmation
choco feature enable -n allowEmptyChecksums

choco install belarcadvisor 
choco install adobereader 
choco install microsoft-teams

# Sysmon w/ custom configuration
mkdir "C:\sysmon";
Invoke-WebRequest -Uri "https://github.com/mellonaut/sysmon/raw/main/sysmon.zip" -OutFile "C:\sysmon\sysmon.zip";
Expand-Archive "c:\sysmon\sysmon.zip" -DestinationPath "C:\sysmon";
cd "c:\sysmon";
c:\sysmon\sysmon.exe -acceptEula -i c:\sysmon\sysmonconfig.xml

# Azure Monitoring Agent
iwr https://go.microsoft.com/fwlink/?linkid=2192409 -o azuremonitoringagent.msi
msiexec /i ./azuremonitoringagent.msi /qn

$web_dl = new-object System.Net.WebClient
$wallpaper_url = "https://tessier-ashpool.s3.us-east-1.amazonaws.com/corevalues.png"
$wallpaper_file = "C:\Users\Public\Pictures\desktop.jpg"
$web_dl.DownloadFile($wallpaper_url, $wallpaper_file)
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Users\Public\Pictures\desktop.jpg" /f
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v WallpaperStyle /t REG_DWORD /d "0" /f 
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v StretchWallpaper /t REG_DWORD /d "2" /f 
reg add "HKEY_CURRENT_USER\Control Panel\Colors" /v Background /t REG_SZ /d "0 0 0" /f