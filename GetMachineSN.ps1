#$machineName = Read-Host "Nome Computer "
# Get-WmiObject -ComputerName $machineName -Class Win32_BIOS | Select -ExpandProperty SerialNumber
Get-WmiObject -ComputerName $env:computername -Class Win32_BIOS | Select -ExpandProperty SerialNumber
pause