$Global:GetHardwareInfoLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

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
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUE6TtUi2Vji41E205drI3THhf
# UEegggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFAzqpYPedmbK
# hQdSOmJ7vA1e2yB9MA0GCSqGSIb3DQEBAQUABIIBAIc7rWN+D/rZMklLfvvJZfBf
# v8JEIqfWbRl2SeGVQPM5ww9u2kjtDhM2LljMf/oh7kXdlKPgKX1yO6xFTTBDmg9r
# sNy/I5pKd13IYDCOS6lTp4CymwMNV4dHpT1MJuBikwblLE0JlgOA8xwFOBvTUXrW
# x7O3VkLfOA9HSBGIIEphRf2afZ2qHHPN+l11CT4kTfXygo0usBomPBAB/2sWvyX2
# Y1TGFzrFZebvFrxmRTlWr9mVKYwuLvspKwCUz5xS6LmaqiZA0H+2ODGBPG6l9guB
# vz5i5nvbjfAf4fWT6+rKbDwRh7UpQ8dVbX3yc7XY9VrMiAw7dxrs4QCFYUi/Kr4=
# SIG # End signature block
