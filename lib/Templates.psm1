$Global:TemplatesLastUpdated = '20220829'
Function Logo(){
    Write-Host " _   _                 _                     _     " -ForegroundColor White -BackgroundColor Black
    Write-Host "| \ | |               | |                   | |    " -ForegroundColor White -BackgroundColor Black
    Write-Host "|  \| | _____      __ | |     ___   __ _  __| |___ " -ForegroundColor White -BackgroundColor Black
    Write-Host "| . `` |/ _ \ \ /\ / / | |    / _ \ / _`` |/ _``  / __|" -ForegroundColor White -BackgroundColor Black
    Write-Host "| |\  |  __/\ V  V /  | |___| (_) | (_| | (_| \__ \" -ForegroundColor White -BackgroundColor Black
    Write-Host "\_| \_/\___| \_/\_/   \_____/\___/ \__,_|\__,_|___/" -ForegroundColor White -BackgroundColor Black
    Write-Host ""
}

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
    Write-Host ">`n" -ForegroundColor DarkYellow -BackgroundColor Black
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
    Write-Host ">`n" -NoNewline -ForegroundColor DarkYellow -BackgroundColor Black

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
#Check

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUPUZmvFpx8b+AkrTaiYyn0Jgu
# hZKgggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIyMTIwNTA1
# NTgyMFoXDTIzMTIwNTA2MTgyMFowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANLmTQ9JLXGTbz4O
# zrXJeDbJAso5/80NUs/iCJ19a79QHoi5RQZRFrZbJ2uu1+Dx3ui0LOqJeKe0/Or+
# 9L3EqEf2hAlThM3JEZCtx5KRUVqF6zk+dztJ/JqkSZQPzSyZF1KqosBCTb/tAQcH
# c4Bi1JggjX/fhMwxuGfyLBUGNp6WDRMoZby2tfUXe+5grsHFKXcgDHNPNcZo6bZY
# zKQYT3iEEATiLsyXtBt7YzcSrrP5D0l8qrRna8EKCmVCX9wgIGAXHwQKeays50sN
# LIwPIrG5GYwwQVGbjOtVeUo3aneLBArGdmcKPKyHVKZn1t49exN92/no96cPYtWn
# kq15EN0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBR9LgSDHkiaRBLzTyX1lAvCIUlW4DANBgkqhkiG9w0BAQsF
# AAOCAQEAQS8ax4uhVvT8tvhADRQX/oNxwjR7xuZTt4ABOkRMTTQRddwlEOOJiwAc
# MhJlBHtvaCrnNN/0FYtL7df3q/FQvvouIDvfnNZgAZrcrBvEWjZZAd+mXrXb4r/w
# sef73iq341OOSLeZ8sLk6digbNGS6EJjYuzsYUrlAEpG5fP9yW+gpYDmerttKtoY
# xo2V7Wtuhnbx4i5VQEK/7tXgaJKNB2Ue3RJi52g1PQ/ZNkS66tIsnF3iIR5WmxdO
# mNWoJ3ZIa1Bn98WYEiJoWT+yTH/ZfZ1k786Cz2hzSolhV3eur/HWwVZ7NmeH35zT
# X0MABZ2lKEBHit+AOYH/r3SN5aMHjzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQcugDkTMWcphI4F8edmMLrTAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUr1yOUUmYEN97DzAMvxgD09n4Uk4wDQYJKoZIhvcNAQEBBQAEggEAOjcx
# hYQIlfngs2yjSM/XL0ILEX+/4QOeRhpUyChcld/Ju7ma2ZGzzrIKDBHvRqWDYLsm
# w8rOVG+HYmGunr6ZMEcNET4pl0SYUBmLxQPYyugpzipGrIHY9XxI3WB4X3erArPO
# 9ija3dKtJjNaeqZQC4ygr960iDGRmqOMDIPFFkv+PM8bfBr5Aqnt2i2N1t2eScW6
# vMuo8UGNMJ2Lxs/90mRe6OPaovucC8QkQUwv2TH2Y1qvT9hz3iAArjPvBC93ZDz4
# kNzcglHmTf8qydR+AyuMbO3KWcSl3EpKo6iyzTsba3xl5ops22xbDXDGycVGxsqy
# qGOxQO5XvcjsuJLBOA==
# SIG # End signature block
