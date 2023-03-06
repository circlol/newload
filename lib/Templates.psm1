Function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "] " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ">`n" -ForegroundColor DarkYellow -BackgroundColor Black
}
Function Write-Section() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "] " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ">" -ForegroundColor DarkYellow -BackgroundColor Black
}
Function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "> " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
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
        Write-Host "[" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
        Write-Host "$Type" -NoNewline -ForegroundColor White -BackgroundColor Black
        Write-Host "] " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
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
    Write-Host "`n<" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "] " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "(" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host " $Counter/$MaxLength " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ") " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "- " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "{ " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "} " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "[" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ">" -ForegroundColor DarkYellow -BackgroundColor Black

}
Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor DarkYellow -Backgroundcolor Black
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "]`n" -ForegroundColor DarkYellow -BackgroundColor Black
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
#Check>




# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKY57yU/0NSBPkIHV/mkjkIYM
# 3JigggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQUx9OfFyZrAwnEWv8IOypB5FtTE50wDQYJKoZIhvcNAQEBBQAEggEAlQZV
# t9tREnbKS9JaAwu4q8DEgtmfyCFlGyDtHUrRgq18Ihia1OTtFYD4QiLjoUbTGlbJ
# vZTNu4UDIEjUwVQ/PTgjYAD26Rwbrzu8P68pVQ/akYDDHxq4j3sQkjWoxF1zSuZV
# nI7wC5yX541q/AMXtd9Fmyeu/grQE5trBuZRNotdQTQ+7MNQhnROVV0KNg17pfoA
# q9iZ2B4tEFCZVRpWbACGincvzu+RMx0T5Xr+LZQKGhasvmO24xfS8SKso2QrGkyt
# Hcl/xghQy3+N0ok/gSqnO/vdD4b/3QbO3hvulPorrXFkHJg6AeEmHFXv+1QxY4yU
# sCPvyckPNj0YwWHXHg==
# SIG # End signature block
