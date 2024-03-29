Function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ">`n" -ForegroundColor $ForegroundColor -BackgroundColor Black
}
Function Write-Section() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor Black
}
Function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "> " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}

Function Write-CaptionFailed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Red -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
    Write-Host ""
}
Function Write-CaptionSucceed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Green -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
    Write-Host ""
}
Function Write-CaptionWarning() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
    Write-Host ""
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
        Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
        Write-Host "$Type" -NoNewline -ForegroundColor White -BackgroundColor Black
        Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    }

    If ($Warning) {
        Write-Host "$Status" -ForegroundColor Yellow -BackgroundColor Black
    } Else {
        Write-Host "$Status" -ForegroundColor White -BackgroundColor Black
    }
}
Function Write-TitleCounter() {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )

    #$Counter += 1
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "(" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host " $Counter/$MaxLength " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ") " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "- " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "{ " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "} " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor Black

}
Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor $ForegroundColor -Backgroundcolor Black
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "]`n" -ForegroundColor $ForegroundColor -BackgroundColor Black
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
    if ($?) {
        Write-CaptionSucceed -Text "Successful"
    } else {
        $errorMessage = $Error[0].Exception.Message
        $lineNumber = $Error[0].InvocationInfo.ScriptLineNumber
        $command = $Error[0].InvocationInfo.Line
        $errorType = $Error[0].CategoryInfo.Reason
        Write-CaptionFailed -Text "Unsuccessful"
        #Write-Host "`n$errorType`n$errorMessage`nLine Number: $lineNumber`nCommand: $command" -ForegroundColor Red
        Write-Host "Command Run: $command `nError Type: $Errortype `nError Message: $errormessage `nLine Number: $linenumber " -ForegroundColor Red
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
#Check>




# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxsoeQVO84n3bSMIxpbEWOEBf
# PU6gggMQMIIDDDCCAfSgAwIBAgIQKjMkMYkqpItNCiCURmEWWjANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDIxMjIx
# MjA1NloXDTI0MDIxMjIxNDA1NlowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN7IxFLVKnoz9n+b
# QgCpdOt/nLnk3qOSUxBZR/cXmGqqRmNQDV+T8FL7XEjvj4iNAGR/A9F2Rs4QKcdW
# OX4t2cUYHxqeft8+2b5HiZirMGAo+sfeILERHJAo5tGTVp8HlPJlvCWXzcrkZEtx
# ib6faWMGuGYRcRHgtbW4G7cQzbQnpYReq4J+LT/wDWJSYrMhTh89u7gFU5vdXX0R
# aBkYBsid6SVNNaZRRATGWq+SU3l5E+RzLDFF+iiDJSVX7HIUB61aYV6RkmyZsY24
# pklxphf8njEeLu30U6aufZ1lu40xhPWFZo4R6O5XLzgXqEXTGEBl2Tm8JyPQEpyy
# ZAryosECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBQnPYNnFm4VyH3ban7w10sQvJ03ZTANBgkqhkiG9w0BAQsF
# AAOCAQEAsR+0Q3ix62SZGte3F8ItYz4B8sVz6PSVtES/4gIf2Rux4tNlvMnrNSqi
# rGC3ZVd8uEpJkLv2jIjTwJ/LWuf4nk2XUonA2San30l/kBf4JaDMuoQf9QsBemxN
# ftnT+5QGu/mg7jzaiiDaw/gN/ejgtE5VJyYMcvBYyiVMqnclFThAvoTSPoejk53v
# flmIVXp3B5Q/4DjsY0XqfhLg6n61kMfT4mTuDLennv6I7NAFW01jwzyMAX7Fef6T
# dT9OOY7fNN8tB5nH8/bwa1mL0pyg6Ss9I2oNM1AZFYxUBKlNwPLg7ZMGYnbsbNKa
# qe1YlgKIRI++rPnYzPbEvZMh88Eb6jGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQKjMkMYkqpItNCiCURmEWWjAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUfOsdtRzQkf6BmgGFi/Y71yzUaDwwDQYJKoZIhvcNAQEBBQAEggEAdVkE
# lw2lhTsT6vCztTqanIoiQ1Hk2PoJdaZ2QXwa3BXvuRuZSsy4BkbkqmTdp3P98ixx
# k7v6U0xhssA8A0VzJP+hLGS9h625ZT6XEcHKKq3IPgWysaCX6D1WDF4HhYQZoMBG
# 7cvKWsFn1Nx6WI2acfxu1q+AW+5rpMIEoXsMvSrn0bU6wm0//8mmJqQhe0/xeqD6
# J/Zh0KRm5FvaUxvhBcWc5jlWsrbqWGylzlp7SkPAHptExnmPRI0hrSZp3eZe8bfC
# XQhy6kMKrYv8wqihNGDStv/6uSxJKhCtcwh3nvXJYMGdi5yBr8ssmmvnyoGbxcya
# 70pvd9GlhqhvWZendw==
# SIG # End signature block
