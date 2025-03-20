cscript.exe slmgr.vbs /upk
cscript.exe slmgr.vbs /cpky
cscript.exe slmgr.vbs /ipk BM3PN-68MJP-JFCCJ-MBKHK-RM49M
cscript.exe slmgr.vbs /ato
cscript.exe slmgr.vbs /dli
cscript.exe slmgr.vbs /dlv

function Get-WindowsKey {
    ## function to retrieve the Windows Product Key from any PC
    $target = $env:COMPUTERNAME
    $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $target)
    $regKey = $reg.OpenSubKey("SOFTWARE\Microsoft\Windows NT\CurrentVersion")
    $DigitalProductId = $regKey.GetValue("DigitalProductId")
    $ProductKey = [char[]] (52..66 + 52..66 + 52..66 + 52..66 + 66..67)
    $Chars = "BCDFGHJKMPQRTVWXY2346789"
    for ($i = 24; $i -ge 0; $i--) {
        $r = 0
        for ($j = 14; $j -ge 0; $j--) {
            $r = ($r * 256) -bxor $DigitalProductId[$j]
            $DigitalProductId[$j] = [math]::Floor([double]($r/24))
            $r = $r % 24
        }
        $ProductKey[$i] = $Chars[$r]
    }
    return (-join $ProductKey[0..4] + "-" + -join $ProductKey[5..9] + "-" + -join $ProductKey[10..14] + "-" + -join $ProductKey[15..19] + "-" + -join $ProductKey[20..24])
}
Get-WindowsKey
