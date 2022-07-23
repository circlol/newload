Function Programs {
    If ($perform_apps.checked -eq $true){
    $WindowTitle = "New Loads - Installing Applications" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "$frmt Installing Apps.$frmt"

    #Google
    If (!(Test-Path -Path:$Location1)){
        If (Test-Path -Path:$gcoi){
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx /f | Out-Null
            Write-Host " Installing $Package1`n"
            Start-Process -FilePath:$gcoi -ArgumentList /passive -Verbose -Wait
        } else {
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx /f | Out-Null
            Write-Host "`n`n Downloading $Package1" 
            Start-BitsTransfer -Source $package1dl -Destination $package1lc | Out-Host
            Check
            Write-Host " Installing $Package1`n"
            Start-Process -FilePath:$package1lc -ArgumentList /passive -Verbose -Wait
        }
        } else {
            Write-Host "`n Verified $package1 is already Installed. Moving On. "
        }
    #VLC
    If (!(Test-Path -Path:$Location2)) {
        If (Test-Path -Path:$vlcoi){
            Write-Host " Installing $Package2`n"
            Start-Process -FilePath:$vlcoi -ArgumentList /quiet -Verbose -Wait
            $vlcyns = "$y"
            $vlcyns
        } else {
            Write-Host "`n`n Downloading $Package2" 
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc | Out-Host
            Check
            Write-Host " Installing $Package2`n"
            Start-Process -FilePath:$package2lc -ArgumentList /quiet -Verbose -Wait
        }
            } else {
                Write-Host "`n Verified $package2 is already installed. Skipping" -ForegroundColor Red
        }

    #Zoom
    If (!(Test-Path -Path:$Location3)) {
        Write-Host "`n`n Downloading $Package3" 
        Start-BitsTransfer -Source $Package3dl -Destination $package3lc | Out-Host
        Check
        Start-Sleep -Milliseconds 300
        Write-Host " Installing $Package3`n"
        Start-Process -FilePath:$package3lc -ArgumentList /quiet -Verbose -Wait
        } else {
            Write-Host "`n Verified $package3 is already installed. Skipping" -ForegroundColor Red
    }

    #Adobe
    If (!(Test-Path -Path:$Location4)) {
        If (Test-Path -Path:$aroi){
            Write-Host " Installing $package4"
            Start-Process -FilePath:$aroi -ArgumentList /sPB -Verbose
        } else {
            Write-Host "`n`n Downloading $Package4" 
            Start-BitsTransfer -Source $Package4dl -Destination $package4lc | Out-Host
                If ($?){
                    Write-Host " Successful"
                }
            Write-Host " Installing $Package4`n" 
            Start-Process -FilePath:$package4lc -ArgumentList /sPB -Verbose    
        }} else {
                Write-Host "`n Verified $package4 is already installed.`n Moving on`n`n"
        }
    } else {
    Write-Host " App installation has been disabled by technician.`n Moving on."
    }
}
