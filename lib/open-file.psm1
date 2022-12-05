Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"show-dialog-window.psm1"

function Open-PowerShellFilesCollection {
    [CmdletBinding()]
    param (
        [String] $RelativeLocation,
        [Array]  $Scripts,
        [String] $DoneTitle,
        [String] $DoneMessage,
        [Parameter(Mandatory = $false)]
        [Bool]   $OpenFromGUI = $true,
        [Switch] $NoDialog
    )

    Push-Location -Path $(Join-Path -Path "$PSScriptRoot\..\.." -ChildPath "$RelativeLocation")
    Get-ChildItem -Recurse *.ps*1 | Unblock-File

    ForEach ($FileName in $Scripts) {
        $LastAccessUtc = "v$((Get-Item "$FileName").LastWriteTimeUtc | Get-Date -Format "yyyy-MM-dd")"
        $Private:Counter = Write-TitleCounter -Text "$FileName ($LastAccessUtc)" -Counter $Counter -MaxLength $Scripts.Length
        If ($OpenFromGUI) {
            Import-Module -DisableNameChecking .\"$FileName" -Force
        } Else {
            PowerShell -NoProfile -ExecutionPolicy Bypass -File .\"$FileName"
        }
    }

    Pop-Location

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }
}

function Open-RegFilesCollection {
    [CmdletBinding()]
    param (
        [String] $RelativeLocation,
        [Array]  $Scripts,
        [String] $DoneTitle,
        [String] $DoneMessage,
        [Switch] $NoDialog
    )

    Push-Location -Path $(Join-Path -Path "$PSScriptRoot\..\.." -ChildPath "$RelativeLocation")

    ForEach ($FileName in $Scripts) {
        $LastAccessUtc = "v$((Get-Item "$FileName").LastWriteTimeUtc | Get-Date -Format "yyyy-MM-dd")"
        $Private:Counter = Write-TitleCounter -Text "$FileName ($LastAccessUtc)" -Counter $Counter -MaxLength $Scripts.Length
        regedit /s "$FileName"
    }

    Pop-Location

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }
}

<#
Example:
Open-PowerShellFilesCollection -RelativeLocation "src\scripts" -Scripts "script.ps1" -NoDialog
Open-PowerShellFilesCollection -RelativeLocation "src\scripts" -Scripts @("script1.ps1", "script2.ps1") -DoneTitle "Title" -DoneMessage "Message" -OpenFromGUI $false
Open-RegFilesCollection -RelativeLocation "src\scripts" -Scripts "script.reg" -NoDialog
Open-RegFilesCollection -RelativeLocation "src\scripts" -Scripts @("script1.reg", "script2.reg") -DoneTitle "Title" -DoneMessage "Message"
#>
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUdScFpp5H4Ddg6ZUjO5UeAuqp
# tC2gggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
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
# CQQxFgQUapA3LrJDqCVeiqR9c+ZoW52j25owDQYJKoZIhvcNAQEBBQAEggEAtwO6
# 6tAAOQmPa6sUDQIkxxfbro3zccCg7hswAT0tqyBnX5SrqIvOaxrLAw7TleM7tZCa
# H7hBTl/kYqVPaMuxAKO2gEdL2zjEc8c/ZPTK4n6+B2KdBSxuuADLYD4OfhBjKkBw
# 4rOyjolFGmrz1h8NtvXd/R/mG0uSZ1guP/GlZL63Ck6WsXBHLxdmexaS8e72M7X6
# qnpIYFVuZTPXj72MecADPZYCm/N4eStv3CnqUD4jEwEkMGX4Uxho0QdzJbN7/Srn
# kVHoWDgq9tXpU9iJjXiX6M3JKxVpgohXyjd9PQANkZ36kTrDjQoC4YPwF4xCJ7rJ
# 30xPk+0GDUoBcmReqA==
# SIG # End signature block
