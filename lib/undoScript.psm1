Function UndoOneDrive(){
    Write-Section "OneDrive"
    Write-Status -Types "+" -Status "Reinstalling OneDrive"
    If (!(Test-Path "C:\Windows\SysWOW64\OneDriveSetup.exe")){
        CheckNetworkStatus
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/bin/OneDriveSetup.exe" -Destination ".\bin\OneDriveSetup.exe" | Out-Host
        Start-Process -FilePath:".\bin\OneDriveSetup.exe" -ArgumentList /install -Verbose
    }else{
        Write-Host " Starting $onedrivelocation"
        Start-Process -FilePath:C:\Windows\Syswow64\OneDriveSetup.exe -ArgumentList /install -Verbose
    }
}
Function UndoDebloat() {
    Write-Status "+" -Status "Reinstalling Computers Default Bloatware"
    Write-Host " Reinstalling this computers default apps"
    Get-AppxPackage -allusers | ForEach-Object {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode -ErrorAction SilentlyContinue} | Out-Host 
}
Function UndoOEMInfo() {
    Write-Section -Text "OEM Info"
    Write-Status -Types "-" -Status "Removing OEM Information"
    
    Set-ItemProperty -Path $PathToOEMInfo -Name "Manufacturer" -Type String -Value ""
    Set-ItemProperty -Path $PathToOEMInfo -Name "Model" -Type String -Value ""
    Set-ItemProperty -Path $PathToOEMInfo -Name "SupportHours" -Type String -Value ""
    Set-ItemProperty -Path $PathToOEMInfo -Name "SupportURL" -Type String -Value ""
    Set-ItemProperty -Path $PathToOEMInfo -Name "SupportPhone" -Type String -Value ""
    If (Test-Path -Path "$wallpaper"){
        Write-Status -Types "-" -Status "Deleting wallpaper from location $wallpaper"
        Remove-Item -Path "$wallpaper" -Verbose -Force
    }
    $defaulttheme = "C:\Windows\Resources\Themes\aero.theme"
    Write-Status -Types "+" -Status "Setting Windows Theme to Default"
    Start-Process $defaulttheme

    Start-Sleep -s 5
    taskkill /F /IM systemsettings.exe 2>$NULL
}
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU610+K4kf/+PBCP/RFgVBAp0l
# DyigggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIyMTIwNTA1
# NTgyMFoXDTIzMTIwNTA2MTgyMFowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANLmTQ9JLXGTbz4O
# zrXJeDbJAso5/80NUs/iCJ19a79QHoi5RQZRFrZbJ2uu1+Dx3ui0LOqJeKe0/Or+
# 9L3EqEf2hAlThM3JEZCtx5KRUVqF6zk+dztJ/JqkSZQPzSyZF1KqosBCTb/tAQcH
# c4Bi1JggjX/fhMwxuGfyLBUGNp6WDRMoZby2tfUXe+5grsHFKXcgDHNPNcZo6bZY
# zKQYT3iEEATiLsyXtBt7YzcSrrP5D0l8qrRna8EKCmVCX9wgIGAXHwQKeays50sN
# LIwPIrG5GYwwQVGbjOtVeUo3aneLBArGdmcKPKyHVKZn1t49exN92/no96cPYtWn
# kq15EN0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBR9LgSDHkiaRBLzTyX1lAvCIUlW4DANBgkqhkiG9w0BAQsF
# AAOCAQEAQS8ax4uhVvT8tvhADRQX/oNxwjR7xuZTt4ABOkRMTTQRddwlEOOJiwAc
# MhJlBHtvaCrnNN/0FYtL7df3q/FQvvouIDvfnNZgAZrcrBvEWjZZAd+mXrXb4r/w
# sef73iq341OOSLeZ8sLk6digbNGS6EJjYuzsYUrlAEpG5fP9yW+gpYDmerttKtoY
# xo2V7Wtuhnbx4i5VQEK/7tXgaJKNB2Ue3RJi52g1PQ/ZNkS66tIsnF3iIR5WmxdO
# mNWoJ3ZIa1Bn98WYEiJoWT+yTH/ZfZ1k786Cz2hzSolhV3eur/HWwVZ7NmeH35zT
# X0MABZ2lKEBHit+AOYH/r3SN5aMHjzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQcugDkTMWcphI4F8edmMLrTAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUi9LvTAwtWmWGMlE/necsy7pAwL8wDQYJKoZIhvcNAQEBBQAEggEASVKs
# 2+9WuTogZ2yhXJxe5xGbxBRlNP5KldT79+meVggBrIfHdd0dCp8hFZdT+R7YDR1/
# 2MMC/BsWv6o1phwq25C3kBhoACU5p4Cv2SUYDonE+HdRQlQgJUYjV25VrLEkBnrY
# m+9kMzdD/sWR2Ge75rME7l0peiSBxn3lj6mDqbOXKTVKT2Z2RetnvFjPiPlsJYsE
# vq1GjzZPFVVZ1IApcaUBX5WoGfbRpMytry1ZfhXr+g8wYmjT6q+fhBwLQlpKcrY1
# 0stk41VA0ih4/gi0VE1EbkGN7Vne0NanbYiTOA/zLXfoO0qdWPIf7o7sfFTCiBBF
# fLj/QVlm2U36qgGXnQ==
# SIG # End signature block
