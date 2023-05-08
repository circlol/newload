
Function Optimize-Privacy() {
    param(
    [Switch] $Revert,
    [Int]    $Zero = 0,
    [Int]    $One = 1,
    [Int]    $OneTwo = 1
)

$EnableStatus = @(
    @{ Symbol = "-"; Status = "Disabling"; }
    @{ Symbol = "+"; Status = "Enabling"; }
)

If (($Revert)) {
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -Warning
    $Zero = 1
    $One = 0
    $OneTwo = 2
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}
    $TweakType = "Privacy"
    Write-Title -Text "Privacy Tweaks"
    Write-Section -Text "Personalization"
    Write-Caption -Text "Start & Lockscreen"
    #Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show me the windows welcome experience after updates..."
    #Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Get fun facts and tips, etc. on lock screen'..."

    $ContentDeliveryManagerDisableOnZero = @(
        "SubscribedContent-310093Enabled"           # "Show me the Windows Welcome Experience after updates and when I sign in highlight whats new and suggested"
        "SubscribedContent-314559Enabled"           # 
        "SubscribedContent-314563Enabled"           # My People Suggested Apps
        "SubscribedContent-338387Enabled"           # Facts, Tips and Tricks on Lock Screen
        "SubscribedContent-338388Enabled"           # App Suggestions on Start
        "SubscribedContent-338389Enabled"           # Tips, Tricks, and Suggestions Notifications
        "SubscribedContent-338393Enabled"           # Suggested content in Settings
        'SubscribedContent-353694Enabled'           # Suggested content in Settings
        'SubscribedContent-353696Enabled'           # Suggested content in Settings
        "SubscribedContent-353698Enabled"           # Timeline Suggestions
        "RotatingLockScreenOverlayEnabled"          # Rotation Lock
        "RotatingLockScreenEnabled"                 # Rotation Lock
        # Prevents Apps from re-installing
        "ContentDeliveryAllowed"                    # Disables Content Delivery
        "FeatureManagementEnabled"                  # 
        "OemPreInstalledAppsEnabled"                # OEM Advertising
        "PreInstalledAppsEnabled"                   # Preinstalled apps like Disney+, Adobe Express, ect.
        "PreInstalledAppsEverEnabled"               # Preinstalled apps like Disney+, Adobe Express, ect.
        "RemediationRequired"                       # 
        "SilentInstalledAppsEnabled"                # 
        "SoftLandingEnabled"                        # 
        "SubscribedContentEnabled"                  # Disables Subscribed content
        "SystemPaneSuggestionsEnabled"              # 
    )

    # Executes the array above
    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUContentDeliveryManager]." -Warning
    ForEach ($Name in $ContentDeliveryManagerDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemPropertyVerified -Path "$PathToCUContentDeliveryManager" -Name "$Name" -Type DWord -Value $Zero
    }

    # Disables content suggestions in settings
    Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) 'Suggested Content in the Settings App'..."
    If (Test-Path "$PathToCUContentDeliveryManager\Subscriptions") {
        Remove-Item -Path "$PathToCUContentDeliveryManager\Subscriptions" -Recurse
    }

    # Disables content suggestion in start
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Show Suggestions' in Start..."
    If (Test-Path "$PathToCUContentDeliveryManager\SuggestedApps") {
        Remove-Item -Path "$PathToCUContentDeliveryManager\SuggestedApps" -Recurse
    }

    Write-Section -Text "Privacy -> Windows Permissions"
    Write-Caption -Text "General"

    # Disables Advertiser ID through permissions and group policy.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Let apps use my advertising ID..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesAdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value $One

    # Disables locally relevant content
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Let websites provide locally relevant content by accessing my language list'..."
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Type DWord -Value $One

    Write-Caption -Text "Speech"
    # Removes consent for online speech recognition services.
    # [@] (0 = Decline, 1 = Accept)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Online Speech Recognition..."
    Set-ItemPropertyVerified -Path "$PathToCUOnlineSpeech" -Name "HasAccepted" -Type DWord -Value $Zero

    Write-Caption -Text "Inking & Typing Personalization"
    # Disables personalization of inking and typing data (Keystrokes)
    Set-ItemPropertyVerified -Path "$PathToCUInputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero -ErrorAction SilentlyContinue

    Write-Caption -Text "Diagnostics & Feedback"
    #Disables Telemetry
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) telemetry..."
    # [@] (0 = Security (Enterprise only), 1 = Basic Telemetry, 2 = Enhanced Telemetry, 3 = Full Telemetry)
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesTelemetry" -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesTelemetry2" -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesTelemetry" -Name "AllowDeviceNameInTelemetry" -Type DWord -Value $Zero


    # Disables Microsofts collection of inking and typing data
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) send inking and typing data to Microsoft..."
    Set-ItemPropertyVerified -Path "$PathToCUInputTIPC" -Name "Enabled" -Type DWord -Value $Zero

    # Disables Microsoft's tailored experiences.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experiences..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value $Zero

    # Disables transcript of diagnostic data for collection
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) View diagnostic data..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" -Name "EnableEventTranscript" -Type DWord -Value $Zero

    # Sets feedback frequency to 0
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) feedback frequency..."
    If ((Test-Path "$PathToCUSiufRules\PeriodInNanoSeconds")) {
        Remove-ItemProperty -Path "$PathToCUSiufRules" -Name "PeriodInNanoSeconds"
    }
    Set-ItemPropertyVerified -Path "$PathToCUSiufRules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value $Zero

    Write-Caption -Text "Activity History"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Activity History..."
    $ActivityHistoryDisableOnZero = @(
        "EnableActivityFeed"
        "PublishUserActivities"
        "UploadUserActivities"
    )
    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToLMActivityHistory]" -Warning
    ForEach ($Name in $ActivityHistoryDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemPropertyVerified -Path "$PathToLMActivityHistory" -Name "$ActivityHistoryDisableOnZero" -Type DWord -Value $Zero
    }

    # Disables Suggested ways of getting the most out of windows (Microsoft account spam)
    Write-Status -Types "-" , $TweakType -Status "$($EnableStatus[1].Status) 'Suggest ways i can finish setting up my device to get the most out of windows.')"
    Set-ItemPropertyVerified -Path $PathToCUUserProfileEngagemment -Name "ScoobeSystemSettingEnabled" -Value "0" -Type DWord
    
    ### Privacy
    Write-Section -Text "Privacy"
    If (Test-Path -Path $PathToRegContentDelivery\Subscriptionn) {
        Remove-Item -Path $PathToRegContentDelivery\Subscriptionn -Recurse -Force
    }
    If (Test-Path -Path $PathToRegContentDelivery\SuggestedApps) {
        Remove-Item -Path $PathToRegContentDelivery\SuggestedApps -Recurse -Force
    }
    
    # Disables app launch tracking
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) App Launch Tracking..."
    Set-ItemPropertyVerified -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $One -Type DWORD
    
    If ($vari -eq '2') {
        Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force -ErrorAction SilentlyContinue
    }

    # Sets windows feeback notifciations to never show
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Feedback Notifications..."
    Set-ItemPropertyVerified -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One

    # Disables location tracking
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Location Tracking..."
    Set-ItemPropertyVerified -Path "$regcam" -Name "Value" -Type String -Value "Deny"
    Set-ItemPropertyVerified -Path "$lfsvc" -Name "Status" -Type DWORD -Value $Zero

    # Disables map updates (Windows Maps is removed)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Automatic Map Updates..."
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $Zero

    # AutoConnect to Hotspots disabled
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) AutoConnect to Sense Hotspots..."
    Set-ItemPropertyVerified -Path $PathToWifiSense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value $Zero
 
    # Disables reporting hotspots to microsoft
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Hotspot Reporting to Microsoft..."
    Set-ItemPropertyVerified -Path $PathToWifiSense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value $Zero

    # Disables cloud content from search (OneDrive, Office, Dropbox, ect.)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cloud Content from Windows Search..."
    Set-ItemPropertyVerified -Path $PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $One

    # Disables tailored experience w users diagnostic data.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experience w/ Diagnostic Data..."
    Set-ItemPropertyVerified -Path $PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value $Zero -Type DWORD

    # Disables HomeGroup
    Write-Status -Types $EnableStatus[1].Symbol,"$TweakType" -Status "Stopping and disabling Home Groups services.. LOL"
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
        Use-Command 'Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue'
        Use-Command 'Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue'
    }
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
        Use-Command 'Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue'
        Use-Command 'Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue'
    }

    # Disables SysMain
    If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped') { } else {
        Write-Host ' Stopping and disabling Superfetch service'
        Use-Command 'Stop-Service "SysMain" -WarningAction SilentlyContinue'
        Use-Command 'Set-Service "SysMain" -StartupType Disabled'
    }
    
    # Disables volume lowering during calls
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Volume Adjustment During Calls..."
    Set-ItemPropertyVerified -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD

    # Groups SVChost processes
    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
    Write-Status -Types $EnableStatus[1].Symbol,"$TweakType" -Status "Grouping svchost.exe Processes"
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram

    # Stack size increased for greater performance
    Write-Status -Types $EnableStatus[1].Symbol,"$TweakType" -Status "Increasing Stack Size to 30"
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30

    # Sets DNS settings to Google with CloudFlare as backup
    If (Get-Command Set-DnsClientDohServerAddress -ErrorAction SilentlyContinue){
        ## Imported text from  win10-debloat-tools on github
        # Adapted from: https://techcommunity.microsoft.com/t5/networking-blog/windows-insiders-gain-new-dns-over-https-controls/ba-p/2494644
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS over HTTPS for Google and Cloudflare (ipv4 and ipv6)..."
        Use-Command 'Set-DnsClientDohServerAddress -ServerAddress ("8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844") -AutoUpgrade $true -AllowFallbackToUdp $true'
        Use-Command 'Set-DnsClientDohServerAddress -ServerAddress ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001") -AutoUpgrade $true -AllowFallbackToUdp $true'
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS from Cloudflare and Google (ipv4 and ipv6)..."
        #Get-DnsClientServerAddress # To look up the current config.           # Cloudflare, Google,         Cloudflare,              Google
        Use-Command 'Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")'
        Use-Command 'Set-DNSClientServerAddress -InterfaceAlias    "Wi-Fi*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")'
    } else {
        Write-Status -Types "?", $TweakType -Status "Failed to set up DNS - DNSClient is not Installed..."
    }

    # Enables Legacy Windows F8 Boot select menu
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Bringing back F8 alternative Boot Modes..."
    bcdedit /set `{current`} bootmenupolicy Legacy

    Write-Section -Text "Ease of Access"
    Write-Caption -Text "Keyboard"
    # Disables Sticky Keys
    Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) Sticky Keys..."
    Set-ItemPropertyVerified -Path "$PathToCUAccessibility\StickyKeys" -Name "Flags" -Value "506" -Type STRING
    Set-ItemPropertyVerified -Path "$PathToCUAccessibility\Keyboard Response" -Name "Flags" -Value "122" -Type STRING
    Set-ItemPropertyVerified -Path "$PathToCUAccessibility\ToggleKeys" -Name "Flags" -Value "58" -Type STRING

    If ($Revert) {
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Force -EA SilentlyContinue
        Remove-ItemProperty -Path $PathToRegInputPersonalization -Name "RestrictImplicitTextCollection" -Force -EA SilentlyContinue
        Remove-ItemProperty -Path $PathToRegInputPersonalization -Name "RestrictImplicitInkCollection" -Force -EA SilentlyContinue
        Set-Service "DiagTrack" -StartupType Automatic -EA SilentlyContinue
        Set-Service "dmwappushservice" -StartupType Automatic -EA SilentlyContinue
        Set-Service "SysMain" -StartupType Automatic -EA SilentlyContinue
    }

    Write-Section -Text "Privacy -> Apps Permissions"
    #Write-Caption -Text "Location"
    #Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    #Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    #Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value $Zero
    #Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "EnableStatus" -Type DWord -Value $Zero

    Write-Caption -Text "Notifications"
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "App Diagnostics"
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny" -Type String
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "Account Info Access"
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny" -Type String
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "Voice Activation"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Voice Activation"
    Set-ItemPropertyVerified -Path $PathToVoiceActivation -Name "AgentActivationEnabled" -Value $Zero -Type DWord

    Write-Caption -Text "Background Apps"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps"
    Set-ItemPropertyVerified -Path $PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Value $One -Type DWord
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps Global"
    Set-ItemPropertyVerified -Path $PathToCUSearch -Name "BackgroundAppGlobalToggle" -Value $Zero -Type DWord

    Write-Caption -Text "Other Devices"
    Write-Status -Types "-", $TweakType -Status "Denying device access..."
    # Disable sharing information with unpaired devices
    Set-ItemPropertyVerified -Path "$PathToCUDeviceAccessGlobal\LooselyCoupled" -Name "Value" -Value "Deny" -Type String
    ForEach ($key in (Get-ChildItem "$PathToCUDeviceAccessGlobal")) {
        If ($key.PSChildName -EQ "LooselyCoupled") { continue }
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Setting $($key.PSChildName) value to 'Deny' ..."
        Set-ItemPropertyVerified -Path ("$PathToCUDeviceAccessGlobal\" + $key.PSChildName) -Name "Value" -Value "Deny"
    }

    Write-Caption -Text "Background Apps"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Background Apps..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path "$PathToCUSearch" -Name "BackgroundAppGlobalToggle" -Type DWord -Value 1

    Write-Caption -Text "Troubleshooting"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Automatic Recommended Troubleshooting, then notify me..."
    Set-ItemPropertyVerified -Path "$PathToLMWindowsTroubleshoot" -Name "UserPreference" -Type DWord -Value 3

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Spotlight Features..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Third Party Suggestions..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) More Telemetry Features..."

    $CloudContentDisableOnOne = @(
        "DisableWindowsSpotlightFeatures"
        "DisableWindowsSpotlightOnActionCenter"
        "DisableWindowsSpotlightOnSettings"
        "DisableWindowsSpotlightWindowsWelcomeExperience"
        "DisableTailoredExperiencesWithDiagnosticData"      # Tailored Experiences
        "DisableThirdPartySuggestions"
    )

    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUPoliciesCloudContent]." -Warning
    ForEach ($Name in $CloudContentDisableOnOne) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $One"
        Set-ItemPropertyVerified -Path "$PathToCUPoliciesCloudContent" -Name "$Name" -Type DWord -Value $One -ErrorAction SilentlyContinue
    }
    Set-ItemPropertyVerified -Path "$PathToCUPoliciesCloudContent" -Name "ConfigureWindowsSpotlight" -Type DWord -Value 2
    Set-ItemPropertyVerified -Path "$PathToCUPoliciesCloudContent" -Name "IncludeEnterpriseSpotlight" -Type DWord -Value $Zero

    # Disabling app suggestions
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Apps Suggestions..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesCloudContent" -Name "DisableThirdPartySuggestions" -Type DWord -Value $One
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesCloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value $One


    # Reference: https://forums.guru3d.com/threads/windows-10-registry-tweak-for-disabling-drivers-auto-update-controversy.418033/
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) automatic driver updates..."
    # [@] (0 = Yes, do this automatically, 1 = No, let me choose what to do, Always install the best, 2 = [...] Install driver software from Windows Update, 3 = [...] Never install driver software from Windows Update
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value $One
    # [@] (0 = Enhanced icons enabled, 1 = Enhanced icons disabled)
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value $Zero

    ## Performance Tweaks and More Telemetry
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
    Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -ErrorAction SilentlyContinue
    # Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Type DWord -Value 4000 # Note: This caused flickering
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "LowLevelHooksTimeout" -Type DWord -Value 1000
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type DWord -Value 10

    # Network Tweaks
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20

    # Gaming Tweaks
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"

    Set-ItemPropertyVerified -Path "$PathToLMPoliciesSQMClient" -Name "CEIPEnable" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -Type DWord -Value $One

    # Details: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004#windows-system-startup-event-traces-autologgers
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) some startup event traces (AutoLoggers)..."
    Set-ItemPropertyVerified -Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "$PathToLMAutoLogger\SQMLogger" -Name "Start" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: HotSpot Sharing'..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting" -Name "value" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: Shared HotSpot Auto-Connect'..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots" -Name "value" -Type DWord -Value $Zero

    Write-Caption "Deleting useless registry keys..."
    $KeysToDelete = @(
        # Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        # Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        # Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )

    ForEach ($Key in $KeysToDelete) {
        If ((Test-Path $Key)) {
            Write-Status -Types "-", $TweakType -Status "Removing Key: [$Key]"
            Remove-Item $Key -Recurse
        }
    }
}