$Global:ManageSoftwareLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"show-dialog-window.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

function Install-Software() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [String]      $Name,
        [Array]       $Packages,
        [ScriptBlock] $InstallBlock = { winget install --silent --source "winget" --id $Package },
        [Parameter(Mandatory = $false)]
        [Switch]      $NoDialog,
        [String]      $PkgMngr = 'Winget',
        [Switch]      $ViaChocolatey,
        [Switch]      $ViaMSStore,
        [Switch]      $ViaWSL
    )

    $DoneTitle = "Information"
    $DoneMessage = "$Name installed successfully!"

    If ($ViaChocolatey) {
        $ViaMSStore, $ViaWSL = $false, $false
        $PkgMngr = 'Chocolatey'
        $InstallBlock = { choco install --ignore-dependencies --yes $Package }
        Write-Status -Types "?" -Status "Chocolatey is configured to ignore dependencies (bloat), you may need to install it before using any program." -Warning
    }

    If ($ViaMSStore) {
        $ViaChocolatey, $ViaWSL = $false, $false
        $PkgMngr = 'Winget (MS Store)'
        $InstallBlock = { winget install --source "msstore" --id $Package --accept-package-agreements }
    }

    If ($ViaWSL) {
        $ViaChocolatey, $ViaMSStore = $false, $false
        $PkgMngr = 'WSL'
        $InstallBlock = { wsl --install --distribution $Package }
    }

    Write-Title "Installing $($Name) via $PkgMngr"
    $DoneMessage += "`n`nInstalled via $PkgMngr`:`n"

    ForEach ($Package in $Packages) {
        If ($ViaMSStore) {
            Write-Status -Types "?" -Status "Reminder: Press 'Y' and ENTER to continue if stuck (1st time only) ..." -Warning
            $PackageName = (winget search --source 'msstore' --exact $Package)[-1].Replace("$Package Unknown", '').Trim(' ')
            $Private:Counter = Write-TitleCounter -Text "$Package - $PackageName" -Counter $Counter -MaxLength $Packages.Length
        } Else {
            $Private:Counter = Write-TitleCounter -Text "$Package" -Counter $Counter -MaxLength $Packages.Length
        }

        Try {
            Invoke-Expression "$InstallBlock" | Out-Host
            If (($LASTEXITCODE)) { throw "Couldn't install package." } # 0 = False, 1 = True

            If ($ViaMSStore) {
                $DoneMessage += "+ $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "+ $Package`n"
            }
        } Catch {
            Write-Status -Types "!" -Status "Failed to install package via $PkgMngr" -Warning

            If ($ViaMSStore) {
                Start-Process "ms-windows-store://pdp/?ProductId=$Package"
                $DoneMessage += "! $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "! $Package`n"
            }
        }
    }

    Write-Host "$DoneMessage" -ForegroundColor Cyan

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }

    return $DoneMessage
}

function Uninstall-Software() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [String]      $Name,
        [Array]       $Packages,
        [ScriptBlock] $UninstallBlock = { winget uninstall --source "winget" --id $Package },
        [Parameter(Mandatory = $false)]
        [Switch]      $NoDialog,
        [String]      $PkgMngr = 'Winget',
        [Switch]      $ViaChocolatey,
        [Switch]      $ViaMSStore,
        [Switch]      $ViaWSL
    )

    $DoneTitle = "Information"
    $DoneMessage = "$Name uninstalled successfully!"

    If ($ViaChocolatey) {
        $ViaMSStore, $ViaWSL = $false, $false
        $PkgMngr = 'Chocolatey'
        $UninstallBlock = { choco uninstall --remove-dependencies --yes $Package }
        Write-Status -Types "?" -Status "Chocolatey is configured to remove dependencies (bloat), you may need to install it before using any program." -Warning
    }

    If ($ViaMSStore) {
        $ViaChocolatey, $ViaWSL = $false, $false
        $PkgMngr = 'Winget (MS Store)'
        $UninstallBlock = { winget uninstall --source "msstore" --id $Package }
    }

    If ($ViaWSL) {
        $ViaChocolatey, $ViaMSStore = $false, $false
        $PkgMngr = 'WSL'
        $UninstallBlock = { wsl --unregister $Package }
    }

    Write-Title "Uninstalling $($Name) via $PkgMngr"
    $DoneMessage += "`n`nUninstalled via $PkgMngr`:`n"

    ForEach ($Package in $Packages) {
        If ($ViaMSStore) {
            $PackageName = (winget search --source 'msstore' --exact $Package)[-1].Replace("$Package Unknown", '').Trim(' ')
            $Private:Counter = Write-TitleCounter -Text "$Package - $PackageName" -Counter $Counter -MaxLength $Packages.Length
        } Else {
            $Private:Counter = Write-TitleCounter -Text "$Package" -Counter $Counter -MaxLength $Packages.Length
        }

        Try {
            Invoke-Expression "$UninstallBlock" | Out-Host
            If (($LASTEXITCODE)) { throw "Couldn't uninstall package." } # 0 = False, 1 = True

            If ($ViaMSStore) {
                $DoneMessage += "- $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "- $Package`n"
            }
        } Catch {
            Write-Status -Types "!" -Status "Failed to uninstall package via $PkgMngr" -Warning

            If ($ViaMSStore) {
                $DoneMessage += "! $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "! $Package`n"
            }
        }
    }

    Write-Host "$DoneMessage" -ForegroundColor Cyan

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }

    return $DoneMessage
}

<#
Example:
Install-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser"
Install-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser" -NoDialog
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey -NoDialog
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore -NoDialog
Install-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL
Install-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL -NoDialog

Uninstall-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser"
Uninstall-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser" -NoDialog
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey -NoDialog
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore -NoDialog
Uninstall-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL
Uninstall-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL -NoDialog
#>

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUx4yha1AIisx5uQHcJ76RWEVc
# WvWgggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
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
# CQQxFgQUoX+t7g4kuBmgUsaiBobzvlA5+WkwDQYJKoZIhvcNAQEBBQAEggEAKsGU
# YVtWKO1qTmc/YqeTKUYSzQmE5ajfcvSKWKNiwMq/RD9qxft4pnpBhMmRtASl/1CA
# AXRz3phjHTJLuFJL6BGEXmvgU0TPTk/Xx6Ix5Z5dICS9Xs48uTfcAeklEgX5ypio
# Aw2/iY9TbItiDOBPpXTXPCRiQPln4RDqkSsHHo5K7mriH78Wn9YdXsczx4fmKr37
# Ausp/zXMmBmxiL4L8bPJJ9BmnmR1EeFamUXNzIe2ZHgX896SJ4TcpV5JY1QojbJZ
# Bpjx5p/wG4a0K4vLdS09Gfs7Ml+wh8VrBEbUHKPCHTmT0HHdUHHJnxH7XpeLHs6j
# Gbx40LL6Ig9U9AUDcw==
# SIG # End signature block
