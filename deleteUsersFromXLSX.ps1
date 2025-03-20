$path = "$PSScriptRoot\deletableUsers.xlsx"

import-module psexcel #it wasn't auto loading on my machine

$people = new-object System.Collections.ArrayList

foreach ($person in (Import-XLSX -Path $path -RowStart 1)) {

    $people.add($person) | out-null #I don't want to see the output

}

$people.ActiveD | Select-Object -unique | foreach-object {
    $user = $_ | get-aduser -Properties enabled, lastlogondate |
    Select-Object samaccountname, enabled, lastlogondate
    $user.samaccountname
    write-host "enabled =" $user.enabled
    write-host "lastLogonDate = " $user.lastlogondate
    remove-aduser -Identity $user.samaccountname -confirm
    # $_ | get-aduser -Properties enabled, lastlogondate |
    # foreach-object { remove-aduser -identity $_.samaccountname -confirm }
}

Move-Item deletableUsers.xlsx deletableUsers_$(Get-Date).xlsx
