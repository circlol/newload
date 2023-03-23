$WindowTitle = "New Loads"
$host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'White'


Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

Clear-Host

Function Bootup() {
    $WindowTitle = "New Loads - Checking Requirements" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    $SYSTEMOSVERSION = [System.Environment]::OSVersion.Version.Build
    $MINIMUMREQUIREMENT = "19042"  ## Windows 10 v20H2 build version
    If ($SYSTEMOSVERSION -LE $MINIMUMREQUIREMENT) {
        Write-Host "Error:" -Foregroundcolor White -BackgroundColor RED -NoNewline
        Write-Host " New Loads Requires a Minimum Windows Version Of 20H2(19042).. Please Upgrade OS Before Continuing." -ForegroundColor Red -BackgroundColor Black
        Start-Sleep -Seconds 3
        Exit
    }

    If ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
        Write-Host "Error: New Loads must be Run As Administrator.. @MATT" -Foregroundcolor White
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
    $License = 20230930
    $DateReq = 20230101
    $License = 20230331
    If ($Time -lt $License -and $Time -gt $DateReq) {} else {
        Clear-Host
        Write-Host "There was an uncorrectable error.. Closing Application."
        Start-Sleep -S 5 ; Exit
    }

    try {
        stop-transcript | out-null
        Remove-Item .\log.txt -Force -ErrorAction SilentlyCOntinue | out-null
        Remove-Item .\$ErrorLog.txt -Force -ErrorAction SilentlyCOntinue | out-null
        Remove-Item .\tmp.txt -Force -ErrorAction SilentlyCOntinue | out-null
    }
    catch {}
}


Function UpdateTime() {
    $timeZone = (Get-TimeZone).Id
    $currentTime = (Get-Date).ToString("hh:mm tt")
    Write-Host "Current Time Zone: $timeZone"
    Write-Host "Current Time: $currentTime"
    $newTimeZone = "UTC-08"
    Set-TimeZone -Id $newTimeZone
    Write-Host "Time Zone successfully updated."
    #Synchronize Time
    w32tm /resync
    If ((Get-Service -Name W32Time).Status -ne "Running") {
        Write-Host "Starting W32Time Service"
        Start-Service -Name W32Time
        Write-Host "Syncing Time" ; w32tm /resync
    }
    else {
        Write-Host "Syncing Time" ; w32tm /resync
    }
}


Function LocalVariables() {
    New-Variable -Name "ProgramVersion" -Value "230307" -Scope Global -Force
    New-Variable -Name "newloads" -Value ".\" -Scope Global -Force
    New-Variable -Name "MaxLength" -Value '12' -Scope Global -Force
    New-Variable -Name "ErrorLog" -Value ".\errorlog.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Log" -Value ".\Log.txt" -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Scope Global -Force
    New-Variable -Name "Win11" -Value "22000" -Scope Global -Force
    New-Variable -Name "22H2" -Value "22621" -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value [System.Environment]::OSVersion.Version.Build -Scope Global -Force
    New-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    New-Variable -Name "Connected" -Value "Internet" -Scope Global -Force
    New-Variable -Name "NewLoadsURL" -Value "https://raw.githubusercontent.com/circlol/newload/main/New%20Loads.ps1" -Scope Global -Force
    New-Variable -Name "NewLoadsURLMain" -Value "https://raw.githubusercontent.com/circlol/newload/main/" -Scope Global -Force
    #New-Variable -Name "HVECCodec" -Value ".\assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx" -Scope Global    
    New-Variable -Name "HVECCodec" -Value  "Assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx" -Scope Global
}


Function ScriptInfo() {
    $WindowTitle = "New Loads - Initialization" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    $Logo = "

    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

                    ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
                    ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
                    ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
                    ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
                    ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                    ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝"
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
}
# Example - Show-YesNoCancelDialog -YesNoCancel
# Example - Show-YesNoCancelDialog -YesNoCancel -Title "Example" -Message "Do you want to x?"

Function CheckNetworkStatus() {
    Set-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    if ($NetStatus -ne $Connected) {
        Write-Status -Types "WAITING" -Status "Seems like there's no network connection. Please reconnect." -Warning
        do { Write-Status -Types ":(" -Status "Waiting for internet..." ; Start-Sleep -Seconds 2
        } until ((Get-NetConnectionProfile).IPv4Connectivity)# -Or (Get-NetConnectionProfile).IPv6Connectivity -eq 'Internet')


        Start-Sleep -Seconds 3 ; Write-Status -Types ":)" -Status "Connected... Moving on"
    }
}

function WaitForInternetConnection {
    <#
    .SYNOPSIS
    Waits for an internet connection to be established.
    
    .PARAMETER NetworkStatusType
    The type of network status to check. Defaults to IPv4Connectivity.
    
    .EXAMPLE
    WaitForInternetConnection -NetworkStatusType IPv6Connectivity
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

        Start-Sleep -Seconds 5
        Write-Status -Types ":)" -Status "Connected. Moving on."
    }
}



Function Check() {
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

LocalVariables
Bootup

If (Test-Path .\assets.psm1 ) { 
    $WindowTitle = "New Loads - Importings Assets.psm1" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Import-Module .\assets.psm1 -Force
} else {
    Clear-Host ; Write-Host "assets.psm1 is missing. Please acquire this file to continue." ; Start-Sleep 4 ; Exit
}

CheckFiles
NewLoadsModules
#CheckNetworkStatus
WaitForInternetConnection
NewLoads


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCY1a2i5spTgxOWmN5D/sYMd+
# e4OgggMQMIIDDDCCAfSgAwIBAgIQEznIweLy56VByeu0DO3dHDANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDIyNTAx
# MTcwMFoXDTI0MDIyNTAxMzcwMFowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMOp0Oy3ZpODBBu9
# SqwzirkvXJYu8inamkKf8D40b5DlSP78UvJxbrfqWUejfqX9pUhIS5bFazZ/3OUH
# TdTGp2Wy85/VUL/3kWIRfRX6cScvGfA5zBHAJ5weTSM9umcogh1fWJmmYl0xgfOP
# dZaWBmnVDJKo/JuOTOmQ0gyIk1JJStgAT8ix5PetmQ9yoCh02UfRO4dfwhEHNS7e
# H9OavAMQStFvycJL63Lz1CqwjBwkq8mBCy1TcP3HzyqGOAulW6WocanOKZm8BoXr
# jaFWpxU16hiVtyP9arbaW91bmFIfNMACQje/9nIdYXN7Eu1gS2Werox5YJ0vntPm
# I3Tun8ECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBSneCZHJdvBbeTvpAb04yuxIcE0MTANBgkqhkiG9w0BAQsF
# AAOCAQEAk9ThUUX5Pjr6hbnR8B20RPRgCPkvNrF4EaMweA8uF5/A84AnxL63X+Bv
# O/9VRCbP08c3N0uG0tkDhCFC3kld2FI77ZCwPNNKbgu8JEvB+Iq16p6DBlWCQ8Ac
# vCLuqtUZHoQEv/+HR4VFjyV3DQdhBorGr6t+HyEEuR56W21D2W1AP+OBJ1yvArky
# pLjWoQobtg1k3Wzwo15hIis95vz4QNjvMEX2PSe67KC4yRZv8SbAYX8okwm3VbJW
# MOEOSfBqZ6aA8V5BvJNpqBWwRFuoutKwl37jPlKA7pZG5BT/iXRF3DgXBti3s2hZ
# n1K1S/S3o113XkKBDsdx1JdQEGlCcTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQEznIweLy56VByeu0DO3dHDAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUQsclVlluGjggm2nku0zSA8gpP+4wDQYJKoZIhvcNAQEBBQAEggEAe8ru
# /K+wLM3oJMiqJHuUQSBNlwrTibyyLoEbK7TpFE2pTiVNVmGsutB3Rnbr7jxO7SmE
# hqpJPCLnbwWRUO8nVUVoUbhsEsb7DoNQsz0SH8SvdbwupuXy8/AVxUTPGXLgR5LQ
# 1wP1liFMsDhO4OUKtq278HzowTNZrtG1tt1ECXmTrBrOWAY3aJ6YL881IRQImdaG
# Di08PwGFHDhH5t77LzSSNYpjQcM9DHnk5/Fswfg7dd0xmzz7NPvFoOftFgGGS0p2
# h0ek8nUtOmQ9evvicOTSECOWRHO9eclFnEkTChPgDxp5LAnrnsRYhZbcBWSex3cM
# afe5Y7VK4onLSctrtw==
# SIG # End signature block
