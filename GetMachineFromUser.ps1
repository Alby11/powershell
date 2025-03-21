$Computers = Get-ADComputer  -Filter { (enabled -eq "true") -and (OperatingSystem -Like "*") } | Select-Object -ExpandProperty Name
$output = @()
ForEach ($PSItem in $Computers) {
    $User = Get-CimInstance Win32_ComputerSystem -ComputerName $PSItem | Select-Object -ExpandProperty UserName
    $Obj = New-Object -TypeName PSObject -Property @{
        "Computer" = $PSItem
        "User"     = $User
    }
    $output += $Obj    
}