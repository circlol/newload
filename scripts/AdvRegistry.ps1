Function AdvRegistry {
    param (
        [Parameter(Mandatory=$True)]
        [String]$Action
    )
    $Vari = Switch ($Action) {

        "Apply" {"1"}
        "Undo" {"2"}
        "*" {"3"}
    }

    If ($vari -eq '1'){
        Write-Host " Applying"
        $1 = '1'
        $0 = '0'
        $tbm = '1'
        $regjob = "Applied"
        $title = "Applying"
    } else {
        If ($Vari -eq '2'){
            Write-Host " Undoing Changes"
            $1 = '0'
            $0 = '1'
            $tbm = '2'
            $regjob = "Undone"
            $title = "Undoing"
        } else {
            If ($Vari -eq '3'){
                Write-Host " ERROR: Option specified is not valid. Try again" -ForegroundColor Red
                Exit
            }
        }
        
    }

    ####################### COMMAND INPUT BELOW THIS #######################
    $WindowTitle = "New Loads - $title Registry" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt $title Registry Changes $frmt"
    If ($1 -eq 0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host " Removing Unnecessary printers"
        Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction SilentlyContinue -Verbose
        Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue -Verbose 
        Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue -Verbose
    }


    If ($BuildNumber -lt $Win11) {            ## Windows 10

        Write-Host " $title Windows 10 Specific Registry Keys`n"
        ## Changes search box to an icon
        If ((Get-ItemProperty -Path $regsearch).SearchBoxTaskbarMode -eq 1){            Write-Host " Skipping" -ForegroundColor Red        } Else {
            Write-Host ' Changing Searchbox to Icon Format on Taskbar'
            Set-ItemProperty -Path $regsearch -Name "SearchboxTaskbarMode" -Value 1 -Verbose
        }


        ## Removes Cortana from the taskbar
        If ((Get-ItemProperty -Path $regexadv).ShowCortanaButton -eq 0){            Write-Host " Skipping" -ForegroundColor Red        } Else {
        Write-Host ' Removing Cortana Icon from Taskbar'
        Set-ItemProperty -Path $regexadv -Name "ShowCortanaButton" -Value 0 -Verbose
        }

        ## Unpins taskview from Windows 10 Taskbar
        If ((Get-ItemProperty -Path $Regexadv).ShowTaskViewButton -eq 0){            Write-Host " Skipping" -ForegroundColor Red        } else {
        Write-Host ' Unpinning Task View Icon'
        Set-ItemProperty -Path $regexadv -Name "ShowTaskViewButton" -Value 0 -Verbose
        }

        ##  Hides 3D Objects from "This PC"
        If (Test-Path -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"){
            Write-Host ' Hiding 3D Objects icon from This PC'
            Remove-Item -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -Verbose
        }

        ## Expands explorers ribbon
        If (!(Test-Path -Path $regex\Ribbon)){
            New-Item -Path "$regex" -Name "Ribbon" -Force -Verbose
        }

        If ((Get-ItemProperty -Path "$regex\Ribbon").MinimizedStateTabletModeOff -eq 0) {             Write-Host " Skipping" -ForegroundColor Red        } else {
            Write-Host ' Expanding Ribbon in Explorer'
            Set-ItemProperty -Path $regex\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value 0 -Verbose
        }

        ## Disabling Feeds Open on Hover
        If ((Get-ItemProperty -Path $regcv\Feeds).ShellFeedsTaskbarOpenOnHover -eq 0){            Write-Host " Skipping" -ForegroundColor Red        } else {
            Write-Host ' Disabling Feeds open on hover'
            If (!(Test-Path -Path $regcv\Feeds)){
                New-Item -Path $regcv -Name "Feeds" -Verbose
            }
            Set-ItemProperty -Path $regcv\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 -Verbose
        }
        #Disables live feeds in search
        If (!(Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB")){
            New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "DSB" -Force -Verbose
        }
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "ShowDynamicContent" -Value 0 -type DWORD -Force -Verbose
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value 0 -Type DWORD -Force -Verbose        
    }

    if ($BuildNumber -gt $Win11) {            ## Windows 11
        Write-Host " $title Windows 11 Specific Registry Keys`n"

        If ($BuildNumber -gt $22H2){
            Set-ItemProperty -Path $regexadv -Name Start_Layout -Value $1 -Type DWORD -Force -Verbose
        }
        
        If ((Get-ItemProperty -Path $regexadv).TaskbarMn -eq 0){            Write-Host " Skipping" -ForegroundColor Red        } else {
            Write-Host " Removing Chats from taskbar"
            Set-ItemProperty -Path $regexadv -Name "TaskBarMn" -Value 0 -Verbose
        }
        If (!(Test-Path $regcv\Policies\Explorer)){
            New-Item $regcv\Policies\ -Name Explorer -Force -Verbose
        }
        If ((Get-ItemProperty -Path "$regcv\Policies\Explorer").HideSCAMeetNow -eq 1){            Write-Host " Skipping" -ForegroundColor Red        } else {
            Write-Host ' Removing "Meet Now" button from taskbar'
            Set-ItemProperty -Path $regcv\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value 1 -Verbose
        }
        
        If ((Get-ItemProperty -Path $regexadv).EnableSnapAssistFlyout -eq $1){        Write-Host " Skipping" -ForegroundColor Red} else {
            Write-Host ' Enabling Snap Assist Flyout'
            Set-ItemProperty -Path $regexadv -Name "EnableSnapAssistFlyout" -Value $1 -Verbose -Type DWORD
        }
    }


    # Checks current value for Game mode and E.
    $key1 = "HKCU:\Software\Microsoft\GameBar"
    $key2 = "AutoGameModeEnabled"
    $agme = (Get-ItemProperty -Path $key1).$key2
    If ($agme -eq 1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host " Enabling Game Mode"
        Set-ItemProperty -Path $key1 -Name $key2 -Value $1 -Force -Verbose
    }
    

    ### Explorer related
    If ((Get-ItemProperty -Path $regex).ShowRecent -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling Show Recent in Explorer Menu'
        Set-ItemProperty -Path $regex -Name "ShowRecent" -Value 0 -Verbose -Type DWORD
    }
    
    If ((Get-ItemProperty -Path $regex).ShowFrequent -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling Show Frequent in Explorer Menu'
        Set-ItemProperty -Path $regex -Name "ShowFrequent" -Value 0 -Verbose -Type DWORD
    }

    If ((Get-ItemProperty -Path $regexadv).HideFileExt -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Enabling File Extensions'
        Set-ItemProperty -Path $regexadv -Name "HideFileExt" -Value 0 -Verbose -Type DWORD
    }

    If ((Get-ItemProperty -Path $regexadv).LaunchTo -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Setting Explorer Launch to This PC'
        Set-ItemProperty -Path $regexadv -Name "LaunchTo" -Value $tbm -Verbose -Type DWORD
    }

    If (!(Test-Path -Path "$regexadv\HideDesktopIcons")){
        New-Item -Path "$regexadv" -Name HideDesktopIcons
        New-Item -Path "$regexadv\HideDesktopIcons" -Name NewStartPanel
    }
    $UsersFolder = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
    If ((Get-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel).$UsersFolder -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Adding User Files to desktop'
        Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value 0 -Verbose
    }

    $ThisPC = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    If ((Get-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel).$ThisPC -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Adding This PC icon to desktop'
        Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value 0 -Verbose
    }

    If (!(Test-Path $regex\OperationStatusManager)){
        New-Item -Path $regex\OperationStatusManager -Name EnthusiastMode -Type DWORD -Force -Verbose
    }
    If ((Get-ItemProperty -Path $regex\OperationStatusManager).EnthusiastMode -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Showing file operations details'
        If (!(Test-Path "$regex\OperationStatusManager")) {
            New-Item -Path "$regex\OperationStatusManager"
        }
        Set-ItemProperty -Path "$regex\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $1 -Verbose
    }


    ### Privacy
    #Write-Host ' Disabling Content Delivery Related Setings'
    If (!(Test-Path -Path $regcdm)){
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ContentDeliveryManager" -Verbose
    }
    If (Test-Path -Path $regcdm\Subscriptionn){
        Remove-Item -Path $regcdm\Subscriptionn -Recurse -Force -Verbose
    }
    If (Test-Path -Path $regcdm\SuggestedApps){
        Remove-Item -Path $regcdm\SuggestedApps -Recurse -Force -Verbose
    }
    $cdms = @(
    'ContentDeliveryAllowed'
    'OemPreInstalledAppsEnabled'
    'PreInstalledAppsEnabled'
    'PreInstalledAppsEverEnabled'
    'SilentInstalledAppsEnabled'
    'SubscribedContent-310093Enabled'
    'SubscribedContent-338387Enabled'
    'SubscribedContent-338388Enabled'
    'SubscribedContent-338389Enabled'
    'SubscribedContent-338393Enabled'
    'SubscribedContent-353694Enabled'
    'SubscribedContent-353696Enabled'
    'SubscribedContent-353698Enabled'
    'SystemPaneSuggestionsEnabled'
    'SoftLandingEnabled'
    )
    ForEach ($cdm in $cdms) {
        If ((Get-ItemProperty -Path $regcdm).$cdm -eq $0){            Write-Host " Skipping" -ForegroundColor Red        } else {
            #Write-Host " Setting $cdm to $0"
            Set-ItemProperty -Path $regcdm -Name $cdm -Value $0 -Verbose
        }
    }


    If ((Get-ItemProperty -Path $regadvertising).DisabledByGroupPolicy -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling Advertiser ID'
        Set-ItemProperty -Path $regadvertising -Name "DisabledByGroupPolicy" -Value $1 -Type DWORD -Verbose
    }


    If ((Get-ItemProperty -Path $regadvertising).Enabled -eq $0){       Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path $regadvertising -Name "Enabled" -Value $0 -Verbose
    }


    If (!(Test-Path -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI)){
        New-Item -Path:HKCU:\Software\Policies\Microsoft\Windows -Name "EdgeUI" -Verbose | Out-Host
    }
    If ((Get-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI).DisableMFUTracking -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling App Launch Tracking'
        Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $1 -Type DWORD -Verbose
    }
    If ($vari -eq '2'){
        Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force -Verbose
    }

    If (!(Test-Path $reginp)){
        Write-Host "Seems that InputPersonalization wasn't found. Creating" ; New-Item -Path "HKCU:\Software\Microsoft" -Name "InputPersonalization" -Verbose
    }

    
    If ((Get-ItemProperty -Path $reginp\TrainedDataStore).HarvestContacts -eq $0){        Write-Host " Skipping" -ForegroundColor Red            } else {
        Write-Host ' Disabling Contact Harvesting'
        Set-ItemProperty -Path $reginp\TrainedDataStore -Name "HarvestContacts" -Value $0 -Verbose
    }


    If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\Personalization\Settings).AcceptedPrivacyPolicy -eq $0){        Write-Host " Skipping" -ForegroundColor Red            } else {
        Write-Host ' Declining Microsoft Privacy Policy'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Personalization\Settings -Name "AcceptedPrivacyPolicy" -Value $0 -Verbose
    }


    If ((Get-ItemProperty -Path $reginp).RestrictImplicitTextCollection -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Restricting Text Collection'
        Set-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Value $1 -Verbose
        
    } 

    If ((Get-ItemProperty -Path $reginp).RestrictImplicitInkCollection -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Restricting Ink Collection'
        Set-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Value $1 -Verbose

    }
    
    
    ### Disables Feedback to Microsoft.
    If (!(Test-Path -Path:HKCU:\Software\Microsoft\Siuf)) { 
        New-Item -Path:HKCU:\Software\Microsoft -Name "Siuf" -Verbose
    }
    If (!(Test-Path -Path $siufrules)) {
        New-Item -Path HKCU:\Software\Microsoft\Siuf -Name "Rules" -Verbose
    }
    If (!((Get-Service -Name DiagTrack).Status -eq "Disabled")){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Stop-Service "DiagTrack" -WarningAction SilentlyContinue
        Set-Service "DiagTrack" -StartupType Disabled -Verbose
    }    
    If ((Get-ItemProperty -Path $siufrules).PeriodInNanoSeconds -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path $siufrules -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0 -Verbose
    }
    If ((Get-ItemProperty -Path $siufrules).PeriodInNanoSeconds -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path $siufrules -Name "PeriodInNanoSeconds" -Type QWORD -Value 0 -Verbose
    }
    
    


    If ((Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection).DoNotShowFeedbackNotifications -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling Windows Feedback Notifications'
        Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $1 -Verbose
    }


    If ((Get-ItemProperty -Path $regsys).EnableActivityFeed -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling Activity History'
        Set-ItemProperty -Path $regsys -Name "EnableActivityFeed" -Type DWORD -Value $0 -Verbose
        
    }

    If ((Get-ItemProperty -Path $regsys).PublishUserActivities -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path $regsys -Name "PublishUserActivities" -Type DWORD -Value $0 -Verbose
        
    }

    If ((Get-ItemProperty -Path $regsys).UploadUserActivities -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path $regsys -Name "UploadUserActivities" -Type DWORD -Value $0 -Verbose
    }



    If (!(Test-Path -Path:$regcam)) {
        New-Item -Path:$regcam -Force -Verbose
    }
    If ((Get-ItemProperty -Path "$regcam" -Name Value).Value -eq "Deny"){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling Location Tracking'
        Set-ItemProperty -Path "$regcam" -Name "Value" -Type String -Value "Deny" -Verbose
    }

    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name SensorPermissionState).SensorPermissionState -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWORD -Value $0 -Verbose
    }

    If (!(Test-Path -Path $lfsvc)){
        New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service" -Name "Configuration" -Verbose -ErrorAction SilentlyContinue
    }
    If ((Get-ItemProperty -Path $lfsvc -Name Status).Status -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path "$lfsvc" -Name "Status" -Type DWORD -Value $0 -Verbose
    }



    If ((Get-ItemProperty -Path HKLM:\System\Maps).AutoUpdateEnabled -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling automatic Maps updates'
        Set-ItemProperty -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $0 -Verbose
    }


    If (!((Get-Service -Name dmwappushservice).Status -eq "Disabled")){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Stopping and disabling WAP Push Service'
        Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
        Set-Service "dmwappushservice" -StartupType Disabled -Verbose
    }
    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection").AllowTelemetry -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value $0 -Verbose
    }

    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection").AllowTelemetry -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value $0 -Verbose
    }
    
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"  -Verbose
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater"  -Verbose
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy"  -Verbose
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"  -Verbose
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"  -Verbose
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -Verbose


    If (!(Test-Path -Path $wifisense\AllowWiFiHotSpotReporting)) {
        New-Item -Path $wifisense\AllowWiFiHotSpotReporting -Force -Verbose
    }
    If ((Get-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots).Value -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling Wi-Fi Sense'
        Set-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value $0 -Verbose
    }
    If ((Get-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting).Value -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Disabling HotSpot Reporting to Microsoft'
        Set-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value $0 -Verbose
    }



    $cloudcontent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    If (!(Test-Path -Path $cloudcontent)) {
    New-Item -Path $cloudcontent -Force
    }
    If ((Get-ItemProperty -Path $cloudcontent).DisableWindowsConsumerFeatures -eq $1){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path $cloudcontent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $1 -Verbose
    }


    $key1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
    $key2 = "TailoredExperiencesWithDiagnosticDataEnabled"
    If ((Get-ItemProperty -Path $key1).$key2 -eq $0){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Set-ItemProperty -Path $key1 -Name "$key2" -Value $0 -Type DWORD -Force -Verbose
    }
<#

### System
Write-Host ' Showing Details in Task Manager, also setting default tab to Performance'
If ($BuildNumber -lt $22h2){
    Write-Host ' Showing task manager details'
    $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
    Do {
        Start-Sleep -Milliseconds 100
        $preferences = Get-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -ErrorAction SilentlyContinue
    } Until ($preferences)
    Stop-Process $taskmgr
    $preferences.Preferences[28] = 0
    Set-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -Type Binary -Value $preferences.Preferences -Verbose
    Write-Host ' Setting default tab to Performance'
    Set-ItemProperty -Path $regcv\TaskManager -Name "StartUpTab" -Value $1 -Type DWORD -Verbose
} else {
    Write-Host " This PC is running 22H2 with a new task manager. Skipping this action."
}
#>



    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Stopping and disabling Home Groups services'
        Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue  -Verbose
    }
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue  -Verbose
    }

    If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped'){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Stopping and disabling Superfetch service'
        Stop-Service "SysMain" -WarningAction SilentlyContinue
        Set-Service "SysMain" -StartupType Disabled -Verbose
    }

    If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\MultiMedia\Audio).UserDuckingPreference -eq 3){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Setting Sounds > Communications to "Do Nothing"'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD -Verbose
    }

    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
    If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control).SvcHostSplitThresholdInKB -eq $ram){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Grouping svchost.exe processes'
        Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram -Force -Verbose
    }

    If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters).IRPStackSize -eq 30){        Write-Host " Skipping" -ForegroundColor Red    } else {
        Write-Host ' Increasing stack size up to 30'
        Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30 -Verbose
    }

    
    If ($vari -eq '2'){
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Force -EA SilentlyContinue
        Remove-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Force -EA SilentlyContinue
        Remove-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Force -EA SilentlyContinue
        Set-Service "DiagTrack" -StartupType Automatic -EA SilentlyContinue
        Set-Service "dmwappushservice" -StartupType Automatic -EA SilentlyContinue
        Set-Service "SysMain" -StartupType Automatic -EA SilentlyContinue
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"  -EA SilentlyContinue
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater"  -EA SilentlyContinue
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy"  -EA SilentlyContinue
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"  -EA SilentlyContinue
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"  -EA SilentlyContinue
        Enable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -EA SilentlyContinue
        }

        Write-Host "$frmt Registry changes $regjob $frmt"
        
    }
