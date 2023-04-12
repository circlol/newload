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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUEzgNIptfe+tXjRe0PTjunc9r
# ol2gggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFJQsgCzx7sWb
# TNRLTaw2vq0xS2FpMA0GCSqGSIb3DQEBAQUABIIBADdQHbYp2MntlzZh9r4JHN+U
# dr1T8t8b/5IIm06P+eqnePlWBxkmoK8gHgsnrybz40GWLUo5wL3XXuMfhc7ElKoK
# z1FDfrGFSJD1FLNkjGE0IeKmTe4pvRsZZXwT+qJxLhajkKg5g05g7eemqSI64WJq
# j8XBQdc14yxgzf47C9mzrQAiJ2ceptxY5JJEmJv7ngZa4rZaxvSshrCryXLlYd19
# FvUhz9bGURy3/q50jQe0yxgf9Qp7zFU4ED90YVCHaxltX5OT5xmg2b9kKqynFVgI
# vDPJW8+iae6pc0TWAmMbppN9KwuA0TVZlqGRbHlARgAvmaGvYqdmnkManPONsCc=
# SIG # End signature block
