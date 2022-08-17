Function Logo(){
    Write-Host " _   _                 _                     _     " -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "| \ | |               | |                   | |    " -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "|  \| | _____      __ | |     ___   __ _  __| |___ " -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "| . `` |/ _ \ \ /\ / / | |    / _ \ / _`` |/ _``  / __|" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "| |\  |  __/\ V  V /  | |___| (_) | (_| | (_| \__ \" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "\_| \_/\___| \_/\_/   \_____/\___/ \__,_|\__,_|___/" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "`n                 Created by " -NoNewLine -ForegroundColor white -BackgroundColor Black
    Write-Host "circ" -ForegroundColor Cyan -BackgroundColor Black
}

function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<====================] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[====================>" -ForegroundColor Cyan -BackgroundColor Black
}
function Write-Section() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<==========] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[==========>`n" -ForegroundColor Cyan -BackgroundColor Black
}
function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}

function Write-CaptionFailed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Red -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}
function Write-CaptionSucceed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Green -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}

function Write-CaptionWarning() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}
Function Write-Status() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Array]  $Types,
        [Parameter(Mandatory)]
        [String] $Status,
        [Switch] $Warning
    )

    ForEach ($Type in $Types) {
        Write-Host "[" -NoNewline -ForegroundColor Cyan -BackgroundColor Black
        Write-Host "$Type" -NoNewline -ForegroundColor Red -BackgroundColor Black
        Write-Host "] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    }

    If ($Warning) {
        Write-Host "$Status" -ForegroundColor Yellow -BackgroundColor Black
    } Else {
        Write-Host "$Status" -ForegroundColor White -BackgroundColor Black
    }
}

function Write-TitleCounter() {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )

    #$Counter += 1
    Write-Host "`n<====================] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "( $Counter/$MaxLength ) - { $Text } " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[====================>" -ForegroundColor Cyan -BackgroundColor Black

}

Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor Cyan -Backgroundcolor Black
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "]`n" -ForegroundColor Cyan -BackgroundColor Black
}

Function ScriptInfo(){
    Write-Break
    Write-Host ""
    Write-Host " New Loads`n"
    Write-Host " New Loads Version : $programversion"
    #Write-Host " Script Intregity: $Health%`n`n"
    Write-Host " Ideally run updates before continuing with this program." -ForegroundColor Red
    Write-Break
}

Function Check() {
    If ($?) {
        Write-CaptionSucceed -Text "Succcessful"
    }else{
        Write-CaptionFailed -Text "Unsuccessful"
    }
}


#Write-Break ; Logo ; Write-Break
#
#Write-Break
#Write-CaptionSucceed
#Write-CaptionFailed
#Write-Caption
#Write-Title
#Write-TitleCounter
#Write-Section
#Check

# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUlrTTrGrYyua7dq+fn7mHhdqm
# wyagggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFASZ3hAX1leM
# Aws9BFg0iRbHpX/2MA0GCSqGSIb3DQEBAQUABIIBAHkz4HTRU2ocKV1eWQgEB8AO
# LIAvFu7LtlPGOyUB+QZi8aNRDwnBnGQvAQi8HgYBlNofA/udGsHOPMYobfhP+voE
# hBDAQ4Ut5yBZJ0qUNMcjFZlIl14KNSWnZ1X6kne2lEk1Wf98owH92yMoaKzFPNSu
# Cj7rOtg39JJq2Xjm+zzyOzwBNX6JWHEzyP2JDl5VXWqbySGdaSuFh0WPqWYxhCQH
# uIf4rlAG52bOxcZ/HOeoETOHiIQLlNXDep+sIhU1309B2MCyHKLhGrMP5Ry6wE6f
# tcFQZU+2OpGmRt0hPpfYxroVkqkuywAI4pj8UaB0hDL6Ligqi8iX76i/0H5/otE=
# SIG # End signature block
