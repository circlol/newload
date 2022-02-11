Function checkme {
    W32tm /resync /force | Out-Null 2>$NULL
    #net start w32time | Out-Null 2>$NULL
    #reg export "HKLM\SYSTEM\CurrentControlSet\services\w32time\Config" "$folder\exported_w32time.reg" /y | Out-Null 2>$NULL
    #reg add "HKLM\SYSTEM\CurrentControlSet\services\w32time\Config" /v MaxNegPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null 2>$NULL
    #reg add "HKLM\SYSTEM\CurrentControlSet\services\w32time\Config" /v MaxPosPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null 2>$NULL
    ## w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update
    #w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update | Out-Null 2>$NULL
    ## w32tm /config /update
    #w32tm /config /update | Out-Null 2>$NULL
    ## w32tm /resync /rediscover 
    #w32tm /resync /rediscover | Out-Null 2>$NULL
    ##Restore registry w32time\Config
    #reg import "$folder\exported_w32time.reg" | Out-Null 2>$NULL
    #Remove-Item "$folder\exported_w32time.reg" | Out-Null 2>$NULL
    $Lie = " License has Expired. Exiting.."
    $Time = (Get-Date -UFormat %Y%m%d)
    $License = 20220330
    Clear-Host
    If ($Time -gt $License) {
        Clear-Host
        Write-Host $lie
        Start-Sleep -s 2
        Exit
        } else {
            If ($Time -gt $tslrd) {
                Clear-Host
                Write-Host " `n Creating Restore Point in case something bad happens"
                Enable-ComputerRestore -Drive "C:\"
                Checkpoint-Computer -Description "OOBE Fresh Load" -RestorePointType "MODIFY_SETTINGS"
                Start-Sleep -s 2
                Clear-Host
                $blstat = "on"
                If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq $blstat){
                    Write-Host " Bitlocker seems to be enabled. Starting the decryption process."
                    manage-bde -off "C:"
                    Write-Host " Process Started in Backgroud. Continuing."
                } else {
                    Write-Host " Bitlocker is not enabled on this machine."
                }} else {
                Clear-Host
                Write-Host $lie
                Start-Sleep -s 2
                Exit
            }
        }
    }