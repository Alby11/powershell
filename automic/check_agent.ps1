[string]$serverName = $args[0]

if ( -not ( $serverName ) )
{
  Write-Host "Pass a server name as an argument. Aborting..."
  return
}

[string]$userName = 'adminuser'
[SecureString]$secStringPassword = Get-Content .\.cred.txt | ConvertTo-SecureString
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)

$Params = @{
  Uri        = "http://server.domain.com:8088/ae/api/v1/1/system/agents/AGWUC4_$serverName"
  Credential = $credObject
}

$response = Invoke-RestMethod @Params -AllowUnencryptedAuthentication

$response

if ( $response.active -eq "True" )
{
  return
}

