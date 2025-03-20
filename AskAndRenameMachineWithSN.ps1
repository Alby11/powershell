$machineName = Read-Host "Nome Computer "
$newName = Get-WmiObject -ComputerName $machineName -Class Win32_BIOS | Select -ExpandProperty SerialNumber
$newName = $("W" + $newName)
Rename-Computer -ComputerName $machineName -NewName $newName
restart-computer -f $machineName
pause