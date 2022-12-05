$Global:AdvRegistryLastUpdated = '20220830'
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
            If ($BuildNumber -GE $22H2) {
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
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqeN+CaW+V4uFx5Q4S64XzjfL
# JGmgggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
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
# CQQxFgQUIW4p4en+c3Ja6PGfdX1BJClRi+0wDQYJKoZIhvcNAQEBBQAEggEAEips
# UqadWzptaJgouEf7f5T+PERuuvAIqga3zFZELxnfc9YSnB3au3Y0gLaa4Rm5v5+t
# mS8LCT8mL+5oRc5Jidoj6769v6w0zGQZKpJn2gqsXxzAaAMVK27aZ1+es9FHteXy
# 2N8vucyVK6mhrvrRmlSJ4w7Zz0jNhHTHX2AAWSQRDbPBAJh9IcChj55/JSfgygDL
# 7jkr6mCvSX43zOCxuH2J1+RYG2VynW1b95+b97fdKwGA8S84C5J4Xr1t5ToCMDSe
# Auc6AVxsDApZb81L3O+wrf5MKaNWc349SrcUhNTKGR2jDjfDyrDBsz5TPaWYeu0B
# rlDOp4O7U7FDaibSng==
# SIG # End signature block
