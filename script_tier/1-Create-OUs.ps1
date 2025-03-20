# Create-OUs.ps1

#Get current working directory
$sLocation = Get-Location

$DomainName = (Get-ADDomain).Name
$sDSE = (Get-ADRootDSE).defaultNamingContext

#$sPath = ("OU="+ $DomainName + " Objects," + $($sDSE))

#Creating Top Level OUs

New-ADOrganizationalUnit -Name "Admin" -Path "$sDSE"
#New-ADOrganizationalUnit -Name "Workstations" -Path "$sDSE"
#New-ADOrganizationalUnit -Name "User Accounts" -Path "$sDSE"



#Creating Sub OUs for Top Level Admin OU

    New-ADOrganizationalUnit -Name "Tier 0" -Path ("OU=Admin,$sDSE")
    New-ADOrganizationalUnit -Name "Tier 1" -Path ("OU=Admin,$sDSE")
    New-ADOrganizationalUnit -Name "Tier 2" -Path ("OU=Admin,$sDSE")
    New-ADOrganizationalUnit -Name "Groups" -Path ("OU=Admin,$sDSE")

#Creating Sub OUs for Admin\Tier 0 OU

        New-ADOrganizationalUnit -Name "Accounts" -Path ("OU=Tier 0,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Groups" -Path ("OU=Tier 0,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Service Accounts" -Path ("OU=Tier 0,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Devices" -Path ("OU=Tier 0,OU=Admin,$sDSE")

#Creating Sub OUs for Admin\Tier 1 OU

        New-ADOrganizationalUnit -Name "Accounts" -Path ("OU=Tier 1,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Groups" -Path ("OU=Tier 1,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Service Accounts" -Path ("OU=Tier 1,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Devices" -Path ("OU=Tier 1,OU=Admin,$sDSE")

#Creating Sub OUs for Admin\Tier 2 OU

        New-ADOrganizationalUnit -Name "Accounts" -Path ("OU=Tier 2,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Groups" -Path ("OU=Tier 2,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Service Accounts" -Path ("OU=Tier 2,OU=Admin,$sDSE")
        New-ADOrganizationalUnit -Name "Devices" -Path ("OU=Tier 2,OU=Admin,$sDSE")

#Creating Sub OUs for Admin\Groups OU

    New-ADOrganizationalUnit -Name "Security Groups" -Path ("OU=Groups,OU=Admin,$sDSE")


#Creating Sub OUs for Top Level Workstations OU

    #New-ADOrganizationalUnit -Name "Desktops" -Path ("OU=Workstations,$sDSE")
    #New-ADOrganizationalUnit -Name "Laptops" -Path ("OU=Workstations,$sDSE")
    #New-ADOrganizationalUnit -Name "Disabled Workstation" -Path ("OU=Workstations,$sDSE")

#Creating Sub OUs for Top Level User Accounts OU

    #New-ADOrganizationalUnit -Name "Enabled Users" -Path ("OU=User Accounts,$sDSE")
    #New-ADOrganizationalUnit -Name "Disabled Users" -Path ("OU=User Accounts,$sDSE")

#Block inheritance for PAW OUs

    Import-Module ServerManager
    Add-WindowsFeature Gpmc | Out-Null
    Import-Module GroupPolicy

    Set-GpInheritance -target "OU=Devices,OU=Tier 0,OU=Admin,$sDSE" -IsBlocked Yes | Out-Null
    Set-GpInheritance -target "OU=Devices,OU=Tier 1,OU=Admin,$sDSE" -IsBlocked Yes | Out-Null
    Set-GpInheritance -target "OU=Devices,OU=Tier 2,OU=Admin,$sDSE" -IsBlocked Yes | Out-Null

#Return to original working directory
Set-Location $sLocation