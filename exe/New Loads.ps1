
$WindowTitle = "New Loads" ; $host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.BackgroundColor = 'Black' ; $host.UI.RawUI.ForegroundColor = 'White'
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
Clear-Host

$License = 20230930
$DateReq = 20230101
New-Variable -Name "License" -Value 20230331 -Scope Global -Force
New-Variable -Name "WantedID" -Value "Pacific Standard Time" -Scope Global -Force

Function Bootup() {
    $SYSTEMOSVERSION = ($PSVersionTable.BuildVersion).Build
    $MINIMUMREQUIREMENT = "19042"
    If ($SYSTEMOSVERSION -LE $MINIMUMREQUIREMENT -OR (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
        Write-Host "Error: New Loads requires a minimum Windows version of 20H2 (19042) and must be run as administrator." -Foregroundcolor White ; Start-Sleep -Seconds 3 ; Exit
    }
    
    # Function that displays program name, version, creator
    ScriptInfo

    # Simple switch to detect current execution policy and prompt user to change current process to remote signed
    $ExecutionPolicy = (Get-ExecutionPolicy)
    switch ($ExecutionPolicy) 
    {
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
    New-Variable -Name "Time" -Value (Get-Date -UFormat %Y%m%d) -Scope Global -Force
    New-Variable -Name "CheckDisplayName" -Value (Get-TimeZone).DisplayName -Scope Global -Force
    New-Variable -Name "WantedDisplayName" -Value '(UTC-08:00) Pacific Time (US & Canada)' -Scope Global -Force

    If ($Time -lt $License -and $Time -gt $DateReq) {} else 
    { 
        Clear-Host ; 
        Write-Host "There was an uncorrectable error.. Closing Application." ; 
        Start-Sleep -S 5 ; Exit 
    }


    try {
        stop-transcript | out-null
        Remove-Item .\log.txt -Force
        Remove-Item .\newloads-errorlog.txt -Force
        Remove-Item .\tmp.txt -Force
    }
    catch [System.InvalidOperationException] {Continue}
}    
Function LocalVariables() {
    New-Variable -Name "ProgramVersion" -Value "230108" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "newloads" -Value ".\" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "MaxLength" -Value '12' -Scope Global -Force
    New-Variable -Name "ErrorLog" -Value ".\newloads-errorlog.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Log" -Value ".\Log.txt" -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Win11" -Value "22000" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "22H2" -Value "22621" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value [System.Environment]::OSVersion.Version.Build -Option ReadOnly -Scope Global -Force
    New-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    New-Variable -Name "Connected" -Value "Internet" -Scope Global -Force
    New-Variable -Name "NewLoadsURL" -Value "https://raw.githubusercontent.com/circlol/newload/main/New%20Loads.ps1" -Scope Global -Force
    New-Variable -Name "NewLoadsURLMain" -Value "https://raw.githubusercontent.com/circlol/newload/main/" -Scope Global -Force
    
}
Function ScriptInfo() {
    $WindowTitle = "New Loads - Initialization" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    
    Write-Host "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

                ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗ 
                ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝ 
                ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗ 
                ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║ 
                ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝" -ForegroundColor Blue -BackgroundColor Black
    Write-Host ""
    Write-Host '                                                                                              '
    Write-Host "     " -NoNewline
    Write-Host "Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Mike" -ForegroundColor Blue -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$ProgramVersion" -NoNewLine -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "      Recommended: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Update Windows before using New Loads" -ForegroundColor Red -BackgroundColor Black
    Write-Host "`n`n▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`n`n" -ForegroundColor Blue -BackgroundColor Black
}


Function Use-WindowsForm() {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null # Load assembly
}
Function Show-Question() {
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DialogResult])]
    param (
        [String] $Title = "New Loads",
        [Array]  $Message = "      ",
        [String] $BoxButtons = "YesNoCancel", # With Yes, No and Cancel, the user can press Esc to exit
        [String] $BoxIcon = "Question"
    )

    Use-WindowsForm
    $Answer = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)

    return $Answer
}
Function CheckNetworkStatus() {
    Set-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    if ($NetStatus -ne $Connected) {
        Write-Status -Types "WAITING" -Status "Seems like theres no network connection.. Please Reconnect..." -Warning 
        do {
            Write-Status -Types ":(" -Status "Waiting for internet..."
            Start-Sleep -Seconds 2
        } until ((Get-NetConnectionProfile).IPv4Connectivity)# -Or (Get-NetConnectionProfile).IPv6Connectivity -eq 'Internet') 
        Start-Sleep -Seconds 3
        Write-Status -Types ":)" -Status "Connected... Moving on"
    }
}
Function Selector() {
    $Ask = "    Run New Loads in GUI or Automated mode?
        (  YES  ) = Automated
        (  NO  )  =   GUI
        ( CANCEL ) =  Exit"

    switch (Show-Question -Title "New Loads" -Message $Ask) {
        'Yes' {
            Write-Host "You have chosen to run New Loads in Automated Mode.. Initiating"
        }
        'No' {
            Write-Host "You have chosen to run New Loads in GUI Mode.. Initiating"
            New-Variable -Name "GUI" -Value $True -Scope Global
        }
        'Cancel' {
            Write-Host "Closing."
            Exit
        }
    }
}


LocalVariables
Bootup


If (Test-Path .\assets.psm1 ) {Import-Module .\assets.psm1 -Force} else { 
    Clear-Host ; Write-Host "assets.psm1 is missing. Please acquire this file to continue." 
    Start-Sleep 4 ; Exit
}

If (Test-Path .\CheckFiles.psm1) {Import-Module .\CheckFiles.psm1 -Force }else { 
    Clear-Host ; Write-Host "CheckFiles.psm1 is missing. Please acquire this file to continue." 
    Start-Sleep 4 ; Exit
}

### Default set to automatic now
Write-Host "New Loads has been set to Automated"
#Selector
CheckFiles
NewLoadsModules
CheckNetworkStatus
NewLoads

#Invoke-WebRequest -useb $NewLoadsURL | Invoke-Expression


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+F9Wkl34nlkkUaXq9bmLdA+W
# zxigggMQMIIDDDCCAfSgAwIBAgIQdcpoZIKDgr5HnNB+o6BnOzANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDEwODIy
# NTQzMFoXDTI0MDEwODIzMTQzMFowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALbOQYXbJ85gu1D3
# PWkH/v+WML05Km9QY9KU5x04J4ir5qAgvxEPW9KnQ3ylFUjthc944yvMNJZ/28DV
# tHqHdT7JOli9xF5KQHlsOBueMYH9ZJLxrJXa8r9/2o2SEdWr6kOdwWubhisVdAcU
# sCnB9qKPAOHEmYmMPCnzwfGkaGR7RjY9FSoKRFsptTlDcrTrq7YszQapGZRuRbDg
# zl1sCgGUch+/MF5VQ5eAq0KvOcsrzTgOVQ5+V/LgGJ8YYU4A0mYnvqMVbHgcE3MQ
# 1NV/MdXQaF700bBArXghPAeoAriC14kytRdJs4ViIA372AKkC5eBNJwDuIqbk4jh
# ELta0ZkCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBRUzfNrq/HATnVlEhQt70L6jmi9cjANBgkqhkiG9w0BAQsF
# AAOCAQEAoYMEMzrKpKJdMNNGA0+Sg9ZlJJZty6dUo3H/TigQcbZBBmv/k/nsqva4
# eRmD9+sI0s9BfqzsUysU6HUh0WRPkE5Ja2rp+pkbecD1vCuIRn+5jrDCuW6FKNna
# 4sLoyVrDoAef0nP/tNllw6QHwJQIC5lGmN4qWd9zCCv0b46W/s6WEd4meKE4bSL6
# Igu2F9fox7+DZMGn1yuiBeClDDXkbACJEDR6TJ6N3fZBaUIF1DTH6mBpecMmvKX4
# NIikml7j7f2Rk/VzY9IFRgsj38rNoQdAboaBy9hOXG4+5YRE12KVwG/eUaP6p5T/
# /Orn42NtISgWtOE7pqkcbYQj00drjDGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQdcpoZIKDgr5HnNB+o6BnOzAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUVRN2FrrlA4ksG+xL81G4bag0YfcwDQYJKoZIhvcNAQEBBQAEggEAJazZ
# rg85Y0ftstCSlsWf4CEuVttf13q3emeTDcYeFvGxWqhf2PYMFnemCeHcejMoKT6k
# 4HBy0iJVX1aX2kN+gL8SWJRVLQSeR5vw+CnkkiwImw3s9b59f9ZQiZAv0cFbSGfu
# komQSjbFM/DK4AQKjZt24GRcQ3eRuqmYbnk+Wx4s4JpTH57P4F90KSa5bI9VK0u1
# ef0qUEcvtpyx85pl+v0OCBrmXVFbNyIz2mCW3AaF4tHsU9P/I3ZkwPO5OSH/Qngc
# sV1wtBiwRFtSXgl42ZrSRDfQG+XJW2Zt6IeM6HrXEQgV6HZQHvUMEMxpLWMt/XAr
# 3lTgKLPhHMnuKFoIvQ==
# SIG # End signature block
