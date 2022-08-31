$Global:ManageSoftwareLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"show-dialog-window.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

function Install-Software() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [String]      $Name,
        [Array]       $Packages,
        [ScriptBlock] $InstallBlock = { winget install --silent --source "winget" --id $Package },
        [Parameter(Mandatory = $false)]
        [Switch]      $NoDialog,
        [String]      $PkgMngr = 'Winget',
        [Switch]      $ViaChocolatey,
        [Switch]      $ViaMSStore,
        [Switch]      $ViaWSL
    )

    $DoneTitle = "Information"
    $DoneMessage = "$Name installed successfully!"

    If ($ViaChocolatey) {
        $ViaMSStore, $ViaWSL = $false, $false
        $PkgMngr = 'Chocolatey'
        $InstallBlock = { choco install --ignore-dependencies --yes $Package }
        Write-Status -Types "?" -Status "Chocolatey is configured to ignore dependencies (bloat), you may need to install it before using any program." -Warning
    }

    If ($ViaMSStore) {
        $ViaChocolatey, $ViaWSL = $false, $false
        $PkgMngr = 'Winget (MS Store)'
        $InstallBlock = { winget install --source "msstore" --id $Package --accept-package-agreements }
    }

    If ($ViaWSL) {
        $ViaChocolatey, $ViaMSStore = $false, $false
        $PkgMngr = 'WSL'
        $InstallBlock = { wsl --install --distribution $Package }
    }

    Write-Title "Installing $($Name) via $PkgMngr"
    $DoneMessage += "`n`nInstalled via $PkgMngr`:`n"

    ForEach ($Package in $Packages) {
        If ($ViaMSStore) {
            Write-Status -Types "?" -Status "Reminder: Press 'Y' and ENTER to continue if stuck (1st time only) ..." -Warning
            $PackageName = (winget search --source 'msstore' --exact $Package)[-1].Replace("$Package Unknown", '').Trim(' ')
            $Private:Counter = Write-TitleCounter -Text "$Package - $PackageName" -Counter $Counter -MaxLength $Packages.Length
        } Else {
            $Private:Counter = Write-TitleCounter -Text "$Package" -Counter $Counter -MaxLength $Packages.Length
        }

        Try {
            Invoke-Expression "$InstallBlock" | Out-Host
            If (($LASTEXITCODE)) { throw $Err } # 0 = False, 1 = True

            If ($ViaMSStore) {
                $DoneMessage += " + $PackageName ($Package)`n"
            } Else {
                $DoneMessage += " + $Package`n"
            }
        } Catch {
            Write-Status -Types "!" -Status "Failed to install package via $PkgMngr" -Warning

            If ($ViaMSStore) {
                Start-Process "ms-windows-store://pdp/?ProductId=$Package"
                $DoneMessage += "[!] $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "[!] $Package`n"
            }
        }
    }

    Write-Host "$DoneMessage" -ForegroundColor Cyan

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }

    return $DoneMessage
}

function Uninstall-Software() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [String]      $Name,
        [Array]       $Packages,
        [ScriptBlock] $UninstallBlock = { winget uninstall --source "winget" --id $Package },
        [Parameter(Mandatory = $false)]
        [Switch]      $NoDialog,
        [String]      $PkgMngr = 'Winget',
        [Switch]      $ViaChocolatey,
        [Switch]      $ViaMSStore,
        [Switch]      $ViaWSL
    )

    $DoneTitle = "Information"
    $DoneMessage = "$Name uninstalled successfully!"

    If ($ViaChocolatey) {
        $ViaMSStore, $ViaWSL = $false, $false
        $PkgMngr = 'Chocolatey'
        $UninstallBlock = { choco uninstall --remove-dependencies --yes $Package }
        Write-Status -Types "?" -Status "Chocolatey is configured to remove dependencies (bloat), you may need to install it before using any program." -Warning
    }

    If ($ViaMSStore) {
        $ViaChocolatey, $ViaWSL = $false, $false
        $PkgMngr = 'Winget (MS Store)'
        $UninstallBlock = { winget uninstall --source "msstore" --id $Package }
    }

    If ($ViaWSL) {
        $ViaChocolatey, $ViaMSStore = $false, $false
        $PkgMngr = 'WSL'
        $UninstallBlock = { wsl --unregister $Package }
    }

    Write-Title "Uninstalling $($Name) via $PkgMngr"
    $DoneMessage += "`n`nUninstalled via $PkgMngr`:`n"

    ForEach ($Package in $Packages) {
        If ($ViaMSStore) {
            $PackageName = (winget search --source 'msstore' --exact $Package)[-1].Replace("$Package Unknown", '').Trim(' ')
            $Private:Counter = Write-TitleCounter -Text "$Package - $PackageName" -Counter $Counter -MaxLength $Packages.Length
        } Else {
            $Private:Counter = Write-TitleCounter -Text "$Package" -Counter $Counter -MaxLength $Packages.Length
        }

        Try {
            Invoke-Expression "$UninstallBlock" | Out-Host
            If (($LASTEXITCODE)) { throw $Err } # 0 = False, 1 = True

            If ($ViaMSStore) {
                $DoneMessage += " - $PackageName ($Package)`n"
            } Else {
                $DoneMessage += " - $Package`n"
            }
        } Catch {
            Write-Status -Types "!" -Status "Failed to uninstall package via $PkgMngr" -Warning

            If ($ViaMSStore) {
                $DoneMessage += "[!] $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "[!] $Package`n"
            }
        }
    }

    Write-Host "$DoneMessage" -ForegroundColor Cyan

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }

    return $DoneMessage
}

<#
Example:
Install-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser"
Install-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser" -NoDialog
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey -NoDialog
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore -NoDialog
Install-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL
Install-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL -NoDialog

Uninstall-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser"
Uninstall-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser" -NoDialog
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey -NoDialog
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore -NoDialog
Uninstall-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL
Uninstall-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL -NoDialog
#
# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfwqNAKLrc/3zDf2rN1e26a+g
# Uw+gggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFICjP/uvFmVd
# iU9N8WzKwtYZMeePMA0GCSqGSIb3DQEBAQUABIIBAFxs6nqSZ8YhfM9hqjCMl/Wn
# 2cU4VOzKLoEy02DAjMxsjTMiDD3NPKaODNlPBxFe71F25Fn80r0PpWlj4/g+z/QN
# bX3s7vXEUbDOKQVchZrVppfLX+YiJor6ii5rc7pDskgjWiFJX1tCy52D0Xjv116y
# +99RzZ3DUOmdOv7bg69W17OCnx4CUymbdp2XjFlE5gXtZwHJ9cdNf+RUKfVnPDLh
# STL1C4gpwDi4q/5plePevygY0Iv37XrunvVAHlFdVA28BRWnYWQ/pKevugUFWoYD
# Bs9Knbl4oJsDy76zFGv3K6MFAzkvtW4XWH9w+JIIjau26K5ssnK+xXW5fjnOQMc=
# SIG # End signature block
