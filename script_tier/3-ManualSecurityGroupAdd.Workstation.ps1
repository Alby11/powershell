<#
.SYNOPSIS
 
.DESCRIPTION
 
.NOTES
 
File Name:      
Created:        
Last modified:  
Author:         Lorenzo.Grasseni@overneteducation.it - Mario.Serra@overneteducation.it
PowerShell:     4.0 or above 
Requires:       -RunAsAdministrator
OS:             
Version:        
Action:         
Disclaimer:     This script is provided "As Is" with no warranties.
 
.EXAMPLE
 
.LINK
 
#>
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
# Creazione gruppi LocalAdmins_$HostName
#$Exclusion1 = "*OU=MAC,OU=.NoWindows,OU=Workstations,OU=FlliCarli,DC=FlliCarli,DC=im"
#$Exclusion2 = "*OU=Linux,OU=.NoWindows,OU=Workstations,OU=FlliCarli,DC=FlliCarli,DC=im"
 
 
Get-ADComputer -Filter {(Enabled -eq $true)} -SearchBase "OU=T2Script,OU=workstation,OU=machines,DC=FlliCarli,DC=im" | Where-Object {($_.DistinguishedName -notlike $Exclusion1) -and ($_.DistinguishedName -notlike $Exclusion2)} |
ForEach-Object { $HostName = $_.Name
 
                try { Get-ADGroup -Identity "LocalAdmins_$HostName" -InformationAction Ignore }
    
                    catch
    
                    { New-ADGroup -Name "LocalAdmins_$HostName" -samAccountName "LocalAdmins_$HostName" -Description "Local Administrators Access for $HostName" -Path "OU=Groups,OU=Tier 2,OU=Admin,DC=FlliCarli,DC=im" -GroupCategory Security -GroupScope Global }
                    }
 
# Creazione gruppi RemoteDesktopUsers_$HostName
Get-ADComputer -Filter {(Enabled -eq $true)} -SearchBase "OU=T2Script,OU=workstation,OU=machines,DC=FlliCarli,DC=im" | Where-Object {($_.DistinguishedName -notlike $Exclusion1) -and ($_.DistinguishedName -notlike $Exclusion2)} |
ForEach-Object { $HostName = $_.Name
 
                try { Get-ADGroup -Identity "RemoteDesktopUsers_$HostName" -InformationAction Ignore }
    
                    catch
    
                    { New-ADGroup -Name "RemoteDesktopUsers_$HostName" -samAccountName "RemoteDesktopUsers_$HostName" -Description "Remote Desktop Users Access for $HostName" -Path "OU=Groups,OU=Tier 2,OU=Admin,DC=FlliCarli,DC=im" -GroupCategory Security -GroupScope Global }
                    }