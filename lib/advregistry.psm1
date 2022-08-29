$Global:AdvRegistryLastUpdated = '20220829'
#Import-Module $PSScriptRoot\..\lib\"templates.psm1"
#Import-Module $PSScriptRoot\..\lib\"Variables.psm1"
Import-Module -DisableNameChecking .\lib\"templates.psm1"
Import-Module -DisableNameChecking .\lib\"Variables.psm1"

Function AdvRegistry() {
    [CmdletBinding()]
    param(
        [Switch] $Revert,
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1,
        [Array]  $EnableStatus = @(
            @{ Symbol = "-"; Status = "Disabling"; }
            @{ Symbol = "+"; Status = "Enabling"; }
        )
    )
    $TweakType = "Registry"
    Write-Host "`n" ; Write-TitleCounter -Counter '9' -MaxLength $MaxLength -Text "Applying Registry Changes"
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


    
    If ($One -ne '0'){
        Write-Section -Text "Removing Unnecessary Printers"
        Remove-Printer -Name "Microsoft XPS Document Writer"  -ErrorAction SilentlyContinue
        If ($?) {Write-Status -Types "-","Printer" -Status "Removed Microsoft XPS Document Writer..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
        Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue
        If ($?) {Write-Status -Types "-","Printer" -Status "Removed Microsoft XPS Document Writer..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
        Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue
        If ($?) {Write-Status -Types "-","Printer" -Status "Removed OneNote..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
    }
    
    
    If ($BuildNumber -lt $Win11) {
        ## Windows 10
        Write-Section -Text "Applying Windows 10 Specific Reg Keys"
        ## Changes search box to an icon
        If ((Get-ItemProperty -Path $PathToRegSearch).SearchBoxTaskbarMode -eq 1) { Write-Caption -Text "Skipping" } Else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Search Box to an Icon."
            Set-ItemProperty -Path $PathToRegSearch -Name "SearchboxTaskbarMode" -Value $OneTwo  
        }
        
        
        ## Removes Cortana from the taskbar
        If ((Get-ItemProperty -Path $PathToRegExplorerAdv).ShowCortanaButton -eq $Zero) { Write-Caption -Text "Skipping" } Else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cortana Button from Taskbar..."
            Set-ItemProperty -Path $PathToRegExplorerAdv -Name "ShowCortanaButton" -Value $Zero 
        }
        
        ## Unpins taskview from Windows 10 Taskbar
        If ((Get-ItemProperty -Path $PathToRegExplorerAdv).ShowTaskViewButton -eq $Zero) { Write-Caption -Text "Skipping" } else {
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
            
            If ((Get-ItemProperty -Path "$PathToRegExplorer\Ribbon").MinimizedStateTabletModeOff -eq $Zero) { Write-Caption -Text "Skipping" } else {
                Write-Status -Types "+","$TweakType" -Status "Expanding Explorer Ribbon.."
                Set-ItemProperty -Path $PathToRegExplorer\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero 
            }
            
            ## Disabling Feeds Open on Hover
            If ((Get-ItemProperty -Path $PathToRegCurrentVersion\Feeds).ShellFeedsTaskbarOpenOnHover -eq $Zero) { Write-Caption -Text "Skipping" } else {
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
        }
        
        if ($BuildNumber -ge $Win11) {
            ## Windows 11
            Write-Section -Text "Applying Windows 11 Specific Reg Keys"
            
            If ($BuildNumber -gt $22H2) {
                Write-Status -Types "+","$TweakType" -Status "Setting Start Layout to More Icons.."
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Start Menu to Show More Icons..."
                Set-ItemProperty -Path $PathToRegExplorerAdv -Name Start_Layout -Value $One -Type DWORD -Force 
            }

            If ((Get-ItemProperty $PathToRegExplorerAdv).UseCompactMode -eq $One){ Write-Caption -Text "Skipping" } else {
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Compact Mode View in Explorer "
                Set-ItemProperty -Path $PathToRegExplorerAdv -Name UseCompactMode -Value $One
            }
            If ((Get-ItemProperty -Path $PathToRegExplorerAdv).TaskbarMn -eq $Zero) { Write-Caption -Text "Skipping" } else {
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Chats from the Taskbar..."
                Set-ItemProperty -Path $PathToRegExplorerAdv -Name "TaskBarMn" -Value $Zero 
            }
            If (!(Test-Path $PathToRegCurrentVersion\Policies\Explorer)) {
                New-Item $PathToRegCurrentVersion\Policies\ -Name Explorer -Force | Out-Null
            }
            If ((Get-ItemProperty -Path "$PathToRegCurrentVersion\Policies\Explorer").HideSCAMeetNow -eq $One) { Write-Caption -Text "Skipping" } else {
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Meet Now from the Taskbar..."
                Set-ItemProperty -Path $PathToRegCurrentVersion\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value $One 
            }
        }


        Write-Section -Text "Explorer Related"

        ### Explorer related
        If ((Get-ItemProperty -Path $PathToRegExplorer).ShowRecent -eq $Zero) { Write-Caption -Text "Skipping" } else {
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Recents in Explorer..."
                Set-ItemProperty -Path $PathToRegExplorer -Name "ShowRecent" -Value $Zero 
            }
            
            If ((Get-ItemProperty -Path $PathToRegExplorer).ShowFrequent -eq $Zero) { Write-Caption -Text "Skipping" } else {
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Frequent in Explorer..."
                Set-ItemProperty -Path $PathToRegExplorer -Name "ShowFrequent" -Value $Zero 
            }
            
            If ((Get-ItemProperty -Path $PathToRegExplorerAdv).EnableSnapAssistFlyout -eq $One) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Snap Assist Flyout..."
            Set-ItemProperty -Path $PathToRegExplorerAdv -Name "EnableSnapAssistFlyout" -Value $One 
        }
        
        
        If ((Get-ItemProperty -Path $PathToRegExplorerAdv).LaunchTo -eq $OneTwo) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Setting Explorer Launch to This PC.."
            Set-ItemProperty -Path $PathToRegExplorerAdv -Name "LaunchTo" -Value $OneTwo 
        }
        
        If (!(Test-Path -Path "$PathToRegExplorerAdv\HideDesktopIcons")) {
            New-Item -Path "$PathToRegExplorerAdv" -Name HideDesktopIcons | Out-Null
            New-Item -Path "$PathToRegExplorerAdv\HideDesktopIcons" -Name NewStartPanel | Out-Null
        }
        $UsersFolder = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
        If ((Get-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel).$UsersFolder -eq $Zero) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) User Files to Desktop..."
            Set-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value $Zero 
        }
        
        $ThisPC = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
        If ((Get-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel).$ThisPC -eq $Zero) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Desktop..."
            Set-ItemProperty -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value $Zero 
        }
        
        If (!(Test-Path $PathToRegExplorer\OperationStatusManager)) {
            New-Item -Path $PathToRegExplorer\OperationStatusManager -Name EnthusiastMode -Type DWORD -Force | Out-Null
        }
        If ((Get-ItemProperty -Path $PathToRegExplorer\OperationStatusManager).EnthusiastMode -eq $One) { Write-Caption -Text "Skipping" } else {
            If (!(Test-Path "$PathToRegExplorer\OperationStatusManager")) {
                New-Item -Path "$PathToRegExplorer\OperationStatusManager" | Out-Null
            }
            Write-Status -Types "+","$TweakType" -Status "Expanding File Operation Details by Default.."
            Set-ItemProperty -Path "$PathToRegExplorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One 
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
        If ((Get-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI).DisableMFUTracking -eq $One) { Write-Caption -Text "Skipping" } else {
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
        
        If ((Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection).DoNotShowFeedbackNotifications -eq $One) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Feedback Notifications..."
            Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One 
        }
        
        
        If (!(Test-Path -Path:$regcam)) {
            New-Item -Path:$regcam -Force | Out-Null
        }
        If ((Get-ItemProperty -Path "$regcam" -Name Value).Value -eq "Deny") { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Location Tracking..."
            Set-ItemProperty -Path "$regcam" -Name "Value" -Type String -Value "Deny" 
        }
        
        
        
        If ((Get-ItemProperty -Path $lfsvc -Name Status).Status -eq $Zero) { Write-Caption -Text "Skipping" } else {
            Set-ItemProperty -Path "$lfsvc" -Name "Status" -Type DWORD -Value $Zero 

        }
        
        
        
        If ((Get-ItemProperty -Path HKLM:\System\Maps).AutoUpdateEnabled -eq $Zero) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Automatic Map Updates..."
            Set-ItemProperty -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $Zero 
        }
        
        
        If (!(Test-Path -Path $wifisense\AllowWiFiHotSpotReporting)) {
            New-Item -Path $wifisense\AllowWiFiHotSpotReporting -Force | Out-Null
        }
        If ((Get-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots).Value -eq $Zero) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) AutoConnect to Sense Hotspots..."
            Set-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value $Zero 
        }
        If ((Get-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting).Value -eq $Zero) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Hotspot Reporting to Microsoft..."
            Set-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value $Zero 
        }
        
        
        
        $cloudcontent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        If (!(Test-Path -Path $cloudcontent)) {
            New-Item -Path $cloudcontent -Force | Out-Null
        }
        If ((Get-ItemProperty -Path $cloudcontent).DisableWindowsConsumerFeatures -eq $One) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cloud Content from Windows Search..."
            Set-ItemProperty -Path $cloudcontent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $One 
        }
        
        
        $key1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
        $key2 = "TailoredExperiencesWithDiagnosticDataEnabled"
        If ((Get-ItemProperty -Path $key1).$key2 -eq $Zero) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experience w/ Diagnostic Data..."
            Set-ItemProperty -Path $key1 -Name "$key2" -Value $Zero -Type DWORD -Force 
        }
        
        Write-Status -Types "+","$TweakType" -Status "Stopping and disabling Home Groups services.. LOL"
        If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { Write-Caption -Text "Skipping" } else {
            Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
            Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue  
        }
        If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { Write-Caption -Text "Skipping" } else {
            Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
            Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue  
        }
        
        If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped') { Write-Caption -Text "Skipping" } else {
            Write-Host ' Stopping and disabling Superfetch service'
            
            Stop-Service "SysMain" -WarningAction SilentlyContinue
            Set-Service "SysMain" -StartupType Disabled 
        }
        
        If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\MultiMedia\Audio).UserDuckingPreference -eq 3) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Volume Adjustment During Calls..."
            Set-ItemProperty -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD 
        }
        
        $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
        If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control).SvcHostSplitThresholdInKB -eq $ram) { Write-Caption -Text "Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Grouping svchost.exe Processes"
            Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram -Force 
        }
        
        If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters).IRPStackSize -eq 30) { Write-Caption -Text "Skipping" } else {
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

        
            
        If ($vari -eq '2') {
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Force -EA SilentlyContinue
            Remove-ItemProperty -Path $PathToRegInputPersonalization -Name "RestrictImplicitTextCollection" -Force -EA SilentlyContinue
            Remove-ItemProperty -Path $PathToRegInputPersonalization -Name "RestrictImplicitInkCollection" -Force -EA SilentlyContinue
            Set-Service "DiagTrack" -StartupType Automatic -EA SilentlyContinue
            Set-Service "dmwappushservice" -StartupType Automatic -EA SilentlyContinue
            Set-Service "SysMain" -StartupType Automatic -EA SilentlyContinue
        }
}

# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURVdDfr/5dhBpuZEdTu56gGEH
# lo2gggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFJWY1BdCS/Fp
# bQO05GzFT5CC+8sWMA0GCSqGSIb3DQEBAQUABIIBAGZwx7ILfWy+TMtu9VjDD7EH
# oAOUJmwssKxN8q14/+NJwEgbVvS2aR9zK6V2u4Xf7rYWEbXSPBjGExvl1Dgi2OUD
# GQgDeRx8n2ny7Ulw6wH95FlgCb1HynNk/hJA7J8BmIb6urmyl0045KexLXsmppzS
# ubuYAX1SUynUArA82I7s++T7JF3Pd2tdR6PmciQNjI4zAso5lM9Vsze+Z7x0aB3h
# yHE/bjZUAxazHKq23mUP64UgYFaAb16v99gjkpwJHG4UNZRJKVjLKaWJo3xJEQlc
# XUUfHfPsT95xWn6LaIZ/1y5Bm9nIsQhphNn2EmRiPq0Tc4PfLH+fhpD5aJnih20=
# SIG # End signature block
