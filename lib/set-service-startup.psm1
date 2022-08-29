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
        Write-Status -Types "?", $TweakType -Status "The $Service service was not found ..." -Warning
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
                Write-Status -Types "?", $TweakType -Status "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability ..." -Warning
                Continue
            }

            If ($Service -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter ..." -Warning
                Continue
            }

            If (!$CustomMessage) {
                If ($Automatic) {
                    Write-Status -Types "+", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Automatic' on Startup ..."
                } ElseIf ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Disabled' on Startup ..."
                } ElseIf ($Manual) {
                    Write-Status -Types "-", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Manual' on Startup ..."
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
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUlmuCszKCfRm2XNpmd5VSyBBV
# QwagggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFGh0CFsfJyk7
# zIT3uHsQWg2IBfxkMA0GCSqGSIb3DQEBAQUABIIBAAgm3GAN+ROEs0En0h0AE5PM
# ZX5N01Yc6g339qwXRvKr2XChwunHX2GNMCtG1uyh3wrlWL0bTIen7KdOVfe+6FRX
# FjU6zzoDYhzbDCcqgYea7wGlKIsFYuZbN7CrbrDBVtl3byWKG2pBuW+GEiKJWDkx
# q2s/ts/E4jKB1v+eqcPL8N68jYKs3iofRf9Doq5fNPUeWPnqQNMRTrUos1kBCD6S
# /wMGtpTCeDFNzbd71QDYaPXdM2p/NZvsE+BxlTe/isJJIopg0dSqzfCWCkbHvHzn
# K9LkT2j4Nz1bVvD36lbDUrVtQLeiKOP680tjlU2vpTDxa5kA8TTcKpZXZnoknPA=
# SIG # End signature block
