<#

    AUTHOR:         Keith Francis
    Description:    This script creates a scheduled task under the system account and runs a command to create a text file with an encrypted password.
                    Since this password is encrypted using the system account, only tasks run under the System account that use this text file for the
                    password will be able to decrypt this password. No other account can decrypt it. This way, the password is stored securely and not
                    in plain text in a powershell script. The encrypted password can be used to, for example, authenticate an email account that may be
                    used in a PS script that sends emails. I could not find another way to run a command under the system account in PowerShell so creating
                    a scheduled task and running it there under the system account will have to do

#>

#Task name. Call it whatever you want
$taskName = "Create Secure Email Password"

#This is the path and name where the encrypted password will be stored in a text file
$filePath = "C:\SecureFolder\"
$fileName = "EncryptedPass.txt"

#Create the filePath if it does not exist
New-Item -ItemType Directory -Force -Path $filePath

$fullPath = $filePath + $fileName

#This is the password you are trying to encrypt. Doing -AsSecureString so that it doesn't show the password when you type it
$password = Read-Host -Prompt "Enter password" -AsSecureString

#Convert the password back to plain text
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

#Remove task with the name "Create Secure Email Password" if it already exists
$task = Get-ScheduledTask | Where-Object {$_.TaskName -like $taskName}
if (![string]::IsNullOrWhiteSpace($task))
{
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

#oCreate the action for the scheduled task. It will run powershell and execute the command specified below
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
          -Argument "-command &{'$password' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $fullPath}"

#Register Scheduled task and then run it once to create the text file with the encrypted password
Register-ScheduledTask -Action $action -TaskName $taskName -Description "Creates a text file with the encrypted email password" -User "System" -RunLevel Highest
Start-ScheduledTask -TaskName $taskName

#Remove the task after it is run
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false

<#

To get the password and use it somewhere like emailing, for example, use the Get-Content command to get the string from the text file 
and convert it to SecureString. See the sample code below to see how to do this:

**********************************************************************************

$email = "someone@example.com"
$pass = Get-Content "C:\SecureFolder\EncryptedPass.txt" | ConvertTo-SecureString
$emailCredential = New-Object System.Net.NetworkCredential($email, $pass)

**********************************************************************************

#>
