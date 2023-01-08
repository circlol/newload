$Global:GetHardwareInfoLastUpdated = '20220829'

function Get-CPU() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Switch] $NameOnly,
        [Parameter(Mandatory = $false)]
        [String] $Separator = '|'
    )

    $CPUName = ""

    ForEach ($Item in (Get-ItemProperty "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0").ProcessorNameString.Trim(" ").Split(" ")) {
        If (($Item -ne " ") -or ($null -ne $Item)) {
            $CPUName = $CPUName.Trim(" ") + " " + $Item.Trim(" ")
        }
    }

    If ($NameOnly) {
        return "$CPUName"
    }

    $CPUCoresAndThreads = "($((Get-CimInstance -class Win32_processor).NumberOfCores)C/$env:NUMBER_OF_PROCESSORS`T)"

    return "$Env:PROCESSOR_ARCHITECTURE $Separator $CPUName $CPUCoresAndThreads"
}

function Get-GPU() {
    [CmdletBinding()]
    [OutputType([String])]

    $GPU = (Get-CimInstance -Class Win32_VideoController).Name
    Write-Verbose "Video Info: $GPU"

    return "$GPU"
}

function Get-RAM() {
    [CmdletBinding()]
    [OutputType([String])]

    $RamInGB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
    $RAMSpeed = (Get-CimInstance -ClassName Win32_PhysicalMemory).Speed[0]

    return "$RamInGB`GB ($RAMSpeed`MHz)"
}

function Get-OSArchitecture() {
    [CmdletBinding()]
    param (
        $Architecture = (Get-ComputerInfo -Property OSArchitecture)
    )

    If ($Architecture -like "*64*bit*") {
        $Architecture = @("x64")
    } ElseIf ($Architecture -like "*32*bit*") {
        $Architecture = @("x86")
    } ElseIf (($Architecture -like "*ARM") -and ($Architecture -like "*64")) {
        $Architecture = @("arm64")
    } ElseIf ($Architecture -like "*ARM") {
        $Architecture = @("arm")
    } Else {
        Write-Host "[?] Couldn't identify the System Architecture '$Architecture'. :/" -ForegroundColor Yellow -BackgroundColor Black
        $Architecture = $null
    }

    Write-Warning "$Architecture OS detected!"
    return $Architecture
}

function Get-OSDriveType() {
    [CmdletBinding()]
    [OutputType([String])]

    # Adapted from: https://stackoverflow.com/a/62087930
    $SystemDriveType = Get-PhysicalDisk | ForEach-Object {
        $PhysicalDisk = $_
        $PhysicalDisk | Get-Disk | Get-Partition |
        Where-Object DriveLetter -EQ "$($env:SystemDrive[0])" | Select-Object DriveLetter, @{ n = 'MediaType'; e = { $PhysicalDisk.MediaType } }
    }

    $OSDriveType = $SystemDriveType.MediaType
    return "$OSDriveType"
}

function Get-DriveSpace() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $false)]
        [String] $DriveLetter = $env:SystemDrive[0]
    )

    $SystemDrive = (Get-PSDrive -Name $DriveLetter)
    $AvailableStorage = $SystemDrive.Free / 1GB
    $UsedStorage = $SystemDrive.Used / 1GB
    $TotalStorage = $AvailableStorage + $UsedStorage

    return "$DriveLetter`: $($AvailableStorage.ToString("#.#"))/$($TotalStorage.ToString("#.#")) GB ($((($AvailableStorage / $TotalStorage) * 100).ToString("#.#"))%)"
}

function Get-SystemSpec() {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $false)]
        [String] $Separator = '|'
    )

    Write-Status -Types "@" -Status "Loading system specs..."
    # Adapted From: https://www.delftstack.com/howto/powershell/find-windows-version-in-powershell/#using-the-wmi-class-with-get-wmiobject-cmdlet-in-powershell-to-get-the-windows-version
    $WinVer = (Get-CimInstance -class Win32_OperatingSystem).Caption -replace 'Microsoft ', ''
    $DisplayVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
    $OldBuildNumber = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    $DisplayedVersionResult = '(' + @{ $true = $DisplayVersion; $false = $OldBuildNumber }[$null -ne $DisplayVersion] + ')'

    return $(Get-OSDriveType), $Separator, $WinVer, $DisplayedVersionResult, $Separator, $(Get-RAM), $Separator, $(Get-CPU -Separator $Separator), $Separator, $(Get-GPU)
}

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUX/TmFL3hn/yNvFKzsAU18YEm
# KlmgggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIyMTIyNDA1
# MDQzMloXDTIzMTIyNDA1MjQzMlowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKBzm18SMDaGJ9ft
# 4mCIOUCCNB1afaXS8Tx2dAnJ+84pGS4prKCxc7/F+n5uqXtPZcl88tr9VR1N/BBE
# Md4LWvD2o/k5WfkYPtBoatldnZs9d1HBgIrWJoulc3PidboCD4Xz9Z9ktfrcmhc8
# MfDD0DfSKswyi3N9L6t8ZRdLUW+JCh/1WHbt7o3ckvijEuKh9AOnzYtkXJfE+eRd
# DKK2sq46WlZG2Sm3J+WOo2oeoFvvYHRG9RtzSY2EhmVRYWzGFM/GCqLUbh2wZwdY
# uG61lCrkC6ZjEYPhs5ckoijMFC6bb4zYk4lYDzartHYiMxH1Ac0jNpaq+7kB3oRF
# QLXWc+kCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBRkAPIg1GpPJcyyzANerOe2sUGidTANBgkqhkiG9w0BAQsF
# AAOCAQEABc3czHPSCyEDQ9MzWSiW7EhjXsyyj6JfP0a2onvRPoW0EzBq3BxwpGGJ
# btML2ST94OmT8huibh8Cp2TnbAAxIhNU0tN3XMz2AXfJT5cr4MdHGDksiMj1Hcjn
# wxXAf6uYX3+jovGZbgpog0KUk88p2vhU1oZP0YpaRaOqnjUH+Ml4g1fOx8siBmGu
# vs9L+Kb5w2W8TjCBuGqGY4d8chxQe8A0ViZtp4LB+/1NAkt14GTwqOdWrKNIynMz
# Rpa+Wkey1J0tG5AhNp0hvwmAO6KFSGtXHuNWwua9IpLMJsowj2U2TmzqLSDC2YrO
# BgC97m41lByepRPQwnnV3p8NFn4CyTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQbsRA190DwbdBuskmJyNY4jAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUPga8w1xx0lk8aUIl5is6eEEANuwwDQYJKoZIhvcNAQEBBQAEggEAYDkb
# jjVF9pSSgl3/kv8x3oJ5wq1BGkKW01xPIDUZ3AY9Cr92K02/BzypsK1+JhVRhEJ9
# +g2CSScNA3R3a8UPY303Wpa50ymX/aTs3TznD3ec1yHINEofqgrRD1udrtUjgEkW
# k6YFZxNT9hzhK2Ecr1PSTcNv0iBz9gVK9AZIoXYbQ45R1jFh44hDaF0CSkx6rPv+
# SfArSGJPG+BBvhQ/4K3V+0kPWjEDHSizAMF8eFEN9+5FXX3OokS6XALByRJOtlRn
# RIDijrQYDJiblheRv19C78cYoWoDk48eLNM32myPDWr83XBsYkl903GOGmNKvrXc
# 0BbHR/J03DRaBV2SWg==
# SIG # End signature block
