# LoginToGraph.ps1
$TenantId = $env:MG_TENANT_ID
$ClientId = $env:MG_CLIENT_ID
$ClientSecret = $env:MG_CLIENT_SECRET

# Corpo della richiesta per ottenere il token
$Body = @{
    grant_type    = "client_credentials"
    scope         = "https://graph.microsoft.com/.default"
    client_id     = $ClientId
    client_secret = $ClientSecret
}

# Ottenere il token di accesso
$TokenResponse = Invoke-RestMethod `
    -Uri "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token" `
    -Method Post `
    -Body $Body `
    -ContentType "application/x-www-form-urlencoded"

if (-not $TokenResponse.access_token) {
    Write-Error "Impossibile ottenere il token di accesso. Verifica i parametri configurati."
    return
}

# Restituisce il token di accesso
return $TokenResponse.access_token
