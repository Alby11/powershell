# Define the module patterns to search for
$modulePatterns = @("Microsoft.Graph", "MSAL.PS")

foreach ($pattern in $modulePatterns) {
    # Get the installed modules matching the pattern
    $installedModules = Get-InstalledModule -Name $pattern -ErrorAction SilentlyContinue

    if (-not $installedModules) {
        # If no modules matching the pattern are installed, install the modules
        Write-Host "Installing modules matching pattern '$pattern'..."
        Install-Module -Name $pattern -Force -AllowClobber
    } else {
        Write-Host "Modules matching pattern '$pattern' are already installed."
    }
}

# Prompt for the user's UPN or email
$UserEmailOrUPN = Read-Host "Enter the user email or UPN"

# Replace the following variables
$TenantId = "304e00e3-38a2-4ea1-bbee-8cb4f779f7a1"
$ClientId = "17a6e0ad-a3ea-4364-9b1a-f0bdc4af8dde"

# Get the access token using the interactive method
$token = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -Interactive -Scopes ".default"

Connect-MgGraph -AccessToken ($token.AccessToken | ConvertTo-SecureString -AsPlainText -Force) -NoWelcome
# Fetch the user object ID using the provided email or UPN
$user = Get-MgUser -Filter "userPrincipalName eq '$UserEmailOrUPN'"
if ($user -ne $null) {
    $userObjectId = $user.Id
    Write-Host "User Object ID: $userObjectId"

    # Prompt for hostname or device object ID
    $hostnameOrObjectId = Read-Host "Enter the hostname or device object ID"

    # Query the device by display name (hostname) or directly by object ID
    if ($hostnameOrObjectId -match "^[a-fA-F0-9\-]{36}$") {
        # It's an object ID
        $device = Get-MgDevice -DeviceId $hostnameOrObjectId
    } else {
        # It's a hostname
        $hostname = $hostnameOrObjectId
        $device = Get-MgDevice -Filter "displayName eq '$hostname'"
    }

    if ($device -ne $null) {
        $deviceObjectId = $device.Id
        $deviceName = $device.DisplayName

        Write-Host "Device Name: $deviceName"
        Write-Host "Device Object ID: $deviceObjectId"

        # Print user and device details
        Write-Host "User: $($user.DisplayName) ($userObjectId)"
        Write-Host "Device Name: $deviceName"
        Write-Host "Device Object ID: $deviceObjectId"

        # Ask for confirmation before removal
        $confirmation = Read-Host "Are you sure you want to remove the user from the device? (yes/no)"
        if ($confirmation -eq "yes") {
            try {
                # Remove the user from the device
                Remove-MgDeviceRegisteredUserByRef -DeviceId $deviceObjectId -DirectoryObjectId $userObjectId
                Write-Host "User removed from the device."
            } catch {
                Write-Host "Failed to remove the user from the device: $_"
            }
        } else {
            Write-Host "Operation cancelled."
        }
    } else {
        Write-Host "Device not found."
    }
} else {
    Write-Host "User not found."
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph
