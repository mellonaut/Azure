choco upgrade all -y
if(!(get-module PSWIndowsUpdate )){ Install-Module PSWindowsUpdate }
Import-Module PSWIndowsUpdate
Get-WUInstall -AcceptAll -IgnoreReboot

$Global:SaveLog = $true
$Global:LogPath = "C:\logs"
$Global:LogFileName = "choco.log"  # must end with .log
$Global:LogRetentionInDays = 365

function WriteLog {
    param ([String]$Msg)
    $TimeStamp = Get-Date -Format "dd/MM/yy HH:mm:ss"
    if ($Global:SaveLog) {
        if (-not (Test-Path "$Global:LogPath")) {
            New-Item -ItemType "directory" -Path "$Global:LogPath" -Force -Confirm:$false | Out-Null
        }
        $FileTimeStamp = Get-Date -Format "yyyyMMdd"
        $LogFileWithDate = ($Global:LogFileName.Replace(".log", "_$($FileTimeStamp).log"))
        Write-Output "[$TimeStamp] $Msg" | Out-File -FilePath "$($Global:LogPath)\$($LogFileWithDate)"  -Append
    }
    else {
        Write-Host "[$TimeStamp] $Msg"
    }
}

Write-Log "Packages updated and Windows Updates installed."

function CleanLogs {
    $Retention = (Get-Date).AddDays(-$($Global:LogRetentionInDays))
    Get-ChildItem -Path $Global:LogPath -Recurse -Force | Where-Object { $_.Extension -eq ".log" -and $_.CreationTime -lt $Retention } |
        Remove-Item -Force -Confirm:$false
}
$Global:SaveLog = $true
$Global:LogPath = "C:\Temp\Logs"
$Global:LogFileName = "my.log"  # must end with .log
$Global:LogRetentionInDays = 7
WriteLog "Hello World!"
# I always place this at the end of the script to ensure old logs are purged.
if ($Global:SaveLog) {
    WriteLog -Msg "Cleaning logs older than $($Global:LogRetentionInDays) days"
    CleanLogs
}