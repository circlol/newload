Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

function Remove-UWPAppx() {
    [CmdletBinding()]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"

    ForEach ($AppxPackage in $AppxPackages) {
        If ((Get-AppxPackage -AllUsers -Name $AppxPackage) -or (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage)) {
            Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage from ALL users ..."
            Get-AppxPackage -AllUsers -Name $AppxPackage | Remove-AppxPackage # App
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers # Payload
        } Else {
            Write-Status -Types "?", $TweakType -Status "$AppxPackage was already removed or not found ..." -Warning
        }
    }
}

<#
Example:
Remove-UWPAppx -AppxPackages "AppX1"
Remove-UWPAppx -AppxPackages @("AppX1", "AppX2", "AppX3")
#>
# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUwMehMNRxF5bM6j7vILqT74k/
# a6SgggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFGHIW+AZOD8w
# vcNm77ETUztejiJaMA0GCSqGSIb3DQEBAQUABIIBAGtEIEnTRBYW0qJgcNJqzbgZ
# mf/okIOZzekyvo4OX1qU66QcXHxjRWjdEK7Tfb7ALT30wC9RvAdqjGeZni2xpaLs
# 3n+eZOspa0xX2/6f0545HlAnSSuotBc/pdiwwzH05+NnCgVGz+b9aJvtivzPetgt
# 2fMG10WxwDQ1k1OjGALAj/cOh6756JH/nMaAj9Utf7TRknQC8ZO7YEcm3B5TmaMs
# yEQ8lBj+opP4H/TvFaT1EOSJGdLFXA1AAofMQYd8jvKXG5VHaza/C1BJ7lMhtjMl
# NGCPB/wXYx1DY/wGv4XCqjCIdOCDk/Fz+KIxPF895MLUu5krCP1CzxI3jNZAa0M=
# SIG # End signature block
