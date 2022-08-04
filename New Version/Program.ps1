#Requires -RunAsAdministrator
$WindowTitle = "New Loads - Initializing" ; $host.UI.RawUI.WindowTitle = $WindowTitle
                                            $host.UI.RawUI.BackgroundColor = 'Black'
                                            $host.UI.RawUI.ForegroundColor = 'White'

                                            
$Win11 = '22000'
$22H2 = '22593'
$BuildNumber = [System.Environment]::OSVersion.Version.Build

Stop-Transcript ; Clear-Host
Import-Module -DisableNameChecking ".\lib\get-hardware-info.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\new-shortcut.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\open-file.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\restart-explorer.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\set-scheduled-task-state.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\set-service-startup.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\Set-Wallpaper.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\set-windows-feature-state.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\show-dialog-window.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\start-logging.psm1" -ErrorAction SilentlyContinue
Import-Module -DisableNameChecking ".\lib\Templates.psm1" -ErrorAction SilentlyContinue
Function BootCheck() {
    $wantedid = "Pacific Standard Time"
    $checkdisplayname = (Get-TimeZone).DisplayName
    $wanteddisplayname = '(UTC-08:00) Pacific Time (US & Canada)'
    $Time = (Get-Date -UFormat %Y%m%d)
    $tslrd = 20220201
    
    ### Checks for a network connection ###
    $NetStatus = (Get-NetConnectionProfile).IPv4Connectivity
    $Connected = "Internet"
    If ($NetStatus -eq $Connected) {
        Write-Status -Types "+" -Status "Detected an Active Internet Connection."
        #Grabs License
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/circlol/newload/main/Assets/Individual%20Functions/ls/license.ps1')) -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        #Detects Time-Zone and Changes to UTC -8
        If (!($checkdisplayname -eq $wanteddisplayname)) {
            Write-Status -Types "+" -Status "Setting Time-Zone to $wanteddisplayname"
            Set-TimeZone -Id $wantedid -Verbose
        }
        #Checks License against This PC        
        If ($Time -gt $License) {
            Write-Status -Types "-", "ERROR" -Status "License failed to validate. Closing Application" -Warning
            Exit
        }
        elseIf ($Time -gt $tslrd) {
            Write-Status -Types "+", "ACTIVATED" "License is valid."
        }
        else { Write-Status -Types "?", "ERROR" -Status "Program Error. Please Restart Application" ; exit }

    }
    elseif ($NetStatus -ne $Connected) {
        Write-Status -Types "?", "ERROR" -Status "This PC Does Not Seem to have and Active Internet Connection. Please rectify and run the script again." -Warning 
        Start-Sleep -s 5
        exit
    }
}
Function CheckFiles() {
    Write-Title -Text "New Loads Integrity Check"
    If (!(Test-Path ".\bin")) { mkdir ".\bin" }
    If (!(Test-Path ".\assets")) { mkdir ".\assets" }
    If (!(Test-Path ".\lib")) { mkdir ".\lib" }
    If (!(Test-Path ".\scripts")) { mkdir ".\scripts" }
    If (!(Test-Path "C:\Windows\Setup\Scripts")) { mkdir "C:\Windows\Setup\Scripts" }

    Write-Section -Text "Scanning Exisitng Files"
    
    $Files = @(
        "bin\googlechromestandaloneenterprise64.msi"
        "bin\vlc-3.0.17-win64.msi"
        "bin\ZoomInstallerFull.msi"
        
        "Assets\Branding.png"
        "Assets\diskette.png"
        "Assets\Floppy.png"
        "Assets\logo.png"
        "Assets\microsoft.png"
        "Assets\NoBranding.png"
        "Assets\toolbox.png"
        
        "Assets\win10.jpg"
        "Assets\win11.jpg"
        
        "lib\get-hardware-info.psm1"
        "lib\new-shortcut.psm1"
        "lib\open-file.psm1"
        "lib\restart-explorer.psm1"
        "lib\set-scheduled-task-state.psm1"
        "lib\set-service-startup.psm1"
        "lib\set-wallpaper.psm1"
        "lib\set-windows-feature-state.psm1"
        "lib\show-dialog-window.psm1"
        "lib\start-logging.psm1"
        "lib\Templates.psm1"
        "lib\Variables.psm1"
        )
    ###  Generates an Empty Array  ###
    $Items = [System.Collections.ArrayList]::new()

    ### Checks if each file exists on the computer ###
    ForEach ($file in $files) {
        If (Test-Path ".\$File") {
            Write-CaptionSucceed -Text "$File Validated"
        }
        else {
            Write-CaptionFailed -Text "$file Failed to validate."
            $Items += $file
        }
    }

    ### Validates files - Downloads missing files from github ###
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }
    else {

        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        Start-Sleep -Seconds 2
        Write-Section -Text "Downloading Missing Files"
        
        
        ForEach ($url in $urls) {
            Write-Caption "Attempting to Download $url"
            $link = "https://raw.githubusercontent.com/circlol/newload/main/" + $url.replace('\', '/')
            Start-BitsTransfer -Source "$link" -Destination ".\$url" -Verbose -TransferType Download -RetryTimeout 60 -RetryInterval 60
            Check
        }
    }
}
Function Variables() {
    New-Variable -Name "ProgramVersion" -Value "22801.631" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "newloads" -Value ".\" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "Log" -Value ".\Log.txt" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "ctemp" -Value "C:\Temp" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Option ReadOnly -Scope Global -Force

    New-Variable -Name "Win11" -Value "22000" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "22H2" -Value "22593" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value [System.Environment]::OSVersion.Version.Build -Option ReadOnly -Scope Global -Force
    #PathLocations
    #Package/Location1 - Google Chrome 2- VLC 3- Zoom 4- Adobe Acrobat
    New-Variable -Name "Package1" -Value "googlechromestandaloneenterprise64.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package2" -Value "vlc-3.0.17-win64.msi" -Option ReadOnly -Scope Global -Force 
    New-Variable -Name "Package3" -Value "ZoomInstallerFull.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package4" -Value "AcroRdrDCx642200120085_MUI.exe" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "oi" -Value ".\bin" -Option ReadOnly -Scope Global -Force
    
    #Offline installer locations
    New-Variable -Name "Location1" -Value "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location2" -Value "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location3" -Value "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location4" -Value "$Env:PROGRAMFILES\Adobe\Acrobat DC\Acrobat\Acrobat.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Location5" -Value "C:\Windows\SysWOW64\OneDriveSetup.exe" -Option ReadOnly -Scope Global -Force
    
    #Offline installer package location
    New-Variable -Name "Package1lc" -Value "$oi\$package1" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package2lc" -Value "$oi\$package2" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package3lc" -Value "$oi\$package3" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package4lc" -Value "$oi\$package4" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "OneDriveLocation" -Value "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe" -Option ReadOnly -Scope Global -Force
    
    #download links
    New-Variable -Name "Package1dl" -Value "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package2dl" -Value "https://get.videolan.org/vlc/3.0.17.4/win64/vlc-3.0.17.4-win64.msi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package3dl" -Value "https://zoom.us/client/5.11.4.7185/ZoomInstallerFull.msi?archType=x64" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Package4dl" -Value "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe" -Option ReadOnly -Scope Global -Force
    
    #Offline installers
    New-Variable -Name "gcoi" -Value ".\bin\$package1" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "vlcoi" -Value ".\bin\$package2" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "zoomoi" -Value ".\bin\$package3" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "aroi" -Value ".\bin\$package4" -Option ReadOnly -Scope Global -Force
    
    #Bloat
    New-Variable -Name "livesafe" -Value "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "webadvisor" -Value "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "WildGames" -Value "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe" -Option ReadOnly -Scope Global -Force
    
    #shortcuts
    New-Variable -Name "EdgeShortcut" -Value "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "acrosc" -Value "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "edgescpub" -Value "$Env:PUBLIC\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "vlcsc" -Value "$Env:PUBLIC\Desktop\VLC Media Player.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "zoomsc" -Value "$Env:PUBLIC\Desktop\Zoom.lnk" -Option ReadOnly -Scope Global -Force
    
    #Reg
    New-Variable -Name "PathToChromeExtensions" -Value "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToChromeLink" -Value "https://clients2.google.com/service/update2/crx" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "lfsvc" -Value "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "wifisense" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regcam" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regexlm" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regsys" -Value "HKLM:\Software\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "siufrules" -Value "HKCU:\Software\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "reginp" -Value "HKCU:\Software\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regcv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regcdm" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regex" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regexadv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regadvertising" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regpersonalize" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regsearch" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
    
    #Branding
    New-Variable -Name "PathToOEMInfo" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "website" -Value "https://www.mothercomputers.com" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "hours" -Value "Monday - Saturday 9AM-5PM | Sunday - Closed"  -Option ReadOnly -Scope Global -Force
    New-Variable -Name "phone" -Value "(250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "store" -Value "Mother Computers" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "model" -Value "Mother Computers - (250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "page" -Value "Model" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "commonapps" -Value "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Option ReadOnly -Scope Global -Force
    
    
    #Wallpaper
    New-Variable -Name "wallpaper" -Value "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "currentwallpaper" -Value (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper -Option ReadOnly -Scope Global -Force
    New-Variable -Name "sysmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme -Option ReadOnly -Scope Global -Force
    New-Variable -Name "appmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme -Option ReadOnly -Scope Global -Force
    
    #Office Removal
    New-Variable -Name "path86" -Value "C:\Program Files (x86)\Microsoft Office" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "path64" -Value "C:\Program Files\Microsoft Office 15" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "officecheck" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "office32" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "office64" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "SaRA" -Value "$newloads\SaRA.zip" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Sexp" -Value "$newloads\SaRA" -Option ReadOnly -Scope Global -Force
    
    # ProgList
    New-Variable -Name "unviewdest" -Value "$newloads\" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "html" -Value "$newloads\unview.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "list" -Value "$newloads\ProgList.html", "$newloads\ProgList.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "link" -Value "https://github.com/circlol/newload/raw/main/Assets/unview.exe" -Option ReadOnly -Scope Global -Force
}
Function Programs() {
    Write-Title -Text "Downloading Applications"
    Write-Section -Text "Google Chrome"
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
            Start-BitsTransfer -Source $package1dl -Destination $package1lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Google Chrome"
            Start-Process -FilePath:$package1lc -ArgumentList /passive -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Google Chrome is already Installed on this PC." -warning
    }

    Write-Section -Text "VLC Media Player"
    #VLC
    If (!(Test-Path -Path:$Location2)) {
        If (Test-Path -Path:$vlcoi) {
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$vlcoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            Write-Status -Types "+", $TweakType -Status "Downloading VLC Media Player"
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$package2lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "VLC Media Player is already Installed on this PC." -Warning
    }
        
    Write-Section -Text "Zoom"
    #Zoom
    If (!(Test-Path -Path:$Location3)) {
        If (Test-Path -Path:$zoomoi) {
            Write-Status -Types "+", $tweaktype -Status "Installing Zoom"
            Start-Process -FilePath:$zoomoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            Write-Status -Types "+", $TweakType -Status "Downloading Zoom"
            Start-BitsTransfer -Source $Package3dl -Destination $package3lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Zoom"
            Start-Process -FilePath:$package3lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Zoom is already Installed on this PC." -Warning
    }
        
    Write-Section -Text "Adobe Acrobat"
    #Adobe
    If (!(Test-Path -Path:$Location4)) {
        If (Test-Path -Path:$aroi) {
            Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64" 
            Start-Process -FilePath:$aroi -ArgumentList /sPB -Verbose
        }
        else {
            Write-Status -Types "+", $TweakType -Status "Downloading Adobe Acrobat Reader x64"
            Start-BitsTransfer -Source $Package4dl -Destination $package4lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64"
            Start-Process -FilePath:$package4lc -ArgumentList /sPB -Verbose    
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Adobe Acrobat is already Installed on this PC." -warning
    }
}
Function StartMenu() {
    Write-Title -Text "Applying Taskbar Layout"
    $StartLayout = @"
    <LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
        <LayoutOptions StartTileGroupCellWidth="6" />
        <DefaultLayoutOverride>
            <StartLayoutCollection>
                <defaultlayout:StartLayout GroupCellWidth="6" />
            </StartLayoutCollection>
        </DefaultLayoutOverride>
        <CustomTaskbarLayoutCollection PinListPlacement="Replace">
            <defaultlayout:TaskbarLayout>
            <taskbar:TaskbarPinList>
                <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
                <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
                <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
                <taskbar:DesktopApp DesktopApplicationID="Chrome" />
                <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer"/>
                </taskbar:TaskbarPinList>
            </defaultlayout:TaskbarLayout>
        </CustomTaskbarLayoutCollection>
    </LayoutModificationTemplate>
"@

    $layoutFile = "C:\Windows\StartMenuLayout.xml"
    #Deletes the Layout file if one exists already.
    If (Test-Path $layoutFile) { Remove-Item $layoutFile }

    #Creates a new layout file
    $StartLayout | Out-File $layoutFile -Encoding ASCII

    $regAliases = @("HKLM", "HKCU")

    #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
    foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        If (!(Test-Path -Path $keyPath)) { New-Item -Path $basePath -Name "Explorer" }
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
    }

    #Restart Explorer
    Restart-Explorer
    Start-Sleep -s 3
    $wshell = new-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 3
    Restart-Explorer

    #Enable the ability to pin items again by disabling "LockedStartLayout"
    Foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
    }
    
    #the next line makes clean start menu default for all new users
    Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
    
    #Restarts Explorer and removes layout file
    Remove-Item $layoutFile -Verbose
}
Function Visuals() {
    $TweakType = "Visual"
    If ($BuildNumber -ge $Win11) {
        Write-Title -Text "Dectected Windows 11"
        Write-Status -Types "+", "$TweakType" -Status "Applying Wallpaper for Windows 11"
        $PathToFile = Get-ChildItem -Path ".\Assets" -Recurse -Filter "11.jpg" | ForEach-Object { $_.FullName }
        Copy-Item -Path "$PathToFile" -Destination "C:\Windows\SysWOW64\oobe\11.jpg" -Verbose -Force -Confirm:$False ; $PathToFile = "C:\Windows\SysWOW64\oobe\11.jpg"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value "$PathToFile"
        Set-ItemProperty -Path $regpersonalize -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $regpersonalize -Name "AppsUseLightTheme" -Value 0
        RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine ; Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted"
        $Status = ($?) ; If ($Status) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set" } elseif (!($Status)) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper" -Warning } else { Write-Host " idk wtf happened" }
        
    }
    elseif ($BuildNumber -Lt $Win11) {
        Write-Title -Text "Dectected Windows 10"
        Write-Status -Types "+", "$TweakType" -Status "Applying Wallpaper for Windows 10"
        $PathToFile = Get-ChildItem -Path ".\Assets" -Recurse -Filter "10.jpg" | ForEach-Object { $_.FullName }
        Copy-Item -Path "$PathToFile" -Destination "C:\Windows\SysWOW64\oobe\10.jpg" -Verbose -Force -Confirm:$False ; $PathToFile = "C:\Windows\SysWOW64\oobe\10.jpg"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value "$PathToFile"
        Set-ItemProperty -Path $regpersonalize -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $regpersonalize -Name "AppsUseLightTheme" -Value 0
        RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine ; Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted"
        $Status = ($?) ; If ($Status) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set" } elseif (!($Status)) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper" -Warning } else { Write-Host " idk wtf happened" }
    }
}
Function Branding() {
    If ((Get-ItemProperty -Path $PathToOEMInfo).Manufacturer -eq "$store") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "Manufacturer" -Type String -Value "$store"
        Check
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportPhone -eq $phone) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportPhone" -Type String -Value "$phone"
        Check
        
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportHours -eq "$hours") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportHours" -Type String -Value "$hours"
        Check
    }
    
    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportURL -eq $website) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportURL" -Type String -Value $website
        Check
    }
    If ((Get-ItemProperty -Path $PathToOEMInfo).Model -eq "$model") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name $page -Type String -Value "$Model"
        Check
    }
}
Function OfficeCheck {
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path "$path64") { $office64 = $true }Else { $office64 = $false }
    If (Test-Path "$path86") { $Office32 = $true }Else { $office32 = $false }
    If ($office32 -eq $true) { $officecheck = $true }       
    If ($office64 -eq $true) { $officecheck = $true }    
    If ($officecheck -eq $true) { Write-Status -Types "WAITING" -Status "Office Exists" -Warning }Else { Write-Status -Types "?" -Status "Office Doesn't Exist on This Machine" -Warning }
    If ($officecheck -eq $true) { Office_Removal_AskUser }
}
Function Office_Removal_AskUser {
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('Office exists. Would you like to remove off this PC?', 'New Loads', 'YesNo', 'Question')
    switch ($msgBoxInput) {
    
        'Yes' {
            Start-BitsTransfer -Source:https://aka.ms/SaRA_CommandLineVersionFiles -Destination:"$SaRA" | Out-Host
            Expand-Archive -Path "$SaRA" -DestinationPath "$Sexp" -Force
            Check
            Start-Process "$Env:temp\New Loads\SaRA\SaRAcmd.exe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -Officeversion All -CloseOffice" -Wait -Verbose -NoNewWindow | Out-Host
        }
    
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
    }    
    
}
Function Debloat() {

    Write-Section -Text "Checking for Win32 Pre-Installed Bloat"
    $TweakTypeLocal = "Win32"
    #McAfee Live Safe Removal
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Attemping Removal of McAfee Live Safe."
        Start-Process "$livesafe"
    }
    #WebAdvisor Removal
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Attemping Removal of McAfee WebAdvisor Uninstall."
        Start-Process "$webadvisor"
    }
    #Preinsatlled on Acer machines primarily WildTangent Games
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Attemping Removal WildTangent Games."
        Start-Process $WildGames 
    }

    $apps = @(
        "Amazon"
        "Booking"
        "Booking.com"
        "Forge of Empires"
        "Planet9 Link"
        "OneDrive"
    )
    $TweakTypeLocal = "Shortcuts"
    ForEach ($app in $apps) {
        
        If (Test-Path -Path "$commonapps\$app.url") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.url"
            Remove-Item -Path "$commonapps\$app.url" -Force -Verbose
        }

        If (Test-Path -Path "$commonapps\$app.lnk") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.lnk"
            Remove-Item -Path "$commonapps\$app.lnk" -Force -Verbose
        }
    }
    Write-Host "" ; Write-Section -Text "Removing UWP Apps"
    $TweakTypeLocal = "UWP"
    $Programs = @(
        "Clipchamp.Clipchamp"
        "Disney.37853FC22B2CE"
        "Disney.37853FC22B2CE_6rarf9sa4v8jt"
        "SpotifyAB.SpotifyMusic_zpdnekdrzrea0"
        "SpotifyAB.SpotifyMusic"
        "4DF9E0F8.Netflix"
        "C27EB4BA.DropboxOEM"
        "2FE3CB00.PicsArt-PhotoStudio"
        "26720RandomSaladGamesLLC.HeartsDeluxe"
        "26720RandomSaladGamesLLC.SimpleSolitaire"
        "26720RandomSaladGamesLLC.SimpleMahjong"
        "26720RandomSaladGamesLLC.Spades"
        "5319275A.WhatsAppDesktop" 
        "5A894077.McAfeeSecurity"
        "57540AMZNMobileLLC.AmazonAlexa"
        "7EE7776C.LinkedInforWindows"
        "89006A2E.AutodeskSketchBook"
        "AD2F1837.HPSupportAssistant"
        "AD2F1837.HPPrinterControl"
        "AD2F1837.HPQuickDrop"
        "AD2F1837.HPSystemEventUtility"
        "AD2F1837.HPPrivacySettings"
        "AD2F1837.HPInc.EnergyStar"
        "AD2F1837.HPAudioCenter"
        "A278AB0D.DisneyMagicKingdoms"
        "A278AB0D.MarchofEmpires"
        "AdobeSystemsIncorporated.AdobeLightroom"
        "AcerIncorporated.AcerRegistration"
        "AcerIncorporated.QuickAccess"
        "AcerIncorporated.UserExperienceImprovementProgram"
        "AcerIncorporated.AcerCareCe nterS"
        "AcerIncorporated.AcerCollectionS"
        "DolbyLaboratories.DolbyAudio"
        "DolbyLaboratories.DolbyAccess"
        "CorelCorporation.PaintShopPro"
        "CyberLinkCorp.ac.PowerDirectorforacerDesktop"
        "CyberLinkCorp.ac.PhotoDirectorforacerDesktop"
        "DB6EA5DB.CyberLinkMediaSuiteEssentials"
        "E0469640.LenovoUtility"
        "Evernote.Evernote"
        "FACEBOOK.317180B0BB486"
        "Microsoft.3DBuilder"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.AppConnector"
        "Microsoft.ConnectivityStore"
        "Microsoft.MinecraftEducationEdition"
        "Microsoft.MinecraftUWP"
        "Microsoft.Messaging"
        "Microsoft.MixedReality.Portal"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.Office.Hub"
        "Microsoft.Office.Lens"
        "Microsoft.Office.Sway"
        "Microsoft.Office.OneNote"
        "Microsoft.OneConnect"
        "Microsoft.OneDriveSync"
        "Microsoft.People"
        "Microsoft.SkypeApp"
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"
        #"Microsoft.WindowsMaps"
    )
    Foreach ($Program in $Programs) {
        If (Get-AppxPackage -Name $program) {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $Program from this account"
            Get-AppxPackage -Name $Program | Remove-AppxPackage | Out-Host
            If ($?) { Write-CaptionSucceed -Text "$Program was successfully removed for $env:COMPUTERNAME\$env:USERNAME." }else {
                Write-Status -Types "?", "$TweakType" , "$TweakTypeLocal" -Status "$Program was not removed" -Warning
            }
        }
        If (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like $Program) {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $Program from this PC"
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Host
            If ($?) { Write-CaptionSucceed -Text "$Program was successfully debloated from future accounts." }else {
                Write-Status -Types "?", "$TweakType" , "$TweakTypeLocal" -Status "$Program was not removed" -Warning
            }
            
        }
        else {
            Write-Status -Types "?", "$TweakType" , "$TweakTypeLocal" -Status "$Program was not found on this PC" -Warning
        }


    }
}
Function OneDriveRe() {
    If (Test-Path $Location5 -ErrorAction SilentlyContinue) {
        If (Test-Path $Location5 -ErrorAction SilentlyContinue) {
            If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue) {
                Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
                Write-Status -Types "-" -Status "Removing OneDrive."
            }
            Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose

        }
        If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue) {
            Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
            Write-Status -Types "-" -Status "Removing OneDrive."
        }
        Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose
    }
    
    Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose
    
    If (Test-Path -Path $env:OneDrive) { Remove-Item -Path "$env:OneDrive" -Force -Recurse }
    If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") { Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse }
    If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") { Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse }
    
    Write-Output "Removing scheduled task"
    Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -Verbose -ErrorAction SilentlyContinue
    

    Write-Status -Types "-","$TweakType" -Status "Removing OneDrive Installation Hook for New Users"
    # Thank you Matthew Israelsson
    reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
    reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
    reg unload "hku\Default"
}
Function AdvRegistry() {
    param (
        [Parameter(Mandatory = $True)]
        [String]$Action
    )
    $Vari = Switch ($Action) {
        "Apply" { "1" }
        "Undo" { "2" }
        "*" { "3" }
    }

    If ($vari -eq '1') {
        #Write-Section -Text " Applying Changes"
        $1 = '1'
        $0 = '0'
        $tbm = '1'
    }
    else {
        If ($Vari -eq '2') {
            #Write-Section -Text " Undoing Changes"
            $1 = '0'
            $0 = '1'
            $tbm = '2'
        }
        
    }
    If (!($1 -ne '1')){
            Write-Section -Text "Removing Unnecessary Printers"
            Write-Status -Types "-","Printer" -Status "Attempting to Remove Microsoft XPS Document Writer Printer..."
            Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction SilentlyContinue -Verbose
            If ($?) {Write-Status -Types "-","Printer" -Status "Removed Microsoft XPS Document Writer..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
            Write-Status -Types "+","Printer" -Status "Attempting to Remove Fax Printer..."
            Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue -Verbose 
            If ($?) {Write-Status -Types "-","Printer" -Status "Removed Microsoft XPS Document Writer..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
            
            Write-Status -Types "+","Printer" -Status "Attempting to Remove OneNote Printer..."
            Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue -Verbose
            If ($?) {Write-Status -Types "-","Printer" -Status "Removed Microsoft XPS Document Writer..."} elseif (!($?)){Write-Status -Types "?","Printer" -Status "Failed to Remove Microsoft XPS Document Writer..." -warning }
        }


        If ($BuildNumber -lt $WantedBuild) {
            ## Windows 10
            Write-Section -Text "Applying Windows 10 Specific Reg Keys"
            ## Changes search box to an icon
            If ((Get-ItemProperty -Path $regsearch).SearchBoxTaskbarMode -eq 1) { Write-Host " Skipping" } Else {
                Write-Status -Types '*',"$TweakType" -Status "Switching Search Box to an Icon."
                Set-ItemProperty -Path $regsearch -Name "SearchboxTaskbarMode" -Value $tbm -Verbose 
                Check
            }
            
            
            ## Removes Cortana from the taskbar
            If ((Get-ItemProperty -Path $regexadv).ShowCortanaButton -eq $0) { Write-Host " Skipping" } Else {
                Write-Status -Types "-","$TweakType" -Status "Removing Cortana Button from Taskbar.."
                Set-ItemProperty -Path $regexadv -Name "ShowCortanaButton" -Value $0 -Verbose
                Check
            }
            
            ## Unpins taskview from Windows 10 Taskbar
            If ((Get-ItemProperty -Path $Regexadv).ShowTaskViewButton -eq $0) { Write-Host " Skipping" } else {
                Write-Status -Types "-","$TweakType" -Status "Removing TaskView from Taskbar.."
                Set-ItemProperty -Path $regexadv -Name "ShowTaskViewButton" -Value $0 -Verbose
                Check
            }
            
            ##  Hides 3D Objects from "This PC"
            If (Test-Path -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}") {
                Write-Status -Types "-","$TweakType" -Status "Removing 3D Objects from This PC.."
                Remove-Item -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -Verbose
                Check
            }
            
            ## Expands explorers ribbon
            If (!(Test-Path -Path $regex\Ribbon)) {
                New-Item -Path "$regex" -Name "Ribbon" -Force -Verbose
            }
            
            If ((Get-ItemProperty -Path "$regex\Ribbon").MinimizedStateTabletModeOff -eq $0) { Write-Host " Skipping" } else {
                Write-Status -Types "+","$TweakType" -Status "Expanding Explorer Ribbon.."
                Set-ItemProperty -Path $regex\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $0 -Verbose
                Check
            }
            
            ## Disabling Feeds Open on Hover
            If ((Get-ItemProperty -Path $regcv\Feeds).ShellFeedsTaskbarOpenOnHover -eq $0) { Write-Host " Skipping" } else {
                If (!(Test-Path -Path $regcv\Feeds)) {
                    New-Item -Path $regcv -Name "Feeds" -Verbose
                }
                Write-Status -Types "-","$TweakType" -Status "Disabling Feeds open on hover.."
                Set-ItemProperty -Path $regcv\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value $0 -Verbose
                Check
            }
            #Disables live feeds in search
            If (!(Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB")) {
                New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "DSB" -Force -Verbose
            }
            Write-Status -Types "-","$TweakType" -Status "Disabling Feeds open on hover.."
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "ShowDynamicContent" -Value $0 -type DWORD -Force -Verbose
            Check
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value $0 -Type DWORD -Force -Verbose   
            Check
        }
        
        if ($BuildNumber -ge $WantedBuild) {
            ## Windows 11
            Write-Section -Text "Applying Windows 11 Specific Reg Keys"
            
            If ($BuildNumber -gt $22H2) {
                Write-Status -Types "+","$TweakType" -Status "Setting Start Layout to More Icons.."
                Set-ItemProperty -Path $regexadv -Name Start_Layout -Value $1 -Type DWORD -Force -Verbose
            }
            
            If ((Get-ItemProperty -Path $regexadv).TaskbarMn -eq $0) { Write-Host " Skipping" } else {
                Write-Status -Types "-","$TweakType" -Status "Removing Chats from TaskBar.."
                Set-ItemProperty -Path $regexadv -Name "TaskBarMn" -Value $0 -Verbose
            }
            If (!(Test-Path $regcv\Policies\Explorer)) {
                New-Item $regcv\Policies\ -Name Explorer -Force -Verbose
            }
            If ((Get-ItemProperty -Path "$regcv\Policies\Explorer").HideSCAMeetNow -eq $1) { Write-Host " Skipping" } else {
                Write-Status -Types "-","$TweakType" -Status "Removing Meet Now from Taskbar.."
                Set-ItemProperty -Path $regcv\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value $1 -Verbose
            }
        }

        ### Enabled Later on in Optimize-Performance
<#
# Checks current value for Game mode and E.
$key1 = "HKCU:\Software\Microsoft\GameBar"
$key2 = "AutoGameModeEnabled"
$agme = (Get-ItemProperty -Path $key1).$key2
If ($agme -eq 1) { Write-Host " Skipping" } else {
    Write-Host " Enabling Game Mode"
    Set-ItemProperty -Path $key1 -Name $key2 -Value $1 -Force -Verbose
}
#>        
        Write-Section -Text "Explorer Related"

        ### Explorer related
        If ((Get-ItemProperty -Path $regex).ShowRecent -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "-","$TweakType" -Status "Disabling Show Recent in Explorer Menu.."
            Set-ItemProperty -Path $regex -Name "ShowRecent" -Value 0 -Verbose
        }
    
        If ((Get-ItemProperty -Path $regex).ShowFrequent -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "-","$TweakType" -Status "Disabling Show Frequent in Explorer Menu.."
            Set-ItemProperty -Path $regex -Name "ShowFrequent" -Value 0 -Verbose
        }

        If ((Get-ItemProperty -Path $regexadv).EnableSnapAssistFlyout -eq $1) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Enabling Snap Assist Flyout.."
            Set-ItemProperty -Path $regexadv -Name "EnableSnapAssistFlyout" -Value $1 -Verbose
        }

        If ((Get-ItemProperty -Path $regexadv).HideFileExt -eq $0) { Write-Host " Skipping" } else {
            
            Write-Status -Types "+","$TweakType" -Status "Enabling File Extensions.."
            Set-ItemProperty -Path $regexadv -Name "HideFileExt" -Value 0 -Verbose
        }

        If ((Get-ItemProperty -Path $regexadv).LaunchTo -eq $tbm) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Setting Explorer Launch to This PC.."
            Set-ItemProperty -Path $regexadv -Name "LaunchTo" -Value $tbm -Verbose
        }

        If (!(Test-Path -Path "$regexadv\HideDesktopIcons")) {
            New-Item -Path "$regexadv" -Name HideDesktopIcons
            New-Item -Path "$regexadv\HideDesktopIcons" -Name NewStartPanel
        }
        $UsersFolder = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
        If ((Get-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel).$UsersFolder -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Adding User Files to desktop.."
            Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value 0 -Verbose
        }

        $ThisPC = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
        If ((Get-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel).$ThisPC -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Adding This PC icon to desktop.."
            Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value 0 -Verbose
        }

        If (!(Test-Path $regex\OperationStatusManager)) {
            New-Item -Path $regex\OperationStatusManager -Name EnthusiastMode -Type DWORD -Force -Verbose 
        }
        If ((Get-ItemProperty -Path $regex\OperationStatusManager).EnthusiastMode -eq $1) { Write-Host " Skipping" } else {
            If (!(Test-Path "$regex\OperationStatusManager")) {
                New-Item -Path "$regex\OperationStatusManager"
            }
            Write-Status -Types "+","$TweakType" -Status "Expanding File Operation Details by Default.."
            Set-ItemProperty -Path "$regex\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $1 -Verbose
        }

        Write-Section -Text "Privacy"
        ### Privacy
        #Write-Host ' Disabling Content Delivery Related Setings'
        If (!(Test-Path -Path $regcdm)) {
            New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ContentDeliveryManager" -Verbose 
        }
        If (Test-Path -Path $regcdm\Subscriptionn) {
            Remove-Item -Path $regcdm\Subscriptionn -Recurse -Force -Verbose
        }
        If (Test-Path -Path $regcdm\SuggestedApps) {
            Remove-Item -Path $regcdm\SuggestedApps -Recurse -Force -Verbose
        }
        $cdms = @(
            'ContentDeliveryAllowed'
            'OemPreInstalledAppsEnabled'
            'PreInstalledAppsEnabled'
            'PreInstalledAppsEverEnabled'
            'SilentInstalledAppsEnabled'
            'SubscribedContent-310093Enabled'
            'SubscribedContent-338387Enabled'
            'SubscribedContent-338388Enabled'
            'SubscribedContent-338389Enabled'
            'SubscribedContent-338393Enabled'
            'SubscribedContent-353694Enabled'
            'SubscribedContent-353696Enabled'
            'SubscribedContent-353698Enabled'
            'SystemPaneSuggestionsEnabled'
            'SoftLandingEnabled'
        )
        ForEach ($cdm in $cdms) {
            If ((Get-ItemProperty -Path $regcdm).$cdm -eq $0) { Write-Host " Skipping" } else {
                Set-ItemProperty -Path $regcdm -Name $cdm -Value $0 -Verbose -ErrorAction SilentlyContinue
                If (($?)){$check1 = ("?","Failed to Set")}elseif($?){$check1 = ("+","Setting")} ; $Check0 = $check1[0] ; $check11 = $check1[1]
                Write-Status -Types "$check0","$TweakType" -Status "$Check11 $cdm to 0.."
            }
        }

        If ((Get-ItemProperty -Path $regadvertising).DisabledByGroupPolicy -eq $1) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Advertiser ID.."
            Set-ItemProperty -Path $regadvertising -Name "DisabledByGroupPolicy" -Value $1 -Type DWORD -Verbose
        }


        If ((Get-ItemProperty -Path $regadvertising).Enabled -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Advertising.."
            Set-ItemProperty -Path $regadvertising -Name "Enabled" -Value $0 -Verbose
        }


        If (!(Test-Path -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI)) {
            New-Item -Path:HKCU:\Software\Policies\Microsoft\Windows -Name "EdgeUI" -Verbose 
        }
        If ((Get-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI).DisableMFUTracking -eq $1) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling App Launch Tracking.."
            Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $1 -Type DWORD -Verbose
        }
        If ($vari -eq '2') {
            Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force -Verbose
        }

        
        If ((Get-ItemProperty -Path $reginp\TrainedDataStore).HarvestContacts -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Contact Harvesting.."
            Set-ItemProperty -Path $reginp\TrainedDataStore -Name "HarvestContacts" -Value $0 -Verbose
        }
        
        
        If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\Personalization\Settings).AcceptedPrivacyPolicy -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Declining Microsoft Privacy Policy.."
            Set-ItemProperty -Path:HKCU:\Software\Microsoft\Personalization\Settings -Name "AcceptedPrivacyPolicy" -Value $0 -Verbose
        }
        
        
        If ((Get-ItemProperty -Path $reginp).RestrictImplicitTextCollection -eq $1) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Restricting Text Collection.."
            Set-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Value $1 -Verbose
            
        } 
        
        If ((Get-ItemProperty -Path $reginp).RestrictImplicitInkCollection -eq $1) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Restricting Ink Collection.."
            Set-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Value $1 -Verbose
            
        }
        
    
        ### Disables Feedback to Microsoft.
        If (!(Test-Path -Path:HKCU:\Software\Microsoft\Siuf)) { 
            New-Item -Path:HKCU:\Software\Microsoft -Name "Siuf" -Verbose 
        }
        If (!(Test-Path -Path $siufrules)) {
            New-Item -Path HKCU:\Software\Microsoft\Siuf -Name "Rules" -Verbose 
        }
        If (!((Get-Service -Name DiagTrack).Status -eq "Disabled")) { Write-Host " Skipping" } else {
            Stop-Service "DiagTrack" -WarningAction SilentlyContinue
            Set-Service "DiagTrack" -StartupType Disabled -Verbose
        }    
        If ((Get-ItemProperty -Path $siufrules).PeriodInNanoSeconds -eq $0) { Write-Host " Skipping" } else {
            Set-ItemProperty -Path $siufrules -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0 -Verbose
        }
        If ((Get-ItemProperty -Path $siufrules).PeriodInNanoSeconds -eq $0) { Write-Host " Skipping" } else {
            Set-ItemProperty -Path $siufrules -Name "PeriodInNanoSeconds" -Type QWORD -Value 0 -Verbose
        }
    
    


        If ((Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection).DoNotShowFeedbackNotifications -eq $1) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Windows Feedback Notifications.."
            Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $1 -Verbose
        }


        If ((Get-ItemProperty -Path $regsys).EnableActivityFeed -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Activity History.."
            Set-ItemProperty -Path $regsys -Name "EnableActivityFeed" -Type DWORD -Value $0 -Verbose
            
        }
        
        If ((Get-ItemProperty -Path $regsys).PublishUserActivities -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Publishing of Users Activities.."
            Set-ItemProperty -Path $regsys -Name "PublishUserActivities" -Type DWORD -Value $0 -Verbose
            
        }
        
        If ((Get-ItemProperty -Path $regsys).UploadUserActivities -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Uploading of User Activity.."
            Set-ItemProperty -Path $regsys -Name "UploadUserActivities" -Type DWORD -Value $0 -Verbose
        }



        If (!(Test-Path -Path:$regcam)) {
            New-Item -Path:$regcam -Force -Verbose
        }
        If ((Get-ItemProperty -Path "$regcam" -Name Value).Value -eq "Deny") { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Location Tracking.."
            Set-ItemProperty -Path "$regcam" -Name "Value" -Type String -Value "Deny" -Verbose
        }

        If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name SensorPermissionState).SensorPermissionState -eq $0) { Write-Host " Skipping" } else {
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWORD -Value $0 -Verbose
        }

        If ((Get-ItemProperty -Path $lfsvc -Name Status).Status -eq $0) { Write-Host " Skipping" } else {
            Set-ItemProperty -Path "$lfsvc" -Name "Status" -Type DWORD -Value $0 -Verbose
        }



        If ((Get-ItemProperty -Path HKLM:\System\Maps).AutoUpdateEnabled -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling automatic Maps updates.."
            Set-ItemProperty -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $0 -Verbose
        }


        If (!((Get-Service -Name dmwappushservice).Status -eq "Disabled")) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Stopping and disabling WAP Push Service.."
            Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
            Set-Service "dmwappushservice" -StartupType Disabled -Verbose
        }
        If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection").AllowTelemetry -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Telemetry.."
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value $0 -Verbose
        }

        If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection").AllowTelemetry -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Disabling Telemetry in its second location.."
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value $0 -Verbose
        }
    
        $ScheduledTasks = @(
            "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
            "Microsoft\Windows\Application Experience\ProgramDataUpdater"
            "Microsoft\Windows\Autochk\Proxy"
            "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
            "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
            "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
            )
            ForEach ($ScheduledTask in $ScheduledTasks){
                Write-Status -Types "-","$TweakType" -Status "Disabling $ScheduledTask.."
                Disable-ScheduledTask -TaskName $ScheduledTask -Verbose -ErrorAction SilentlyContinue
                Check
            }

        If (!(Test-Path -Path $wifisense\AllowWiFiHotSpotReporting)) {
            New-Item -Path $wifisense\AllowWiFiHotSpotReporting -Force -Verbose
        }
        If ((Get-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots).Value -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "-","$TweakType" -Status "Disabling AutoConnect to Sense Hotspots.."
            Set-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value $0 -Verbose
        }
        If ((Get-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting).Value -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "-","$TweakType" -Status "Disabling HotSpot Reporting to Microsoft.."
            Set-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value $0 -Verbose
        }



        $cloudcontent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        If (!(Test-Path -Path $cloudcontent)) {
            New-Item -Path $cloudcontent -Force
        }
        If ((Get-ItemProperty -Path $cloudcontent).DisableWindowsConsumerFeatures -eq $1) { Write-Host " Skipping" } else {
            Write-Status -Types "-","$TweakType" -Status "Disabling Cloud Content from Windows Search.."
            Set-ItemProperty -Path $cloudcontent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $1 -Verbose
        }


        $key1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
        $key2 = "TailoredExperiencesWithDiagnosticDataEnabled"
        If ((Get-ItemProperty -Path $key1).$key2 -eq $0) { Write-Host " Skipping" } else {
            Write-Status -Types "-","$TweakType" -Status "Disabling Tailored Experience w/ Diagnostic Data.."
            Set-ItemProperty -Path $key1 -Name "$key2" -Value $0 -Type DWORD -Force -Verbose
        }

        Write-Status -Types "-","$TweakType" -Status "Stopping and disabling Home Groups services.. LOL"
        If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { Write-Host " Skipping" } else {
            Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
            Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue  -Verbose
        }
        If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { Write-Host " Skipping" } else {
            Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
            Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue  -Verbose
        }

        If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped') { Write-Host " Skipping" } else {
            Write-Host ' Stopping and disabling Superfetch service'
            
            Stop-Service "SysMain" -WarningAction SilentlyContinue
            Set-Service "SysMain" -StartupType Disabled -Verbose
        }

        If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\MultiMedia\Audio).UserDuckingPreference -eq 3) { Write-Host " Skipping" } else {
            Write-Status -Types "-","$TweakType" -Status "Disabling Volume Adjustment during Calls"
            Set-ItemProperty -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD -Verbose
        }

        $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
        If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control).SvcHostSplitThresholdInKB -eq $ram) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Grouping svchost.exe Processes"
            Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram -Force -Verbose
        }

        If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters).IRPStackSize -eq 30) { Write-Host " Skipping" } else {
            Write-Status -Types "+","$TweakType" -Status "Increasing Stack Size to 30"
            Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30 -Verbose
        }

    
        If ($vari -eq '2') {
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Force -EA SilentlyContinue
            Remove-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Force -EA SilentlyContinue
            Remove-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Force -EA SilentlyContinue
            Set-Service "DiagTrack" -StartupType Automatic -EA SilentlyContinue
            Set-Service "dmwappushservice" -StartupType Automatic -EA SilentlyContinue
            Set-Service "SysMain" -StartupType Automatic -EA SilentlyContinue
            Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"  -EA SilentlyContinue
            Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater"  -EA SilentlyContinue
            Enable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy"  -EA SilentlyContinue
            Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator"  -EA SilentlyContinue
            Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"  -EA SilentlyContinue
            Enable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -EA SilentlyContinue
        }
}
Function Optimize-Performance() {
    [CmdletBinding()]
    param(
        [Switch] $Revert,
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Array]  $EnableStatus = @(
            @{ Symbol = "-"; Status = "Disabling"; }
            @{ Symbol = "+"; Status = "Enabling"; }
        )
    )
    $TweakType = "Performance"

    If (($Revert)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -Warning
        $Zero = 1
        $One = 0
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }

    $ExistingPowerPlans = $((powercfg -L)[3..(powercfg -L).Count])
    # Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
    $BuiltInPowerPlans = @{
        "Power Saver"            = "a1841308-3541-4fab-bc81-f71556f20b4a"
        "Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
        "High Performance"       = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        "Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    }
    $UniquePowerPlans = $BuiltInPowerPlans.Clone()
    # Initialize all Path variables used to Registry Tweaks
    $PathToLMPoliciesPsched = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
    $PathToLMPoliciesWindowsStore = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
    $PathToLMPrefetchParams = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters"
    $PathToCUGameBar = "HKCU:\SOFTWARE\Microsoft\GameBar"

    Write-Title -Text "Performance Tweaks"

    Write-Status -Types "=", $TweakType -Status "Enabling game mode..."
    Set-ItemProperty -Path "$PathToCUGameBar" -Name "AllowAutoGameMode" -Type DWord -Value 1
    Set-ItemProperty -Path "$PathToCUGameBar" -Name "AutoGameModeEnabled" -Type DWord -Value 1

    Write-Section -Text "System"
    Write-Caption -Text "Display"
    Write-Status -Types "+", $TweakType -Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)"
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2 -ErrorAction SilentlyContinue -Force

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) SysMain/Superfetch..."
    # As SysMain was already disabled on the Services, just need to remove it's key
    # [@] (0 = Disable SysMain, 1 = Enable when program is launched, 2 = Enable on Boot, 3 = Enable on everything)
    Set-ItemProperty -Path "$PathToLMPrefetchParams" -Name "EnableSuperfetch" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Remote Assistance..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value $Zero

    Write-Status -Types "-", $TweakType -Status "Disabling Ndu High RAM Usage..."
    # [@] (2 = Enable Ndu, 4 = Disable Ndu)
    Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Services\Ndu" -Name "Start" -Type DWord -Value 4

    # Details: https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
    # Will reduce Processes number considerably on > 4GB of RAM systems
    Write-Status -Types "+", $TweakType -Status "Setting SVCHost to match RAM size..."
    $RamInKB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $RamInKB

    Write-Status -Types "+", $TweakType -Status "Unlimiting your network bandwidth for all your system..." # Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
    If (!(Test-Path "$PathToLMPoliciesPsched")) {
        New-Item -Path "$PathToLMPoliciesPsched" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesPsched" -Name "NonBestEffortLimit" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff

    Write-Status -Types "=", $TweakType -Status "Enabling Windows Store apps Automatic Updates..."
    If (!(Test-Path "$PathToLMPoliciesWindowsStore")) {
        New-Item -Path "$PathToLMPoliciesWindowsStore" -Force | Out-Null
    }
    If ((Get-Item "$PathToLMPoliciesWindowsStore").GetValueNames() -like "AutoDownload") {
        Remove-ItemProperty -Path "$PathToLMPoliciesWindowsStore" -Name "AutoDownload" # [@] (2 = Disable, 4 = Enable)
    }

    Write-Section -Text "Power Plan Tweaks"

    Write-Status -Types "@", $TweakType -Status "Cleaning up duplicated Power plans..."
    ForEach ($PowerCfgString in $ExistingPowerPlans) {
        $PowerPlanGUID = $PowerCfgString.Split(':')[1].Split('(')[0].Trim()
        $PowerPlanName = $PowerCfgString.Split('(')[-1].Replace(')', '').Trim()

        If (($PowerPlanGUID -in $BuiltInPowerPlans.Values)) {
            Write-Status -Types "@", $TweakType -Status "The '$PowerPlanName' power plan` is built-in, skipping $PowerPlanGUID ..." -Warning
            Continue
        }

        Try {
            If (($PowerPlanName -notin $UniquePowerPlans.Keys) -and ($PowerPlanGUID -notin $UniquePowerPlans.Values)) {
                $UniquePowerPlans.Add($PowerPlanName, $PowerPlanGUID)
            }
            Else {
                Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
                powercfg -Delete $PowerPlanGUID
            }
        }
        Catch {
            Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
            powercfg -Delete $PowerPlanGUID
        }
    }

    Write-Status -Types "+", $TweakType -Status "Setting Power Plan to High Performance..."
    powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

    Write-Status -Types "+", $TweakType -Status "Creating the Ultimate Performance hidden Power Plan..."
    powercfg -DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61

    Write-Status -Types "+", $TweakType -Status "Setting Hibernate size to reduced..."
    powercfg -Hibernate -type Reduced

    Write-Status -Types "+", $TweakType -Status "Enabling Hibernate (Boots faster on Laptops/PCs with HDD and generate '$env:SystemDrive\hiberfil.sys' file)..."
    powercfg -Hibernate on

    Write-Section -Text "Network & Internet"
    Write-Caption -Text "Proxy"
    Write-Status -Types "-", $TweakType -Status "Fixing Edge slowdown by NOT Automatically Detecting Settings..."
    # Code from: https://www.reddit.com/r/PowerShell/comments/5iarip/set_proxy_settings_to_automatically_detect/?utm_source=share&utm_medium=web2x&context=3
    $Key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
    $Data = (Get-ItemProperty -Path $Key -Name DefaultConnectionSettings).DefaultConnectionSettings
    $Data[8] = 3
    Set-ItemProperty -Path $Key -Name DefaultConnectionSettings -Value $Data

}
Function Optimize-Privacy() {
    [CmdletBinding()]
    param(
        [Switch] $Revert,
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Array]  $EnableStatus = @(
            @{ Symbol = "-"; Status = "Disabling"; }
            @{ Symbol = "+"; Status = "Enabling"; }
        )
    )
    $TweakType = "Privacy"

    If ($Revert) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -Warning
        $Zero = 1
        $One = 0
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }

    # Initialize all Path variables used to Registry Tweaks
    $PathToLMActivityHistory = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    $PathToLMAutoLogger = "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger"
    $PathToLMDeliveryOptimizationCfg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
    $PathToLMPoliciesAdvertisingInfo = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
    $PathToLMPoliciesCloudContent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    $PathToLMPoliciesSQMClient = "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
    $PathToLMPoliciesTelemetry = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    $PathToLMPoliciesTelemetry2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    $PathToLMPoliciesToWifi = "HKLM:\Software\Microsoft\PolicyManager\default\WiFi"
    $PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    $PathToLMWindowsTroubleshoot = "HKLM:\SOFTWARE\Microsoft\WindowsMitigation"
    $PathToCUContentDeliveryManager = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $PathToCUDeviceAccessGlobal = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global"
    $PathToCUInputPersonalization = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
    $PathToCUInputTIPC = "HKCU:\SOFTWARE\Microsoft\Input\TIPC"
    $PathToCUOnlineSpeech = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
    $PathToCUPoliciesCloudContent = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    $PathToCUSearch = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    $PathToCUSiufRules = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"

    Write-Title -Text "Privacy Tweaks"
    Write-Section -Text "Personalization"
    Write-Caption -Text "Start & Lockscreen"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show me the windows welcome experience after updates..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Get fun facts and tips, etc. on lock screen'..."

    $ContentDeliveryManagerDisableOnZero = @(
        "SubscribedContent-310093Enabled"
        "SubscribedContent-314559Enabled"
        "SubscribedContent-314563Enabled"
        "SubscribedContent-338387Enabled"
        "SubscribedContent-338388Enabled"
        "SubscribedContent-338389Enabled"
        "SubscribedContent-338393Enabled"
        "SubscribedContent-353698Enabled"
        "RotatingLockScreenOverlayEnabled"
        "RotatingLockScreenEnabled"
        # Prevents Apps from re-installing
        "ContentDeliveryAllowed"
        "FeatureManagementEnabled"
        "OemPreInstalledAppsEnabled"
        "PreInstalledAppsEnabled"
        "PreInstalledAppsEverEnabled"
        "RemediationRequired"
        "SilentInstalledAppsEnabled"
        "SoftLandingEnabled"
        "SubscribedContentEnabled"
        "SystemPaneSuggestionsEnabled"
    )

    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUContentDeliveryManager]." -Warning
    ForEach ($Name in $ContentDeliveryManagerDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemProperty -Path "$PathToCUContentDeliveryManager" -Name "$Name" -Type DWord -Value $Zero
    }

    Write-Status -Types "-", $TweakType -Status "Disabling 'Suggested Content in the Settings App'..."
    If (Test-Path "$PathToCUContentDeliveryManager\Subscriptions") {
        Remove-Item -Path "$PathToCUContentDeliveryManager\Subscriptions" -Recurse
    }

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Show Suggestions' in Start..."
    If (Test-Path "$PathToCUContentDeliveryManager\SuggestedApps") {
        Remove-Item -Path "$PathToCUContentDeliveryManager\SuggestedApps" -Recurse
    }

    Write-Section -Text "Privacy -> Windows Permissions"
    Write-Caption -Text "General"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Let apps use my advertising ID..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value $Zero
    If (!(Test-Path "$PathToLMPoliciesAdvertisingInfo")) {
        New-Item -Path "$PathToLMPoliciesAdvertisingInfo" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesAdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value $One

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Let websites provide locally relevant content by accessing my language list'..."
    Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Type DWord -Value $One

    Write-Caption -Text "Speech"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Online Speech Recognition..."
    If (!(Test-Path "$PathToCUOnlineSpeech")) {
        New-Item -Path "$PathToCUOnlineSpeech" -Force | Out-Null
    }
    # [@] (0 = Decline, 1 = Accept)
    Set-ItemProperty -Path "$PathToCUOnlineSpeech" -Name "HasAccepted" -Type DWord -Value $Zero

    Write-Caption -Text "Inking & Typing Personalization"
    Set-ItemProperty -Path "$PathToCUInputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero
    Set-ItemProperty -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value $One
    Set-ItemProperty -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value $One
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero

    Write-Caption -Text "Diagnostics & Feedback"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) telemetry..."
    # [@] (0 = Security (Enterprise only), 1 = Basic Telemetry, 2 = Enhanced Telemetry, 3 = Full Telemetry)
    Set-ItemProperty -Path "$PathToLMPoliciesTelemetry" -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemProperty -Path "$PathToLMPoliciesTelemetry2" -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemProperty -Path "$PathToLMPoliciesTelemetry" -Name "AllowDeviceNameInTelemetry" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) send inking and typing data to Microsoft..."
    If (!(Test-Path "$PathToCUInputTIPC")) {
        New-Item -Path "$PathToCUInputTIPC" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToCUInputTIPC" -Name "Enabled" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experiences..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) View diagnostic data..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" -Name "EnableEventTranscript" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) feedback frequency..."
    If (!(Test-Path "$PathToCUSiufRules")) {
        New-Item -Path "$PathToCUSiufRules" -Force | Out-Null
    }
    If ((Test-Path "$PathToCUSiufRules\PeriodInNanoSeconds")) {
        Remove-ItemProperty -Path "$PathToCUSiufRules" -Name "PeriodInNanoSeconds"
    }
    Set-ItemProperty -Path "$PathToCUSiufRules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value $Zero

    Write-Caption -Text "Activity History"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Activity History..."
    $ActivityHistoryDisableOnZero = @(
        "EnableActivityFeed"
        "PublishUserActivities"
        "UploadUserActivities"
    )

    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToLMActivityHistory]" -Warning
    ForEach ($Name in $ActivityHistoryDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemProperty -Path "$PathToLMActivityHistory" -Name "$ActivityHistoryDisableOnZero" -Type DWord -Value $Zero
    }

    Write-Section -Text "Privacy -> Apps Permissions"
    Write-Caption -Text "Location"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value $Zero
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "EnableStatus" -Type DWord -Value $Zero

    Write-Caption -Text "Notifications"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" -Name "Value" -Value "Deny"

    Write-Caption -Text "App Diagnostics"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny"

    Write-Caption -Text "Account Info Access"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny"

    Write-Caption -Text "Other Devices"
    Write-Status -Types "-", $TweakType -Status "Denying device access..."
    If (!(Test-Path "$PathToCUDeviceAccessGlobal\LooselyCoupled")) {
        New-Item -Path "$PathToCUDeviceAccessGlobal\LooselyCoupled" -Force | Out-Null
    }
    # Disable sharing information with unpaired devices
    Set-ItemProperty -Path "$PathToCUDeviceAccessGlobal\LooselyCoupled" -Name "Value" -Value "Deny"
    ForEach ($key in (Get-ChildItem "$PathToCUDeviceAccessGlobal")) {
        If ($key.PSChildName -EQ "LooselyCoupled") {
            continue
        }
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Setting $($key.PSChildName) value to 'Deny' ..."
        Set-ItemProperty -Path ("$PathToCUDeviceAccessGlobal\" + $key.PSChildName) -Name "Value" -Value "Deny"
    }

    Write-Caption -Text "Background Apps"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Background Apps..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Type DWord -Value 0
    Set-ItemProperty -Path "$PathToCUSearch" -Name "BackgroundAppGlobalToggle" -Type DWord -Value 1

    Write-Section -Text "Update & Security"
    Write-Caption -Text "Windows Update"
    Write-Status -Types "-", $TweakType -Status "Disabling Automatic Download and Installation of Windows Updates..."
    If (!(Test-Path "$PathToLMPoliciesWindowsUpdate")) {
        New-Item -Path "$PathToLMPoliciesWindowsUpdate" -Force | Out-Null
    }
    # [@] (2 = Notify before download, 3 = Automatically download and notify of installation)
    # [@] (4 = Automatically download and schedule installation, 5 = Automatic Updates is required and users can configure it)
    Set-ItemProperty -Path "$PathToLMPoliciesWindowsUpdate" -Name "AUOptions" -Type DWord -Value 2

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Automatic Updates..."
    # [@] (0 = Enable Automatic Updates, 1 = Disable Automatic Updates)
    Set-ItemProperty -Path "$PathToLMPoliciesWindowsUpdate" -Name "NoAutoUpdate" -Type DWord -Value $Zero

    Write-Status -Types "+", $TweakType -Status "Setting Scheduled Day to Every day..."
    # [@] (0 = Every day, 1~7 = The days of the week from Sunday (1) to Saturday (7) (Only valid if AUOptions = 4))
    Set-ItemProperty -Path "$PathToLMPoliciesWindowsUpdate" -Name "ScheduledInstallDay" -Type DWord -Value 0

    Write-Status -Types "-", $TweakType -Status "Setting Scheduled time to 03h00m..."
    # [@] (0-23 = The time of day in 24-hour format)
    Set-ItemProperty -Path "$PathToLMPoliciesWindowsUpdate" -Name "ScheduledInstallTime" -Type DWord -Value 3

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Automatic Reboot after update..."
    # [@] (0 = Enable Automatic Reboot after update, 1 = Disable Automatic Reboot after update)
    Set-ItemProperty -Path "$PathToLMPoliciesWindowsUpdate" -Name "NoAutoRebootWithLoggedOnUsers" -Type DWord -Value $One

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Change Windows Updates to 'Notify to schedule restart'..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "UxOption" -Type DWord -Value $One

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Restricting Windows Update P2P downloads for Local Network only..."
    If (!(Test-Path "$PathToLMDeliveryOptimizationCfg")) {
        New-Item -Path "$PathToLMDeliveryOptimizationCfg" -Force | Out-Null
    }
    # [@] (0 = Off, 1 = Local Network only, 2 = Local Network private peering only)
    # [@] (3 = Local Network and Internet,  99 = Simply Download mode, 100 = Bypass mode)
    Set-ItemProperty -Path "$PathToLMDeliveryOptimizationCfg" -Name "DODownloadMode" -Type DWord -Value $One

    Write-Caption -Text "Troubleshooting"
    Write-Status -Types "+", $TweakType -Status "Enabling Automatic Recommended Troubleshooting, then notify me..."
    If (!(Test-Path "$PathToLMWindowsTroubleshoot")) {
        New-Item -Path "$PathToLMWindowsTroubleshoot" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMWindowsTroubleshoot" -Name "UserPreference" -Type DWord -Value 3

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Spotlight Features..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Third Party Suggestions..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) More Telemetry Features..."

    $CloudContentDisableOnOne = @(
        "DisableWindowsSpotlightFeatures"
        "DisableWindowsSpotlightOnActionCenter"
        "DisableWindowsSpotlightOnSettings"
        "DisableWindowsSpotlightWindowsWelcomeExperience"
        "DisableTailoredExperiencesWithDiagnosticData"      # Tailored Experiences
        "DisableThirdPartySuggestions"
    )

    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUPoliciesCloudContent]." -Warning
    ForEach ($Name in $CloudContentDisableOnOne) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $One"
        Set-ItemProperty -Path "$PathToCUPoliciesCloudContent" -Name "$Name" -Type DWord -Value $One
    }
    If (!(Test-Path "$PathToCUPoliciesCloudContent")) {
        New-Item -Path "$PathToCUPoliciesCloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToCUPoliciesCloudContent" -Name "ConfigureWindowsSpotlight" -Type DWord -Value 2
    Set-ItemProperty -Path "$PathToCUPoliciesCloudContent" -Name "IncludeEnterpriseSpotlight" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Apps Suggestions..."
    If (!(Test-Path "$PathToLMPoliciesCloudContent")) {
        New-Item -Path "$PathToLMPoliciesCloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesCloudContent" -Name "DisableThirdPartySuggestions" -Type DWord -Value $One
    Set-ItemProperty -Path "$PathToLMPoliciesCloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value $One

    # Reference: https://forums.guru3d.com/threads/windows-10-registry-tweak-for-disabling-drivers-auto-update-controversy.418033/
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) automatic driver updates..."
    # [@] (0 = Yes, do this automatically, 1 = No, let me choose what to do, Always install the best, 2 = [...] Install driver software from Windows Update, 3 = [...] Never install driver software from Windows Update
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value $One
    # [@] (0 = Enhanced icons enabled, 1 = Enhanced icons disabled)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value $One

    If (!(Test-Path "$PathToLMPoliciesSQMClient")) {
        New-Item -Path "$PathToLMPoliciesSQMClient" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesSQMClient" -Name "CEIPEnable" -Type DWord -Value $Zero
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "AppCompat"
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type DWord -Value $Zero
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -Type DWord -Value $One

    # Details: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004#windows-system-startup-event-traces-autologgers
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) some startup event traces (AutoLoggers)..."
    If (!(Test-Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener")) {
        New-Item -Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value $Zero
    Set-ItemProperty -Path "$PathToLMAutoLogger\SQMLogger" -Name "Start" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: HotSpot Sharing'..."
    If (!(Test-Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting")) {
        New-Item -Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting" -Name "value" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: Shared HotSpot Auto-Connect'..."
    If (!(Test-Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots")) {
        New-Item -Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots" -Name "value" -Type DWord -Value $Zero

    Write-Caption "Deleting useless registry keys..."
    $KeysToDelete = @(
        # Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        # Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        # Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )

    ForEach ($Key in $KeysToDelete) {
        If ((Test-Path $Key)) {
            Write-Status -Types "-", $TweakType -Status "Removing Key: [$Key]"
            Remove-Item $Key -Recurse
        }
    }
}
Function Optimize-Security() {
    $TweakType = "Security"
    # Initialize all Path variables used to Registry Tweaks
    $PathToLMPoliciesEdge = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge"
    $PathToLMPoliciesMRT = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
    $PathToCUExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    $PathToCUExplorerAdvanced = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    Write-Title -Text "Security Tweaks"

    Write-Section -Text "Windows Firewall"
    Write-Status -Types "+", $TweakType -Status "Enabling default firewall profiles..."
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

    Write-Section -Text "Windows Defender"
    Write-Status -Types "?", $TweakType -Status "If you already use another antivirus, nothing will happen." -Warning
    Write-Status -Types "+", $TweakType -Status "Ensuring your Windows Defender is ENABLED..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWORD -Value 0 -Force
    Set-MpPreference -DisableRealtimeMonitoring $false -Force

    Write-Status -Types "+", $TweakType -Status "Enabling Microsoft Defender Exploit Guard network protection..."
    Set-MpPreference -EnableNetworkProtection Enabled -Force

    Write-Status -Types "+", $TweakType -Status "Enabling detection for potentially unwanted applications and block them..."
    Set-MpPreference -PUAProtection Enabled -Force

    Write-Section -Text "SmartScreen"
    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Microsoft Edge..."
    If (!(Test-Path "$PathToLMPoliciesEdge\PhishingFilter")) {
        New-Item -Path "$PathToLMPoliciesEdge\PhishingFilter" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 1

    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Store Apps..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 1

    Write-Section -Text "Old SMB Protocol"
    # Details: https://techcommunity.microsoft.com/t5/storage-at-microsoft/stop-using-smb1/ba-p/425858
    Write-Status -Types "+", $TweakType -Status "Disabling SMB 1.0 protocol..."
    Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

    Write-Section -Text "Old .NET cryptography"
    # Enable strong cryptography for .NET Framework (version 4 and above) - https://stackoverflow.com/a/47682111
    Write-Status -Types "+", $TweakType -Status "Enabling .NET strong cryptography..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1

    Write-Section -Text "Autoplay and Autorun (Removable Devices)"
    Write-Status -Types "-", $TweakType -Status "Disabling Autoplay..."
    Set-ItemProperty -Path "$PathToCUExplorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

    Write-Status -Types "-", $TweakType -Status "Disabling Autorun for all Drives..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

    Write-Section -Text "Microsoft Store"
    Write-Status -Types "-", $TweakType -Status "Disabling Search for App in Store for Unknown Extensions..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "NoUseStoreOpenWith" -Type DWord -Value 1

    Write-Section -Text "Windows Explorer"
    Write-Status -Types "+", $TweakType -Status "Enabling Show file extensions in Explorer..."
    Set-ItemProperty -Path "$PathToCUExplorerAdvanced" -Name "HideFileExt" -Type DWord -Value 0

    Write-Section -Text "User Account Control (UAC)"
    # Details: https://docs.microsoft.com/pt-br/windows/security/identity-protection/user-account-control/user-account-control-group-policy-and-registry-key-settings
    Write-Status -Types "+", $TweakType -Status "Raising UAC level..."
    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1

    Write-Section -Text "Windows Update"
    # Details: https://forums.malwarebytes.com/topic/246740-new-potentially-unwanted-modification-disablemrt/
    Write-Status -Types "+", $TweakType -Status "Enabling offer Malicious Software Removal Tool via Windows Update..."
    If (!(Test-Path "$PathToLMPoliciesMRT")) {
        New-Item -Path "$PathToLMPoliciesMRT" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToLMPoliciesMRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 0

    Write-Status -Types "?", $TweakType -Status "For more tweaks, edit the '$PSCommandPath' file, then uncomment '#SomethingHere' code lines" -Warning
    # Consumes more RAM - Make Windows Defender run in Sandbox Mode (MsMpEngCP.exe and MsMpEng.exe will run on background)
    # Details: https://www.microsoft.com/security/blog/2018/10/26/windows-defender-antivirus-can-now-run-in-a-sandbox/
    #Write-Status -Types "+", $TweakType -Status "Enabling Windows Defender Sandbox mode..."
    #setx /M MP_FORCE_USE_SANDBOX 1  # Restart the PC to apply the changes, 0 to Revert

    # Disable Windows Script Host. CAREFUL, this may break stuff, including software uninstall.
    #Write-Status -Types "+", $TweakType -Status "Disabling Windows Script Host (execution of *.vbs scripts and alike)..."
    #Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type DWord -Value 0
}
Function Optimize-ServicesRunning() {
    [CmdletBinding()]
    param (
        [Switch] $Revert
    )

    $IsSystemDriveSSD = $(Get-OSDriveType) -eq "SSD"
    $EnableServicesOnSSD = @("SysMain", "WSearch")

    # Services which will be totally disabled
    $ServicesToDisabled = @(
        "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
        "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
        "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
        #"Fax"                                       # DEFAULT: Manual    | Fax Service
        "fhsvc"                                     # DEFAULT: Manual    | Fax History Service
        "GraphicsPerfSvc"                           # DEFAULT: Manual    | Graphics performance monitor service
        #"HomeGroupListener"                         # NOT FOUND (Win 10+)| HomeGroup Listener
        #"HomeGroupProvider"                         # NOT FOUND (Win 10+)| HomeGroup Provider
        "lfsvc"                                     # DEFAULT: Manual    | Geolocation Service
        "MapsBroker"                                # DEFAULT: Automatic | Downloaded Maps Manager
        "PcaSvc"                                    # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
        "RemoteAccess"                              # DEFAULT: Disabled  | Routing and Remote Access
        "RemoteRegistry"                            # DEFAULT: Disabled  | Remote Registry
        "RetailDemo"                                # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
        "SysMain"                                   # DEFAULT: Automatic | SysMain / Superfetch (100% Disk usage on HDDs)
        # read://https_helpdeskgeek.com/?url=https%3A%2F%2Fhelpdeskgeek.com%2Fhelp-desk%2Fdelete-disable-windows-prefetch%2F%23%3A~%3Atext%3DShould%2520You%2520Kill%2520Superfetch%2520(Sysmain)%3F
        "TrkWks"                                    # DEFAULT: Automatic | Distributed Link Tracking Client
        "WSearch"                                   # DEFAULT: Automatic | Windows Search (100% Disk usage on HDDs)
        # - Services which cannot be disabled (and shouldn't)
        #"wscsvc"                                   # DEFAULT: Automatic | Windows Security Center Service
        #"WdNisSvc"                                 # DEFAULT: Manual    | Windows Defender Network Inspection Service
    )

    # Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
    $ServicesToManual = @(
        "BITS"                           # DEFAULT: Manual    | Background Intelligent Transfer Service
        #"cbdhsvc_*"                      # DEFAULT: Manual    | Clipboard User Service
        "edgeupdate"                     # DEFAULT: Automatic | Microsoft Edge Update Service
        "edgeupdatem"                    # DEFAULT: Manual    | Microsoft Edge Update Service²
        "FontCache"                      # DEFAULT: Automatic | Windows Font Cache
        "iphlpsvc"                       # DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
        "lmhosts"                        # DEFAULT: Manual    | TCP/IP NetBIOS Helper
        "ndu"                            # DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
        #"NetTcpPortSharing"             # DEFAULT: Disabled  | Net.Tcp Port Sharing Service
        "PhoneSvc"                       # DEFAULT: Manual    | Phone Service (Manages the telephony state on the device)
        "SCardSvr"                       # DEFAULT: Manual    | Smart Card Service
        "SharedAccess"                   # DEFAULT: Manual    | Internet Connection Sharing (ICS)
        "stisvc"                         # DEFAULT: Automatic | Windows Image Acquisition (WIA) Service
        "WbioSrvc"                       # DEFAULT: Manual    | Windows Biometric Service (required for Fingerprint reader / Facial detection)
        "Wecsvc"                         # DEFAULT: Manual    | Windows Event Collector Service
        "WerSvc"                         # DEFAULT: Manual    | Windows Error Reporting Service
        "wisvc"                          # DEFAULT: Manual    | Windows Insider Program Service
        "WMPNetworkSvc"                  # DEFAULT: Manual    | Windows Media Player Network Sharing Service
        "WpnService"                     # DEFAULT: Automatic | Windows Push Notification Services (WNS)
        # - Diagnostic Services
        "DPS"                            # DEFAULT: Automatic | Diagnostic Policy Service
        "WdiServiceHost"                 # DEFAULT: Manual    | Diagnostic Service Host
        "WdiSystemHost"                  # DEFAULT: Manual    | Diagnostic System Host
        # - Bluetooth services
        "BTAGService"                    # DEFAULT: Manual    | Bluetooth Audio Gateway Service
        "BthAvctpSvc"                    # DEFAULT: Manual    | AVCTP Service
        "bthserv"                        # DEFAULT: Manual    | Bluetooth Support Service
        "RtkBtManServ"                   # DEFAULT: Automatic | Realtek Bluetooth Device Manager Service
        # - Xbox services
        "XblAuthManager"                 # DEFAULT: Manual    | Xbox Live Auth Manager
        "XblGameSave"                    # DEFAULT: Manual    | Xbox Live Game Save
        "XboxGipSvc"                     # DEFAULT: Manual    | Xbox Accessory Management Service
        "XboxNetApiSvc"                  # DEFAULT: Manual    | Xbox Live Networking Service
        # - NVIDIA services
        "NVDisplay.ContainerLocalSystem" # DEFAULT: Automatic | NVIDIA Display Container LS (NVIDIA Control Panel)
        "NvContainerLocalSystem"         # DEFAULT: Automatic | NVIDIA LocalSystem Container (GeForce Experience / NVIDIA Telemetry)
        # - Printer services
        #"PrintNotify"                   # DEFAULT: Manual    | WARNING! REMOVING WILL TURN PRINTING LESS MANAGEABLE | Printer Extensions and Notifications
        #"Spooler"                       # DEFAULT: Automatic | WARNING! REMOVING WILL DISABLE PRINTING              | Print Spooler
        # - Wi-Fi services
        #"WlanSvc"                       # DEFAULT: Manual (No Wi-Fi devices) / Automatic (Wi-Fi devices) | WARNING! REMOVING WILL DISABLE WI-FI | WLAN AutoConfig
        # - 3rd Party Services
        "gupdate"                        # DEFAULT: Automatic | Google Update Service
        "gupdatem"                       # DEFAULT: Manual    | Google Update Service²
    )

    Write-Title -Text "Services tweaks"
    Write-Section -Text "Disabling services from Windows"

    If ($Revert) {
        Write-Status -Types "<", "Service" -Status "Reverting the tweaks is set to '$Revert'." -Warning
        $CustomMessage = { "Resetting $Service ($((Get-Service $Service).DisplayName)) as 'Manual' on Startup ..." }
        Set-ServiceStartup -Manual -Services $ServicesToDisabled -Filter $EnableServicesOnSSD -CustomMessage $CustomMessage
    }
    Else {
        Set-ServiceStartup -Disabled -Services $ServicesToDisabled -Filter $EnableServicesOnSSD
    }

    Write-Section -Text "Enabling services from Windows"

    If ($IsSystemDriveSSD -or $Revert) {
        $CustomMessage = { "The $Service ($((Get-Service $Service).DisplayName)) service works better in 'Automatic' mode on SSDs ..." }
        Set-ServiceStartup -Automatic -Services $EnableServicesOnSSD -CustomMessage $CustomMessage
    }

    Set-ServiceStartup -Manual -Services $ServicesToManual
}
Function Optimize-TaskScheduler() {
    [CmdletBinding()]
    param (
        [Switch] $Revert
    )

    # Adapted from: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations#task-scheduler
    $DisableScheduledTasks = @(
        "\Microsoft\Office\OfficeTelemetryAgentLogOn"
        "\Microsoft\Office\OfficeTelemetryAgentFallBack"
        "\Microsoft\Office\Office 15 Subscription Heartbeat"
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
        "\Microsoft\Windows\Application Experience\StartupAppTask"
        "\Microsoft\Windows\Autochk\Proxy"
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         # Recommended state for VDI use
        "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"       # Recommended state for VDI use
        "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              # Recommended state for VDI use
        "\Microsoft\Windows\Defrag\ScheduledDefrag"                                       # Recommended state for VDI use
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
        "\Microsoft\Windows\Location\Notifications"                                       # Recommended state for VDI use
        "\Microsoft\Windows\Location\WindowsActionDialog"                                 # Recommended state for VDI use
        "\Microsoft\Windows\Maps\MapsToastTask"                                           # Recommended state for VDI use
        "\Microsoft\Windows\Maps\MapsUpdateTask"                                          # Recommended state for VDI use
        "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"                # Recommended state for VDI use
        "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"                   # Recommended state for VDI use
        "\Microsoft\Windows\Retail Demo\CleanupOfflineContent"                            # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyMonitor"                                    # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"                                # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyUpload"
        "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"                          # Recommended state for VDI use
    )

    $EnableScheduledTasks = @(
        "\Microsoft\Windows\Maintenance\WinSAT"                     # WinSAT detects incorrect system configurations, that causes performance loss, then sends it via telemetry | Reference (PT-BR): https://youtu.be/wN1I0IPgp6U?t=16
        "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"        # Verify the Recovery Environment integrity, it's the Diagnostic tools and Troubleshooting when your PC isn't healthy on BOOT, need this ON.
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting" # Windows Error Reporting event, needed to improve compatibility with your hardware
    )

    Write-Title -Text "Task Scheduler tweaks"
    Write-Section -Text "Disabling Scheduled Tasks from Windows"

    If ($Revert) {
        Write-Status -Types "<", "TaskScheduler" -Status "Reverting the tweaks is set to '$Revert'." -Warning
        $CustomMessage = { "Resetting the $ScheduledTask task as 'Ready' ..." }
        Set-ScheduledTaskState -Ready -ScheduledTask $DisableScheduledTasks -CustomMessage $CustomMessage
    }
    Else {
        Set-ScheduledTaskState -Disabled -ScheduledTask $DisableScheduledTasks
    }

    Write-Section -Text "Enabling Scheduled Tasks from Windows"
    Set-ScheduledTaskState -Ready -ScheduledTask $EnableScheduledTasks
}
Function BitlockerDecryption() { 
    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq "On") {
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        manage-bde -off "C:"
    }
    else {
        Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" -Warning
    }
}
Function Cleanup() {
    Restart-Explorer
    

    
    Write-Status -Types "+" , "Modify" -Status "Enabling F8 boot menu options"
    #    bcdedit /set {bootmgr} displaybootmenu yes | Out-Null
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    


    Write-Status -Types "?" , "Parse" -Status "Checking Windows Activation Status.." -Warning
    $ActiStat = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object PartialProductKey).LicenseStatus
    If ($ActiStat -ne 1) { Write-CaptionFailed -Text "Windows is not activated. Launching slui" ; Start-Process slui -ArgumentList '3' }else { Write-CaptionSucceed -Text "Windows is Activated. Proceeding" }
        
    
    Write-Status -Types "-", "Remove" -Status "Cleaning Temp Folder"
        
    Remove-Item "$env:localappdata\temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL

    If (Test-Path $location1) {
        Write-Status -Types "+", "Launching" -Status "Google Chrome"
        Start-Process Chrome
    }    
    If (Test-Path $vlcsc) { 
        Write-Status -Types "-", "Remove" -Status "Removing VLC Media Player Desktop Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $acrosc) { 
        Write-Status -Types "-" , "Remove" -Status "Removing Acrobat Desktop Icon"

        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $zoomsc) {
        Write-Status -Types "-", "Remove" -Status "Removing Zoom Desktop Icon"
        Remove-Item -path $zoomsc -force -verbose
    }
    Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL


    If (Test-Path $EdgeShortcut) { 
        #Write-Host " Removing Edge Icon"
        Write-Status -Types "-" , "Remove" -Status "Removing Edge Desktop Shortcut"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $edgescpub) { 
        Write-Status -Types "-" , "Remove" -Status "Removing Edge Shortcut in Public Desktop"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $ctemp) { 
        Write-Status -Types "-" , "Remove" -Status "Removing C:\Temp"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }

}
Function New-RestorePoint() {
    Write-Status -Types "+" -Status "Enabling system drive Restore Point..."
    Enable-ComputerRestore -Drive "$env:SystemDrive\"
    Checkpoint-Computer -Description "Mother Computers Courtesy Restore Point" -RestorePointType "MODIFY_SETTINGS"
}
Function Backup-HostsFile() {
    $PathToHostsFile = "$env:SystemRoot\System32\drivers\etc"

    Write-Status -Types "+" -Status "Doing Backup on Hosts file..."
    $Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Push-Location "$PathToHostsFile"

    If (!(Test-Path "$PathToHostsFile\Hosts_Backup")) {
        Write-Status -Types "?" -Status "Backup folder not found! Creating a new one..."
        mkdir -Path "$PathToHostsFile\Hosts_Backup"
    }
    Push-Location "Hosts_Backup"

    Copy-Item -Path ".\..\hosts" -Destination "hosts_$Date"

    Pop-Location
    Pop-Location
}
Function EmailLog {
    
    Stop-Transcript;$EndTime = $(get-date)
	systeminfo | Sort-Object | Out-File -Append $log -Encoding ascii
    [String]$SystemSpec = Get-SystemSpec
    $ip = (New-Object System.Net.WebClient).DownloadString("http://ifconfig.me/ip")
    $ipinfo = (New-Object System.Net.WebClient).DownloadString('http://ipinfo.io/')
    #$ip = (New-Object System.Net.WebClient).DownloadString('http://ipinfo.io/')

    If (Test-Path -Path "$Location1"){
        $chromeyns = "X"
    }else{ 
        $chromeyns = ""
    }
    If (Test-Path -Path "$Location2"){
        $vlcyns = "X"
    }else{
        $vlcyns = ""
    }
    If (Test-Path -Path "$Location4"){ 
        $adobeyns = "X"
    }else{ 
        $adobeyns = ""
    }
    If (
        Test-Path -Path "$Location3"){
        $zoomyns = "X"
    }else{
        $zoomyns = ""
    }

    If ($currentwallpaper -eq $wallpaper){ $visualsyn = "X"}else{ $visualsyn = ""}


    $elapsedTime = $(get-date) - $StartTime
    $totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption

    Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "New Loads Automatic Log" -Attachments $Log -Priority High -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -Verbose -ErrorAction SilentlyContinue -Body "
    The script was run on a computer for $ip\$env:USERNAME, Completing in $totaltime

    Windows Version: $WindowsVersion, $DisplayVersion
    Script Version: $programversion
    Script Start Time: $StartTime
    Script End Time: $EndTime
    
    Script Log $dtime.txt
    
    #System Information
    $SystemSpec


    Applications Installed: $appsyns
    [$chromeyns] Chrome
    [$vlcyns] VLC Media Player
    [$adobeyns] Adobe Acrobat DC
    [$zoomyns] Zoom
    
    Visuals: [$visualsyn]
    Network Information of this PC: 
    $ipinfo"

}
$MaxLength = '17'

Variables
BootCheck



While (Test-Path .\Log.txt){
    Remove-Item log.txt
}


Start-Transcript -Path $Log ; $StartTime = $(get-date)
Write-Break ; "" ; Logo ; "" ; Write-Break
Write-Host "`n" ; Write-TitleCounter -Counter '1' -MaxLength $MaxLength -Text "Integrity Check"
CheckFiles

$TweakType = "Programs"
Write-Host "`n" ; Write-TitleCounter -Counter '2' -MaxLength $MaxLength -Text "Program Installation"
Programs

$TweakType = "Visuals"
Write-Host "`n" ; Write-TitleCounter -Counter '3' -MaxLength $MaxLength -Text "StartMenuLayout.xml Modification"
StartMenu
Write-Host "`n" ; Write-TitleCounter -Counter '4' -MaxLength $MaxLength -Text "Visuals"
Visuals
Write-Host "`n" ; Write-TitleCounter -Counter '5' -MaxLength $MaxLength -Text "Mothers Branding"
Branding

$TweakType = "Debloat"
Write-Host "`n" ; Write-TitleCounter -Counter '6' -MaxLength $MaxLength -Text "Debloat"
Debloat
Write-Host "`n" ; Write-TitleCounter -Counter '7' -MaxLength $MaxLength -Text "Office Removal"
OfficeCheck
Write-Host "`n" ; Write-TitleCounter -Counter '8' -MaxLength $MaxLength -Text "OneDrive Removal"
OneDriveRe

$TweakType = "Registry"
Write-Host "`n" ; Write-TitleCounter -Counter '9' -MaxLength $MaxLength -Text "Applying Registry Changes"
AdvRegistry -Action Apply

$TweakType = "Optimize"
Write-Host "`n" ; Write-TitleCounter -Counter '10' -MaxLength $MaxLength -Text "Optimize Performance"
Optimize-Performance
Write-Host "`n" ; Write-TitleCounter -Counter '11' -MaxLength $MaxLength -Text "Optimize Privacy"
Optimize-Privacy
Write-Host "`n" ; Write-TitleCounter -Counter '12' -MaxLength $MaxLength -Text "Optimize Security"
Optimize-Security
Write-Host "`n" ; Write-TitleCounter -Counter '13' -MaxLength $MaxLength -Text "Optimize Services"
Optimize-ServicesRunning
Write-Host "`n" ; Write-TitleCounter -Counter '14' -MaxLength $MaxLength -Text "Optimize Task Scheduler"
Optimize-TaskScheduler

$TweakType = 'BitlockerDecryption'
Write-Host "`n" ; Write-TitleCounter -Counter '15' -MaxLength $MaxLength -Text "Bitlocker Decryption"


$TweakType = 'Cleanup'
Write-Host "`n" ; Write-TitleCounter -Counter '16' -MaxLength $MaxLength -Text "Cleaning Up"
Cleanup

$TweakType = "Backup"
Write-Host "`n" ; Write-TitleCounter -Counter '17' -MaxLength $MaxLength -Text "Creating Restore Point"
New-RestorePoint
Backup-HostsFile
EmailLog



### END OF SCRIPT ###

<#

$scripts = @(
    #"CheckFiles.ps1"
    "Adwcleaner.ps1"
    #"Programs.ps1"
    #"Branding.ps1"
    #"Start Menu.ps1"
    #"Visuals.ps1"
    #"Debloat.ps1"
    #"OfficeRemoval.ps1"
    #"OneDrive Removal.ps1"
    "ssd-tune.ps1"
    "Bitlocker Decryption.ps1"
    "optimize-performance.ps1"
    "optimize-privacy.ps1"
    "optimize-security.ps1"
    "optimize-services.ps1"
    "optimize-task-scheduler.ps1"
    "optimize-windows-features.ps1"
    "Cleanup.ps1"
    "backup-system.ps1"
)
$maxLength = ($scripts | Measure-Object -Line).Lines
Foreach ($script in $scripts) {
    $Counter = $counter + 1
    Write-Host "`n" ; Write-TitleCounter -Counter $Counter -MaxLength $MaxLength -Text "$Script"
    PowerShell -NoProfile -Noninteractive -NoLogo -Mta -ExecutionPolicy Bypass -File .\scripts\"$Script"
}
RunScripts

Remove-Item $VariableFile -Verbose
#>

### GUI TOGGLES FOR FUNCTIONS ###
#If ($perform_apps.checked -eq $true){
#Programs
#}
#If ($perform_debloat.checked -eq $true){
#Debloat
#}
#If ($perform_onedrive.checked -eq $true){
#OneDriveRe
#}

##Runs every script inside of .\scripts. Recurses child folders as well. ###
#$scripts = (get-childitem -recurse -path .\scripts -include *.ps1).Name

#Foreach ($script in $scripts){
#powershell -executionpolicy unrestricted -file ".\Scripts\$script"
#}