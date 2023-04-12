$Global:SetServiceLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
function Find-Service() {
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $Service
    )

    If (Get-Service $Service -ErrorAction SilentlyContinue) {
        return $true
    } Else {
        Write-Status -Types "?", $TweakType -Status "The $Service service was not found." -Warning
        return $false
    }
}

function Set-ServiceStartup() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch] $Automatic,
        [Parameter(Mandatory = $false)]
        [Switch] $Disabled,
        [Parameter(Mandatory = $false)]
        [Switch] $Manual,
        [Parameter(Mandatory = $true)]
        [Array] $Services,
        [Parameter(Mandatory = $false)]
        [Array] $Filter,
        [Parameter(Mandatory = $false)]
        [ScriptBlock] $CustomMessage
    )

    $Script:SecurityFilterOnEnable = @("RemoteAccess", "RemoteRegistry")
    $Script:TweakType = "Service"

    ForEach ($Service in $Services) {
        If (Find-Service $Service) {
            If (($Service -in $SecurityFilterOnEnable) -and (($Automatic) -or ($Manual))) {
                Write-Status -Types "?", $TweakType -Status "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..." -Warning
                Continue
            }

            If ($Service -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..." -Warning
                Continue
            }

            If (!$CustomMessage) {
                If ($Automatic) {
                    Write-Status -Types "+", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Automatic' on Startup..."
                } ElseIf ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Disabled' on Startup..."
                } ElseIf ($Manual) {
                    Write-Status -Types "-", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Manual' on Startup..."
                } Else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Automatic, -Disabled or -Manual)" -Warning
                }
            } Else {
                Write-Status -Types "@", $TweakType -Status $(Invoke-Expression "$CustomMessage")
            }

            If ($Automatic) {
                Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType Automatic
            } ElseIf ($Disabled) {
                Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled
            } ElseIf ($Manual) {
                Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType Manual
            }
        }
    }
}

<#
Set-ServiceStartup -Automatic -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -Automatic -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
Set-ServiceStartup -Automatic -Services @("Service1", "Service2", "Service3") -Filter @("Service3") -CustomMessage { "Setting $Service as Automatic!"}

Set-ServiceStartup -Disabled -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -Disabled -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
Set-ServiceStartup -Disabled -Services @("Service1", "Service2", "Service3") -Filter @("Service3") -CustomMessage { "Setting $Service as Disabled!"}

Set-ServiceStartup -Manual -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -Manual -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
Set-ServiceStartup -Manual -Services @("Service1", "Service2", "Service3") -Filter @("Service3") -CustomMessage { "Setting $Service as Manual!"}
#>

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXgeXph64iI0Q67eJA0DxATEy
# wUGgggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
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
# CQQxFgQU4NfIymwrNzf3v/NhpXR0yiEpPLcwDQYJKoZIhvcNAQEBBQAEggEAQdAc
# DcAsVakkKYFysA5P0W7kszR4vlNu0Nx90MH688WlhystLhCtzxr6mI+t2Y8uqxbJ
# sANoyBX+minUUxcdlXHBAv79cMENOM2ICkNZWyz+JHeQnYpyPrhiKv70+9I2mPoT
# S00PCF4Aa6oZUoKM/yAUxW13D52C2hNfyT9X0AR0Q6PC3LMjurqT8tAnmPi+keLg
# o2V2pXf3cUJKa/jXVFbKKSA27ArNhuUZK5Ujh+BlG8B4w/ZbOxQaNg2a+VUlmEyK
# tGgR1C64IdGr4beLmHq7ORyGsJo2rtWHngCOPaA3lttfaWTo2kTLIXO9XAC3uMMX
# qCxEvqkdgruCQLNcZg==
# SIG # End signature block
