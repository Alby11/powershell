#!/usr/bin/env pwsh

# Verifica se la chiave del registro esiste
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin")) {
    # Crea la chiave del registro se non esiste
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Force | Out-Null
}

# Imposta il valore del registro
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Name "BlockAADWorkplaceJoin" -Value 1

