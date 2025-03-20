# Import the Active Directory module
Import-Module ActiveDirectory

# Define the source user
$sourceUser = "sourceuser"

# Get the source user's details
$sourceUserDetails = Get-ADUser -Identity $sourceUser -Properties *

# Get the source user's group memberships
$sourceUserGroups = Get-ADUser -Identity $sourceUser | Get-ADPrincipalGroupMembership | Select-Object -ExpandProperty SamAccountName

# Get the OU of the source user
$sourceUserOU = ($sourceUserDetails.DistinguishedName -split ",", 2)[1]

# Define the target users
$targetUsers = 25..34 | ForEach-Object { "targetuser{0:D3}" -f $_ }

# Define the password
$password = ConvertTo-SecureString "password" -AsPlainText -Force

# Loop through each target user
foreach ($targetUser in $targetUsers)
{
    # Create the new user with the defined password
    $newUser = New-ADUser -Path $sourceUserOU -SamAccountName $targetUser -UserPrincipalName ("{0}@domain.com" -f $targetUser) -GivenName $targetUser -Name $targetUser -Initials ("C{0}" -f $targetUser.Substring(8)) -EmailAddress ("{0}@domain.com" -f $targetUser) -Enabled $true -ChangePasswordAtLogon $false -PasswordNeverExpires $false -AccountPassword $password -PassThru | Set-ADUser -Description $sourceUserDetails.Description

    # Add the new user to the source user's groups
    foreach ($group in $sourceUserGroups)
    {
        Add-ADGroupMember -Identity $group -Members $targetUser
    }

}
