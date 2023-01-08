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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUuYio5RKj8tKiMXaPRgT6E0Q1
# YUqgggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQU/aOFHHc7UqOrzbkcZgvhUSmDah0wDQYJKoZIhvcNAQEBBQAEggEAh7oH
# 3ddqLtGXt2rNJp5TZJSUNt+c0cruNPG89R07xpegjPsML/LhQkqztO15MzAaW7La
# bzuu/5ow0PiOqVm7L/5/TmjzvRVNT5T2SJxwaMZCNBN34kqX8cDtn0RxK/kJ7A8c
# M6F8THHtj8QPLFV51n1lN0mqbSVqBzVrOlL3lk1RzHa01IgA7mdFLKJQzDNd9JUg
# G0OGV9EHUAAATkChxvVs+PbbycERzW9CkjrCMuqUna7UEDp+OoigkC21iGa+toEo
# duPN/kGC1v425hGjId6rwgYm57dr4KsN/1yG9g2kLnf9usaMSoCsyOws1M4jm7Ue
# +8plaq7aLWqnxaGlNQ==
# SIG # End signature block
