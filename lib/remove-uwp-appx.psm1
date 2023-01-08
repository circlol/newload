function Remove-UWPAppx() {
    [CmdletBinding()]
    param (
        [Array] $AppxPackages
    )

    $TweakType = "UWP"
    ForEach ($AppxPackage in $AppxPackages) {
        If ((Get-AppxPackage -AllUsers -Name $AppxPackage) -or (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage)) {
            Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage from ALL users..."
            Get-AppxPackage -AllUsers -Name $AppxPackage | Remove-AppxPackage # App
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers # Payload
        } Else {
            Write-Status -Types "?", $TweakType -Status "$AppxPackage was already removed or not found..." -Warning
        }
    }
}

<#
Example:
Remove-UWPAppx -AppxPackages "AppX1"
Remove-UWPAppx -AppxPackages @("AppX1", "AppX2", "AppX3")
#>


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzLDsNupS4l7Ju44/eMPmamTu
# iTugggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQUq1pz+03bxyESSyVWgbcZuZjsDaAwDQYJKoZIhvcNAQEBBQAEggEAWzyR
# fQ+rWO3NfY1kWQ5D6UYQ8RWawy5L9tKrFYefxmvZHhEm1GQQR0eWpsdJ3Qe5SZyo
# x/hLLlE0sJ/uec5K25YY1fAgPEwLFBwpTyy1QioakRxg+2JNyC8U2y4hyuqptZYv
# 6OMYuDEmeIZ/fNEkyY71kMi+8GpqfdLdUGx5GQIQzhcV0maUVYGB9VIfjYSwSv7d
# kGP0kHWlrBKea/Ie17nMnUXyPAJOrDPatvsCZVD5orKfp8IA+9NVwyD5nncN5Qmb
# Z7PVzPPNK2ETd+ad4gMQ03KwHbkWnbqxz/5vmYuE0fQrAc8e21FWAY44LkNvz+uq
# IbIEJB2qmDc2Io6bLQ==
# SIG # End signature block
