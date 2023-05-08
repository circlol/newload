param(
    [switch]$Global:GUI,
    [switch]$Global:WhatIf
)
$WindowTitle = "New Loads"
$LogoColor = "Red"
$Global:BackgroundColor = "Black"
$Global:ForegroundColor = "Red"
$host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'White'
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
New-Variable -Name "ProgramVersion" -Value "2023.1.005" -Scope Global -Force
New-Variable -Name "ReleaseDate" -Value "May 1st, 2023" -Scope Global -Force
New-Variable -Name "NewLoadsURL" -Value "https://raw.githubusercontent.com/circlol/newloadsTesting/main/New%20Loads.ps1" -Scope Global -Force
New-Variable -Name "NewLoadsURLMain" -Value "https://raw.githubusercontent.com/circlol/newloadsTesting/main/" -Scope Global -Force
Clear-Host

Function Bootup {
    $WindowTitle = "New Loads - Checking Requirements" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    $SYSTEMOSVERSION = [System.Environment]::OSVersion.Version.Build
    $MINIMUMREQUIREMENT = "19042"  ## Windows 10 v20H2 build version
    If ($SYSTEMOSVERSION -LE $MINIMUMREQUIREMENT) {
        $errorMessage = "New Loads requires a minimum Windows version of 20H2 (19042). Please upgrade your OS before continuing."
        throw $errorMessage
        Start-Sleep -Milliseconds 1500
        Exit
    }

    If ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
        $errorMessage = "New Loads requires a minimum Windows version of 20H2 (19042). Please upgrade your OS before continuing."
        throw $errorMessage
        Start-Sleep -Seconds 3
        Exit
    }

    # Function that displays program name, version, creator
    ScriptInfo
    $executionPolicy = (Get-ExecutionPolicy)
    switch ($ExecutionPolicy) {
        "Restricted" {
            Write-Warning "The execution policy is set to 'Restricted', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
        "AllSigned" {
            Write-Warning "The execution policy is set to 'AllSigned', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
        "Unrestricted" {
            Write-Warning "The execution policy is set to 'Unrestricted', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
        "RemoteSigned" {
            Write-Host "The execution policy is already set to 'RemoteSigned'."
        }
        default {
            Write-Warning "The execution policy is set to an unknown value, setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
    }

    $localPath = ".\assets.psm1"
    $AssetsURL = "https://raw.githubusercontent.com/circlol/newload/main/exe/assets.psm1"
    
    # Check if the file exists in the local path
    if (Test-Path $localPath) {
        Import-Module $localPath -Force
    } else {
        # Download the module from the remote URL and save it to the local path
        Invoke-WebRequest $AssetsURL -OutFile $localPath
        Import-Module $localPath -Force
    }

    # We check the time here so later
    CheckNetworkStatus
    UpdateTime
    $Global:Time = (Get-Date -UFormat %Y%m%d)
    $DateReq = 20230101
    $License = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/circlol/newloadsTesting/main/assets/license.txt" -UseBasicParsing | Select-Object -ExpandProperty Content

    If ($Time -lt $License -and $Time -gt $DateReq) {} else {
        Clear-Host
        Write-Host "There was an uncorrectable error.. Closing Application."
        Start-Sleep -S 5 ; Exit
    }
    try {
        Remove-Item .\log.txt -Force -ErrorAction SilentlyCOntinue | out-null
        Remove-Item .\newloads-errorlog.txt -Force -ErrorAction SilentlyCOntinue | out-null
        Remove-Item .\tmp.txt -Force -ErrorAction SilentlyCOntinue | out-null
    }
    catch {
        Write-Error "An error occurred while removing the files: $_"
        Continue
    }
}
Function UpdateTime {
    $CurrentTimeZone = (Get-TimeZone).DisplayName
    $CurrentTime = (Get-Date).ToString("hh:mm tt")
    $TimeZone = "Pacific Standard Time"
    Write-Host "Current Time: $currentTime  Current Time Zone: $CurrentTimeZone"
    # Set time zone to Pacific
    Set-TimeZone -Id $TimeZone -ErrorAction SilentlyContinue
    If ($?) { Write-Host "Time Zone successfully updated." } elseif (!$?) { Write-Host "Time Zone failed to update." }
    #Synchronize Time
    If ((Get-Service -Name W32Time).Status -ne "Running") {
        Write-Host "Starting W32Time Service"
        Start-Service -Name W32Time
        Write-Host "Syncing Time"
        w32tm /resync
    }
    else {
        Write-Host "Syncing Time"
        w32tm /resync
    }
}
Function ScriptInfo {
    $WindowTitle = "New Loads - Initialization" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    $Logo = "


▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀


                    ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
                    ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
                    ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
                    ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
                    ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                    ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝
                    
                    
                        "
    Write-Host $Logo -ForegroundColor $LogoColor -BackgroundColor Black -NoNewline
    Write-Host " Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Papi" -ForegroundColor Red -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$ProgramVersion - $ReleaseDate" -ForegroundColor Green -BackgroundColor Black
    #Write-Host "`n`n                     "
    Write-Host "`n`n  Notice: " -NoNewLine -ForegroundColor RED -BackgroundColor Black
    Write-Host "For New Loads to function correctly, it is important to update your system to the latest version of Windows." -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "`n`n`n▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`n`n" -ForegroundColor $LogoColor -BackgroundColor Black
    $WindowTitle = "New Loads" ; $host.UI.RawUI.WindowTitle = $WindowTitle
}
Function Show-YesNoCancelDialog {
    [CmdletBinding()]
    param (
        [String] $Title = "New Loads",
        [String] $Message = "Set Execution Policy to RemoteSigned?",
        [Switch] $YesNoCancel
    )
    $BackupWindowTitle = $host.UI.RawUI.WindowTitle
    $WindowTitle = "New Loads - WAITING FOR USER INPUT" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    if ($YesNoCancel) {
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNoCancel)
    }
    $host.UI.RawUI.WindowTitle = $BackupWindowTitle                                 
    return $result                                                                  
    # Example - Show-YesNoCancelDialog -YesNoCancel
    # Example - Show-YesNoCancelDialog -YesNoCancel -Title "Example" -Message "Do you want to x?"
}
function CheckNetworkStatus {
    <#
    .SYNOPSIS
    Waits for an internet connection to be established.
    .PARAMETER NetworkStatusType
    The type of network status to check. Defaults to IPv4Connectivity.
    .EXAMPLE
    WaitForInternetConnection -NetworkStatusType IPv6Connectivity
    #>
<#
Function CheckNetworkStatus {
    Set-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    if ($NetStatus -ne $Connected) {
        Write-Status -Types "WAITING" -Status "Seems like there's no network connection. Please reconnect." -Warning
        do { Write-Status -Types ":(" -Status "Waiting for internet..." ; Start-Sleep -Seconds 2
        } until ((Get-NetConnectionProfile).IPv4Connectivity)# -Or (Get-NetConnectionProfile).IPv6Connectivity -eq 'Internet')
        Start-Sleep -Seconds 3 ; Write-Status -Types ":)" -Status "Connected... Moving on"
    }
}
#>
    [CmdletBinding()]
    param(
        [string]$NetworkStatusType = "IPv4Connectivity"
    )
    # Check the initial network status
    $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
    if ($NetStatus -ne 'Internet') {
        Write-Status -Types "WAITING" -Status "Seems like there's no network connection. Please reconnect." -Warning
        # Wait for internet connection
        while ($NetStatus -ne 'Internet') {
            Write-Status -Types ":(" -Status "Waiting for internet..."
            Start-Sleep -Seconds 2
            $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
        }
        Start-Sleep -Seconds 3
        Write-Status -Types ":)" -Status "Connected. Moving on."
    }
}
Function Check {
    if ($?) {
        Write-CaptionSucceed -Text "Successful"
    } else {
        $errorMessage = $Error[0].Exception.Message
        $lineNumber = $Error[0].InvocationInfo.ScriptLineNumber
        $command = $Error[0].InvocationInfo.Line
        $errorType = $Error[0].CategoryInfo.Reason
        Write-CaptionFailed -Text "Unsuccessful"
        #Write-Host "`n$errorType`n$errorMessage`nLine Number: $lineNumber`nCommand: $command" -ForegroundColor Red
        Write-Host "Command Run: $command `nError Type: $Errortype `nError Message: $errormessage `nLine Number: $linenumber " -ForegroundColor Red
    }
}
####################################################################################


### RUN ORDER


####################################################################################

Bootup
Variables
CheckFiles
NewLoadsModules
CheckNetworkStatus
NewLoads


####################################################################################





####################################################################################
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzxOrKPAeP7TIdHxTa7hjkLLc
# OuygggMQMIIDDDCCAfSgAwIBAgIQGopRfa9vUaBNYHxjP9CRADANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDQxMzAx
# MzgyOVoXDTI0MDQxMzAxNTgyOVowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMeESaCCI/aIc/XE
# UOPfQdPyPZudTPoqikHcv7qQyiSa1dwOldn+UlP72iCb1SdNOrQ1pS9PW9fVpaOG
# hhQU48deC9WgUykyg+Z5mUt23bb+ni8bb48cvP2DdOGtmCRQYm5ok/8aEMsi35/t
# cXl7Odmiro8xd+SBgXf7bg8qgxyOqNSqO0kbOAroYlOLMQ5UDmmw6wv2YuPQhddv
# Uzg+pI+J0c+/mJEFdhGORuTnOLABgOZHRD7DDGNV5f91pglS9qHkNiXm857PHq4s
# l4DKUmfAdlDhTFcHOv6eSI1o1IUtjeLGD8d6lG5Hp3qwfZ/j14FoSodmsKfUdOqY
# HBCYWxECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBTb52Tr21VDXgO3IsUAvCDBP16w7DANBgkqhkiG9w0BAQsF
# AAOCAQEAXsHUgL7wW600L+6M+AZHyHwsKhoCaVztMHMPsx/H/4rF8EuQYyTS5/s2
# Ov8a4DlRLjYlsJ6VqrLjqLyTf84U9EV8IVB7N94F3u9A0O647y0PTmZ4wMqPtW6P
# mZGLQ0G6r7digzaHb/IaiUhj30MnWY7ZZwZlwlMlOGdR/2yiyv4vmNNa/3xQXipR
# LdjshlF8Jjj399OxppKOgKDaTv4ebzIZlUv2qdQYsiQkg6f9w2vFdPAdAddW5573
# dWc4o1HPgGiuwMJuulS9cP0W5iXMwQGgIM8v6FkpcHSLoLgSJ3ngsVNn4BCEyFU9
# NQq7c3E4f66ssnXlSSwTCT7RQEZJSzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQGopRfa9vUaBNYHxjP9CRADAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUaDEaPiS4QIeuoMcPpBCFNVGdFaAwDQYJKoZIhvcNAQEBBQAEggEAhujh
# 9bShpAbtUZ5UCQWxPO5JBbdKocpmtuyaGbiwVRRiJ80BXbGrHk2Xu8j/3+oWveza
# 11+aOajjhcvJIpCwI8AyPOopX9APPb5r6K+jAc9lLLF0YlM4vPuSOOi8JR9KUTkA
# ghcbgrK3F8GPn2N3GSCz8lsjavNqvnjQc0RZJxd73Z+5S90lo+JI4LWRAXnApF5r
# WcEDjCFPNDTAsuws+hSrwQU5NFCk6lwza894rGQBFwjzG/Fo/mA9oMZoIzKphzLW
# fX4jpxwX7ShMSvqrOERp6Az5zP5xPLpqRo32nQ3bueiVUKXW4gzBZ3+U3SLMhGwr
# 2SrEWX+0RTJtDNDQxA==
# SIG # End signature block
