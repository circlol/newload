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
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/whRePBL/FmuFV0H9u6gjrKU
# YkigggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
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
# CQQxFgQUB5xT5NYqFeGvd1sX/fIfChTr/jQwDQYJKoZIhvcNAQEBBQAEggEAnyFP
# 7KN/vFth3GbuimsYkbxeoBr1JdJnMMngaCvDA8aTf1W1HiQqvOZTDF1WWBPZOQcX
# KwLFPdlJrPN8y3j9FTmtCXqlYwmGZteaN2hCgbwO3gpNYsf7aKP+XrdSndIrEYnt
# OiUxUYZ9+eaW0xW+qP+zFfXg6c5YLtlSRMciQutifgE75/MwRIoAOsfiNAbWFMsZ
# vN+EBji7BG8mycqj2D/PiqW5of01/PkgsnrFHqfiRdb9G/et1YsXwKkdlpnXdKWo
# ObF51aCmy3lvTeq8zti4rEgOyRUx6Yupgcjrai1+FFzxH4RCl6rNBVdUX2NTJiOg
# y72KhNVK/N2veZsUWg==
# SIG # End signature block
