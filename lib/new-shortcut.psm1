$Global:NewShortcutLastUpdated = '20220829'
# Adapted From: https://shellgeek.com/create-shortcuts-on-user-desktop-using-powershell/
# Short circuit code: https://stackoverflow.com/a/26768902

function New-Shortcut() {
    [CmdletBinding()]
    param (
        [String] $SourcePath,
        [String] $ShortcutPath = "$([Environment]::GetFolderPath("Desktop"))\$((Split-Path -Path $SourcePath -Leaf).Split('.')[0]).lnk",
        [Parameter(Mandatory = $false)]
        [String] $Description = "Opens $(Split-Path -Path $SourcePath -Leaf)",
        [Parameter(Mandatory = $false)]
        [String] $IconLocation = "$SourcePath, 0",
        [Parameter(Mandatory = $false)]
        [String] $Arguments = '',
        [Parameter(Mandatory = $false)]
        [String] $Hotkey = '',
        [Parameter(Mandatory = $false)]
        [String] $WindowStyle = 1 # I'm not sure, but i'll take the UI as example: 1 = Normal, 2 = Minimized, 3 = Maximized
    )

    If (!(Test-Path -Path (Split-Path -Path $ShortcutPath))) {
        Write-Status -Types "?" -Status "$((Split-Path -Path $ShortcutPath)) does not exist, creating it..."
        New-Item -Path (Split-Path -Path $ShortcutPath) -ItemType Directory -Force
    }

    $WScriptObj = New-Object -ComObject ("WScript.Shell")
    $Shortcut = $WScriptObj.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $SourcePath

    If ($Hotkey) {
        $Shortcut.Description = "$Description ($Hotkey)"
    } Else {
        $Shortcut.Description = $Description
    }

    $Shortcut.Arguments = $Arguments
    $ShortCut.Hotkey = $Hotkey
    $Shortcut.IconLocation = $IconLocation
    $Shortcut.WindowStyle = $WindowStyle

    $Shortcut.Save()
}

<#
"$env:SystemRoot\System32\shell32.dll, 27"         >>> 27 or 215 is the number of icon to shutdown in SHELL32.dll
"$env:SystemRoot\System32\imageres.dll, 2"         >>> Icons from Windows 10
"$env:SystemRoot\System32\pifmgr.dll, 2"           >>> Icons from Windows 95/98
"$env:SystemRoot\explorer.exe, 2"                  >>> Icons from Windows Explorer
"$env:SystemRoot\System32\accessibilitycpl.dll, 2" >>> Icons from Accessibility
"$env:SystemRoot\System32\ddores.dll, 2"           >>> Icons from Hardware
"$env:SystemRoot\System32\moricons.dll, 2"         >>> Icons from MS-DOS
"$env:SystemRoot\System32\mmcndmgr.dll, 2"         >>> More Icons from Windows 95/98
"$env:SystemRoot\System32\mmres.dll, 2"            >>> Icons from Sound
"$env:SystemRoot\System32\netshell.dll, 2"         >>> Icons from Network
"$env:SystemRoot\System32\netcenter.dll, 2"        >>> More Icons from Network
"$env:SystemRoot\System32\networkexplorer.dll, 2"  >>> More Icons from Network and Printer
"$env:SystemRoot\System32\pnidui.dll, 2"           >>> More Icons from Status in Network
"$env:SystemRoot\System32\sensorscpl.dll, 2"       >>> Icons from Distinct Sensors
"$env:SystemRoot\System32\setupapi.dll, 2"         >>> Icons from Setup Wizard
"$env:SystemRoot\System32\wmploc.dll, 2"           >>> Icons from Player
"$env:SystemRoot\System32\System32\wpdshext.dll, 2">>> Icons from Portable devices and Battery
"$env:SystemRoot\System32\compstui.dll, 2"         >>> Classic Icons from Printer, Phone and Email
"$env:SystemRoot\System32\dmdskres.dll, 2"         >>> Icons from Disk Management
"$env:SystemRoot\System32\dsuiext.dll, 2"          >>> Icons from Services in Network
"$env:SystemRoot\System32\mstscax.dll, 2"          >>> Icons from Remote Connection
"$env:SystemRoot\System32\wiashext.dll, 2"         >>> Icons from Hardware in Image
"$env:SystemRoot\System32\comres.dll, 2"           >>> Icons from Actions
"$env:SystemRoot\System32\comres.dll, 2"           >>> More Icons from Network, Sound and logo from Windows 8
#>

###


# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUhm8IR6N+f09YjOG0Y6Z6ZgOf
# 9XGgggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFN1gkZuMLNXi
# eS2enVV0O0aiWDdNMA0GCSqGSIb3DQEBAQUABIIBABQCZ2sRi7gtX1CbrqZdScEo
# NmNB+mdTJl1aNjCqedCanYWwk1KhYWJNkvBFB34GBtHTUxklh4ZwL22zI5GsPlMq
# PmQHcBpY+44Edn0U2WnxG691WL1T9akgEwr3cKpUhCgrRbGZoe1ZtlEYeBJk7heS
# dCZD56BZx5ysDgmgxKf/sIa4Z23MT5/8D0VzMg7kPB2t8FDQaBBNZ/lEmAWjwvZd
# NsSz9JOtV124yqY0hZ/QQVueA95eBWgZvBi63hvpAAiDQtml+TIpzmVvNWo+W7dE
# tFW+W16O0+RmGAR5SujNKpmoheUvw1Qb1tzRjanImECe6RbctlTn60FXLIRJag0=
# SIG # End signature block
