# Check Administrator Privilege
#Check Administrator Privilege

$user = [Security.Principal.WindowsIdentity]::GetCurrent();
$admin=(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if ($admin -eq $false) {
"Please run the script as Administrator"

Start-Sleep -s 10
}

#Define The API Token
#To automate the script, replace the 'Get-Host' section with the API Token from management, and save the script.
#$token = Read-Host "Please enter your API Token: "
$token = # Get the API Token from an environment variable
$token = [System.Environment]::GetEnvironmentVariable("SENTINELONE_API_KEY", "Machine")

#Gets Management URL
$config = & 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config | select-string -Pattern "server.mgmtServer"
$mgmt = $config -split ' ' | select -last 1

#Gets passphrase for Endpoint
$uuid = & 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' agent_id
$passphrase_url = $mgmt + "/web/api/v2.1/agents/passphrases?uuids="+"$uuid"

$passphrase = (Invoke-RestMethod ("$passphrase_url") -Method 'GET' -Headers $headers).data.passphrase

#Gets the SiteID for diagnostics
$site_url = $mgmt + "/web/api/v2.1/agents?uuids="+"$uuid"
$siteID = (Invoke-RestMethod ("$site_url") -Method 'GET' -Headers $headers).data.siteId

#Disabling SentinelOne protection (please insert the actual path for the sentinelctl.exe)
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' unprotect -k $passphrase
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config vssConfig.vssProtection false
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config enginesWantedState.penetration off

#Delete all shadow copies
Get-WmiObject Win32_ShadowCopy | ForEach-Object { $_.Delete() }

#Enabling SentinelOne protection
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config vssConfig.vssProtection true
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config enginesWantedState.penetration local
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' protect

$user = [Security.Principal.WindowsIdentity]::GetCurrent()
$admin = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

if ($admin -eq $false) {
    Write-Host "Please run the script as Administrator"
    Start-Sleep -s 10
    exit
}

# Define The API Token
$token = [System.Environment]::GetEnvironmentVariable("SENTINELONE_API_KEY", "Machine")

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

# Gets Management URL
$config = & 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config | Select-String -Pattern "server.mgmtServer"
$mgmt = $config -split ' ' | Select-Object -Last 1

# Gets passphrase for Endpoint
$uuid = & 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' agent_id
$passphrase_url = $mgmt + "/web/api/v2.1/agents/passphrases?uuids=" + "$uuid"

$passphrase = (Invoke-RestMethod ("$passphrase_url") -Method 'GET' -Headers $headers).data.passphrase

# Gets the SiteID for diagnostics
$site_url = $mgmt + "/web/api/v2.1/agents?uuids=" + "$uuid"
$siteID = (Invoke-RestMethod ("$site_url") -Method 'GET' -Headers $headers).data.siteId

# Disabling SentinelOne protection (please insert the actual path for the sentinelctl.exe)
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' unprotect -k $passphrase
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config vssConfig.vssProtection false
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config enginesWantedState.penetration off

# Log file path
$logFilePath = "C:\Logs\ShadowCopyDeletionLog.txt"

# Ensure the log file directory exists
$logDir = Split-Path $logFilePath
if (-not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory | Out-Null
}

# Log the header
Add-Content -Path $logFilePath -Value "`nShadow Copy Deletion Log - $(Get-Date)`n==============================="

# Delete all shadow copies and log the deletion
Get-WmiObject Win32_ShadowCopy | ForEach-Object {
    $shadowCopyID = $_.ID
    $shadowCopyVolume = $_.VolumeName
    $shadowCopyCreationTime = $_.InstallDate
    $logEntry = "Deleting Shadow Copy: ID=$shadowCopyID, Volume=$shadowCopyVolume, Created On=$shadowCopyCreationTime"

    # Log the deletion attempt
    Add-Content -Path $logFilePath -Value $logEntry

    # Delete the shadow copy
    $_.Delete()

    # Log success or failure
    if ($? -eq $true) {
        Add-Content -Path $logFilePath -Value "Successfully deleted Shadow Copy: ID=$shadowCopyID"
    } else {
        Add-Content -Path $logFilePath -Value "Failed to delete Shadow Copy: ID=$shadowCopyID"
    }
}

# Enabling SentinelOne protection
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config vssConfig.vssProtection true
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' config enginesWantedState.penetration local
& 'C:\Program Files\SentinelOne\Sentinel*\SentinelCtl.exe' protect

# Log the completion of the script
Add-Content -Path $logFilePath -Value "`nScript completed on $(Get-Date)`n"
