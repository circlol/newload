Function Optimize-Windows() {
    param(
        [Switch] $Revert,
        [Int]    $Zero = 0,
        [Int]    $One = 1
    )
    
    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )
    
    If (($Revert)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -Warning
        $Zero = 1
        $One = 0
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }

$TweakType = "Registry"
Write-Host "`n" ; Write-TitleCounter -Counter '9' -MaxLength $MaxLength -Text "Optimization"


If ($One -ne '0'){
    Write-Section -Text "Removing Unnecessary Printers"
    Remove-Printer -Name "Microsoft XPS Document Writer"  -ErrorAction SilentlyContinue
    If ($?) {Write-Status -Types "-","Printer" -Status "Removed Microsoft XPS Document Writer..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
    Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue
    If ($?) {Write-Status -Types "-","Printer" -Status "Removed Microsoft XPS Document Writer..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
    Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue
    If ($?) {Write-Status -Types "-","Printer" -Status "Removed OneNote..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
}
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$osVersion = $os.Caption

If ($osVersion -like "*10*") {
    # code for Windows 10
    Write-Section -Text "Applying Windows 10 Specific Reg Keys"
    ## Changes search box to an icon
    If ((Get-ItemProperty -Path $PathToRegSearch).SearchBoxTaskbarMode -eq 1) { } Else {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Search Box to an Icon."
        Set-ItemProperty -Path $PathToRegSearch -Name "SearchboxTaskbarMode" -Value $OneTwo  
    }
    
    
    ## Removes Cortana from the taskbar
    If ((Get-ItemProperty -Path $PathToRegExplorerAdv).ShowCortanaButton -eq $Zero) { } Else {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cortana Button from Taskbar..."
        Set-ItemProperty -Path $PathToRegExplorerAdv -Name "ShowCortanaButton" -Value $Zero 
    }
    
    ## Unpins taskview from Windows 10 Taskbar
    If ((Get-ItemProperty -Path $PathToRegExplorerAdv).ShowTaskViewButton -eq $Zero) { } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Task View from Taskbar..."
            Set-ItemProperty -Path $PathToRegExplorerAdv -Name "ShowTaskViewButton" -Value $Zero 
        }
        
        ##  Hides 3D Objects from "This PC"
        If (Test-Path -Path "$PathToRegExplorerLocalMachine\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}") {
            Write-Status -Types "-","$TweakType" -Status "Removing 3D Objects from This PC.."
            Remove-Item -Path "$PathToRegExplorerLocalMachine\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse 
        }
        
        ## Expands explorers ribbon
        If (!(Test-Path -Path $PathToRegExplorer\Ribbon)) {
            New-Item -Path "$PathToRegExplorer" -Name "Ribbon" -Force | Out-Null
        }
        
        If ((Get-ItemProperty -Path "$PathToRegExplorer\Ribbon").MinimizedStateTabletModeOff -eq $Zero) { } else {
            Write-Status -Types "+","$TweakType" -Status "Expanding Explorer Ribbon.."
            Set-ItemProperty -Path $PathToRegExplorer\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero 
        }
        
        ## Disabling Feeds Open on Hover
        If ((Get-ItemProperty -Path $PathToRegCurrentVersion\Feeds).ShellFeedsTaskbarOpenOnHover -eq $Zero) { } else {
            If (!(Test-Path -Path $PathToRegCurrentVersion\Feeds)) {
                New-Item -Path $PathToRegCurrentVersion -Name "Feeds" | Out-Null
            }
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Feeds Open on Hover..."
            Set-ItemProperty -Path $PathToRegCurrentVersion\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value $Zero 
        }
        
        #Disables live feeds in search
        If (!(Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB")) {
            New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "DSB" -Force | Out-Null
        }
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Dynamic Content in Windows Search..."
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "ShowDynamicContent" -Value $Zero -type DWORD -Force 
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value $Zero -Type DWORD -Force    
}elseif ($osVersion -like "*11*") {
        ## Code for Windows 11
        Write-Section -Text "Applying Windows 11 Specific Reg Keys"
        If ($BuildNumber -GE $22H2) {
            Write-Status -Types "+","$TweakType" -Status "Setting Start Layout to More Icons.."
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Start Menu to Show More Icons..."
            Set-ItemProperty -Path $PathToRegExplorerAdv -Name Start_Layout -Value $One -Type DWORD -Force
        }

        If ((Get-ItemProperty $PathToRegExplorerAdv).UseCompactMode -eq $One){ } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Compact Mode View in Explorer "
            Set-ItemProperty -Path $PathToRegExplorerAdv -Name UseCompactMode -Value $One
        }
        If ((Get-ItemProperty -Path $PathToRegExplorerAdv).TaskbarMn -eq $Zero) { } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Chats from the Taskbar..."
            Set-ItemProperty -Path $PathToRegExplorerAdv -Name "TaskBarMn" -Value $Zero 
        }
        If (!(Test-Path $PathToRegCurrentVersion\Policies\Explorer)) {
            New-Item $PathToRegCurrentVersion\Policies\ -Name Explorer -Force | Out-Null
        }
        If ((Get-ItemProperty -Path "$PathToRegCurrentVersion\Policies\Explorer").HideSCAMeetNow -eq $One) { } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Meet Now from the Taskbar..."
            Set-ItemProperty -Path $PathToRegCurrentVersion\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value $One 
        }
}else {
    # code for other operating systems
    # Check Windows version
    Throw{"
    Don't know what happened. Closing" ; exit}
}

    Write-Section -Text "Explorer Related"

    ### Explorer related
    If ((Get-ItemProperty -Path $PathToRegExplorer).ShowRecent -eq $Zero) { } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Recents in Explorer..."
            Set-ItemProperty -Path $PathToRegExplorer -Name "ShowRecent" -Value $Zero 
        }
        
        If ((Get-ItemProperty -Path $PathToRegExplorer).ShowFrequent -eq $Zero) { } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Frequent in Explorer..."
            Set-ItemProperty -Path $PathToRegExplorer -Name "ShowFrequent" -Value $Zero 
        }
        
        If ((Get-ItemProperty -Path $PathToRegExplorerAdv).EnableSnapAssistFlyout -eq $One) { } else {
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Snap Assist Flyout..."
        Set-ItemProperty -Path $PathToRegExplorerAdv -Name "EnableSnapAssistFlyout" -Value $One 
    }
    
    
    If ((Get-ItemProperty -Path $PathToRegExplorerAdv).LaunchTo -eq $OneTwo) { } else {
        Write-Status -Types "+","$TweakType" -Status "Setting Explorer Launch to This PC.."
        Set-ItemProperty -Path $PathToRegExplorerAdv -Name "LaunchTo" -Value $OneTwo 
    }
    
    If (!(Test-Path -Path "$PathToRegExplorerAdv\HideDesktopIcons")) {
        New-Item -Path "$PathToRegExplorerAdv" -Name HideDesktopIcons | Out-Null
        New-Item -Path "$PathToRegExplorerAdv\HideDesktopIcons" -Name NewStartPanel | Out-Null
    }
    $UsersFolder = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
    If ((Get-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel).$UsersFolder -eq $Zero) { } else {
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) User Files to Desktop..."
        Set-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value $Zero 
    }
    
    $ThisPC = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    If ((Get-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel).$ThisPC -eq $Zero) { } else {
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Desktop..."
        Set-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value $Zero 
    }
    
    If (!(Test-Path $PathToRegExplorer\OperationStatusManager)) {
        New-Item -Path $PathToRegExplorer\OperationStatusManager -Name EnthusiastMode -Type DWORD -Force | Out-Null
    }
    If ((Get-ItemProperty -Path $PathToRegExplorer\OperationStatusManager).EnthusiastMode -eq $One) { } else {
        If (!(Test-Path "$PathToRegExplorer\OperationStatusManager")) {
            New-Item -Path "$PathToRegExplorer\OperationStatusManager" | Out-Null
        }
        Write-Status -Types "+","$TweakType" -Status "Expanding File Operation Details by Default.."
        Set-ItemProperty -Path "$PathToRegExplorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One 
    }
    


                    $TweakType = "Performance"


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
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2 #-ErrorAction SilentlyContinue -Force

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




                        $TweakType = "Privacy"



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

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
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
Set-ItemProperty -Path "$PathToCUInputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
Set-ItemProperty -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
Set-ItemProperty -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero -ErrorAction SilentlyContinue

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
Write-Section -Text "Privacy"
### Privacy
#Write-Host ' Disabling Content Delivery Related Setings'
If (Test-Path -Path $PathToRegContentDelivery\Subscriptionn) {
    Remove-Item -Path $PathToRegContentDelivery\Subscriptionn -Recurse -Force
}
If (Test-Path -Path $PathToRegContentDelivery\SuggestedApps) {
    Remove-Item -Path $PathToRegContentDelivery\SuggestedApps -Recurse -Force
}


If (!(Test-Path -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI)) {
    New-Item -Path:HKCU:\Software\Policies\Microsoft\Windows -Name "EdgeUI" | Out-Null
}
If ((Get-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI).DisableMFUTracking -eq $One) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) App Launch Tracking..."
    Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $One -Type DWORD 
}
If ($vari -eq '2') {
    Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force -ErrorAction SilentlyContinue
}
### Disables Feedback to Microsoft.
If (!(Test-Path -Path $PathToCUSiufRules)) { 
    New-Item -Path $PathToCUSiufRules -Name "Siuf" -ErrorAction SilentlyContinue | Out-Null
}
If (!(Test-Path -Path $PathToCUSiufRules)) {
    New-Item -Path $PathToCUSiufRules -Name "Rules" -ErrorAction SilentlyContinue | Out-Null
}

If ((Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection).DoNotShowFeedbackNotifications -eq $One) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Feedback Notifications..."
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One 
}


If (!(Test-Path -Path:$regcam)) {
    New-Item -Path:$regcam -Force | Out-Null
}
If ((Get-ItemProperty -Path "$regcam" -Name Value).Value -eq "Deny") { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Location Tracking..."
    Set-ItemProperty -Path "$regcam" -Name "Value" -Type String -Value "Deny" 
}



If ((Get-ItemProperty -Path $lfsvc -Name Status).Status -eq $Zero) { } else {
    Set-ItemProperty -Path "$lfsvc" -Name "Status" -Type DWORD -Value $Zero 

}



If ((Get-ItemProperty -Path HKLM:\System\Maps).AutoUpdateEnabled -eq $Zero) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Automatic Map Updates..."
    Set-ItemProperty -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $Zero 
}


If (!(Test-Path -Path $PathToWifiSense\AllowWiFiHotSpotReporting)) {
    New-Item -Path $PathToWifiSense\AllowWiFiHotSpotReporting -Force | Out-Null
}
If ((Get-ItemProperty -Path $PathToWifiSense\AllowAutoConnectToWiFiSenseHotspots).Value -eq $Zero) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) AutoConnect to Sense Hotspots..."
    Set-ItemProperty -Path $PathToWifiSense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value $Zero 
}
If ((Get-ItemProperty -Path $PathToWifiSense\AllowWiFiHotSpotReporting).Value -eq $Zero) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Hotspot Reporting to Microsoft..."
    Set-ItemProperty -Path $PathToWifiSense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value $Zero 
}


If (!(Test-Path -Path $PathToLMPoliciesCloudContent)) {
    New-Item -Path $PathToLMPoliciesCloudContent -Force | Out-Null
}
If ((Get-ItemProperty -Path $PathToLMPoliciesCloudContent).DisableWindowsConsumerFeatures -eq $One) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cloud Content from Windows Search..."
    Set-ItemProperty -Path $PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $One 
}


If ((Get-ItemProperty -Path $PathToPrivacy).TailoredExperiencesWithDiagnosticDataEnabled -eq $Zero) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experience w/ Diagnostic Data..."
    Set-ItemProperty -Path $PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value $Zero -Type DWORD -Force 
}

Write-Status -Types "+","$TweakType" -Status "Stopping and disabling Home Groups services.. LOL"
If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
    Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue  
}
If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
    Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue  
}

If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped') { } else {
    Write-Host ' Stopping and disabling Superfetch service'
    
    Stop-Service "SysMain" -WarningAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled 
}

If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\MultiMedia\Audio).UserDuckingPreference -eq 3) { } else {
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Volume Adjustment During Calls..."
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD 
}

$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control).SvcHostSplitThresholdInKB -eq $ram) { } else {
    Write-Status -Types "+","$TweakType" -Status "Grouping svchost.exe Processes"
    Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram -Force 
}

If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters).IRPStackSize -eq 30) { } else {
    Write-Status -Types "+","$TweakType" -Status "Increasing Stack Size to 30"
    Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30 
}

If (Get-Command Set-DnsClientDohServerAddress -ErrorAction SilentlyContinue){
    
    ## Imported text from  win10-debloat-tools on github 
    # Adapted from: https://techcommunity.microsoft.com/t5/networking-blog/windows-insiders-gain-new-dns-over-https-controls/ba-p/2494644
    Write-Status -Types "+", $TweakType -Status "Setting up the DNS over HTTPS for Google and Cloudflare (ipv4 and ipv6)..."
    Set-DnsClientDohServerAddress -ServerAddress ("8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844") -AutoUpgrade $true -AllowFallbackToUdp $true
    Set-DnsClientDohServerAddress -ServerAddress ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001") -AutoUpgrade $true -AllowFallbackToUdp $true
    Write-Status -Types "+", $TweakType -Status "Setting up the DNS from Cloudflare and Google (ipv4 and ipv6)..."
    #Get-DnsClientServerAddress # To look up the current config.           # Cloudflare, Google,         Cloudflare,              Google
    Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
    Set-DNSClientServerAddress -InterfaceAlias    "Wi-Fi*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
} else {
    Write-Status -Types "?", $TweakType -Status "Failed to set up DNS - DNSClient is not Installed..."
}


Write-Status -Types "+", $TweakType -Status "Bringing back F8 alternative Boot Modes..."
bcdedit /set `{current`} bootmenupolicy Legacy

Write-Section -Text "Ease of Access"
Write-Caption -Text "Keyboard"
$PathToCUAccessibility = "HKCU:\Control Panel\Accessibility"
Write-Status -Types "-", $TweakType -Status "Disabling Sticky Keys..."
Set-ItemProperty -Path "$PathToCUAccessibility\StickyKeys" -Name "Flags" -Value "506"
Set-ItemProperty -Path "$PathToCUAccessibility\Keyboard Response" -Name "Flags" -Value "122"
Set-ItemProperty -Path "$PathToCUAccessibility\ToggleKeys" -Name "Flags" -Value "58"


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
}Catch{Continue}


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
    Set-ItemProperty -Path "$PathToCUPoliciesCloudContent" -Name "$Name" -Type DWord -Value $One -ErrorAction SilentlyContinue
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

#Write-Status -Types "?", $TweakType -Status "For more tweaks, edit the '$PSCommandPath' file, then uncomment '#SomethingHere' code lines" -Warning
# Consumes more RAM - Make Windows Defender run in Sandbox Mode (MsMpEngCP.exe and MsMpEng.exe will run on background)
# Details: https://www.microsoft.com/security/blog/2018/10/26/windows-defender-antivirus-can-now-run-in-a-sandbox/
#Write-Status -Types "+", $TweakType -Status "Enabling Windows Defender Sandbox mode..."
#setx /M MP_FORCE_USE_SANDBOX 1  # Restart the PC to apply the changes, 0 to Revert

# Disable Windows Script Host. CAREFUL, this may break stuff, including software uninstall.
#Write-Status -Types "+", $TweakType -Status "Disabling Windows Script Host (execution of *.vbs scripts and alike)..."
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type DWord -Value 0



                $TweakType = "Services"

$IsSystemDriveSSD = $(Get-OSDriveType) -eq "SSD"
$EnableServicesOnSSD = @("SysMain", "WSearch")

# Services which will be totally disabled
$ServicesToDisabled = @(
    "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
    "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
    "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
    "BthAvctpSvc"                               # DEFAULT: Manual    | AVCTP Service - This is Audio Video Control Transport Protocol service
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
    "NPSMSvc_df772"
    "LanmanServer"

)

# Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
$ServicesToManual = @(
    "BITS"                           # DEFAULT: Manual    | Background Intelligent Transfer Service
    "BDESVC"                         # DEFAULT: Manual    | BItLocker Drive Encryption Service
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
    "DisplayEnhancementService"      # DEFAULT: Manual    | A service for managing display enhancement such as brightness control.
    "DispBrokerDesktopSvc"           # DEFAULT: Automatic | Manages the connection and configuration of local and remote displays
    
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




                        $TweakType = "TaskScheduler"

# Adapted from: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations#task-scheduler
$DisableScheduledTasks = @(
    "\Microsoft\Office\OfficeTelemetryAgentLogOn"
    "\Microsoft\Office\OfficeTelemetryAgentFallBack"
    "\Microsoft\Office\Office 15 Subscription Heartbeat"
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "\Microsoft\Windows\Autochk\Proxy"
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         # Recommended state for VDI use
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"       # Recommended state for VDI use
    "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              # Recommended state for VDI use
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
    "\Microsoft\Windows\Defrag\ScheduledDefrag"                 # Defragments all internal storages connected to your computer
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
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUAlihS6AAA9XNN9FS7/l88ybG
# 13ygggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIyMTIyNDA1
# MDQzMloXDTIzMTIyNDA1MjQzMlowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKBzm18SMDaGJ9ft
# 4mCIOUCCNB1afaXS8Tx2dAnJ+84pGS4prKCxc7/F+n5uqXtPZcl88tr9VR1N/BBE
# Md4LWvD2o/k5WfkYPtBoatldnZs9d1HBgIrWJoulc3PidboCD4Xz9Z9ktfrcmhc8
# MfDD0DfSKswyi3N9L6t8ZRdLUW+JCh/1WHbt7o3ckvijEuKh9AOnzYtkXJfE+eRd
# DKK2sq46WlZG2Sm3J+WOo2oeoFvvYHRG9RtzSY2EhmVRYWzGFM/GCqLUbh2wZwdY
# uG61lCrkC6ZjEYPhs5ckoijMFC6bb4zYk4lYDzartHYiMxH1Ac0jNpaq+7kB3oRF
# QLXWc+kCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBRkAPIg1GpPJcyyzANerOe2sUGidTANBgkqhkiG9w0BAQsF
# AAOCAQEABc3czHPSCyEDQ9MzWSiW7EhjXsyyj6JfP0a2onvRPoW0EzBq3BxwpGGJ
# btML2ST94OmT8huibh8Cp2TnbAAxIhNU0tN3XMz2AXfJT5cr4MdHGDksiMj1Hcjn
# wxXAf6uYX3+jovGZbgpog0KUk88p2vhU1oZP0YpaRaOqnjUH+Ml4g1fOx8siBmGu
# vs9L+Kb5w2W8TjCBuGqGY4d8chxQe8A0ViZtp4LB+/1NAkt14GTwqOdWrKNIynMz
# Rpa+Wkey1J0tG5AhNp0hvwmAO6KFSGtXHuNWwua9IpLMJsowj2U2TmzqLSDC2YrO
# BgC97m41lByepRPQwnnV3p8NFn4CyTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQbsRA190DwbdBuskmJyNY4jAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUbGxxFY/QmDaz6j8SgDoMpZ6XDRAwDQYJKoZIhvcNAQEBBQAEggEAnVLn
# mPkJ10ZfrnwMcM26DHs7KUES+6G5KkzIxWIhyHQchVPsiU0/8P8z40jExdjiNjK8
# 2nxfZyEJzX9ZWJwoeYS0x9/PZU/W6Kypco+buCQ1gx89i821+cnMK1ijN2ScQlK2
# 5GFALDDH/hLCPUtE5U5fdgB5jkJQmTUcHbodYriWje1VUs+IeUKzSviqcF0MJAdQ
# OaE749zjzCjxSVb3fnBZwwJbxPy4mlEkaZSVTx3DXezjYfsaQ/NwglIjTs7OI2HU
# hCFXes57U9bOKaZTB6gmJbWRq5sx4ozKfe88y2IOvdlFJMMOXs4tXDPm+nHsxnpL
# tqVs/ssCIWu0Qdu9xg==
# SIG # End signature block
