# Reference: https://michlstechblog.info/blog/powershell-show-a-messagebox/#:~:text=Sometimes%20while%20a%20powershell%20script,NET%20Windows.
function Use-WindowsForm() {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null # Load assembly
}

function Show-Message() {
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DialogResult])]
    param (
        [String] $Title = "New Loads",
        [Array]  $Message = "Donkey`nKong",
        [String] $BoxButtons = "OK", # AbortRetryIgnore, OK, OKCancel, RetryCancel, YesNo, YesNoCancel
        [String] $BoxIcon = "Information" # Information, Question, Warning, Error or None
    )

    Use-WindowsForm
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)
}
$Global:ShowDialogLastUpdated = '20220829'

function Show-Question() {
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DialogResult])]
    param (
        [String] $Title = "New Loads",
        [Array]  $Message = "Donkey`nKong",
        [String] $BoxButtons = "YesNoCancel", # With Yes, No and Cancel, the user can press Esc to exit
        [String] $BoxIcon = "Question"
    )

    Use-WindowsForm
    $Answer = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)

    return $Answer
}

function Request-PcRestart() {
    $Ask = "Reboot?"

    switch (Show-Question -Title "New Loads" -Message $Ask) {
        'Yes' {
            Write-Host "You choose to Restart now"
            Restart-Computer
        }
        'No' {
            Write-Host "You choose to Restart later"
        }
        'Cancel' {
            # With Yes, No and Cancel, the user can press Esc to exit
            Write-Host "You choose to Restart later"
        }
    }
}

<#
Example:
Show-Message -Title "Title" -Message "Message"
$Question = Show-Question -Title "Title" -Message "Message"
Request-PcRestart
Returns Yes or No or Cancel
#>


# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6bQRc3vKUoMuj1ey/rJeHtnO
# kAygggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFGcJ3gUptPcj
# qNjh058owjG9jPpRMA0GCSqGSIb3DQEBAQUABIIBAKM0az5KS9d8PvqBHXunNRpD
# 07+18SIrGSwV3gq0rKlKHAGUu1lxP/bHEGITTODhBItZWXjT96PZpmHu65qnVzap
# f4PWHMAYGA4GbFd+pkkU0SHrxQn39ySM4npmt4C5gmdaNo+fIYKH5Q3nC00lxnNp
# 7r3VF8y8JhztlYh2IPDzOUnqp2DUcn++fiANpTpgjdHvdIBjgDjIjqyIR+PLiBC9
# t/dDUla2J1fySA6V8FCaWPJJM/Z+hr9Ds4zGlejg97JioYRwQ8pFQ/GxkxEQPXRj
# GzglUc7HZLAx/8lyP2Wit0c9Gowzs0v6DLcuoZNbvpGQ23Xno1QaiAY/Xdk7yQ8=
# SIG # End signature block
