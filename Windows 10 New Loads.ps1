#Requires -RunAsAdministrator
Set-ExecutionPolicy RemoteSigned -Scope Process -Force

$WindowTitle = "New Loads - Initializing" ; $host.UI.RawUI.WindowTitle = $WindowTitle
                                            $host.UI.RawUI.BackgroundColor = 'Black'
                                            $host.UI.RawUI.ForegroundColor = 'White'
try {
    stop-transcript | out-null
    While (Test-Path .\Log.txt) { Remove-Item .\log.txt }
    While (Test-Path .\tmp.txt) { Remove-Item .\tmp.txt }
}
catch [System.InvalidOperationException] {}

Function Check() {
    If ($?) {
        Write-CaptionSucceed -Text "Succcessful"
    }else{
        Write-CaptionFailed -Text "Unsuccessful"
    }
}
Function BootCheck() {

    If ($NetStatus -eq $Connected) {
        Write-Status -Types "+" -Status "Detected an Active Internet Connection."
        #Grabs License
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/circlol/newload/main/Assets/Individual%20Functions/ls/newlicense.ps1')) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        #Detects Time-Zone and Changes to UTC -8
        If (!($checkdisplayname -eq $wanteddisplayname)) {
            Write-Status -Types "+" -Status "Setting Time-Zone to $wanteddisplayname"
            Set-TimeZone -Id $wantedid -Verbose
        }
        #Checks License against This PC        
        If ($Time -gt $License) {
            Write-Status -Types "-", "ERROR" -Status "License failed to validate. Closing Application" -Warning
            Exit
        }
        elseIf ($Time -gt $tslrd) {
            Write-Status -Types "+", "ACTIVATED" "License is valid."
        }
        else { Write-Status -Types "?", "ERROR" -Status "Program Error. Please Restart Application" ; exit }

    }elseif ($NetStatus -ne $Connected) {
        Write-Status -Types "WAITING" -Status "This PC Does Not Seem to have and Active Internet Connection. Please reconnect..." -Warning 
        do {
                Start-Sleep -Seconds 5
                Write-Status -Types ":(" -Status "Waiting for internet..."
            } until ((Get-NetConnectionProfile).IPv4Connectivity -Or (Get-NetConnectionProfile).IPv6Connectivity -eq 'Internet')
            Start-Sleep -Seconds 3
            Write-Status -Types ":)" -Status "Connected... Moving on"
    }
        #Start-Sleep -s 5
        #exit
}
Function CheckFiles() {
    Write-Host "`n" ; Write-TitleCounter -Counter '1' -MaxLength $MaxLength -Text "Integrity Check"
    Write-Title -Text "New Loads Integrity Check"
    
    If (Test-Path .\tmp.txt) { Remove-Item .\tmp.txt }
    If (!(Test-Path ".\bin")) { mkdir ".\bin" }
    If (!(Test-Path ".\assets")) { mkdir ".\assets" }
    If (!(Test-Path ".\lib")) { mkdir ".\lib" }
    #If (!(Test-Path ".\scripts")) { mkdir ".\scripts" }
    #If (!(Test-Path "C:\Windows\Setup\Scripts")) { mkdir "C:\Windows\Setup\Scripts" }

    Write-Section -Text "Scanning Exisitng Files"
    
    $Files = @(
        #"Assets\Branding.png"
        #"Assets\diskette.png"
        #"Assets\Floppy.png"
        #"Assets\logo.png"
        #"Assets\microsoft.png"
        #"Assets\NoBranding.png"
        #"Assets\toolbox.png"
        "Assets\settings.cfg"
        "Assets\start.bin"
        "Assets\10.jpg"
        "Assets\10_mGaming.png"
        "Assets\11.jpg"
        "Assets\11_mGaming.png"
        "Assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx"

        #"bin\googlechromestandaloneenterprise64.msi"
        #"bin\vlc-3.0.17-win64.msi"
        #"bin\ZoomInstallerFull.msi"

        "lib\advregistry.psm1"
        #"lib\download-web-file.psm1"
        "lib\get-hardware-info.psm1"
        #"lib\manage-software.psm1"
        "lib\new-shortcut.psm1"
        "lib\office.psm1"
        "lib\open-file.psm1"
        "lib\remove-uwp-appx.psm1"
        "lib\optimization.psm1"
        "lib\restart-explorer.psm1"
        "lib\set-scheduled-task-state.psm1"
        "lib\set-service-startup.psm1"
        "lib\set-wallpaper.psm1"
        "lib\set-windows-feature-state.psm1"
        "lib\show-dialog-window.psm1"
        "lib\start-logging.psm1"
        "lib\Templates.psm1"
        "lib\Variables.psm1"
        )
    #  Generates an Empty Array  #
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) {
        If (Test-Path ".\$File") {
            Write-CaptionSucceed -Text "$File Validated"
        }
        else {
            Write-CaptionFailed -Text "$file Failed to validate."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }
    else {

        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        CheckNetworkStatus
        Write-Section -Text "Downloading Missing Files"
        ForEach ($url in $urls) {
            Write-Caption "Attempting to Download $url"
            $link = "https://raw.githubusercontent.com/circlol/newload/main/" + $url.replace('\', '/')
            Start-BitsTransfer -Source "$link" -Destination ".\$url" -Verbose -TransferType Download -RetryTimeout 60 -RetryInterval 60 -Confirm:$False
            Check
        }

        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile
    }
    #Write-Status -Types "?" -Status "Heads up - Type 'Y' and press 'ENTER' to continue!" -Warning
    #Import-Module -DisableNameChecking .\lib\"download-web-file.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"advregistry.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"get-hardware-info.psm1"  -Force | Unblock-File
    #Import-Module -DisableNameChecking .\lib\"manage-software.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"new-shortcut.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"office.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"open-file.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"optimization.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"remove-uwp-appx.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"restart-explorer.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"set-scheduled-task-state.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"set-service-startup.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"Set-Wallpaper.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"set-windows-feature-state.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"show-dialog-window.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"start-logging.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"Templates.psm1" -Force | Unblock-File
    #Import-Module -DisableNameChecking .\lib\"download-web-file.psm1" -Force | Unblock-File
    Import-Module -DisableNameChecking .\lib\"Variables.psm1" -Force | Unblock-File
    
    <#
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/circlol/newload/main/Assets/Individual%20Functions/ls/comparisons.ps1'))
    Write-Section -Text "Checking for Updated Script Files"
    If ( $AdvRegistryLastUpdated -lt $AdvRegistryComparison ) { Write-Status -Types "+" -Status "Downloading Update for AdvRegistry.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/advregistry.psm1' -Destination ".\lib\advregistry.psm1" ; Check }
    #    If ( $DownloadWebFileLastUpdated -lt $DownloadWebFileComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Download-Web-File.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/download-web-file.psm1' -Destination ".\lib\download-web-file.psm1"  ; Check }
    If ( $GetHardwareInfoLastUpdated -lt $GetHardwareInfoComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Get-Hardware-Info.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/get-hardware-info.psm1' -Destination ".\lib\get-hardware-info.psm1"  ; Check }
    #    If ( $ManageSoftwareLastUpdated -lt $ManageSoftwareComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Manage-Software.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/manage-software.psm1' -Destination ".\lib\manage-software.psm1" ; Check  }
    If ( $NewShortcutLastUpdated -lt $NewShortcutComparison ) { Write-Status -Types "+" -Status "Downloading Update for  New-Shortcut.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/new-shortcut.psm1' -Destination ".\lib\new-shortcut.psm1" ; Check  }
    If ( $OfficeLastUpdated -lt $OfficeComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Office.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/office.psm1' -Destination ".\lib\office.psm1" ; Check  }
    If ( $OpenFileLastUpdated -lt $OpenFileComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Open-File.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/open-file.psm1' -Destination ".\lib\open-file.psm1"  ; Check }
    If ( $OptimiziationLastUpdated -lt $OptimiziationComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Optimization.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/optimization.psm1' -Destination ".\lib\optimization.psm1"  ; Check }
    If ( $RemoveUWPLastUpdated -lt $RemoveUWPComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Remove-UWP-Appx.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/remove-uwp-appx.psm1' -Destination ".\lib\remove-uwp-appx.psm1"  ; Check }
    If ( $RestartExplorerLastUpdated -lt $RestartExplorerComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Restart-Explorer.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/restart-explorer.psm1' -Destination ".\lib\restart-explorer.psm1"  ; Check }
    If ( $ScheduledTaskLastUpdated -lt $ScheduledTaskComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Set-Scheduled-Task-State.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/set-scheduled-task-state.psm1' -Destination ".\lib\set-scheduled-task-state.psm1"  ; Check }
    If ( $SetWallpaperLastUpdated -lt $SetWallpaperComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Set-Wallpaper.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/Set-Wallpaper.psm1' -Destination ".\lib\Set-Wallpaper.psm1"  ; Check }
    If ( $SetServiceLastUpdated -lt $SetServiceComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Set-Service-Startup.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/set-service-startup.psm1' -Destination ".\lib\set-service-startup.psm1"  ; Check }
    If ( $SetWindowFeatureLastUpdated -lt $SetWindowFeatureComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Set-Windows-Feature-State.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/set-windows-feature-state.psm1' -Destination ".\lib\set-windows-feature-state.psm1"  ; Check }
    If ( $ShowDialogLastUpdated -lt $ShowDialogComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Show-Dialog-Window.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/show-dialog-window.psm1' -Destination ".\lib\show-dialog-window.psm1"  ; Check }
    If ( $StartLoggingLastUpdated -lt $StartLoggingComparison ) { Write-Status -Types "+" -Status "Downloading Update for  Start-Logging.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/start-logging.psm1' -Destination ".\lib\start-logging.psm1"  ; Check }
    If ( $TemplatesLastUpdated -lt $TemplatesComparison ) { Write-Status -Types "+" -Status "Downloading Update for Templates.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/Templates.psm1' -Destination ".\lib\Templates.psm1"  ; Check }
    If ( $VariablesLastUpdated -lt $VariablesComparison ) { Write-Status -Types "+" -Status "Downloading Update for Variables.psm1" ; Start-BitsTransfer -Source 'https://raw.githubusercontent.com/circlol/newload/main/lib/Variables.psm1' -Destination ".\lib\Variables.psm1"  ; Check }
    #>
    
}
Function Variables() {
    New-Variable -Name "ProgramVersion" -Value "22830.223" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "newloads" -Value ".\" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "Log" -Value ".\Log.txt" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "ctemp" -Value "C:\Temp" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Option ReadOnly -Scope Global -Force

    New-Variable -Name "Win11" -Value "22000" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "22H2" -Value "22593" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value (Get-CimInstance -class Win32_OperatingSystem).BuildNumber -Option ReadOnly -Scope Global -Force
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
    #$wantedid = "Pacific Standard Time"
    #$checkdisplayname = (Get-TimeZone).DisplayName
    #$wanteddisplayname = '(UTC-08:00) Pacific Time (US & Canada)'
    #$Time = (Get-Date -UFormat %Y%m%d)
    #$tslrd = 20220201
#    
    ### Checks for a network connection ###
    #$NetStatus = (Get-NetConnectionProfile).IPv4Connectivity
    #$Connected = "Internet"
}
Function Programs() {
    $TweakType = "Apps"
    Write-Host "`n" ; Write-TitleCounter -Counter '2' -MaxLength $MaxLength -Text "Program Installation"
    Write-Title -Text "Downloading Applications"
    Write-Section -Text "Google Chrome"
    #Google
    If (!(Test-Path -Path:$Location1)) {
        If (Test-Path -Path:$gcoi) {
            Write-Status -Types "+", $TweakType -Status "Google Chrome"
            Start-Process -FilePath:$gcoi -ArgumentList /passive -Verbose -Wait
            Write-Status -Types "+", "Registry" -Status "Flagging Google Chrome to Install UBlock Origin"
            REG ADD $PathToChromeExtensions /v update_url /t REG_SZ /d $PathToChromeLink /f | Out-Null
            Check
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading Google Chrome"
            Start-BitsTransfer -Source $package1dl -Destination $package1lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 -Verbose | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Google Chrome"
            Start-Process -FilePath:$package1lc -ArgumentList /passive -Verbose -Wait
            Write-Status -Types "+", "Registry" -Status "Flagging Google Chrome to Install UBlock Origin"
            REG ADD $PathToChromeExtensions /v update_url /t REG_SZ /d $PathToChromeLink /f | Out-Null
            Check
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Google Chrome is already Installed on this PC." -warning
    }

    Write-Section -Text "VLC Media Player"
    #VLC
    If (!(Test-Path -Path:$Location2)) {
        If (Test-Path -Path:$vlcoi) {
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$vlcoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading VLC Media Player"
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 -Verbose | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$package2lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "VLC Media Player is already Installed on this PC." -Warning
    }
        
    Write-Section -Text "Zoom"
    #Zoom
    If (!(Test-Path -Path:$Location3)) {
        If (Test-Path -Path:$zoomoi) {
            Write-Status -Types "+", $tweaktype -Status "Installing Zoom"
            Start-Process -FilePath:$zoomoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading Zoom"
            Start-BitsTransfer -Source $Package3dl -Destination $package3lc -TransferType Download -RetryInterval 60 -RetryTimeout 60  -Verbose | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Zoom"
            Start-Process -FilePath:$package3lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Zoom is already Installed on this PC." -Warning
    }
        
    Write-Section -Text "Adobe Acrobat"
    #Adobe
    If (!(Test-Path -Path:$Location4)) {
        If (Test-Path -Path:$aroi) {
            Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64" 
            Start-Process -FilePath:$aroi -ArgumentList /sPB -Verbose
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading Adobe Acrobat Reader x64"
            Start-BitsTransfer -Source $Package4dl -Destination $package4lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 -Verbose | Out-Host
            Check
            If ($? -eq $true){
                Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64"
                Start-Process -FilePath:$package4lc -ArgumentList /sPB -Verbose    
            }
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Adobe Acrobat is already Installed on this PC." -warning
    }

    Write-Status -Types "+" -Status "Adding support to HEVC/H.265 video codec (MUST HAVE)..."
    Add-AppPackage -Path ".\assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx" -ErrorAction SilentlyContinue
    Check
    #Install-Software -Name "HEVC Video Extensions from Device Manufacturer" -Packages "9N4WGH0Z6VHQ" -ViaMSStore -NoDialog # Gives error
    #rite-Status -Types "+" -Status "Opening store to get support to HEVC/H.265 video codec (MUST HAVE)..."
    #Start-Process ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq
}
Function Visuals() {
    $TweakType = "Visual"
    Write-Host "`n" ; Write-TitleCounter -Counter '3' -MaxLength $MaxLength -Text "Visuals"
    If ($BuildNumber -Ge '22000') {
        Write-Title -Text "Detected Windows 11"
        Write-Status -Types "+", "$TweakType" -Status "Applying Wallpaper for Windows 11"
        $PathToFile = Get-ChildItem -Path ".\Assets" -Recurse -Filter "11.jpg" | ForEach-Object { $_.FullName }
        $WallpaperDestination = "$env:appdata\Microsoft\Windows\Themes\11.jpg"
        If (!(Test-Path $WallpaperDestination)){
            Copy-Item -Path $PathToFile -Destination $WallpaperDestination -Force -Confirm:$False
        }
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $WallpaperDestination
        Set-ItemProperty -Path $PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1
        RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine ; Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted"
        $Status = ($?) ; If ($Status) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set" } elseif (!$Status) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper" -Warning } else { Write-Host " idk wtf happened" }
        
    }
    elseif ($BuildNumber -Lt '22000') {
        Write-Title -Text "Detected Windows 10"
        Write-Status -Types "+", "$TweakType" -Status "Applying Wallpaper for Windows 10"
        $PathToFile = Get-ChildItem -Path ".\Assets" -Recurse -Filter "10.jpg" | ForEach-Object { $_.FullName }
        $WallpaperDestination = "$env:appdata\Microsoft\Windows\Themes\11.jpg"
        If (!(Test-Path $WallpaperDestination)){
        Copy-Item -Path $PathToFile -Destination $WallpaperDestination -Force -Confirm:$False
        }
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $WallpaperDestination
        Set-ItemProperty -Path $PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1
        RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine ; Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted"
        $Status = ($?) ; If ($Status) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set" } elseif (!$Status) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper" -Warning } else { Write-Host " idk wtf happened" }
    }
}
Function Branding() {
    Write-Host "`n" ; Write-TitleCounter -Counter '4' -MaxLength $MaxLength -Text "Mothers Branding"
    $TweakType = "Branding"
    If ((Get-ItemProperty -Path $PathToOEMInfo).Manufacturer -eq "$store") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "Manufacturer" -Type String -Value "$store"
        Check
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportPhone -eq $phone) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportPhone" -Type String -Value "$phone"
        Check
        
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportHours -eq "$hours") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportHours" -Type String -Value "$hours"
        Check
    }
    
    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportURL -eq $website) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportURL" -Type String -Value $website
        Check
    }
    If ((Get-ItemProperty -Path $PathToOEMInfo).Model -eq "$model") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name $page -Type String -Value "$Model"
        Check
    }
}
Function StartMenu() {
    Write-Host "`n" ; Write-TitleCounter -Counter '5' -MaxLength $MaxLength -Text "StartMenuLayout.xml Modification"
    Write-Title -Text "Applying Taskbar Layout"
    $StartLayout = @"
    <LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
        <LayoutOptions StartTileGroupCellWidth="6" />
        <DefaultLayoutOverride>
            <StartLayoutCollection>
                <defaultlayout:StartLayout GroupCellWidth="6" />
            </StartLayoutCollection>
        </DefaultLayoutOverride>
        <CustomTaskbarLayoutCollection PinListPlacement="Replace">
            <defaultlayout:TaskbarLayout>
            <taskbar:TaskbarPinList>
                <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
                <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
                <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
                <taskbar:DesktopApp DesktopApplicationID="Chrome" />
                <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer"/>
                </taskbar:TaskbarPinList>
            </defaultlayout:TaskbarLayout>
        </CustomTaskbarLayoutCollection>
    </LayoutModificationTemplate>
"@

    $layoutFile = "C:\Windows\StartMenuLayout.xml"
    #Deletes the Layout file if one exists already.
    If (Test-Path $layoutFile) { Remove-Item $layoutFile -Verbose | Out-Null }

    #Creates a new layout file
    $StartLayout | Out-File $layoutFile -Encoding ASCII

    $regAliases = @("HKLM", "HKCU")

    #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
    foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        If (!(Test-Path -Path $keyPath)) { New-Item -Path $basePath -Name "Explorer" -Verbose | Out-Null }
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
    }

    #Restart Explorer
    Restart-Explorer
    Start-Sleep -s 4
    $wshell = new-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 4
    Restart-Explorer

    #Enable the ability to pin items again by disabling "LockedStartLayout"
    Foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
    }

    If ($BuildNumber -Ge $Win11){
        xcopy ".\assets\start.bin" "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y
        xcopy ".\assets\start.bin" "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" /y
        #Copy-Item -Path .\Assets\start.bin -Destination "$env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
    }
    
    #the next line makes clean start menu default for all new users
    Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
    
    #Restarts Explorer and removes layout file
    Remove-Item $layoutFile -Verbose
}
Function Debloat() {
    $TweakType = "Debloat"
    Write-Host "`n" ; Write-TitleCounter -Counter '6' -MaxLength $MaxLength -Text "Debloat"
    
    Write-Section -Text "Checking for Win32 Pre-Installed Bloat"
    $TweakTypeLocal = "Win32"

    #McAfee Live Safe Removal
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee Live Safe..."
        Start-Process "$livesafe"
    }
    #WebAdvisor Removal
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee WebAdvisor Uninstall."
        Start-Process "$webadvisor"
    }
    #Preinsatlled on Acer machines primarily WildTangent Games
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal WildTangent Games."
        Start-Process $WildGames 
    }

    $NortonUninstallers = (Get-ChildItem "C:\Program Files (x86)\NortonInstaller\{*-*-*-*-*}" -Recurse -Include "*.exe" -ErrorAction SilentlyContinue).FullName 
    If ($NortonUninstallers){
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of Norton..."
        Start-Process "$NortonUninstallers" -ArgumentList "/x /ARP"
    }

    $apps = @(
        "Amazon"
        "Booking"
        "Booking.com"
        "Forge of Empires"
        "Planet9 Link"
        "OneDrive"
    )

    $TweakTypeLocal = "Shortcuts"

    ForEach ($app in $apps) {
        
        If (Test-Path -Path "$commonapps\$app.url") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.url"
            Remove-Item -Path "$commonapps\$app.url" -Force
        }

        If (Test-Path -Path "$commonapps\$app.lnk") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.lnk"
            Remove-Item -Path "$commonapps\$app.lnk" -Force
        }
    }
    Write-Host "" ; Write-Section -Text "Removing UWP Apps"
    $TweakTypeLocal = "UWP"
    $Programs = @(
        "Microsoft.3DBuilder"                       # 3D Builder
        "Microsoft.Appconnector"
        "Microsoft.BingFinance"                     # Finance
        "Microsoft.BingFoodAndDrink"                # Food And Drink
        "Microsoft.BingHealthAndFitness"            # Health And Fitness
        "Microsoft.BingNews"                        # News
        "Microsoft.BingSports"                      # Sports
        "Microsoft.BingTranslator"                  # Translator
        "Microsoft.BingTravel"                      # Travel
        "Microsoft.BingWeather"                     # Weather
        "Microsoft.CommsPhone"
        "Microsoft.ConnectivityStore"
        #"Microsoft.GamingServices"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftPowerBIForWindows"
        "Microsoft.MicrosoftSolitaireCollection"    # MS Solitaire
        "Microsoft.MinecraftEducationEdition"
        "Microsoft.MinecraftUWP"
        "Microsoft.MixedReality.Portal"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.Office.Hub"
        "Microsoft.Office.Lens"
        "Microsoft.Office.OneNote"                  # MS Office One Note
        "Microsoft.Office.Sway"
        "Microsoft.OneConnect"
        "Microsoft.OneDriveSync"
        "Microsoft.People"                          # People
        #"Microsoft.MSPaint"                         # Paint 3D (Where every artist truly start as a kid, i mean, on original Paint, not this 3D)
        #"Microsoft.Print3D"                         # Print 3D
        "Microsoft.SkypeApp"                        # Skype (Who still uses Skype? Use Discord)
        "Microsoft.Todos"                           # Microsoft To Do
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"                      # Microsoft Whiteboard
        #"Microsoft.WindowsAlarms"                   # Alarms
        #"microsoft.windowscommunicationsapps"
        "Microsoft.WindowsMaps"                     # Maps
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsReadingList"
        "Microsoft.WindowsSoundRecorder"
        #"Microsoft.XboxApp"                         # Xbox Console Companion (Replaced by new App)
        #"Microsoft.XboxGameCallableUI"
        #"Microsoft.XboxGameOverlay"
        #"Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.YourPhone"                       # Your Phone
        #"Microsoft.ZuneMusic"                       # Groove Music / (New) Windows Media Player
        #"Microsoft.ZuneVideo"                       # Movies & TV
        
        # Default Windows 11 apps
        #"MicrosoftWindows.Client.WebExperience"     # Taskbar Widgets
        "MicrosoftTeams"                            # Microsoft Teams / Preview
        
        # 3rd party Apps
        #"*ACGMediaPlayer*"
        #"*ActiproSoftwareLLC*"
        "*AdobePhotoshopExpress*"                   # Adobe Photoshop Express
        "AdobeSystemsIncorporated.AdobeLightroom"   # Adobe Lightroom
        "AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    # Adobe Creative Cloud Express
        "*Amazon.com.Amazon*"                       # Amazon
        "AmazonVideo.PrimeVideo"                    # Amazon Prime Video
        "57540AMZNMobileLLC.AmazonAlexa"            # Amazon Alexa
        #"*Asphalt8Airborne*"                       # Asphalt 8 Airbone
        "89006A2E.AutodeskSketchBook"               # SketchBook
        "*AutodeskSketchBook*"
        "*BubbleWitch3Saga*"                        # Bubble Witch 3 Saga
        #"*CaesarsSlotsFreeCasino*"
        "*CandyCrush*"                              # Candy Crush
        "*Clipchamp*"                               # ClipChamp Video Editor
        #"*COOKINGFEVER*"
        "*CyberLinkMediaSuiteEssentials*"
        "*DisneyMagicKingdoms*"
        "Disney.37853FC22B2CE"
        "*Disney*"
        "*Dolby*"                                   # Dolby Products (Like Atmos)
        #"*DrawboardPDF*"
        "*DropboxOEM*"
        #"*Duolingo-LearnLanguagesforFree*"          # Duolingo
        "*EclipseManager*"
        "Evernote.Evernote"
        "*Facebook*"                                # Facebook
        "*FarmVille2CountryEscape*"
        "*FitbitCoach*"
        "*Flipboard*"                               # Flipboard
        "*HiddenCity*"
        "*Hulu*"
        "*iHeartRadio*"
        "*LinkedInforWindows*"
        #"*MarchofEmpires*"
        "*McAfee*"
        "5A894077.McAfeeSecurity"
        "4DF9E0F8.Netflix"
        #"*NYTCrossword*"
        #"*OneCalendar*"
        #"*PandoraMediaInc*"
        #"*PhototasticCollage*"
        "*PicsArt-PhotoStudio*"
        "*Pinterest*"
        "1424566A.147190DF3DE79"
        #"*Plex*"                                   # Plex
        "*PolarrPhotoEditorAcademicEdition*"
        #*RoyalRevolt*"                             # Royal Revolt
        #"*Shazam*"
        #"*Sidia.LiveWallpaper*"                     # Live Wallpaper
        #"*SlingTV*"
        #"*Speed Test*"
        "SpotifyAB.SpotifyMusic"
        "SpotifyAB.SpotifyMusic_zpdnekdrzrea0"
        "*Sway*"
        "*TuneInRadio*"
        "*Twitter*"                                 # Twitter
        "*TikTok*"
        #"*Viber*"
        #"*WinZipUniversal*"
        "5319275A.WhatsAppDesktop" 
        #"*Wunderlist*"
        #"*XING*"
        
        # Lenovo Bloat

        "E0469640.LenovoUtility"
        
        # Acer OEM Bloat
        "AcerIncorporated.AcerRegistration"
        "AcerIncorporated.QuickAccess"
        "AcerIncorporated.UserExperienceImprovementProgram"
        "AcerIncorporated.AcerCareCe nterS"
        "AcerIncorporated.AcerCollectionS"

        # HP Bloat
        "AD2F1837.HPSupportAssistant"
        "AD2F1837.HPPrinterControl"
        "AD2F1837.HPQuickDrop"
        "AD2F1837.HPSystemEventUtility"
        "AD2F1837.HPPrivacySettings"
        "AD2F1837.HPInc.EnergyStar"
        "AD2F1837.HPAudioCenter"
        
        # Common HP & Acer Bloat
        "CyberLinkCorp.ac.PowerDirectorforacerDesktop"
        "CyberLinkCorp.ac.PhotoDirectorforacerDesktop"
        "CorelCorporation.PaintShopPro"
        "26720RandomSaladGamesLLC.HeartsDeluxe"
        "26720RandomSaladGamesLLC.SimpleSolitaire"
        "26720RandomSaladGamesLLC.SimpleMahjong"
        "26720RandomSaladGamesLLC.Spades"

        # Samsung Bloat                 -  More Samsung bloat available in #Disabled
        "SAMSUNGELECTRONICSCO.LTD.1412377A9806A"
        "SAMSUNGELECTRONICSCO.LTD.NewVoiceNote"
        "SAMSUNGELECTRONICSCO.LTD.SamsungWelcome"
        "SAMSUNGELECTRONICSCO.LTD.SamsungUpdate"
        "SAMSUNGELECTRONICSCO.LTD.SamsungSecurity1.2"
        "SAMSUNGELECTRONICSCO.LTD.SamsungScreenRecording"
        "SAMSUNGELECTRONICSCO.LTD.SamsungQuickSearch"
        "SAMSUNGELECTRONICSCO.LTD.SamsungPCCleaner"
        "SAMSUNGELECTRONICSCO.LTD.SamsungCloudBluetoothSync"
        "SAMSUNGELECTRONICSCO.LTD.OnlineSupportSService"
        
        
        # DISABLED BLOAT
        # SAMSUNG Bloat
        #"SAMSUNGELECTRONICSCO.LTD.SamsungSettings1.2"          # Allow user to Tweak some hardware settings
        #"SAMSUNGELECTRONICSCoLtd.SamsungNotes"
        #"SAMSUNGELECTRONICSCoLtd.SamsungFlux"
        #SAMSUNGELECTRONICSCO.LTD.StudioPlus"
        #"SAMSUNGELECTRONICSCO.LTD.SamsungRecovery"             # Used to Factory Reset
        #"SAMSUNGELECTRONICSCO.LTD.PCGallery"
        #"4AE8B7C2.BOOKING.COMPARTNERAPPSAMSUNGEDITION"
        # Apps which other apps depend on
        #"Microsoft.Advertising.Xaml"
        )
        Remove-UWPAppx -AppxPackages $Programs

}
Function OneDriveRemoval() {
    Write-Host "`n" ; Write-TitleCounter -Counter '8' -MaxLength $MaxLength -Text "OneDrive Removal"
    If (Test-Path $Location5 -ErrorAction SilentlyContinue) {
        If (Test-Path $Location5 -ErrorAction SilentlyContinue) {
            If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue) {
                Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
                Write-Status -Types "-" -Status "Removing OneDrive."
            }
            Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose

        }
        If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue) {
            Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
            Write-Status -Types "-" -Status "Removing OneDrive."
        }
        Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose
    }
    
    Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose
    If ($env:OneDrive){
        If (Test-Path -Path $env:OneDrive -ErrorAction SilentlyContinue | Out-Null) { 
            Remove-Item -Path $env:OneDrive -Force -Recurse -ErrorAction SilentlyContinue ; Check
        }
    }
    If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") { Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue ; Check}
    If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") { Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse  -ErrorAction SilentlyContinue ; Check}
    
    Write-Output "Removing scheduled task"
    Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -Verbose -ErrorAction SilentlyContinue
    

    Write-Status -Types "-","$TweakType" -Status "Removing OneDrive Installation Hook for New Users"
    # Thank you Matthew Israelsson
    reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
    If (Get-ItemProperty -Path REGISTRY::HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name "OneDriveSetup" -ErrorAction SilentlyContinue){
        reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f 2> $Null | Out-Null
    }
    reg unload "hku\Default" 
}
Function BitlockerDecryption() { 
    Write-Host "`n" ; Write-TitleCounter -Counter '15' -MaxLength $MaxLength -Text "Bitlocker Decryption"

    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq "On") {
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        manage-bde -off "C:"
    }
    else {
        Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" -Warning
    }
}
Function Cleanup() {
    Write-Host "`n" ; Write-TitleCounter -Counter '17' -MaxLength $MaxLength -Text "Cleaning Up"
    $TweakType = 'Cleanup'
    Restart-Explorer
    Write-Status -Types "+" , $TweakType -Status "Enabling F8 boot menu options"
    #    bcdedit /set {bootmgr} displaybootmenu yes | Out-Null
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    If (Test-Path $location1) {
        Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
        Start-Process Chrome
    }    

    Write-Section -Text "Cleanup"

    <#
    If (Test-Path "~\Desktop\New Loads"){
        Write-Status -Types "-", $TweakType -Status "Removing New Loads"
        Remove-Item "~\Desktop\New Loads" -Recurse -Force -Confirm:$false -Verbose -ErrorAction SilentlyContinue | Out-Null
        #Remove-Item "..\New Loads" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Status -Types "-", $TweakType -Status "Removing Assets"
        If (Test-Path .\"assets"){Remove-Item .\"assets" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue}
        Write-Status -Types "-", $TweakType -Status "Removing bin"
        If (Test-Path .\"bin"){Remove-Item .\"bin" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue}
        Write-Status -Types "-", $TweakType -Status "Removing lib"
        If (Test-Path .\"lib"){Remove-Item .\"lib" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue}
        Write-Status -Types "-", $TweakType -Status "Removing log.txt"
        If (Test-Path .\"log.txt"){Remove-Item .\"log.txt" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue}
        Write-Status -Types "-", $TweakType -Status "Removing tmp.txt"
        If (Test-Path .\"tmp.txt"){Remove-Item .\"tmp.txt" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue}
    }
    #>

    Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"

    Remove-Item "$env:localappdata\temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue  -Exclude "New Loads" 2>$NULL
    If (Test-Path $vlcsc) { 
        Write-Status -Types "-", $TweakType -Status "Removing VLC Media Player Desktop Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $acrosc) { 
        Write-Status -Types "-" , $TweakType -Status "Removing Acrobat Desktop Icon"
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $zoomsc) {
        Write-Status -Types "-", $TweakType -Status "Removing Zoom Desktop Icon"
        Remove-Item -path $zoomsc -force | Out-Null
    }

    Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Exclude "New Loads" | Out-Null
    
    
    If (Test-Path $EdgeShortcut) { 
        Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in User Folder"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $edgescpub) { 
        Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in Public Desktop"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $ctemp) { 
        Write-Status -Types "-" , $TweakType -Status "Removing C:\Temp"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }

    
}
Function New-RestorePoint() {
    $TweakType = "Backup"
    Write-Host "`n" ; Write-TitleCounter -Counter '16' -MaxLength $MaxLength -Text "Creating Restore Point"
    Write-Status -Types "+", $TweakType -Status "Enabling system drive Restore Point..."
    Enable-ComputerRestore -Drive "$env:SystemDrive\"
    Checkpoint-Computer -Description "Mother Computers Courtesy Restore Point" -RestorePointType "MODIFY_SETTINGS"
}
Function Backup-HostsFile() {
    $PathToHostsFile = "$env:SystemRoot\System32\drivers\etc"

    Write-Status -Types "+" -Status "Doing Backup on Hosts file..."
    $Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Push-Location "$PathToHostsFile"

    If (!(Test-Path "$PathToHostsFile\Hosts_Backup")) {
        Write-Status -Types "?" -Status "Backup folder not found! Creating a new one..."
        mkdir -Path "$PathToHostsFile\Hosts_Backup"
    }
    Push-Location "Hosts_Backup"

    Copy-Item -Path ".\..\hosts" -Destination "hosts_$Date"

    Pop-Location
    Pop-Location
}
Function EmailLog() {
    
    Stop-Transcript;$EndTime = $(get-date)
	systeminfo | Sort-Object | Out-File -Append $log -Encoding ascii
    [String]$SystemSpec = Get-SystemSpec
    $ip = (New-Object System.Net.WebClient).DownloadString("http://ifconfig.me/ip")
    $ipinfo = (New-Object System.Net.WebClient).DownloadString('http://ipinfo.io/')
    #$ip = (New-Object System.Net.WebClient).DownloadString('http://ipinfo.io/')

    If (Test-Path -Path "$Location1"){
        $chromeyns = "X"
    }else{ 
        $chromeyns = ""
    }
    If (Test-Path -Path "$Location2"){
        $vlcyns = "X"
    }else{
        $vlcyns = ""
    }
    If (Test-Path -Path "$Location4"){ 
        $adobeyns = "X"
    }else{ 
        $adobeyns = ""
    }
    If (
        Test-Path -Path "$Location3"){
        $zoomyns = "X"
    }else{
        $zoomyns = ""
    }

    If ($currentwallpaper -eq $wallpaper){ $visualsyn = "X"}else{ $visualsyn = ""}


    $elapsedTime = $(get-date) - $StartTime
    $totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption

    Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "New Loads Automatic Log" -Attachments $Log -Priority High -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -Verbose -ErrorAction SilentlyContinue -Body "
    The script was run on a computer for $ip\$env:USERNAME, Completing in $totaltime

    Windows Version: $WindowsVersion, $DisplayVersion
    Script Version: $programversion
    Script Start Time: $StartTime
    Script End Time: $EndTime
    
    Script Log $dtime.txt
    
    #System Information
    $SystemSpec


    Applications Installed: $appsyns
    [$chromeyns] Chrome
    [$vlcyns] VLC Media Player
    [$adobeyns] Adobe Acrobat DC
    [$zoomyns] Zoom
    
    Visuals: [$visualsyn]
    Network Information of this PC: 
    $ipinfo"

}


#PowerShell -NoProfile -ExecutionPolicy Bypass
### CTRL + K - CTRL + 0 - Fold Everything
### CTRL + K - CTRL + J - Unfold Everything
If (!($GUI)){
$MaxLength = '17'
Variables
BootCheck
Start-Transcript -Path $Log ; $StartTime = $(get-date)
ScriptInfo
CheckFiles
Programs
Visuals
Branding
StartMenu
Debloat
#OOS
#Adw
OfficeCheck
OneDriveRemoval
AdvRegistry
Optimize-Performance
Optimize-Privacy
Optimize-Security
Optimize-ServicesRunning
Optimize-TaskScheduler
BitlockerDecryption
New-RestorePoint
Backup-HostsFile
EmailLog
Cleanup
Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB "
Request-PcRestart
}elseif ($GUI -eq $True){
    GUI
}
### END OF SCRIPT ###

# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUMYPJtY8ioLDMC7hghjnWoXvM
# uFigggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFP1UaBBEhdSH
# 5n2X4vuiSSfSr/pVMA0GCSqGSIb3DQEBAQUABIIBAGcnjOnDasTo2UMYjBhVoOPv
# qke86Qvew8lQMFmWNDoI3bsCwdKl0iQ3c/F2jaUuGb2miiyemQgUUflA1csqa5c6
# hdPiPCB7qmQ4irQYgO4mm+eqmg4qbSv86S+pF6YVTmKOp2A2dSS5wWrxZzYanFTw
# A7tN/w5k3512rVusNLxul/Z4oSFbeI+T7i04xrU/WABXWhlSlqAWRp6D7vTyCsqJ
# oSlzv5SnD4GOd0Y9fb4/F1DFx4Z+PPwzbR71o1AHRzachgThy5kZvFrtrWt2HjhY
# eP7InDWj5jZGGEBTi/67ZKxKkBXlmmWor3L/8sZH/6rAAnWVRuMgYtraK2TyISk=
# SIG # End signature block
