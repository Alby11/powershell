#flag check RDP Users
$checkRdp = 1

Clear-Host

$tiers = @("2", "1", "0")
foreach ($tier in $tiers)
{
    # imposta stirnga per amministratori del tier
    $tierAccountsAll = "tier" + $tier + "admins"
    # imposta stirnga ou di ricerca
    $searchBase = "OU=Groups,OU=Tier " + $tier + ",OU=user,DC=domain,DC=com"

    $localAdmins = Get-ADGroup -Filter "name -like 'LocalAdmins*'" -SearchBase $searchBase | Sort-Object "name"

    Write-Host "`r`n**************************" -ForegroundColor Magenta
    Write-Host "`r--------- TIER $tier ---------" -ForegroundColor Magenta

    Write-Host "`r`nAmministratori Tier T$tier" -ForegroundColor red
    $t2Admins = Get-ADGroupMember -Identity $tierAccountsAll | Sort-Object "name"
    foreach ($t2Admin in $t2Admins)
    {
        Write-Host "$($t2Admin.name)"
    }

    Write-Host "`r`nLocal Admins Macchine T$tier" -ForegroundColor Yellow
    foreach ($group in $localAdmins)
    {
        $members = Get-ADGroupMember -Identity $group | Sort-Object "name"
        if ($null -ne $members)
        {
            $machineName = $group.name.Substring(12)
            Write-Host "$machineName : " -ForegroundColor cyan -NoNewline
            Write-Host "$($members.Name -join ",")"
        }
    }

    if ($checkRdp -ne 0)
    {
        $rdpUsers = Get-ADGroup -Filter "name -like 'group*'" -SearchBase $searchBase | Sort-Object "name"

        Write-Host "`r`nRDP Users Macchine T$tier" -ForegroundColor Green
        foreach ($group in $rdpUsers)
        {
            $members = Get-ADGroupMember -Identity $group | Sort-Object "name"
            if ($null -ne $members)
            {
                $machineName = $group.name.Substring(19)
                Write-Host "$machineName : " -ForegroundColor cyan -NoNewline
                Write-Host "$($members.Name -join ",")"
            }
        }
    }
}
