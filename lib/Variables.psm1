Function Variables() {
    New-Variable -Name "ProgramVersion" -Value "22800" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "newloads" -Value ".\" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "Log" -Value ".\Log.txt" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "ctemp" -Value "C:\Temp" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Option ReadOnly -Scope Global -Force

    #New-Variable -Name "Win11" -Value "22000" -Option ReadOnly -Scope Global -Force
    #New-Variable -Name "22H2" -Value "22593" -Option ReadOnly -Scope Global -Force
    #New-Variable -Name "BuildNumber" -Value [System.Environment]::OSVersion.Version.Build -Option ReadOnly -Scope Global -Force

    #PathLocations
    #Package/Location1 - Google Chrome 2- VLC 3- Zoom 4- Adobe Acrobat
    New-Variable -Name "Package1" -Value "googlechromestandaloneenterprise64.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package2" -Value "vlc-3.0.17-win64.msi" -Option ReadOnly -Scope Global -Force 
    New-Variable -Name "Package3" -Value "ZoomInstallerFull.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package4" -Value "AcroRdrDCx642200120085_MUI.exe" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "oi" -Value ".\bin" -Option ReadOnly -Scope Global -Force
    
    #Offline installer locations
    New-Variable -Name "Location1" -Value "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location2" -Value "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location3" -Value "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location4" -Value "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location5" -Value "C:\Windows\SysWOW64\OneDriveSetup.exe" -Option ReadOnly -Scope Global -Force
    
    #Offline installer package location
    New-Variable -Name "Package1lc" -Value "$oi\$package1" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package2lc" -Value "$oi\$package2" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package3lc" -Value "$oi\$package3" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package4lc" -Value "$oi\$package4" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "OneDriveLocation" -Value "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe" -Option ReadOnly -Scope Global -Force
    
    #download links
    New-Variable -Name "Package1dl" -Value "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package2dl" -Value "https://get.videolan.org/vlc/3.0.17.4/win64/vlc-3.0.17.4-win64.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package3dl" -Value "https://zoom.us/client/5.11.4.7185/ZoomInstallerFull.msi?archType=x64" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package4dl" -Value "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe" -Option ReadOnly -Scope Global -Force
    
    #Offline installers
    New-Variable -Name "gcoi" -Value ".\bin\$package1" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "vlcoi" -Value ".\bin\$package2" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "zoomoi" -Value ".\bin\$package3" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "aroi" -Value ".\bin\$package4" -Option ReadOnly -Scope Global -Force
    
    #Bloat
    New-Variable -Name "livesafe" -Value "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "webadvisor" -Value "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "WildGames" -Value "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe" -Option ReadOnly -Scope Global -Force
    
    #shortcuts
    New-Variable -Name "EdgeShortcut" -Value "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "acrosc" -Value "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "edgescpub" -Value "$Env:PUBLIC\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "vlcsc" -Value "$Env:PUBLIC\Desktop\VLC Media Player.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "zoomsc" -Value "$Env:PUBLIC\Desktop\Zoom.lnk" -Option ReadOnly -Scope Global -Force
    
    #Reg
    New-Variable -Name "PathToChromeExtensions" -Value "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToChromeLink" -Value "https://clients2.google.com/service/update2/crx" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "siufrules" -Value "HKCU:\Software\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "lfsvc" -Value "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "wifisense" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regcam" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorerLocalMachine" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegSystem" -Value "HKLM:\Software\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegInputPersonalization" -Value "HKCU:\Software\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegCurrentVersion" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegContentDelivery" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorer" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorerAdv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegAdvertising" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegPersonalize" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegSearch" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force

    # Initialize all Path variables used to Registry Tweaks
    New-Variable -Name "PathToLMActivityHistory" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMAutoLogger" -Value "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" -Option ReadOnly -Scope Global -Force

    #$PathToLMDeliveryOptimizationCfg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
    New-Variable -Name "PathToLMPoliciesAdvertisingInfo" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesCloudContent" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesSQMClient" -Value "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesTelemetry" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesTelemetry2" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesToWifi" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force

    #$PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    New-Variable -Name "PathToLMWindowsTroubleshoot" -Value "HKLM:\SOFTWARE\Microsoft\WindowsMitigation" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUContentDeliveryManager" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUDeviceAccessGlobal" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUInputPersonalization" -Value "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUInputTIPC" -Value "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUOnlineSpeech" -Value "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUPoliciesCloudContent" -Value "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUSearch" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUSiufRules" -Value "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToVoiceActivation" -Value "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToBackgroundAppAccess" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Option ReadOnly -Scope Global -Force

    #Branding" -Option ReadOnly -Scope Global -Force
    #Branding
    New-Variable -Name "PathToOEMInfo" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "website" -Value "https://www.mothercomputers.com" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "hours" -Value "Monday - Saturday 9AM-5PM | Sunday - Closed"  -Option ReadOnly -Scope Global -Force
    New-Variable -Name "phone" -Value "(250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "store" -Value "Mother Computers" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "model" -Value "Mother Computers - (250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "page" -Value "Model" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "commonapps" -Value "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Option ReadOnly -Scope Global -Force
    
    
    #Wallpaper
    New-Variable -Name "wallpaper" -Value "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "currentwallpaper" -Value (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper -Option ReadOnly -Scope Global -Force
    New-Variable -Name "sysmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme -Option ReadOnly -Scope Global -Force
    New-Variable -Name "appmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme -Option ReadOnly -Scope Global -Force
    
    #Office Removal
    New-Variable -Name "PathToOffice86" -Value "C:\Program Files (x86)\Microsoft Office" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToOffice64" -Value "C:\Program Files\Microsoft Office 15" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "officecheck" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "office32" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "office64" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "SaRA" -Value "$newloads\SaRA.zip" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Sexp" -Value "$newloads\SaRA" -Option ReadOnly -Scope Global -Force
    
    # ProgList
    New-Variable -Name "unviewdest" -Value "$newloads\" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "html" -Value "$newloads\unview.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "list" -Value "$newloads\ProgList.html", "$newloads\ProgList.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "link" -Value "https://github.com/circlol/newload/raw/main/Assets/unview.exe" -Option ReadOnly -Scope Global -Force
    



    New-Variable -Name "WantedID" -Value "Pacific Standard Time" -Scope Global -Force
    New-Variable -Name "CheckDisplayName" -Value (Get-TimeZone).DisplayName -Scope Global -Force
    New-Variable -Name "WantedDisplayName" -Value '(UTC-08:00) Pacific Time (US & Canada)' -Scope Global -Force
    New-Variable -Name "Time" -Value (Get-Date -UFormat %Y%m%d) -Scope Global -Force
    New-Variable -Name "TSLRD" -Value 20220801 -Option ReadOnly -Scope Global -Force

    New-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    New-Variable -Name "Connected" -Value "Internet" -Scope Global -Force
}
Variables
# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUQSlOaUqIN89UZw4Maq8qwggs
# MLKgggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFCz2W484MsMt
# dsS3sB1MYEEZ7eXxMA0GCSqGSIb3DQEBAQUABIIBAHVO7z7ITzdhH445Bg0J7VWN
# cYgExIhkVAekFAXj2puy9faKPGSp3ujmhEsODP4xXj5Z6sEWpk2lkPjJqMw5AozM
# vTAU+fRMve/FwbQl771yJKaBuZZF6WeytyD8mCNrLGokQ10zfBT4+NdkPpRDYxem
# AfCRYviHnlg/6aCRLAXJwn8BJje7T1BPODlIBmPyOQoEQJUYWuNQWgyU/DLu+mnX
# +bj2aexLVqbXE/4zSCOgR2EZGMbnJKubjpzVnqEmuWdFrdNy/0qfeYlQNFmibJZ4
# Qy73uEoFZ/xnxvTYIKSdBxVllB3reiaoEvc5XS7mW5UYeZ9x2vnsugkHqulKIUA=
# SIG # End signature block
