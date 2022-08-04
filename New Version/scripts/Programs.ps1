Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"restart-explorer.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"get-hardware-info.psm1"
Import-Module -DisableNameChecking $PsScriptRoot\..\lib\"Variables.psm1"
Function Programs {

    #Google
    If (!(Test-Path -Path:$Location1)) {
        If (Test-Path -Path:$gcoi) {
            Write-Status -Types "+", $TweakType -Status "Google Chrome"
            Start-Process -FilePath:$gcoi -ArgumentList /passive -Verbose -Wait
            Write-Status -Types "+", "Registry" -Status "Flagging Google Chrome to Install UBlock Origin"
            REG ADD $PathToChromeExtensions /v update_url /t REG_SZ /d $PathToChromeLink /f | Out-Null
        }
        else {
            Write-Status -Types "+", "Registry" -Status "Flagging Google Chrome to Install UBlock Origin"
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD $PathToChromeExtensions /v update_url /t REG_SZ /d $PathToChromeLink /f | Out-Null
            Write-Status -Types "+", $TweakType -Status "Downloading Google Chrome"
            Start-BitsTransfer -Source $package1dl -Destination $package1lc | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Google Chrome"
            Start-Process -FilePath:$package1lc -ArgumentList /passive -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?" -Status "Google Chrome is already Installed on this PC." -warning
    }
    #VLC
    If (!(Test-Path -Path:$Location2)) {
        If (Test-Path -Path:$vlcoi) {
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$vlcoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            Write-Status -Types "+", $TweakType -Status "Downloading VLC Media Player"
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$package2lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?" -Status "VLC Media Player is already Installed on this PC." -Warning
    }
        
    #Zoom
    If (!(Test-Path -Path:$Location3)) {
        If (Test-Path -Path:$zoomoi) {
            Write-Status -Types "+", $tweaktype -Status "Installing Zoom"
            Start-Process -FilePath:$zoomoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            Write-Status -Types "+", $TweakType -Status "Downloading Zoom"
            Start-BitsTransfer -Source $Package3dl -Destination $package3lc | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Zoom"
            Start-Process -FilePath:$package3lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?" -Status "Zoom is already Installed on this PC." -Warning
    }
        
    #Adobe
    If (!(Test-Path -Path:$Location4)) {
        If (Test-Path -Path:$aroi) {
            Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64" 
            Start-Process -FilePath:$aroi -ArgumentList /sPB -Verbose
        }
        else {
            Write-Status -Types "+", $TweakType -Status "Downloading Adobe Acrobat Reader x64"
            Start-BitsTransfer -Source $Package4dl -Destination $package4lc | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64"
            Start-Process -FilePath:$package4lc -ArgumentList /sPB -Verbose    
        }
    }
    else {
        Write-Status -Types "?" -Status "Adobe Acrobat is already Installed on this PC." -warning
    }
}

Programs