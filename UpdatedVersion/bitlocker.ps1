##################################
#                                #
#    Name : BitlockerDecryptor   #
#       Author: Circlol          #
#         Version:  1.0          #
#                                #
################################## 

# Checks to make sure our shell is running as admin otherwise it'll display a message and restart this script.
If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
    Write-Host $Variables.errorMessage2 -ForegroundColor Yellow
    do { $SelfElevate = Read-Host -Prompt "To disable Bitlocker we need admin privileges. Do you want me to attempt to reopen this script as admin ? (Y/N) "
        switch ($SelfElevate.ToUpper()) {
            "Y" {
                $wtExists = Get-Command-Command wt
                If ($wtExists) {
                    Start-Process wt -verb runas -ArgumentList "new-tab powershell -c ""irm bitlocker.newloads.ca | iex"""
                }
                else {
                    Start-Process powershell -verb runas -ArgumentList "-command ""irm bitlocker.newloads.ca | iex"""
                }
                Stop-Process $pid
            }
            "N" { exit 1 }
            default { Write-Host "Invalid input. Please enter Y or N." }
        }
    } while ($true)
}

# Checks encryption status
do { $Question = Read-Host -Prompt "Do you want to scan for Bitlocker on C:\ ? (Y/N) "
switch ($Question.ToUpper()) {
    "Y" {
        If ($bitlockerStatus -eq 'FullyEncrypted' -or 'EncryptionInProgress') {
                # Gets encryption status
                Write-Output "Gathering Bitlocker volume information"
                $bitlockerStatus = (Get-BitlockerVolume -MountPoint C:\).VolumeStatus

                # Disables bitlocker on C:\
                Write-Output "Disabling Bitlocker on C:\"
                Disable-Bitlocker -MountPoint "C:\" -Verbose


                # loops until percentage equals 0 
                do { 
                    $percentage = (Get-BitLockerVolume -MountPoint "C:\").EncryptionPercentage
                    If ($percentage -ne 0) {
                        Write-Output "Encryption Percentage: $percentage %"
                        Start-Sleep -Seconds 5
                    }
                } while ( (Get-BitLockerVolume -MountPoint "C:\").EncryptionPercentage -ne 0 )

                If ((Get-BitLockerVolume -MountPoint "C:\").EncryptionPercentage -eq 0 ) {
                    Write-Output "C:\ is at 0% encryption."
                    exit 0
                }
            } else {
                Write-Output "Bitlocker is not enabled on C:\"
            }
            }
        "N" { exit 1 }
        default { Write-Host "Invalid input. Please enter Y or N." }
        }
    } until ( (Get-BitlockerVolume -MountPoint C:\).VolumeStatus -eq 'FullyDecrypted')
