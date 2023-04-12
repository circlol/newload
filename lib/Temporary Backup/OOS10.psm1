Function OOS10 {
    param (
        [switch] $Revert
    )
    If (!(Get-ChildItem ".\bin")){
        New-Item "bin" -ItemType Directory -Force
    }
    $ShutUpDl = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
    $ShutUpOutput = ".\bin\OOSU10.exe"
    Start-BitsTransfer -Source "$ShutUpDl" -Destination $ShutUpOutput

    If ($Revert) {
        Write-Status -Types "*" -Status "Running ShutUp10 and REVERTING to default settings..."
        Start-Process -FilePath $ShutUpOutput -ArgumentList ".\Assets\settings-revert.cfg", "/quiet" -Wait
    } Else {
        Write-Status -Types "+" -Status "Running ShutUp10 and applying Recommended settings..."
        Start-Process -FilePath $ShutUpOutput -ArgumentList ".\Assets\settings.cfg", "/quiet" -Wait
    }

    Remove-Item "$ShutUpOutput" -Force
}


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUelM7xx+/TBppNAYQ0e/r3d/s
# 3SagggMQMIIDDDCCAfSgAwIBAgIQKjMkMYkqpItNCiCURmEWWjANBgkqhkiG9w0B
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
# CQQxFgQUNBQ9ouWpmYX7JpP3SmkT7z4mz/kwDQYJKoZIhvcNAQEBBQAEggEAhvLw
# 2a1t+5U2WT24BcH3SsQqulyz40FmtaIoH7PfHME3HgJkTZ1mT4UJWxfOMe2jC96y
# gcXVnfagyclYsfG7SavaQkp90zQGeBbK8iTICI1oto+2ceq/o31Hkh+bRB9T3JY4
# 4x3+mw9XG6F4sUs4RO7LKAUpj+SdacrDicDh0ZbjjF4khvLf3Q5NEu5Kr23HTdr+
# rSCkbo4aLJoSDIVzuXKoe5+oLynD6oIHl332vcgIcoXhsBCexh6o7mmB5Y8OQCkc
# 1IKtjCErA+CBkLz53xt2xDP9QEKGLNDkJ9KhAS5NqGi9ugpkHY5CbmHMgDstSINP
# 3FrV9qKqipqZQEwaag==
# SIG # End signature block
