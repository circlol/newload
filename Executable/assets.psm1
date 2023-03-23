$Global:BackgroundColor = "Black"
$Global:ForegroundColor = "DarkCyan"

Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor $ForegroundColor -Backgroundcolor $BackgroundColor
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "]`n" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "> " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionFailed() {
    [CmdletBinding()]
    param (
        [String] $Text = "Failed"
    )
    Write-Host "==> " -ForegroundColor Red -BackgroundColor $BackgroundColor -NoNewline
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionSucceed() {
    [CmdletBinding()]
    param (
        [String] $Text = "Success"
    )
    Write-Host "==> " -NoNewline -ForegroundColor Green -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionWarning() {
    [CmdletBinding()]
    param (
        [String] $Text = "Warning"
    )
    Write-Host "==> " -NoNewline -ForegroundColor Yellow -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-Section() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-Status() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Array]  $Types,
        [Parameter(Mandatory)]
        [String] $Status,
        [Switch] $Warning,
        [Switch] $NoNewLineLast
    )

    ForEach ($Type in $Types) {
        Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
        Write-Host "$Type" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
        Write-Host "]" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }

    If ($Warning) {
        If ($NoNewLine){
            Write-Host "-> $Status" -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        }else{
            Write-Host "-> $Status" -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        }
    } Else {
        If ($NoNewLine){
            Write-Host "-> $Status" -ForegroundColor White -BackgroundColor $BackgroundColor
        }else{
            Write-Host "-> $Status" -ForegroundColor White -BackgroundColor $BackgroundColor
        }
    }
}
Function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text",
        [Switch] $NoNewLineLast
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "<" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor

}

Function Write-TitleCounter() {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )

    #$Counter += 1
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    #Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    #Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "]" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host " (" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host " $Counter/$MaxLength " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ") " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "|" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    #Write-Host "(" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host " $Text " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    #Write-Host ") " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    #Write-Host "====================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    #Write-Host "ΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞΞ" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor

}
Function NewLoadsModules() {
    $Modules = (Get-ChildItem -Path ".\lib" -Include "*.psm1" -Recurse).Name
    ForEach ($Module in $Modules) {
    Import-Module .\lib\"$Module" -Force -Global
    }
}
Function NewLoads() {
    # Setting the window title
    $WindowTitle = "New Loads Utility" 
    $host.UI.RawUI.WindowTitle = $WindowTitle

    # Creats a new web client object
    $wc = New-Object System.Net.WebClient
    # Assures Internet 
    CheckNetworkStatus
    # Outputs the raw script into a variable
    $Script = $wc.DownloadString($NewLoadsURL)
    Invoke-Expression $Script

}
Function CheckFiles() {
    Try {
        $folders = @("bin", "assets", "lib")
        $folders | ForEach-Object {
            if (!(Test-Path ".\$_" -PathType Container -ErrorAction SilentlyContinue)) {
                Write-Status -Types "+" -Status "Creating $_ Folder."
                New-Item -ItemType Directory -Path ".\$_" -Force | Out-Null
            }
        }
        If (Test-Path ".\tmp.txt") {
            Write-Status -Types "-" -Status "Removing a previously runs tmp.txt."
            Remove-Item ".\tmp.txt" -Force -ErrorAction SilentlyContinue
        }
        If (Test-Path .\ErrorLog.txt) {
            Write-Status -Types "-" -Status "Removing a previous runs ErrorLog.txt."
            Remove-Item -Path ".\ErrorLog.txt" -Force -ErrorAction SilentlyContinue
        }
    }
    Catch {
        Write-Error "An error occurred while creating folders or removing files: $_"
    }

    Write-Section -Text "Scanning Exisitng Files"
    New-Variable -Name "Files" -Value @(        
        "lib\get-hardware-info.psm1",
        "lib\office.psm1",
        "lib\optimizeWindows.psm1",
        "lib\remove-uwp-appx.psm1",
        "lib\restart-explorer.psm1",
        "lib\set-scheduled-task-state.psm1",
        "lib\set-service-startup.psm1",
        "lib\set-windows-feature-state.psm1",
        "lib\Templates.psm1",
        "lib\Variables.psm1",
        "Assets\10.jpg",
        "Assets\10_mGaming.png",
        "Assets\11.jpg",
        "Assets\11_mGaming.png",
        "Assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx",
        "Assets\settings.cfg"
        "Assets\settings-revert.cfg"
        "Assets\start2.bin" 
    ) -Scope Global -Force

    # Creates an array for missing files
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) {
        If (Test-Path ".\$file" -PathType Leaf -ErrorAction SilentlyContinue) {
            Write-CaptionSucceed -Text "$file Validated"
        }
        else {
            Write-CaptionFailed -Text "$file Failed to validate."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }
    else {
        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        CheckNetworkStatus
        Write-Section -Text "Downloading Missing Files"
        ForEach ($url in $urls) {
                $link = $NewLoadsURLMain + $url
                Write-Status -Types "+","Modules" -Status "Attempting to Download $url"
                Start-BitsTransfer -Dynamic -Source "$link" -Destination ".\$url" -Verbose -TransferType Download -Confirm:$False -OutVariable bitsTransfers
                Check
        }
        While ((Get-BitsTransfer | Where {$_.JobState -eq "Transferring"})) {
            Write-Verbose "Waiting for downloads to complete..."
            Start-Sleep -Seconds 1
        }
        $status = Get-BitsTransfer | Where {$_.JobState -eq "Error"}
        If ($status) {
            Write-Error "An error occurred while downloading files : $status"
        }
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile -Force -ErrorAction SilentlyContinue
        }
        
        Write-Section "Importing Modules"
        ForEach ($url in $URLs){
        If (Test-Path ".\$url" -Include "*.psm1" -ErrorAction SilentlyContinue) {
            Write-Status -Types "+","Modules" -Status "Attempting to Import Module: $url"
            Import-Module -DisableNameChecking ".\$url"
            Check
        }
    }

}
<#
Write-Break ; Write-Caption -Text "This is a Test Message" ; Write-CaptionFailed -Text "This is a Test Message" ; Write-CaptionSucceed -Text "This is a Test Message" ; Write-CaptionWarning -Text "This is a Test Message" ; Write-Section -Text "This is a Test Message" ; Write-Status -Types "+" , "Test" -Status "This is a Test Message" ; Write-Title -Text "This is a Test Message" ; Write-TitleCounter -Counter "4" -MaxLength "15" -Text "This is a Test Message"
#>



# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6RPXtZKAufMrS9v+ZiaRVzls
# dBagggMQMIIDDDCCAfSgAwIBAgIQEznIweLy56VByeu0DO3dHDANBgkqhkiG9w0B
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
# CQQxFgQUeo+dqnTFfPxdIm9rkOPp6dDrcxswDQYJKoZIhvcNAQEBBQAEggEAKScE
# EGo7eQJnSc74SuGOJj17PLDSCEmMgrj9mlpw5qIxxRQWbccMMfPcHSx1z+Ks4+wh
# hgp3mndvhgajjOgqRfBxveNTvWHh47nt4P7CYZc9n7ac/A87bTgiAb38J6vrIL3f
# eaBb+I0hdySeRHc8T4qQccxDMwiWad+A3DnIKD6yMhGZmYFcAhwduc4gGffXw1P+
# CjDwYKHjCqcb4nd1gckIKECXndHzmyBRoh/pfeuGLDzEHaGRDLu4EHDpX7RSIO4b
# 6rA6U1VtV5f0oZnNdbpVFh2X2dIGxjus1yumeH5qgao2sT7X2QIJ6RmygN80dG+2
# 68apjNzfP+bgkwyBQw==
# SIG # End signature block
