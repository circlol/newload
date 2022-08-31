$Global:DownloadWebFileLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

function Request-FileDownload {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [String] $FileURI,
        [Parameter(Mandatory = $false)]
        [String] $OutputFolder,
        [String] $OutputFile
    )

    Write-Verbose "[?] I'm at: $PWD"
    If (!(Test-Path "$PSScriptRoot\..\tmp")) {
        Write-Status -Types "@" -Status "$PSScriptRoot\..\tmp doesn't exist, creating folder..."
        mkdir "$PSScriptRoot\..\tmp" | Out-Null
    }

    $FileLocation = "$PSScriptRoot\..\tmp\$OutputFile"

    If ($OutputFolder) {
        If (!(Test-Path "$PSScriptRoot\..\tmp\$OutputFolder")) {
            Write-Status -Types "@" -Status "$PSScriptRoot\..\tmp\$OutputFolder doesn't exist, creating folder..."
            mkdir "$PSScriptRoot\..\tmp\$OutputFolder"
        }
        $FileLocation = "$PSScriptRoot\..\tmp\$OutputFolder\$OutputFile"
    }

    Import-Module BitsTransfer
    Write-Host
    Write-Status -Types "@" -Status "Downloading from: '$FileURI' as '$OutputFile'"
    Write-Status -Types "@" -Status "On: '$FileLocation'"
    Start-BitsTransfer -Dynamic -RetryTimeout 60 -TransferType Download -Source $FileURI -Destination $FileLocation

    return $FileLocation
}

function Get-APIFile {
    [CmdletBinding()]
    param (
        [String] $URI,
        [String] $ObjectProperty,
        [String] $FileNameLike,
        [String] $PropertyValue,
        [Parameter(Mandatory = $false)]
        [String] $OutputFolder,
        [String] $OutputFile
    )

    $Response = Invoke-RestMethod -Method Get -Uri $URI | ForEach-Object $ObjectProperty | Where-Object name -like $FileNameLike
    $FileURI = $Response."$PropertyValue"

    If ($OutputFolder) {
        return Request-FileDownload -FileURI $FileURI -OutputFolder $OutputFolder -OutputFile $OutputFile
    } Else {
        return Request-FileDownload -FileURI $FileURI -OutputFile $OutputFile
    }
}

<#
Example:
$FileOutput = Request-FileDownload -FileURI "https://www.example.com/download/file.exe" -OutputFile "AnotherFileName.exe" # File will download on src\tmp
$WSLgOutput = Get-APIFile -URI "https://api.github.com/repos/microsoft/wslg/releases/latest" -ObjectProperty "assets" -FileNameLike "*$OSArch*.msi" -PropertyValue "browser_download_url" -OutputFile "wsl_graphics_support.msi"
#>

# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzqYi7zZuPqCsUJ17HZMHS2FK
# gp6gggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFGc190PQL/gr
# Tcm2v35aBZuEOlicMA0GCSqGSIb3DQEBAQUABIIBAKFAzMoRCr/qCEkA8NxFoqGD
# JoFu5rHnMGQHbaiyZRVORS3pREKsQBtvX6j5Hxyhbnp/oYL1Sa2gQSg+eUfxv3Dl
# oWKTLGGSBPg6JhbAMZ0XrEBOxVS6SLkCaROjUXKVXAhs6vrXSec8C5ycKbwIOepr
# sGTe99kmfyg7dhoRMgA8kO5hlbbzKAr9aFjKWr5jboUC4fzcWs9/gtayPeMHv6rX
# HButhPS5omK2jslfjo8I9jBVpYAXSfMHYUfpDj0hcUCBUQ2Rgkh7b2xGnqH+XFkV
# fvJ8bOwCtVKysM7/24qHSTsorBh0MQRiAWzyvBRe945N5pyzGR8/I7UffDic/9E=
# SIG # End signature block
