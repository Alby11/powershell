#$machineName = Read-Host "Nome Computer "
# Get-WmiObject -ComputerName $machineName -Class Win32_BIOS | Select -ExpandProperty SerialNumber
$newName = Get-WmiObject -ComputerName $env:computername -Class Win32_BIOS | Select -ExpandProperty SerialNumber
$newName = $("W" + $newName)
Rename-Computer -ComputerName $env:computername -NewName $newName
pause