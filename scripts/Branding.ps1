Function OEMInfo{
    $WindowTitle = "New Loads - OEM Info" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Applying OEM Information $frmt "
    $regoeminfo = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"

    $store = "Mother Computers"
    If ((Get-ItemProperty -Path $regoeminfo).Manufacturer -eq "$store"){
        Write-Host " Skipping" -ForegroundColor Red
    } else {
        Set-ItemProperty -Path $regoeminfo -Name "Manufacturer" -Type String -Value "$store" -Verbose
    }

    $phone = "(250) 479-8561"
    If ((Get-ItemProperty -Path $regoeminfo).SupportPhone -eq $phone){
        Write-Host " Skipping" -ForegroundColor Red
    } else {
    Set-ItemProperty -Path $regoeminfo -Name "SupportPhone" -Type String -Value "$phone" -Verbose
        
    }

    $hours = "Monday - Saturday 9AM-5PM | Sunday - Closed" 
    If ((Get-ItemProperty -Path $regoeminfo).SupportHours -eq "$hours"){
        Write-Host " Skipping" -ForegroundColor Red
    } else {
    Set-ItemProperty -Path $regoeminfo -Name "SupportHours" -Type String -Value "$hours" -Verbose
        
    }

}
