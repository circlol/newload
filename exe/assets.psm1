Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor DarkYellow -Backgroundcolor Black
    Write-Host "════════════════════════════════════════════════════════════════════════════════════════════════" -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "]`n" -ForegroundColor DarkYellow -BackgroundColor Black
}
Function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "══" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "▶ " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}
Function Write-CaptionFailed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "══▶ " -NoNewline -ForegroundColor Red -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}
Function Write-CaptionSucceed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "╠══▶ " -NoNewline -ForegroundColor Green -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}
Function Write-CaptionWarning() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "╠══▶ " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
    Write-Host ""
}
Function Write-Section() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n◀" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "════════════════════" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "╣" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host " $Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "╠" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "════════════════════" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "▶" -ForegroundColor DarkYellow -BackgroundColor Black
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
Function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n◀" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "════════════════════" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "] " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "╠" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "════════════════════" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "▶`n" -ForegroundColor DarkYellow -BackgroundColor Black
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
    Write-Host "`n◀" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "════════════════════" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "╣ " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "(" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host " $Counter/$MaxLength " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host ") " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "- " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "{ " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "} " -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "╠" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black
    Write-Host "════════════════════" -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "▶" -ForegroundColor DarkYellow -BackgroundColor Black

}
Function NewLoadsModules() {
    $Modules = (Get-ChildItem -Path ".\lib" -Include "*.psm1" -Recurse).Name
    ForEach ($Module in $Modules) {
    Import-Module .\lib\"$Module" -Force -Global
    }
}
Function NewLoads() {
    $WindowTitle = "New Loads" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    $wc = New-Object System.Net.WebClient
    CheckNetworkStatus ; $wc.DownloadString($NewLoadsURL) | Invoke-Expression 
}


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU8RpEX1toShkosv5UCcvR2nCt
# OEygggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQUr+eQhmczQz5+rwWQO0BfV6la00kwDQYJKoZIhvcNAQEBBQAEggEAYC29
# vRLOipIjXqB389tYPtAix4+HLRWUSjrkL0hTleE8YXL+pVYxpNPylKFnQNVCKIsj
# 0RjhM+tLm65eJsJ1LopQLLuGu4hMIKh4t1G5wb90l5V9N+msv8Mu4DPhmubX2e6g
# dcI3/ORilwOWaHPX3JRuL4T7iNgSKLwQeoWXD1sZ2EhwUbj9pzma1Ly6IT/3/qCz
# XILy1K11QCsx954eLzOh6wiwAPuOX2SRL3+SZwC8mt9O7OGt7Bh6imcDaKQ4VnAe
# pBtouRU4u+fIAEjzgKUio9AEn4zmW+lM2AjwYedPRg6gRVlVUcIyEntVabzFh3v7
# h3fzYWteAkZgKSXgpQ==
# SIG # End signature block
