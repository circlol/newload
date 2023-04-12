param(
    [switch]$GUI,
    [switch]$WhatIf
)
$WindowTitle = "New Loads"
$host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'White'
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
New-Variable -Name "ProgramVersion" -Value "2023r1.0" -Scope Global -Force
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

    # We check the time here so later
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

    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

                    ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
                    ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
                    ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
                    ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
                    ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                    ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝[]"
    Write-Host $Logo -ForegroundColor Blue -BackgroundColor Black
    Write-Host ""
    Write-Host '                                                                                              '
    Write-Host "     " -NoNewline
    Write-Host "Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Mike" -ForegroundColor Blue -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$ProgramVersion" -NoNewLine -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "      Recommended: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Update Windows before using New Loads" -ForegroundColor Red -BackgroundColor Black
    Write-Host "`n`n    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`n`n" -ForegroundColor Blue -BackgroundColor Black
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
try { if (Test-Path .\assets.psm1 ) {
        Import-Module .\assets.psm1 -Force
    } else { throw "assets.psm1 is missing. Please acquire this file to continue." }
} catch { Clear-Host
    Write-Host "An error occurred while importing assets.psm1: $_"
    Start-Sleep 4
    Exit
}

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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUTq+G59nE7GJ3npwWZ0uFkiS0
# dyqgggMQMIIDDDCCAfSgAwIBAgIQeokdU+IlOplKdeWKCux2rDANBgkqhkiG9w0B
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
# CQQxFgQUayF29spu5TN+v62bAOrcgeEG/3MwDQYJKoZIhvcNAQEBBQAEggEAD2x3
# CIKOmC1yoGO7PO/BLh5ciUtyQudPBTdhThsEg1ytUM/1+1t4PHtmtP2qHXpogexV
# idNpI8YY9PKc9FlE1m6o8WzXL5uHrhRETVmNgsT5pacRysjbZ1sw6h5oIvFrVVtR
# y1rAjrVSqlpgnfoHXG6zzQm757dEWUwPiaU2QQ342N6SsOkvHYeVWgUaNZAR/oOk
# kg3akmdL5sumuRKeOkSnKsAtvTqvfRDKoCh2U0Yk2MirGRQUT9GohmnlkAI00sKa
# eX/Q+hoWKETuyarfd1lapoAhA/q9mqHdiOx6uQCxxDjEP5Zmz1nEN6SKmNkG4ktR
# RfrQBz6nHh4xVuM3Cg==
# SIG # End signature block
