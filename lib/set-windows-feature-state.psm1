$Global:SetWindowsLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
function Find-OptionalFeature() {
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $OptionalFeature
    )

    If (Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature) {
        return $true
    } Else {
        Write-Status -Types "?", $TweakType -Status "The $OptionalFeature optional feature was not found." -Warning
        return $false
    }
}

function Set-OptionalFeatureState() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch] $Disabled,
        [Parameter(Mandatory = $false)]
        [Switch] $Enabled,
        [Parameter(Mandatory = $true)]
        [Array] $OptionalFeatures,
        [Parameter(Mandatory = $false)]
        [Array] $Filter,
        [Parameter(Mandatory = $false)]
        [ScriptBlock] $CustomMessage
    )

    $Script:SecurityFilterOnEnable = @("IIS-*")
    $Script:TweakType = "OptionalFeature"

    ForEach ($OptionalFeature in $OptionalFeatures) {
        If (Find-OptionalFeature $OptionalFeature) {
            If (($OptionalFeature -in $SecurityFilterOnEnable) -and ($Enabled)) {
                Write-Status -Types "?", $TweakType -Status "Skipping $OptionalFeature ($((Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature).DisplayName)) to avoid a security vulnerability..." -Warning
                Continue
            }

            If ($OptionalFeature -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $OptionalFeature ($((Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature).DisplayName)) will be skipped as set on Filter..." -Warning
                Continue
            }

            If (!$CustomMessage) {
                If ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Uninstalling the $OptionalFeature ($((Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature).DisplayName)) optional feature..."
                } ElseIf ($Enabled) {
                    Write-Status -Types "+", $TweakType -Status "Installing the $OptionalFeature ($((Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature).DisplayName)) optional feature..."
                } Else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Enabled)" -Warning
                }
            } Else {
                Write-Status -Types "@", $TweakType -Status $(Invoke-Expression "$CustomMessage")
            }

            If ($Disabled) {
                Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart
            } ElseIf ($Enabled) {
                Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart
            }
        }
    }
}

<#
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3")
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3")
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3") -CustomMessage { "Uninstalling $OptionalFeature feature!"}

Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3")
Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3")
Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3") -CustomMessage { "Installing $OptionalFeature feature!"}
#>

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUFIpw+0mgsoltHJcPWDLkaQd/
# N2KgggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
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
# CQQxFgQUsgOvC70r35cqP6lsTOxTsltXC5wwDQYJKoZIhvcNAQEBBQAEggEAyOWN
# OKCn1UIR8miMWsY1gLq9vOqsbPkggk5n1+dPb5qe4//hI3VhRa3IYgcJl/EVDymy
# gnUxIv4gRbq3sIxCs/b+GQrcWb4SDq0z/esfzuY7ZdGgAdg415Yjv3wS9amcXZnh
# G0KdXwM/WTnKw9UAsIz26dedLlPygTfAZTiaGdanT+VCzAIKqNfkhGRGE1rUPttW
# Olv2HQHfMZdrQ7qUW7fYeRZ2FBN/zHlcBfUfJGl/AXwkG8QyNHE6tL6udUD/vpod
# Cf0jw4Jayvd+uKMuTtjXj5y07YXbB+2PA94e9WZEJSHl0p9VZ9ZnDC0lM/4Q0/Oi
# 3DbPH+HD2roCeGKimw==
# SIG # End signature block
