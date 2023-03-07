Function Restart-Explorer {
    $explorer = Get-Process -Name explorer -ErrorAction SilentlyContinue
    if ($explorer) {
        try {
            taskkill /f /im explorer.exe
        }
        catch {
            Write-Warning "Failed to stop Explorer process: $_"
            return
        }
        Start-Sleep -Milliseconds 1500
    }
    try {
        Start-Process explorer -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to start Explorer process: $_"
        return
    }
}

<#Function Restart-Explorer () {
    $Run = Get-Process -Name Explorer -EA SilentlyContinue -WarningAction SilentlyContinue
    If (!($Run)) { Explorer }else {
        taskkill /f /im explorer.exe
        Start-Sleep -Milliseconds 1500
        Explorer
    }
}#>


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHpwvYH5m4lDmuUI/SdoTV+4D
# UN6gggMQMIIDDDCCAfSgAwIBAgIQKjMkMYkqpItNCiCURmEWWjANBgkqhkiG9w0B
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
# CQQxFgQUllr6+Fc9Idx1e1u+BeoouJkmnWowDQYJKoZIhvcNAQEBBQAEggEAhMAr
# tL6fClJ83sS9XI8PwGnztJfy3XPvj/truhjadQ3cfrIrxfGCIIgJU4BjtMiqNxev
# OY8Qg595MenzjiUxcESOtq6I2kXDYHT7LCVB/LtBgRrg2FBXhH9+0uzcxQNk9V+z
# 9hrU9RMWLl15byGcbp44HhCzQSldSuAG8MSVNk+s2qSgIZeE7DqGFdvAIgSv9Q6P
# WhSiNMywO2dlsZp+3JOfWmsU5rJtDzIgAd4ml+Kd0jGc1IuCwqsrn1hZe7+z3oAx
# OtOfcUJJDG6wOdR/UeX0t7gNNhNKIroWylmHEemvcgJMM0Wc9HhD/DbQH6jfkIAV
# zyrCc1z6F80eooihBg==
# SIG # End signature block
