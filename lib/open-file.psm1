$Global:OpenFileLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"show-dialog-window.psm1"

#$PSScriptRoot\
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

    Push-Location -Path "$PSScriptRoot\..\..\$RelativeLocation"
    Get-ChildItem -Recurse *.ps*1 | Unblock-File

    ForEach ($FileName in $Scripts) {
        $LastAccessUtc = "v$((Get-Item "$FileName").LastWriteTimeUtc | Get-Date -Format "yyyy-MM-dd")"
        $Private:Counter = Write-TitleCounter -Text "$FileName ( $LastAccessUtc )" -Counter $Counter -MaxLength $Scripts.Length
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

    Push-Location -Path "$PSScriptRoot\..\..\$RelativeLocation"

    ForEach ($FileName in $Scripts) {
        $LastAccessUtc = "v$((Get-Item "$FileName").LastWriteTimeUtc | Get-Date -Format "yyyy-MM-dd")"
        $Private:Counter = Write-TitleCounter -Text "$FileName ( $LastAccessUtc )" -Counter $Counter -MaxLength $Scripts.Length
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
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUT0tMSt/GfKILT8u1fHqcb9II
# 9lmgggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFJgtWUekZhIy
# lW8kYACNLO2f+jgXMA0GCSqGSIb3DQEBAQUABIIBACD28FL45MJFCz19gK/7L+Yz
# G0ccclMhzU/x4H01gjsJZQepFUCs2VS0s4+xH0fukaIneG3pZumKHxByTuMWAQQB
# rNn9FLI4GYolJAWvOgglEukBUppR/jkpIFeaY6LGWj027XchvBUsduk+OGPnv4N9
# 9moHfDfgUPvQQXUgijeka199NNl1NrKWB/qeZCW2MOziA9WNEhCMkZDBUKpg34mv
# uZzmalG0TDM4svnISS6ofAliIXij8Y0S+uQvJhVaCxyV0wuryAUHxGHdnjKCtgCp
# qoQQbQ3WcaxsMVR4pQrD7UbO/bWPJ+m077vu3iGsJu/tay4SVV5UmqTnVlsgrnY=
# SIG # End signature block
