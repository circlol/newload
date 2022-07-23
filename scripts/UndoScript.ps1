
Function UndoOneDrive{
    Write-Host " Starting $onedrivelocation"
    Start-Process -FilePath:C:\Windows\Syswow64\OneDriveSetup.exe -ArgumentList /install -Verbose
}
Function UndoDebloat {
    Write-Host " Reinstalling this computers default apps"
    Start-Sleep -Milliseconds 1285
    Get-AppxPackage -allusers | ForEach-Object {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode -ErrorAction SilentlyContinue} | Out-Host 
}
Function UndoOEMInfo{
    Write-Host "$frmt Undoing OEM Information $frmt "

    Write-Host "$frmt Undoing OEM Information $frmt "
    $regoeminfo = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
    Set-ItemProperty -Path $regoeminfo -Name "Manufacturer" -Type String -Value ""
    Set-ItemProperty -Path $regoeminfo -Name "Model" -Type String -Value ""
    Set-ItemProperty -Path $regoeminfo -Name "SupportHours" -Type String -Value ""
    Set-ItemProperty -Path $regoeminfo -Name "SupportURL" -Type String -Value ""
    Set-ItemProperty -Path $regoeminfo -Name "SupportPhone" -Type String -Value ""
    If (Test-Path -Path "$wallpaper"){
        Remove-Item -Path "$wallpaper" -Verbose -Force
        Write-Host " Deleting wallpaper from location $wallpaper"
    }
    #$mocostore = "$env:localappdata" + "\Microsoft\Windows\Themes"
    
    $defaulttheme = "C:\Windows\Resources\Themes\aero.theme"
    Write-Host " Resetting Default Theme"
    Start-Process $defaulttheme

    Start-Sleep -s 5
    taskkill /F /IM systemsettings.exe 2>$NULL
}
