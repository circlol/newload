$params = @{
    Subject = 'CN=New Loads Code Sign'
    Type = 'CodeSigning'
    CertStoreLocation = 'Cert:\CurrentUser\My'
    HashAlgorithm = 'sha256'
}
$cert = New-SelfSignedCertificate @params

$cert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
$Scripts = Get-ChildItem -Recurse -Include "*.ps*1"
ForEach ($Script in $Scripts){
Set-AuthenticodeSignature $Script $cert
#Set-AuthenticodeSignature .\program.ps1 $cert
}
Read-Host
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUF+FCO0iUeEf8NE8O1VK79KGH
# v5GgggMQMIIDDDCCAfSgAwIBAgIQeokdU+IlOplKdeWKCux2rDANBgkqhkiG9w0B
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
# CQQxFgQUqe/AneL35mcbcWz28ZqrufMdnSYwDQYJKoZIhvcNAQEBBQAEggEALvJr
# VriLEFE0L+f2sgNsmcoMWtA8nrt6pLH5GyIdMxAIKFJrCei8eyiPx/WjglPLeD3Y
# kXVoygVaQRdu0sceExd1KGwRhzFmdn8C3P2m+NsBW5rJybY2gKl4ZW08AGTNe60B
# 6lQnxffc8DcOeQZKIMD7+/SwSp40E/SWLXE5hAZhHt9MGMtGrs1WVaZouDa6NIf3
# M4nweL1piWok73w1QRXyOT4Dt5G7f4cvBcw3xL6wIItGR/QdGXLZdESs+XaRN0vW
# KDP0vq6XeScCIEVncUZvOG7/rl4JqF9Ya2gouAbjXOaIAsdfapyvjhluzHtq5zwW
# XDY6kAKkXoXB5EATyw==
# SIG # End signature block
