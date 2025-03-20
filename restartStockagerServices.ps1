$theDate = "$(Get-Date -Format "yyyyMMdd_hh:mm:ss").log"
$Logfile = "C:\PS\Logs\$theDate"

# function WriteLog
# {
#     Param ([string]$LogString)
#     $Stamp = (Get-Date).toString("yyyy/MM/dd_HH:mm:ss")
#     $LogMessage = "$Stamp $LogString"
#     Add-content $LogFile -value $LogMessage
# }

# WriteLog "Start"
# WriteLog "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
Stop-Service -Name "Beta80RunnerConveiorManager" -Force -Verbose | Out-File -Append $Logfile
Stop-Service -Name "Beta80RunnerCommunicator" -Force -Verbose | Out-File -Append $Logfile
# WriteLog "---------------------------------------------------------------"
shutdown.exe /m \\stocklin /r /t 0
Start-Sleep -s 10
Do {Start-Sleep -s 15}
Until ((Test-NetConnection -ComputerName stocklin -Port 445).TcpTestSucceeded -eq $true)
# Do {Start-Sleep -s 5
# Until ((Get-Service -ComputerName stocklin -Name 'spooler').Status -eq 'Running')
# sc \\stocklin start wms_mf >> $Logfile
Start-Sleep -s 30
"sc \\stocklin start wms_mf" | cmd.exe /K | Out-File -Append $Logfile
"sc \\stocklin start wms_services" | cmd.exe /K | Out-File -Append $Logfile
# WriteLog "---------------------------------------------------------------"
Start-Service -Name "Beta80RunnerCommunicator" -Force -Verbose | Out-File -Append $Logfile
Start-Service -Name "Beta80RunnerConveiorManager" -Force -Verbose | Out-File -Append $Logfile
# WriteLog "---------------------------------------------------------------"
Restart-Service -Name "Stockager_ConfezionamentoPallettizzatori_CARLI" -Force -Verbose | Out-File -Append $Logfile
Restart-Service -Name "Stockager_ComunicazioniMagazzinoVasi_CARLI" -Force -Verbose | Out-File -Append $Logfile
# WriteLog "---------------------------------------------------------------"
Stop-Service -Name "Stockager_MagEstero_GestorePTL" -Force -Verbose | Out-File -Append $Logfile
Stop-Service -Name "Stockager_MagEstero_AgentePTL" -Force -Verbose | Out-File -Append $Logfile
Stop-Service -Name "Stockager_MagEstero_FineLinea1" -Force -Verbose | Out-File -Append $Logfile
Stop-Service -Name "Stockager_MagEstero_FineLinea2" -Force -Verbose | Out-File -Append $Logfile
# WriteLog "---------------------------------------------------------------"
Start-Service -Name "Stockager_MagEstero_GestorePTL" -Force -Verbose | Out-File -Append $Logfile
Start-Service -Name "Stockager_MagEstero_AgentePTL" -Force -Verbose | Out-File -Append $Logfile
Start-Service -Name "Stockager_MagEstero_FineLinea1" -Force -Verbose | Out-File -Append $Logfile
Start-Service -Name "Stockager_MagEstero_FineLinea2" -Force -Verbose | Out-File -Append $Logfile
# WriteLog "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
# WriteLog "End"
