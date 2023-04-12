#$iconfile = "E:\CONSOLIDATED DATA\Pictures\.ico\Blackvariant-Button-Ui-System-Apps-Finder-1.ico"
#$iconfile = "C:\Users\owner\Downloads\Blackvariant-Button-Ui-System-Apps-Finder-1.ico"
#$iconfile = "E:\CONSOLIDATED DATA\Pictures\.ico\Blackvariant-Button-Ui-System-Apps-Finder-1.ico"
#$IconFile = "E:\CONSOLIDATED DATA\Pictures\.ico\Blackvariant-Button-Ui-System-Apps-Finder-1-1-gigapixel-standard-scale-2_00x.ico"
#$IconFile = "C:\Users\Circlol\Downloads\curved-monitor_result.ico"
#$IconFile = "C:\Users\Circlol\Downloads\curved-monitor_result.ico"
$IconFile = "~\OneDrive\New Loads\icon\curved-monitor_result.ico"
#$Source = ".\Program.ps1"
$Source = ".\New Loads.ps1"
$Output = ".\newloads.exe"
$Title = "New Loads"
$Description = "Automated Windows Setup and Debloat Script"
$Version = "20231"
$Company = "Mother Computers"
$Copyright = "Mike Ivison"
#ps2exe -inputFile $Source -outputFile $Output -iconFile $iconfile #-requireAdmin -x64 -Mta



Write-host "Creating New Loads.exe"
Invoke-PS2EXE -inputFile $Source -outputFile $Output -x64 -STA -iconFile $iconfile -title $title -description $Description -version $Version -copyright $Copyright -supportOS -Company $Company -requireAdmin
Write-Host "Finished."# Opening Explorer"
#Explorer .\
#Start-Sleep -Seconds 3

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+pKXKlB101Zjh8fbAVjjffCv
# wEOgggMQMIIDDDCCAfSgAwIBAgIQeokdU+IlOplKdeWKCux2rDANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDQxMTE4
# MTI0N1oXDTI0MDQxMTE4MzI0N1owHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALtQ3KS4tiFLpVaa
# iwbD/7SaF5Z1FzsB3FCfjb9oYyirUycVAn3J8Y5WBCj01+/4X5CnbuAzTMbEQoYX
# GcYAXZeK7dE7MtFu+UPklcxJgj0cmFWFSqoIXW/u++a2tz5umCu+cVKl4KRhi3jV
# AEwegr+0t0rVeRf9laJ5jMnwqnQX1OK/Io+lnZczPiDaqRh41iP0QxBRnhI4JzY0
# Bvgw5fIEQHhdCkJbuR2B8lwJ+dNqNYWywk9gwfj5gboExlKINPgrRTvFwRKZwxEy
# jB/4/EoeKVgIY0nVZ3h5JIMXMvessQboeTCQZZnOpy05UfjtRx2QJEYel03cRY89
# J6U6mcUCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBRDigo9jC2UTikf0HvKxvTbR6SbATANBgkqhkiG9w0BAQsF
# AAOCAQEAlGw+ujETSZYwIRdpzsQlQYyZNgDhex68Q2UVwZlbvbd9kpWUCSM2swTh
# uvvnKuCRXhxm9d47Y0dTR2sz4tb7p1uctXS62itj01ol8yGU4+CWBna5WkBAVRz0
# SSYfijYA8GmzMbU9p25VegeCEr20gRXQGlKBq5yObKuok/KLIAwHDn/NT4+iRf7Y
# F/GhA0GMNk8KdVGSkpkRXwvIyh9GszfMyv+71jxZeZ6rmpYAwf9Hu0aFP9cUKQJF
# L0I8kQHtjTJPx9YV29ZYn/lEQz8poeoPWZokHq1rQ97LE/P9NayaFjRqeSMMmnjz
# IXkBte/WsvSrxQO2bdJdM2tty+VsEzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQeokdU+IlOplKdeWKCux2rDAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUKupvWwg7jwSUCG7WX2TZTyv4m8EwDQYJKoZIhvcNAQEBBQAEggEAazl9
# 7BG0d9n+T1BLiv4yMqHKBYMWTnnI4mg04J4zgCnUCybBAXv5BGXjmRri2nwLqvBT
# hPF3XzJZjYek0Phtz7XWa+gtd4+TllaNvnY3IvPKjr2kq6raSa/CZ40zuVKO4+5U
# cKgMkIAknD3kWTtvrjz7TSmOID6aN5ARHEo7ycseAQLr6MHKbo0leHRy2g5+PpRB
# C1OQhcu5ZVtuNRZ2ZRBzNH+okVLLd0Gfb2wdk4+Y+OJ3twinq5mOGrPq+JUgX0w9
# BwXjzNdL392Oh0HE0Vw9QDMQ/gLpxUxVZphE6a3sKtJTL5WDHZXXamFMWkksgyHP
# t0YfupEntxHFxL2IoQ==
# SIG # End signature block
