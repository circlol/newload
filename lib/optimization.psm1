$Global:OptimizationLastUpdated = '20220830'
Import-Module -DisableNameChecking .\lib\"templates.psm1"
Import-Module -DisableNameChecking .\lib\"Variables.psm1"





Function Optimize-Performance() {
    [CmdletBinding()]
    param(
        [Switch] $Revert,
        [Int]    $Zero = 0,
    [Int]    $One = 1,
    [Array]  $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )
)
$TweakType = "Performance"
Write-Host "`n" ; Write-TitleCounter -Counter '10' -MaxLength $MaxLength -Text "Optimize Performance"
If (($Revert)) {
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -Warning
    $Zero = 1
    $One = 0
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}

$ExistingPowerPlans = $((powercfg -L)[3..(powercfg -L).Count])
# Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
$BuiltInPowerPlans = @{
    "Power Saver"            = "a1841308-3541-4fab-bc81-f71556f20b4a"
    "Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
    "High Performance"       = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    "Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
}

$UniquePowerPlans = $BuiltInPowerPlans.Clone()
# Initialize all Path variables used to Registry Tweaks
$PathToLMPoliciesPsched = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
$PathToLMPoliciesWindowsStore = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
$PathToLMPrefetchParams = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters"
$PathToCUGameBar = "HKCU:\SOFTWARE\Microsoft\GameBar"
$TimeoutScreenBattery = 5
$TimeoutScreenPluggedIn = 10
$TimeoutStandByBattery = 15
$TimeoutStandByPluggedIn = 30
$TimeoutDiskBattery = 15
$TimeoutDiskPluggedIn = 30
$TimeoutHibernateBattery = 15
$TimeoutHibernatePluggedIn = 30

Write-Title -Text "Performance Tweaks"

Write-Status -Types "=", $TweakType -Status "Enabling game mode..."
Set-ItemProperty -Path "$PathToCUGameBar" -Name "AllowAutoGameMode" -Type DWord -Value 1
Set-ItemProperty -Path "$PathToCUGameBar" -Name "AutoGameModeEnabled" -Type DWord -Value 1

Write-Section -Text "System"
Write-Caption -Text "Display"
Write-Status -Types "+", $TweakType -Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2 -ErrorAction SilentlyContinue -Force

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) SysMain/Superfetch..."
# As SysMain was already disabled on the Services, just need to remove it's key
# [@] (0 = Disable SysMain, 1 = Enable when program is launched, 2 = Enable on Boot, 3 = Enable on everything)
Set-ItemProperty -Path "$PathToLMPrefetchParams" -Name "EnableSuperfetch" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Remote Assistance..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value $Zero

Write-Status -Types "-", $TweakType -Status "Disabling Ndu High RAM Usage..."
# [@] (2 = Enable Ndu, 4 = Disable Ndu)
Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Services\Ndu" -Name "Start" -Type DWord -Value 4

# Details: https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
# Will reduce Processes number considerably on > 4GB of RAM systems
Write-Status -Types "+", $TweakType -Status "Setting SVCHost to match RAM size..."
$RamInKB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $RamInKB

Write-Status -Types "+", $TweakType -Status "Unlimiting your network bandwidth for all your system..." # Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
If (!(Test-Path "$PathToLMPoliciesPsched")) {
    New-Item -Path "$PathToLMPoliciesPsched" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesPsched" -Name "NonBestEffortLimit" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 4294967295

Write-Status -Types "=", $TweakType -Status "Enabling Windows Store apps Automatic Updates..."
If (!(Test-Path "$PathToLMPoliciesWindowsStore")) {
    New-Item -Path "$PathToLMPoliciesWindowsStore" -Force | Out-Null
}
If ((Get-Item "$PathToLMPoliciesWindowsStore").GetValueNames() -like "AutoDownload") {
    Remove-ItemProperty -Path "$PathToLMPoliciesWindowsStore" -Name "AutoDownload" # [@] (2 = Disable, 4 = Enable)
}

Write-Section -Text "Power Plan Tweaks"

Write-Status -Types "@", $TweakType -Status "Cleaning up duplicated Power plans..."
ForEach ($PowerCfgString in $ExistingPowerPlans) {
    $PowerPlanGUID = $PowerCfgString.Split(':')[1].Split('(')[0].Trim()
    $PowerPlanName = $PowerCfgString.Split('(')[-1].Replace(')', '').Trim()

    If (($PowerPlanGUID -in $BuiltInPowerPlans.Values)) {
        Write-Status -Types "@", $TweakType -Status "The '$PowerPlanName' power plan` is built-in, skipping $PowerPlanGUID ..." -Warning
        Continue
    }

    Try {
        If (($PowerPlanName -notin $UniquePowerPlans.Keys) -and ($PowerPlanGUID -notin $UniquePowerPlans.Values)) {
            $UniquePowerPlans.Add($PowerPlanName, $PowerPlanGUID)
        }
        Else {
            Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
            powercfg -Delete $PowerPlanGUID
        }
    }
    Catch {
        Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
        powercfg -Delete $PowerPlanGUID
    }
}

Write-Status -Types "+", $TweakType -Status "Creating the Ultimate Performance hidden Power Plan..."
powercfg -DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61
Write-Status -Types "+", $TweakType -Status "Setting Power Plan to High Performance..."
powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c


Write-Status -Types "+", $TweakType -Status "Setting the Monitor Timeout to AC: $TimeoutScreenPluggedIn and DC: $TimeoutScreenBattery..."
powercfg -Change Monitor-Timeout-AC $TimeoutScreenPluggedIn 
powercfg -Change Monitor-Timeout-DC $TimeoutScreenBattery

Write-Status -Types "+", $TweakType -Status "Setting the Standby Timeout to AC: $TimeoutStandByPluggedIn and DC: $TimeoutStandByBattery..."
powercfg -Change Standby-Timeout-AC $TimeoutStandByPluggedIn
powercfg -Change Standby-Timeout-DC $TimeoutStandByBattery

Write-Status -Types "+", $TweakType -Status "Setting the Disk Timeout to AC: $TimeoutDiskPluggedIn and DC: $TimeoutDiskBattery..."
powercfg -Change Disk-Timeout-AC $TimeoutDiskPluggedIn
powercfg -Change Disk-Timeout-DC $TimeoutDiskBattery

Write-Status -Types "+", $TweakType -Status "Setting the Hibernate Timeout to AC: $TimeoutHibernatePluggedIn and DC: $TimeoutHibernateBattery..."
powercfg -Change Hibernate-Timeout-AC $TimeoutHibernatePluggedIn
Powercfg -Change Hibernate-Timeout-DC $TimeoutHibernateBattery
<#
Write-Status -Types "+", $TweakType -Status "Setting Hibernate size to reduced..."
powercfg -Hibernate -type Reduced

Write-Status -Types "+", $TweakType -Status "Enabling Hibernate (Boots faster on Laptops/PCs with HDD and generate '$env:SystemDrive\hiberfil.sys' file)..."
powercfg -Hibernate on -ErrorAction SilentlyContinue
#>

Write-Section -Text "Network & Internet"
Write-Caption -Text "Proxy"
Write-Status -Types "-", $TweakType -Status "Fixing Edge slowdown by NOT Automatically Detecting Settings..."
# Code from: https://www.reddit.com/r/PowerShell/comments/5iarip/set_proxy_settings_to_automatically_detect/?utm_source=share&utm_medium=web2x&context=3
$Key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
$Data = (Get-ItemProperty -Path $Key -Name DefaultConnectionSettings).DefaultConnectionSettings
$Data[8] = 3
Set-ItemProperty -Path $Key -Name DefaultConnectionSettings -Value $Data

}
Function Optimize-Privacy() {
[CmdletBinding()]
param(
    [Switch] $Revert,
    [Int]    $Zero = 0,
    [Int]    $One = 1,
    [Array]  $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )
)
Write-Host "`n" ; Write-TitleCounter -Counter '11' -MaxLength $MaxLength -Text "Optimize Privacy"

$TweakType = "Privacy"

If ($Revert) {
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -Warning
    $Zero = 1
    $One = 0
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}

Write-Title -Text "Privacy Tweaks"
Write-Section -Text "Personalization"
Write-Caption -Text "Start & Lockscreen"
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show me the windows welcome experience after updates..."
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Get fun facts and tips, etc. on lock screen'..."

$ContentDeliveryManagerDisableOnZero = @(
    "SubscribedContent-310093Enabled"
    "SubscribedContent-314559Enabled"
    "SubscribedContent-314563Enabled"
    "SubscribedContent-338387Enabled"
    "SubscribedContent-338388Enabled"
    "SubscribedContent-338389Enabled"
    "SubscribedContent-338393Enabled"
    'SubscribedContent-353694Enabled'
    'SubscribedContent-353696Enabled'
    "SubscribedContent-353698Enabled"
    "RotatingLockScreenOverlayEnabled"
    "RotatingLockScreenEnabled"
    # Prevents Apps from re-installing
    "ContentDeliveryAllowed"
    "FeatureManagementEnabled"
    "OemPreInstalledAppsEnabled"
    "PreInstalledAppsEnabled"
    "PreInstalledAppsEverEnabled"
    "RemediationRequired"
    "SilentInstalledAppsEnabled"
    "SoftLandingEnabled"
    "SubscribedContentEnabled"
    "SystemPaneSuggestionsEnabled"
)

Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUContentDeliveryManager]." -Warning
ForEach ($Name in $ContentDeliveryManagerDisableOnZero) {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
    Set-ItemProperty -Path "$PathToCUContentDeliveryManager" -Name "$Name" -Type DWord -Value $Zero
}

Write-Status -Types "-", $TweakType -Status "Disabling 'Suggested Content in the Settings App'..."
If (Test-Path "$PathToCUContentDeliveryManager\Subscriptions") {
    Remove-Item -Path "$PathToCUContentDeliveryManager\Subscriptions" -Recurse
}

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Show Suggestions' in Start..."
If (Test-Path "$PathToCUContentDeliveryManager\SuggestedApps") {
    Remove-Item -Path "$PathToCUContentDeliveryManager\SuggestedApps" -Recurse
}

Write-Section -Text "Privacy -> Windows Permissions"
Write-Caption -Text "General"
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Let apps use my advertising ID..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value $Zero
If (!(Test-Path "$PathToLMPoliciesAdvertisingInfo")) {
    New-Item -Path "$PathToLMPoliciesAdvertisingInfo" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesAdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value $One

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Let websites provide locally relevant content by accessing my language list'..."
Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Type DWord -Value $One

Write-Caption -Text "Speech"
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Online Speech Recognition..."
If (!(Test-Path "$PathToCUOnlineSpeech")) {
    New-Item -Path "$PathToCUOnlineSpeech" -Force | Out-Null
}
# [@] (0 = Decline, 1 = Accept)
Set-ItemProperty -Path "$PathToCUOnlineSpeech" -Name "HasAccepted" -Type DWord -Value $Zero

Write-Caption -Text "Inking & Typing Personalization"
Set-ItemProperty -Path "$PathToCUInputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero
Set-ItemProperty -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value $One
Set-ItemProperty -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value $One
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero

Write-Caption -Text "Diagnostics & Feedback"
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) telemetry..."
# [@] (0 = Security (Enterprise only), 1 = Basic Telemetry, 2 = Enhanced Telemetry, 3 = Full Telemetry)
Set-ItemProperty -Path "$PathToLMPoliciesTelemetry" -Name "AllowTelemetry" -Type DWord -Value $Zero
Set-ItemProperty -Path "$PathToLMPoliciesTelemetry2" -Name "AllowTelemetry" -Type DWord -Value $Zero
Set-ItemProperty -Path "$PathToLMPoliciesTelemetry" -Name "AllowDeviceNameInTelemetry" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) send inking and typing data to Microsoft..."
If (!(Test-Path "$PathToCUInputTIPC")) {
    New-Item -Path "$PathToCUInputTIPC" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToCUInputTIPC" -Name "Enabled" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experiences..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) View diagnostic data..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" -Name "EnableEventTranscript" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) feedback frequency..."
If (!(Test-Path "$PathToCUSiufRules")) {
    New-Item -Path "$PathToCUSiufRules" -Force | Out-Null
}
If ((Test-Path "$PathToCUSiufRules\PeriodInNanoSeconds")) {
    Remove-ItemProperty -Path "$PathToCUSiufRules" -Name "PeriodInNanoSeconds"
}
Set-ItemProperty -Path "$PathToCUSiufRules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value $Zero

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
    Set-ItemProperty -Path "$PathToLMActivityHistory" -Name "$ActivityHistoryDisableOnZero" -Type DWord -Value $Zero
}

Write-Section -Text "Privacy -> Apps Permissions"
#Write-Caption -Text "Location"
#Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value $Zero
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "EnableStatus" -Type DWord -Value $Zero

Write-Caption -Text "Notifications"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" -Name "Value" -Value "Deny"

Write-Caption -Text "App Diagnostics"
Try {

    If (!(Test-Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore')){
        New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager' -Name 'ConsentStore'}
    If (!(Test-Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics')){
        New-item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore' -Name appDiagnostics -Force}
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny" -Type String
    
    If (!(Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics')){
        New-item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore' -Name appDiagnostics -Force}
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny" -Type String
}Catch{}


Write-Caption -Text "Account Info Access"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny"

If (Test-Path $PathToVoiceActivation){
    Write-Caption -Text "Voice Activation"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Voice Activation"
    Set-ItemProperty -Path $PathToVoiceActivation -Name "AgentActivationEnabled" -Value $Zero -Type DWord -Force
} 

Write-Caption -Text "Background Apps"
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps"
Set-ItemProperty -Path $PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Value $One -Type DWord -Force
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps Global"
Set-ItemProperty -Path $PathToCUSearch -Name "BackgroundAppGlobalToggle" -Value $Zero -Type DWord -Force
    



Write-Caption -Text "Other Devices"
Write-Status -Types "-", $TweakType -Status "Denying device access..."
If (!(Test-Path "$PathToCUDeviceAccessGlobal\LooselyCoupled")) {
    New-Item -Path "$PathToCUDeviceAccessGlobal\LooselyCoupled" -Force | Out-Null
}
# Disable sharing information with unpaired devices
Set-ItemProperty -Path "$PathToCUDeviceAccessGlobal\LooselyCoupled" -Name "Value" -Value "Deny"
ForEach ($key in (Get-ChildItem "$PathToCUDeviceAccessGlobal")) {
    If ($key.PSChildName -EQ "LooselyCoupled") {
        continue
    }
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Setting $($key.PSChildName) value to 'Deny' ..."
    Set-ItemProperty -Path ("$PathToCUDeviceAccessGlobal\" + $key.PSChildName) -Name "Value" -Value "Deny"
}

Write-Caption -Text "Background Apps"
Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Background Apps..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Type DWord -Value 0
Set-ItemProperty -Path "$PathToCUSearch" -Name "BackgroundAppGlobalToggle" -Type DWord -Value 1

Write-Caption -Text "Troubleshooting"
Write-Status -Types "+", $TweakType -Status "Enabling Automatic Recommended Troubleshooting, then notify me..."
If (!(Test-Path "$PathToLMWindowsTroubleshoot")) {
    New-Item -Path "$PathToLMWindowsTroubleshoot" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMWindowsTroubleshoot" -Name "UserPreference" -Type DWord -Value 3

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
    Set-ItemProperty -Path "$PathToCUPoliciesCloudContent" -Name "$Name" -Type DWord -Value $One
}
If (!(Test-Path "$PathToCUPoliciesCloudContent")) {
    New-Item -Path "$PathToCUPoliciesCloudContent" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToCUPoliciesCloudContent" -Name "ConfigureWindowsSpotlight" -Type DWord -Value 2
Set-ItemProperty -Path "$PathToCUPoliciesCloudContent" -Name "IncludeEnterpriseSpotlight" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Apps Suggestions..."
If (!(Test-Path "$PathToLMPoliciesCloudContent")) {
    New-Item -Path "$PathToLMPoliciesCloudContent" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesCloudContent" -Name "DisableThirdPartySuggestions" -Type DWord -Value $One
Set-ItemProperty -Path "$PathToLMPoliciesCloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value $One

# Reference: https://forums.guru3d.com/threads/windows-10-registry-tweak-for-disabling-drivers-auto-update-controversy.418033/
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) automatic driver updates..."
# [@] (0 = Yes, do this automatically, 1 = No, let me choose what to do, Always install the best, 2 = [...] Install driver software from Windows Update, 3 = [...] Never install driver software from Windows Update
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value $One
# [@] (0 = Enhanced icons enabled, 1 = Enhanced icons disabled)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value $Zero


## Performance Tweaks and More Telemetry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -ErrorAction SilentlyContinue
# Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Type DWord -Value 4000 # Note: This caused flickering
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Type DWord -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "LowLevelHooksTimeout" -Type DWord -Value 1000
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type DWord -Value 10


# Network Tweaks
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20

# Gaming Tweaks
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"

If (!(Test-Path "$PathToLMPoliciesSQMClient")) {
    New-Item -Path "$PathToLMPoliciesSQMClient" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesSQMClient" -Name "CEIPEnable" -Type DWord -Value $Zero
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "AppCompat"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type DWord -Value $Zero
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -Type DWord -Value $One

# Details: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004#windows-system-startup-event-traces-autologgers
Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) some startup event traces (AutoLoggers)..."
If (!(Test-Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener")) {
    New-Item -Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value $Zero
Set-ItemProperty -Path "$PathToLMAutoLogger\SQMLogger" -Name "Start" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: HotSpot Sharing'..."
If (!(Test-Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting")) {
    New-Item -Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting" -Name "value" -Type DWord -Value $Zero

Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: Shared HotSpot Auto-Connect'..."
If (!(Test-Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots")) {
    New-Item -Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots" -Name "value" -Type DWord -Value $Zero

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
Function Optimize-Security() {
Write-Host "`n" ; Write-TitleCounter -Counter '12' -MaxLength $MaxLength -Text "Optimize Security"

$TweakType = "Security"
# Initialize all Path variables used to Registry Tweaks
$PathToLMPoliciesEdge = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge"
$PathToLMPoliciesMRT = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
$PathToCUExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
$PathToCUExplorerAdvanced = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

Write-Title -Text "Security Tweaks"
<#
Write-Section -Text "Windows Firewall"
Write-Status -Types "+", $TweakType -Status "Enabling default firewall profiles..."
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True
$IParray = @("13.64.90.137", "13.66.56.243", "13.68.31.193", "13.68.82.8", "13.68.92.143", "13.68.233.9", "13.69.109.130", "13.69.109.131",    
"13.69.131.175", "13.73.26.107", "13.74.169.109", "13.78.130.220", "13.78.232.226", "13.78.233.133", "13.88.21.125", "13.92.194.212", "13.104.215.69", "13.105.28.32", "13.105.28.48", 
"20.44.86.43", "20.49.150.241", "20.54.232.160", "20.60.20.4", "20.69.137.228", "20.190.169.24", "20.190.169.25", "23.99.49.121", "23.102.4.253", "23.102.5.5", "23.102.21.4", "23.103.182.126", 
"40.68.222.212", "40.69.153.67", "40.70.184.83", "40.70.220.248", "40.77.228.47", "40.77.228.87", "40.77.228.92", "40.77.232.101", "40.78.128.150", "40.79.85.125", "40.88.32.150", 
"40.112.209.200", "40.115.3.210","40.115.119.185","40.119.211.203","40.124.34.70","40.126.41.96","40.126.41.160","51.104.136.2"
"51.105.218.222","51.140.40.236","51.140.157.153","51.143.53.152","51.143.111.7","51.143.111.81","51.144.227.73","52.138.204.217","52.147.198.201","52.155.94.78"
"52.157.234.37","52.158.208.111","52.164.241.205","52.169.189.83","52.170.83.19","52.174.22.246","52.178.147.240","52.178.151.212","52.178.223.23","52.182.141.63","52.183.114.173"
"52.184.221.185","52.229.39.152","52.230.85.180","52.230.222.68","52.236.42.239","52.236.43.202","52.255.188.83","65.52.100.7","65.52.100.9","65.52.100.11","65.52.100.91","65.52.100.92"
    "65.52.100.93","65.52.100.94","65.52.161.64","65.55.29.238","65.55.83.120","65.55.113.11","65.55.113.12","65.55.113.13","65.55.176.90","65.55.252.43","65.55.252.63","65.55.252.70","65.55.252.71"
    "65.55.252.72","65.55.252.93","65.55.252.190","65.55.252.202","66.119.147.131","104.41.207.73","104.42.151.234","104.43.137.66","104.43.139.21","104.43.139.144","104.43.140.223","104.43.193.48"
    "104.43.228.53","104.43.228.202","104.43.237.169","104.45.11.195","104.45.214.112","104.46.1.211","104.46.38.64","104.46.162.224","104.46.162.226","104.210.4.77","104.210.40.87","104.210.212.243"
    "104.214.35.244","104.214.78.152","131.253.6.87","131.253.6.103","131.253.34.230","131.253.34.234","131.253.34.237","131.253.34.243","131.253.34.246","131.253.34.247","131.253.34.249","131.253.34.252"
    "131.253.34.255","131.253.40.37","134.170.30.202","134.170.30.203","134.170.30.204","134.170.30.221","134.170.52.151","134.170.235.16","157.56.74.250","157.56.91.77","157.56.106.184","157.56.106.185"
    "157.56.106.189","157.56.113.217","157.56.121.89","157.56.124.87","157.56.149.250","157.56.194.72","157.56.194.73","157.56.194.74","168.61.24.141","168.61.146.25","168.61.149.17","168.61.161.212"
    "168.61.172.71","168.62.187.13","168.63.100.61","168.63.108.233","191.236.155.80","191.237.218.239","191.239.50.18","191.239.50.77","191.239.52.100","191.239.54.52","207.68.166.254"
    )
#>
    
foreach($ip in $IParray)
{
    Write-Status "+",$TweakType -Status "Blocking Microsoft Telemtry IP Address: $ip "
    New-NetFirewallRule -DisplayName "Allow $ip" -Direction Inbound -Action Block -RemoteAddress $ip -ErrorAction SilentlyContinue | Out-Null
    Check
}


Write-Section -Text "Windows Defender"
Write-Status -Types "?", $TweakType -Status "If you already use another antivirus, nothing will happen." -Warning
Write-Status -Types "+", $TweakType -Status "Ensuring your Windows Defender is ENABLED..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWORD -Value 0 -Force
If (Get-Command Set-MpPreference -ErrorAction SilentlyContinue){
Set-MpPreference -DisableRealtimeMonitoring $false -Force -ErrorAction SilentlyContinue

Write-Status -Types "+", $TweakType -Status "Enabling Microsoft Defender Exploit Guard network protection..."
Set-MpPreference -EnableNetworkProtection Enabled -Force -ErrorAction SilentlyContinue

Write-Status -Types "+", $TweakType -Status "Enabling detection for potentially unwanted applications and block them..."
Set-MpPreference -PUAProtection Enabled -Force -ErrorAction SilentlyContinue

Write-Status -Types "+", $TweakType -Status "Enabling Windows Defender Definition Update Before Running Scans..."
Set-MpPreference -CheckForSignaturesBeforeRunningScan $True -Force -ErrorAction SilentlyContinue

}

Write-Section -Text "SmartScreen"
Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Microsoft Edge..."
If (!(Test-Path "$PathToLMPoliciesEdge\PhishingFilter")) {
    New-Item -Path "$PathToLMPoliciesEdge\PhishingFilter" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 1

Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Store Apps..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 1

Write-Section -Text "Old SMB Protocol"
# Details: https://techcommunity.microsoft.com/t5/storage-at-microsoft/stop-using-smb1/ba-p/425858
Write-Status -Types "+", $TweakType -Status "Disabling SMB 1.0 protocol..."
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

Write-Section -Text "Old .NET cryptography"
# Enable strong cryptography for .NET Framework (version 4 and above) - https://stackoverflow.com/a/47682111
Write-Status -Types "+", $TweakType -Status "Enabling .NET strong cryptography..."
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1
Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1

Write-Section -Text "Autoplay and Autorun (Removable Devices)"
Write-Status -Types "-", $TweakType -Status "Disabling Autoplay..."
Set-ItemProperty -Path "$PathToCUExplorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

Write-Status -Types "-", $TweakType -Status "Disabling Autorun for all Drives..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

Write-Section -Text "Microsoft Store"
Write-Status -Types "-", $TweakType -Status "Disabling Search for App in Store for Unknown Extensions..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoUseStoreOpenWith" -Type DWord -Value 1

Write-Section -Text "Windows Explorer"
Write-Status -Types "+", $TweakType -Status "Enabling Show file extensions in Explorer..."
Set-ItemProperty -Path "$PathToCUExplorerAdvanced" -Name "HideFileExt" -Type DWord -Value 0

Write-Section -Text "User Account Control (UAC)"
# Details: https://docs.microsoft.com/pt-br/windows/security/identity-protection/user-account-control/user-account-control-group-policy-and-registry-key-settings
Write-Status -Types "+", $TweakType -Status "Raising UAC level..."
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1

Write-Section -Text "Windows Update"
# Details: https://forums.malwarebytes.com/topic/246740-new-potentially-unwanted-modification-disablemrt/
Write-Status -Types "+", $TweakType -Status "Enabling offer Malicious Software Removal Tool via Windows Update..."
If (!(Test-Path "$PathToLMPoliciesMRT")) {
    New-Item -Path "$PathToLMPoliciesMRT" -Force | Out-Null
}
Set-ItemProperty -Path "$PathToLMPoliciesMRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 0

Write-Status -Types "?", $TweakType -Status "For more tweaks, edit the '$PSCommandPath' file, then uncomment '#SomethingHere' code lines" -Warning
# Consumes more RAM - Make Windows Defender run in Sandbox Mode (MsMpEngCP.exe and MsMpEng.exe will run on background)
# Details: https://www.microsoft.com/security/blog/2018/10/26/windows-defender-antivirus-can-now-run-in-a-sandbox/
#Write-Status -Types "+", $TweakType -Status "Enabling Windows Defender Sandbox mode..."
#setx /M MP_FORCE_USE_SANDBOX 1  # Restart the PC to apply the changes, 0 to Revert

# Disable Windows Script Host. CAREFUL, this may break stuff, including software uninstall.
#Write-Status -Types "+", $TweakType -Status "Disabling Windows Script Host (execution of *.vbs scripts and alike)..."
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type DWord -Value 0
}
Function Optimize-ServicesRunning() {
[CmdletBinding()]
param (
    [Switch] $Revert
)
Write-Host "`n" ; Write-TitleCounter -Counter '13' -MaxLength $MaxLength -Text "Optimize Services"

$IsSystemDriveSSD = $(Get-OSDriveType) -eq "SSD"
$EnableServicesOnSSD = @("SysMain", "WSearch")

# Services which will be totally disabled
$ServicesToDisabled = @(
    "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
    "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
    "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
    #"Fax"                                       # DEFAULT: Manual    | Fax Service
    "fhsvc"                                     # DEFAULT: Manual    | Fax History Service
    "GraphicsPerfSvc"                           # DEFAULT: Manual    | Graphics performance monitor service
    #"HomeGroupListener"                         # NOT FOUND (Win 10+)| HomeGroup Listener
    #"HomeGroupProvider"                         # NOT FOUND (Win 10+)| HomeGroup Provider
    "lfsvc"                                     # DEFAULT: Manual    | Geolocation Service
    "MapsBroker"                                # DEFAULT: Automatic | Downloaded Maps Manager
    "PcaSvc"                                    # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
    "RemoteAccess"                              # DEFAULT: Disabled  | Routing and Remote Access
    "RemoteRegistry"                            # DEFAULT: Disabled  | Remote Registry
    "RetailDemo"                                # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
    "SysMain"                                   # DEFAULT: Automatic | SysMain / Superfetch (100% Disk usage on HDDs)
    # read://https_helpdeskgeek.com/?url=https%3A%2F%2Fhelpdeskgeek.com%2Fhelp-desk%2Fdelete-disable-windows-prefetch%2F%23%3A~%3Atext%3DShould%2520You%2520Kill%2520Superfetch%2520(Sysmain)%3F
    "TrkWks"                                    # DEFAULT: Automatic | Distributed Link Tracking Client
    "WSearch"                                   # DEFAULT: Automatic | Windows Search (100% Disk usage on HDDs)
    # - Services which cannot be disabled (and shouldn't)
    #"wscsvc"                                   # DEFAULT: Automatic | Windows Security Center Service
    #"WdNisSvc"                                 # DEFAULT: Manual    | Windows Defender Network Inspection Service
)

# Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
$ServicesToManual = @(
    "BITS"                           # DEFAULT: Manual    | Background Intelligent Transfer Service
    #"cbdhsvc_*"                      # DEFAULT: Manual    | Clipboard User Service
    "edgeupdate"                     # DEFAULT: Automatic | Microsoft Edge Update Service
    "edgeupdatem"                    # DEFAULT: Manual    | Microsoft Edge Update Service²
    "FontCache"                      # DEFAULT: Automatic | Windows Font Cache
    "iphlpsvc"                       # DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
    "lmhosts"                        # DEFAULT: Manual    | TCP/IP NetBIOS Helper
    "ndu"                            # DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
    #"NetTcpPortSharing"             # DEFAULT: Disabled  | Net.Tcp Port Sharing Service
    "PhoneSvc"                       # DEFAULT: Manual    | Phone Service (Manages the telephony state on the device)
    "SCardSvr"                       # DEFAULT: Manual    | Smart Card Service
    "SharedAccess"                   # DEFAULT: Manual    | Internet Connection Sharing (ICS)
    "stisvc"                         # DEFAULT: Automatic | Windows Image Acquisition (WIA) Service
    "WbioSrvc"                       # DEFAULT: Manual    | Windows Biometric Service (required for Fingerprint reader / Facial detection)
    "Wecsvc"                         # DEFAULT: Manual    | Windows Event Collector Service
    "WerSvc"                         # DEFAULT: Manual    | Windows Error Reporting Service
    "wisvc"                          # DEFAULT: Manual    | Windows Insider Program Service
    "WMPNetworkSvc"                  # DEFAULT: Manual    | Windows Media Player Network Sharing Service
    "WpnService"                     # DEFAULT: Automatic | Windows Push Notification Services (WNS)
    # - Diagnostic Services
    "DPS"                            # DEFAULT: Automatic | Diagnostic Policy Service
    "WdiServiceHost"                 # DEFAULT: Manual    | Diagnostic Service Host
    "WdiSystemHost"                  # DEFAULT: Manual    | Diagnostic System Host
    # - Bluetooth services
    "BTAGService"                    # DEFAULT: Manual    | Bluetooth Audio Gateway Service
    "BthAvctpSvc"                    # DEFAULT: Manual    | AVCTP Service
    "bthserv"                        # DEFAULT: Manual    | Bluetooth Support Service
    "RtkBtManServ"                   # DEFAULT: Automatic | Realtek Bluetooth Device Manager Service
    # - Xbox services
    "XblAuthManager"                 # DEFAULT: Manual    | Xbox Live Auth Manager
    "XblGameSave"                    # DEFAULT: Manual    | Xbox Live Game Save
    "XboxGipSvc"                     # DEFAULT: Manual    | Xbox Accessory Management Service
    "XboxNetApiSvc"                  # DEFAULT: Manual    | Xbox Live Networking Service
    # - NVIDIA services
    "NVDisplay.ContainerLocalSystem" # DEFAULT: Automatic | NVIDIA Display Container LS (NVIDIA Control Panel)
    "NvContainerLocalSystem"         # DEFAULT: Automatic | NVIDIA LocalSystem Container (GeForce Experience / NVIDIA Telemetry)
    # - Printer services
    #"PrintNotify"                   # DEFAULT: Manual    | WARNING! REMOVING WILL TURN PRINTING LESS MANAGEABLE | Printer Extensions and Notifications
    #"Spooler"                       # DEFAULT: Automatic | WARNING! REMOVING WILL DISABLE PRINTING              | Print Spooler
    # - Wi-Fi services
    #"WlanSvc"                       # DEFAULT: Manual (No Wi-Fi devices) / Automatic (Wi-Fi devices) | WARNING! REMOVING WILL DISABLE WI-FI | WLAN AutoConfig
    # - 3rd Party Services
    "gupdate"                        # DEFAULT: Automatic | Google Update Service
    "gupdatem"                       # DEFAULT: Manual    | Google Update Service²
)

Write-Title -Text "Services tweaks"
Write-Section -Text "Disabling services from Windows"

If ($Revert) {
    Write-Status -Types "<", "Service" -Status "Reverting the tweaks is set to '$Revert'." -Warning
    $CustomMessage = { "Resetting $Service ($((Get-Service $Service).DisplayName)) as 'Manual' on Startup ..." }
    Set-ServiceStartup -Manual -Services $ServicesToDisabled -Filter $EnableServicesOnSSD -CustomMessage $CustomMessage
}
Else {
    Set-ServiceStartup -Disabled -Services $ServicesToDisabled -Filter $EnableServicesOnSSD
}

Write-Section -Text "Enabling services from Windows"

If ($IsSystemDriveSSD -or $Revert) {
    $CustomMessage = { "The $Service ($((Get-Service $Service).DisplayName)) service works better in 'Automatic' mode on SSDs ..." }
    Set-ServiceStartup -Automatic -Services $EnableServicesOnSSD -CustomMessage $CustomMessage
}

Set-ServiceStartup -Manual -Services $ServicesToManual
}
Function Optimize-TaskScheduler() {
[CmdletBinding()]
param (
    [Switch] $Revert
)
Write-Host "`n" ; Write-TitleCounter -Counter '14' -MaxLength $MaxLength -Text "Optimize Task Scheduler"

# Adapted from: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations#task-scheduler
$DisableScheduledTasks = @(
    "\Microsoft\Office\OfficeTelemetryAgentLogOn"
    "\Microsoft\Office\OfficeTelemetryAgentFallBack"
    "\Microsoft\Office\Office 15 Subscription Heartbeat"
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "\Microsoft\Windows\Application Experience\StartupAppTask"
    "\Microsoft\Windows\Autochk\Proxy"
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         # Recommended state for VDI use
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"       # Recommended state for VDI use
    "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              # Recommended state for VDI use
    "\Microsoft\Windows\Defrag\ScheduledDefrag"                                       # Recommended state for VDI use
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "\Microsoft\Windows\Location\Notifications"                                       # Recommended state for VDI use
    "\Microsoft\Windows\Location\WindowsActionDialog"                                 # Recommended state for VDI use
    "\Microsoft\Windows\Maps\MapsToastTask"                                           # Recommended state for VDI use
    "\Microsoft\Windows\Maps\MapsUpdateTask"                                          # Recommended state for VDI use
    "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"                # Recommended state for VDI use
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"                   # Recommended state for VDI use
    "\Microsoft\Windows\Retail Demo\CleanupOfflineContent"                            # Recommended state for VDI use
    "\Microsoft\Windows\Shell\FamilySafetyMonitor"                                    # Recommended state for VDI use
    "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"                                # Recommended state for VDI use
    "\Microsoft\Windows\Shell\FamilySafetyUpload"
    "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"                          # Recommended state for VDI use
)

$EnableScheduledTasks = @(
    "\Microsoft\Windows\Maintenance\WinSAT"                     # WinSAT detects incorrect system configurations, that causes performance loss, then sends it via telemetry | Reference (PT-BR): https://youtu.be/wN1I0IPgp6U?t=16
    "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"        # Verify the Recovery Environment integrity, it's the Diagnostic tools and Troubleshooting when your PC isn't healthy on BOOT, need this ON.
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting" # Windows Error Reporting event, needed to improve compatibility with your hardware
)

Write-Title -Text "Task Scheduler tweaks"
Write-Section -Text "Disabling Scheduled Tasks from Windows"

If ($Revert) {
    Write-Status -Types "<", "TaskScheduler" -Status "Reverting the tweaks is set to '$Revert'." -Warning
    $CustomMessage = { "Resetting the $ScheduledTask task as 'Ready' ..." }
    Set-ScheduledTaskState -Ready -ScheduledTask $DisableScheduledTasks -CustomMessage $CustomMessage
}
Else {
    Set-ScheduledTaskState -Disabled -ScheduledTask $DisableScheduledTasks
}

Write-Section -Text "Enabling Scheduled Tasks from Windows"
Set-ScheduledTaskState -Ready -ScheduledTask $EnableScheduledTasks
}

# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2Xfh/3v+mfOi5NL3HQE8cp4I
# gg2gggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFGWVkYA1tIBT
# noZkzEb61zat//I5MA0GCSqGSIb3DQEBAQUABIIBAKIay2EnA8Nx9RlqiTQHgc0b
# LAgiiCOWaU2oejAr3TINPErzcH1LLQeCT+DGYqFkodicEg1f9G1F57PDCbFWxgVu
# 1EdTabvepSJWyf3yof1mufnFUmOLFNvABm/+CacFpUkLPgm8VVg0Hz7Of488yn5m
# obtH0KHDZww9m4ie1lePKPTXiyHaMGlGMpLMY20lWcPPt4OGvhVUu4jHr2hUlWvo
# ltHCzCx1lykQBqRzn8QRf4xUVPXaa/TjHoWXk+rSDaSD6Q48jzP4xG3wvlDxfKA7
# nOxcuA0OopXewXAf8HLdO9MiNjuMh7CTSxYQQ68GlukBI4qI2mVLe8SRQEyUx4s=
# SIG # End signature block
