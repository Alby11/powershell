$Users = Import-Csv -Delimiter "," -Path ".\TierUsersList1.csv"            
foreach ($User in $Users)            
{            
    $Displayname = $User.displayname            
    $Firstname = $User.firstname            
    $Lastname = $User.lastname
    $SAM = $user.sam
    $UPN = $user.upn
    $Password = $user.Password
    $OU = $User.OU
    #$Description = $User.Description            
 
    echo $Displayname
    New-ADUser -Name $Displayname -SamAccountName $SAM -UserPrincipalName $UPN -DisplayName $DisplayName -EmailAddress $UPN -GivenName $firstname -Surname $lastname -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Path $OU -Enabled $true -PasswordNeverExpires $true 
    
}


#New-ADUser -Name $Firstname -DisplayName $Displayname -Surname $Lastname -SamAccountName $SAM -UserPrincipalName $UPN -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) -Enabled $true -Path $OU -ChangePasswordAtLogon $true –PasswordNeverExpires $false