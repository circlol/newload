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
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU610+K4kf/+PBCP/RFgVBAp0l
# DyigggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
# AQsFADB5MScwJQYJKoZIhvcNAQkBFhhtaWtlQG1vdGhlcmNvbXB1dGVycy5jb20x
# JDAiBgNVBAsMG2h0dHBzOi8vbW90aGVyY29tcHV0ZXJzLmNvbTESMBAGA1UECgwJ
# TmV3IExvYWRzMRQwEgYDVQQDDAtNaWtlIEl2aXNvbjAeFw0yMjAyMjYwMjA4MjFa
# Fw0yMzAxMDEwODAwMDBaMHkxJzAlBgkqhkiG9w0BCQEWGG1pa2VAbW90aGVyY29t
# cHV0ZXJzLmNvbTEkMCIGA1UECwwbaHR0cHM6Ly9tb3RoZXJjb21wdXRlcnMuY29t
# MRIwEAYDVQQKDAlOZXcgTG9hZHMxFDASBgNVBAMMC01pa2UgSXZpc29uMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqfJhHWoMaoTvauUnS1yhV8oTyjqf
# fO+OQrN8ysjIv3THM74mgPFnAYSkMxl2MCSOgZXOmeyiEZJdIyZQIEZuv/JeX6ud
# 77m5HylKT7Y73Xqb6nL6Z1latXyR+Jj9ZeIo6omJWPHLqLRpBJUxniPuXVOYdiYu
# Ahp3R3vX8JPmFAgDqjuYvOhQzEJ4ZkJGb+gYoaM34AaPv51aenN3EwqVKLNfCse0
# 2qDqDHEh84I7xZU0pjFWPR2oZPodJD71wWLQ02f2sj2ggcH1kiyzt+oBCGAIf/Vg
# 3KGhpDrWCdlv5yCeIK5N4GNmKGNkV7rh75//n8ieKD7dbEradkiEqa0PNQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCBaAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFCtXFGsxQLT0r4rik3dDQ059x5dXMA0GCSqGSIb3DQEBCwUAA4IBAQAYPL43
# 0hOONDAMC3sD2H6MfSeo+5MZgt3xpeRhGm0xQ9f6KWGWsSnM+fQsmXAquKS3dCHf
# BzDgBYFuOdHJMq+lACZMUD2zPUlPwvUFY/40ScaO/3MzrPU1qd8TW8UdvTaBDywa
# KAkXx2OkEw+NvMFD5Bz8fH1up2dT0BPN+4eX5lsWJcdsD4sOTOXOnWBj3x3mu11Z
# YO25XmA9TFerTVBVszRmfchQ3T01V9/WAo0VM2inP8iBWKfMCIv3sJdtVVbInQW+
# Sybg4NaAQV9HTFeSVI4BC/F0G2zo7WysE1K35s9uEhM4giO9ZPbAcMpfWsl/nJ27
# VK1ykVYYVsfiBSiXMYICLzCCAisCAQEwgY0weTEnMCUGCSqGSIb3DQEJARYYbWlr
# ZUBtb3RoZXJjb21wdXRlcnMuY29tMSQwIgYDVQQLDBtodHRwczovL21vdGhlcmNv
# bXB1dGVycy5jb20xEjAQBgNVBAoMCU5ldyBMb2FkczEUMBIGA1UEAwwLTWlrZSBJ
# dmlzb24CEBtt3obIJSCsQ8lXhZc6ic8wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcC
# AQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYB
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFIvS70wMLVpl
# hjJRP53nLMu6QMC/MA0GCSqGSIb3DQEBAQUABIIBABBUy6OGgxJlNm0Zb8i7z8ib
# AGubvtmLuzmLES+F427//0K0knGeHN2B1JLcpfAn1XxuxuXzY9c+LBokdiijEvoU
# 6M/b/c4r36owDnr9f1Aa7drNWU50oofSu62Tj5rTLCXI0CPz8G9HxJCdIFejaX8m
# iGO+UBUvCadkBRN3g34+qF1R/esei1o4AX6gE1mibRKx5wt+aReuRpo72olBk5Zd
# kZr5ZzapYHkrfLBuKNCiSCuPnyTJ8c1o0wDiBIww9pTf7cq+owN+2H43lR8YBxl5
# HQniNkACMq0fugfd+Gut4q5Htv3KqO/c7/MnqxACjra0ZZS1Fb3wflLbcbFUwiU=
# SIG # End signature block
