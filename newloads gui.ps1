Write-Host "Initializing Script"
$reason = "OK"
$Health = 40
If (Get-Module -ListAvailable -Name BitsTransfer){
    $health += 25
} else {
    Write-Host " Importing BitsTransfer"
    Import-Module BitsTransfer
    Start-Sleep -s 2
    If (!(Get-Module -ListAvailable -Name BitsTransfer)){
        Write-Host " For some reason one of the modules wasn't found. Trying again."
        Import-Module BitsTransfer -Verbose
        $health += 25
        Start-Sleep -s 2
        If (!(Get-Module -ListAvailable -Name BitsTransfer)){
            $reason = " BitsTransfer not found
 
            What do I do?:
            If Relaunching the script does not help
            
            What is Winget?:
            https://docs.microsoft.com/en-us/windows/package-manager/winget/
           "
        } else {
            $health += 25
        }
    } else {
        $health += 25
    }
}
#  Add a Base64 icon to quotations. Enable all 3 lines.  #
#Add-Type -AssemblyName System.Windows.Forms
#[System.Windows.Forms.Application]::EnableVisualStyles()
#$iconBase64 = ''

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(633,590)
$Form.text                       = "New Loads by Mike - UI Mode"
$Form.TopMost                    = $False
$Form.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#4b4b4b")
$Form.StartPosition              = "CenterScreen"
$Form.FormBorderStyle            = 'FixedSingle'
#$Form.StartPosition              = "manual"
#$Form.Location                   = New-Object System.Drawing.Size(1400, 300)
#$Form.AutoScaleDimensions        = '192, 192'
#$Form.AutoScaleMode              = "Dpi"
#$Form.AutoSize                   = $True
#$Form.AutoScroll                 = $True
# GUI Icon

$iconBytes                       = [Convert]::FromBase64String($iconBase64)
$stream                          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length)
$Form.Icon                    = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())


$RunScript                       = New-Object system.Windows.Forms.Button
$RunScript.text                  = "Run Script"
$RunScript.width                 = 240
$RunScript.height                = 90
$RunScript.location              = New-Object System.Drawing.Point(356,440)
$RunScript.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RunScript.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$RunNoOEM                        = New-Object system.Windows.Forms.Button
$RunNoOEM.text                   = "Run without Branding"
$RunNoOEM.width                  = 240
$RunNoOEM.height                 = 36
$RunNoOEM.location               = New-Object System.Drawing.Point(356,400)
$RunNoOEM.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$RunNoOEM.ForeColor              = [System.Drawing.ColorTranslator]::FromHtml("")
$RunNoOEM.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$UndoScript                      = New-Object system.Windows.Forms.Button
$UndoScript.text                 = "Revert Changes"
$UndoScript.width                = 118
$UndoScript.height               = 34
$UndoScript.location             = New-Object System.Drawing.Point(356,535)
$UndoScript.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$UndoScript.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$UndoScript.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#f8e71c")

$ExitButton                      = New-Object system.Windows.Forms.Button
$ExitButton.text                 = "Exit"
$ExitButton.width                = 122
$ExitButton.height               = 34
$ExitButton.location             = New-Object System.Drawing.Point(475,535)
$ExitButton.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ExitButton.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$ExitButton.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$mocologo                        = New-Object system.Windows.Forms.PictureBox
$mocologo.width                  = 221
$mocologo.height                 = 206
$mocologo.location               = New-Object System.Drawing.Point(-5,373)
$mocologo.imageLocation          = "https://raw.githubusercontent.com/circlol/newload/main/Assets/logo.png"
$mocologo.SizeMode               = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$nvidiashortcut                  = New-Object system.Windows.Forms.Button
$nvidiashortcut.text             = "NVIDIA"
$nvidiashortcut.width            = 102
$nvidiashortcut.height           = 58
$nvidiashortcut.location         = New-Object System.Drawing.Point(492,200)
$nvidiashortcut.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$nvidiashortcut.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$nvidiashortcut.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#7ed321")

$amdshortcut                     = New-Object system.Windows.Forms.Button
$amdshortcut.text                = "AMD"
$amdshortcut.width               = 102
$amdshortcut.height              = 58
$amdshortcut.location            = New-Object System.Drawing.Point(492,60)
$amdshortcut.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$amdshortcut.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$amdshortcut.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#d0021b")

$DriverWebsites                  = New-Object system.Windows.Forms.Label
$DriverWebsites.text             = "Driver Websites"
$DriverWebsites.AutoSize         = $true
$DriverWebsites.width            = 25
$DriverWebsites.height           = 34
$DriverWebsites.location         = New-Object System.Drawing.Point(423,38)
$DriverWebsites.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',13,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DriverWebsites.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")

$asusshortcut                    = New-Object system.Windows.Forms.Button
$asusshortcut.text               = "ASUS"
$asusshortcut.width              = 102
$asusshortcut.height             = 58
$asusshortcut.location           = New-Object System.Drawing.Point(383,151)
$asusshortcut.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$asusshortcut.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$asusshortcut.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$msishortcut                     = New-Object system.Windows.Forms.Button
$msishortcut.text                = "MSI"
$msishortcut.width               = 102
$msishortcut.height              = 58
$msishortcut.location            = New-Object System.Drawing.Point(383,84)
$msishortcut.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$msishortcut.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$msishortcut.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$Shortcuts                       = New-Object system.Windows.Forms.Label
$Shortcuts.text                  = "Shortcuts"
$Shortcuts.AutoSize              = $true
$Shortcuts.width                 = 25
$Shortcuts.height                = 34
$Shortcuts.location              = New-Object System.Drawing.Point(104,37)
$Shortcuts.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',13,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Shortcuts.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")

$activationbutton                = New-Object system.Windows.Forms.Button
$activationbutton.text           = "Windows Activation"
$activationbutton.width          = 102
$activationbutton.height         = 58
$activationbutton.location       = New-Object System.Drawing.Point(149,66)
$activationbutton.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',11)
$activationbutton.ForeColor      = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$activationbutton.BackColor      = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$programsbutton                  = New-Object system.Windows.Forms.Button
$programsbutton.text             = "Installed Apps"
$programsbutton.width            = 102
$programsbutton.height           = 58
$programsbutton.location         = New-Object System.Drawing.Point(149,135)
$programsbutton.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$programsbutton.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$programsbutton.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$updatesbutton                   = New-Object system.Windows.Forms.Button
$updatesbutton.text              = "Windows Updates"
$updatesbutton.width             = 102
$updatesbutton.height            = 58
$updatesbutton.location          = New-Object System.Drawing.Point(35,66)
$updatesbutton.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',11)
$updatesbutton.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$updatesbutton.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$ThemeButton                     = New-Object system.Windows.Forms.Button
$ThemeButton.text                = "Old Themes Page"
$ThemeButton.width               = 102
$ThemeButton.height              = 58
$ThemeButton.location            = New-Object System.Drawing.Point(35,135)
$ThemeButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$ThemeButton.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ThemeButton.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$powerplanbutton                 = New-Object system.Windows.Forms.Button
$powerplanbutton.text            = "Windows Power Plan"
$powerplanbutton.width           = 102
$powerplanbutton.height          = 58
$powerplanbutton.location        = New-Object System.Drawing.Point(36,207)
$powerplanbutton.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$powerplanbutton.ForeColor       = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$powerplanbutton.BackColor       = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "Program owned by Mike Ivison"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(7,571)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Label3.ForeColor                = [System.Drawing.ColorTranslator]::FromHtml("#4f4f4f")

$intelshortcut                   = New-Object system.Windows.Forms.Button
$intelshortcut.text              = "Intel"
$intelshortcut.width             = 102
$intelshortcut.height            = 58
$intelshortcut.location          = New-Object System.Drawing.Point(492,130)
$intelshortcut.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$intelshortcut.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$intelshortcut.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#4a90e2")

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(64,468)
$Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$LightMode                       = New-Object system.Windows.Forms.Button
$LightMode.text                  = "Light Mode"
$LightMode.width                 = 102
$LightMode.height                = 35
$LightMode.location              = New-Object System.Drawing.Point(149,293)
$LightMode.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$LightMode.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$LightMode.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$DarkMode                        = New-Object system.Windows.Forms.Button
$DarkMode.text                   = "Dark Mode"
$DarkMode.width                  = 102
$DarkMode.height                 = 35
$DarkMode.location               = New-Object System.Drawing.Point(35,293)
$DarkMode.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$DarkMode.ForeColor              = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$DarkMode.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$Reboot                          = New-Object system.Windows.Forms.Button
$Reboot.text                     = "REBOOT"
$Reboot.width                    = 100
$Reboot.height                   = 89
$Reboot.location                 = New-Object System.Drawing.Point(247,479)
$Reboot.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Reboot.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")

$DeviceManager                   = New-Object system.Windows.Forms.Button
$DeviceManager.text              = "Device Manager"
$DeviceManager.width             = 102
$DeviceManager.height            = 58
$DeviceManager.location          = New-Object System.Drawing.Point(149,207)
$DeviceManager.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$DeviceManager.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$DeviceManager.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$Explorer                        = New-Object system.Windows.Forms.Button
$Explorer.text                   = "Explorer"
$Explorer.width                  = 100
$Explorer.height                 = 37
$Explorer.location               = New-Object System.Drawing.Point(246,434)
$Explorer.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Explorer.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$ReinstallOneDrive               = New-Object system.Windows.Forms.Button
$ReinstallOneDrive.text          = "Reinstall OneDrive"
$ReinstallOneDrive.width         = 215
$ReinstallOneDrive.height        = 35
$ReinstallOneDrive.location      = New-Object System.Drawing.Point(35,335)
$ReinstallOneDrive.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$ReinstallOneDrive.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ReinstallOneDrive.BackColor     = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$customclean               = New-Object system.Windows.Forms.Button
$customclean.text          = "Custom Debloat"
$customclean.width         = 210
$customclean.height        = 35
$customclean.location      = New-Object System.Drawing.Point(383,360)
$customclean.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$customclean.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$customclean.BackColor     = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$mssu               = New-Object system.Windows.Forms.Button
$mssu.text          = "Update all MS Store Apps"
$mssu.width         = 210
$mssu.height        = 35
$mssu.location      = New-Object System.Drawing.Point(383,320)
$mssu.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$mssu.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$mssu.BackColor     = [System.Drawing.ColorTranslator]::FromHtml("#857777")

$Form.controls.AddRange(@($RunScript,$RunNoOEM,$UndoScript,$ExitButton,$mocologo,$nvidiashortcut,$amdshortcut,$DriverWebsites,$asusshortcut,$msishortcut,$Shortcuts,$activationbutton,$programsbutton,$updatesbutton,$ReinstallOneDrive,$customclean,$mssu,$ThemeButton,$powerplanbutton,$Label3,$intelshortcut,$Label4,$LightMode,$DarkMode,$Reboot,$DeviceManager,$Explorer))
###########################################################################################################################




            #START OF SCRIPT 




###########################################################################################################################

$programversion = "22.32.603"


$package1  = "Google.Chrome"
$package2  = "Adobe.Acrobat.Reader.64-bit"
$package3  = "VideoLAN.VLC"
$Location1 = "$env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
$Location3 = "$env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
$Location2 = "$env:PROGRAMFILES\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
$onedrivelocation = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
$EdgeShortcut = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
$edgescpub = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
$vlcsc = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
$acrosc = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
$ctemp = "C:\Temp"
$frmt = "`n `n======================================== `n `n"
$BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
$WantedBuild = "10.0.22000"
$dtime = (Get-Date -UFormat %H.%M-%Y.%m.%d)
$blstat = "on"
$mocotheme1 = "$Env:USERPROFILE\desktop\win11-light.deskthemepack"
$mocotheme2 = "$Env:USERPROFILE\desktop\win11-dark.deskthemepack"
$mocotheme3 = "$Env:USERPROFILE\desktop\win10-purple.deskthemepack"

Function Programs {
    Write-Host "$frmt Installing Apps `n Please be patient as the programs install in the background.$frmt"
    Write-Host " Double Checking Winget is installed"
    If (!(Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe)){
        Write-Host " Winget not found, installing it now."
        Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
        $nid = (Get-Process AppInstaller).Id
        Wait-Process -Id $nid
        Write-Host " Winget Installed"
        Start-Sleep -s 4
        Stop-Process -Name AppInstaller -Force
    }
If (!(Test-Path $Location1)) {
    Write-Host "`n `n Installing $Package1`n" 
    winget install $package1 -s winget -e -h
    Write-Host " $package1 Installed."
    Write-Host "`n Verified $package1 is already Installed. Moving On. "
    Write-Host " Adding Extension Flag for UBlock Origin. When Chrome launches later, make sure to hit the accept button."
    REG ADD "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
	Write-Host " Adding Extension Flag for Microsoft Defender Browser Protection"
    REG ADD "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Google\Chrome\Extensions\bkbeeeffjjeopflfhgeknacdieedcoml" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
    } else {
        Write-Host " $package1 is already insatlled. Skipping"
    }
If (!(Test-Path $Location2)) {
    Write-Host "`n `n Installing $Package2`n" 
    winget install $package2 -s winget -e -h
    Write-Host "$package2 Installed."
    } else {
    Write-Host "`n Verified $package2 is already installed. Skipping"
    }    
If (!(Test-Path $Location3)) {
    Write-Host "`n `n Installing $Package3`n" 
    winget install $package3 -s winget -e -h
    Write-Host "$package3 Installed."
    } else {
    Write-Host "`n Verified $package3 is already installed.`n Moving on`n `n"
    } 
}             
Function Visuals {
    Write-Host " Checking your OS.."
    If (!((Get-Process -Name explorer -ErrorAction SilentlyContinue).Id)){
        Write-Host " Explorer not found."
        Start-Process explorer -Verbose
        write-host " Explorer Started"
        }
    Start-Sleep -s 2
    If ($BuildNumber -gt $WantedBuild) {
        write-Host " I have detected that you are on Windows 11 `n `n Applying Appropriate Theme & Flagging Required Settings"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/win11-light.deskthemepack" -Destination "$env:temp\win11-light.deskthemepack"
        Start-Process "$env:temp\win11-light.deskthemepack"
        Start-Sleep -s 3
        taskkill /F /IM systemsettings.exe 2>$NULL
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            write-Host " I have detected that you are on Windows 10 `n `n Applying Appropriate Theme & Flagging Required Settings"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/win10-purple.deskthemepack" -Destination "$env:temp\win10-purple.deskthemepack"
            Start-Process "$env:temp\win10-purple.deskthemepack"
            Start-Sleep -s 3
            taskkill /F /IM systemsettings.exe 2>$NULL
        }
    }

    Write-Host "`n Setting Wallpaper to Stretch `n"
    Stop-Process -Name Explorer
    If(!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System")){
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name "System"
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "WallpaperStyle" -Type String -Value 2 -ErrorAction SilentlyContinue
    Start-Sleep -s 1
    Start-Process Explorer -Wait
}
Function StartMenu {
    Write-host "$frmt Applying Start Menu & Pinning Taskbar Layout $frmt"
    Write-Host " Creating StartMenuLayout.Xml"
    $START_MENU_LAYOUT = @"
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
            <taskbar:DesktopApp DesktopApplicationID="Chrome" />
            <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer" />
            </taskbar:TaskbarPinList>
        </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@
$layoutFile="C:\Windows\StartMenuLayout.Xml"
Write-Host " Clearing Pinned Start Icons"
Start-Sleep -Milliseconds 300
Write-Host " Applied Taskbar Icons"
    If(Test-Path $layoutFile)
    {
        Remove-Item $layoutFile
    }
    $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
    $regAliases = @("HKLM", "HKCU")
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        IF(!(Test-Path -Path $keyPath)) { 
            New-Item -Path $basePath -Name "Explorer"
        }
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
    }
    Write-Host " Restarting Explorer Service"
    Stop-Process -name explorer -force | Out-Null 2>$NULL
    Start-Sleep -s 3
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESC}')
    Start-Sleep -s 3
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
    }
    Stop-Process -name explorer -force | Out-Null 2>$NULL
    Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
    Write-Host " Removing layout.xml files "
    Remove-Item $layoutFile
    taskkill /F /IM explorer.exe | Out-Null 2>$NULL
}

Function UndoOneDrive{
    Write-Host "$frmt Starting OneDriveSetup.exe $frmt"
    Write-Host " Starting $onedrivelocation"
    Start-Process $onedrivelocation /Silent -Wait
    Write-Host "`n `n OneDrive reinstalled."
}
Function OneDrive {
    If (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive"){
    Write-Host "$frmt `n Stopping OneDrive"
    Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
    Start-Sleep -s 2
    Write-Host " Uninstalling OneDrive..."
    If (!(Test-Path $onedrive)) {
        $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
    }
    Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
    Start-Sleep -s 2
    Stop-Process -Name "explorer" -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Host " $frmt It appears that OneDrive isn't installed."
    }
}

$Programs = @(
#Unnecessary Windows 10 AppX Apps
"Microsoft.3DBuilder"
"Microsoft.Microsoft3DViewer"
"Microsoft.AppConnector"
"Microsoft.BingFinance"
"Microsoft.BingNews"
"Microsoft.BingSports"
"Microsoft.BingTranslator"
"Microsoft.BingWeather"
"Microsoft.BingFoodAndDrink"
"Microsoft.BingHealthAndFitness"
"Microsoft.BingTravel"
"Microsoft.ConnectivityStore"
"Microsoft.MinecraftUWP"
"Microsoft.GetHelp"
"Microsoft.Messaging"
"Microsoft.MixedReality.Portal"
"Microsoft.MicrosoftOfficeHub"
"Microsoft.Microsoft3DViewer"
"Microsoft.MicrosoftSolitaireCollection"
"Microsoft.NetworkSpeedTest"
"Microsoft.News"
"Microsoft.Office.Lens"
"Microsoft.Office.Sway"
"Microsoft.Office.OneNote"
"Microsoft.OneConnect"
"Microsoft.People"
"Microsoft.Print3D"
"Microsoft.SkypeApp"
"MicrosoftTeams"
"Microsoft.Wallet"
"Microsoft.Whiteboard"
"Microsoft.WindowsMaps"
"Microsoft.WindowsSoundRecorder"

#   Deactivated Microsoft Services   #
#"Microsoft.GamingServices"
#"Microsoft.Getstarted"
#"Microsoft.WindowsPhone"
#"Microsoft.XboxApp"
#"Microsoft.CommsPhone"
#"Microsoft.Xbox.TCUI"
#"Microsoft.XboxSpeechToTextOverlay"
#"Microsoft.XboxIdentityProvider"
#"Microsoft.YourPhone"
#"Microsoft.Getstarted"
# Realtek Audio
#"RealtekSemiconductorCorp.RealtekAudioControl"
#"Microsoft.ScreenSketch"
#"Microsoft.WindowsCommunicationsApps"
#"Microsoft.XboxGameOverlay"
#"Microsoft.XboxGameCallableUI"
#"Microsoft.WindowsAlarms"
#"Microsoft.WindowsFeedbackHub"
#"Microsoft.ZuneMusic"
#"Microsoft.ZuneVideo"


# non-Microsoft All Machines
"Disney.37853FC22B2CE"
"SpotifyAB.SpotifyMusic"
"4DF9E0F8.Netflix"
"C27EB4BA.DropboxOEM"


# non-Microsoft
"26720RandomSaladGamesLLC.HeartsDeluxe"
"26720RandomSaladGamesLLC.SimpleSolitaire"
"26720RandomSaladGamesLLC.SimpleMahjong "
"26720RandomSaladGamesLLC.Spades"
"DolbyLaboratories.DolbyAccess"
"5319275A.WhatsAppDesktop"
"2FE3CB00.PicsArt-PhotoStudio"
"AdobeSystemsIncorporated.AdobeLightroom"
"WikimediaFoundation.Wikipedia"
"CorelCorporation.PaintShopPro"
"2FE3CB00.PicsArt-PhotoStudio"
"NAVER.LINEwin8"
"2FE3CB00.PicsArt-PhotoStudio"
"613EBCEA.PolarrPhotoEditorAcademicEdition"
"89006A2E.AutodeskSketchBook"
"A278AB0D.DisneyMagicKingdoms"
"A278AB0D.MarchofEmpires"
"CAF9E577.Plex"  
"D52A8D61.FarmVille2CountryEscape"
"DB6EA5DB.CyberLinkMediaSuiteEssentials"
"ClearChannelRadioDigital.iHeartRadio"
"Drawboard.DrawboardPDF"
"Fitbit.FitbitCoach"
"GAMELOFTSA.Asphalt8Airborne"
"KeeperSecurityInc.Keeper"
"NORDCURRENT.COOKINGFEVER"
"Playtika.CaesarsSlotsFreeCasino"
"ShazamEntertainmentLtd.Shazam"
"SlingTVLLC.SlingTV"
"ThumbmunkeysLtd.PhototasticCollage"
"TuneIn.TuneInRadio"
"WinZipComputing.WinZipUniversal"
"XINGAG.XING"
"flaregamesGmbH.RoyalRevolt2"
"Evernote.Evernote"
"MirametrixInc.GlancebyMirametrix"
"7EE7776C.LinkedInforWindows"
"DolbyLaboratories.DolbyAudio"
"*EclipseManager*"
"*ActiproSoftwareLLC*"
"*Duolingo-LearnLanguagesforFree*"


"*PandoraMediaInc*"
"*CandyCrush*"
"*BubbleWitch3Saga*"
"*Wunderlist*"
"*Flipboard*"
"*Royal Revolt*"
"*Sway*"
"*Speed Test*"
"*Viber*"
"*ACGMediaPlayer*"
"*OneCalendar*"
"*LinkedInforWindows*"
"*HiddenCityMysteryofShadows*"
"*Hulu*"
"*HiddenCity*"
"*AdobePhotoshopExpress*"
 
#Social Networking
"57540AMZNMobileLLC.AmazonAlexa"
"*TikTok*"
"*Twitter*"
"FACEBOOK.*"
"FACEBOOK.317180B0BB486"

#AntiVirus
"5A894077.McAfeeSecurity"

# Removes Acer Apps
"AcerIncorporated.AcerRegistration"
"AcerIncorporated.QuickAccess"
"AcerIncorporated.UserExperienceImprovementProgram"
"AcerIncorporated.AcerCareCe nterS"
"AcerIncorporated.AcerCollectionS"
"CyberLinkCorp.ac.PowerDirectorforacerDesktop"
"CyberLinkCorp.ac.PhotoDirectorforacerDesktop"
    
# Removes HP Apps
"AD2F1837.HPSupportAssistant"
"AD2F1837.HPPrinterControl"
"AD2F1837.HPQuickDrop"
"AD2F1837.HPSystemEventUtility"
"AD2F1837.HPPrivacySettings"
"AD2F1837.HPInc.EnergyStar"
"AD2F1837.HPAudioCenter"
# Removes Lenovo Apps
"E0469640.LenovoUtility"

# Removes Dell Apps

# Removes X Apps {Placeholder}
)
Function Debloat {
    Write-Host "$frmt Removing Bloatware $frmt "
    foreach ($Program in $Programs) {
    Get-AppxPackage -Name $Program| Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online
    Write-Host " Attempting removal of $Program."
    }
}
Function UndoDebloat {
    Write-Host " Reinstalling this computers default apps"
    Start-Sleep -Milliseconds 1285
    Get-AppxPackage -allusers | ForEach-Object {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode -Verbose -ErrorAction SilentlyContinue}
}

Function Registry {
    Write-Host "$frmt Applying Registry Changes $frmt"

    If ($BuildNumber -lt $WantedBuild) {
        Write-Host " Applying Windows 10 Specific Registry Keys `n"
        Start-Sleep -s 1
        Write-Host " Unpinning Cortana Icon on Taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Value 0
        Write-Host " Unpinning TaskView Icon from Taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
        Write-Host " Changing Searchbox to Icon Format on Taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 1
        Start-Sleep -s 10        
    }
    #11 Specific
    if ($BuildNumber -gt $WantedBuild) {
        Write-Host " Applying Windows 11 Specific Registry Keys `n"
        #Write-Host " Unpinning Widgets and Teams from taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
        #Taskbarda is Widgets - Currently Widgets shows temperature bottom left
        #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarDa" -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarMn" -Value 0
        Start-Sleep -s 10
    }

    Write-Host " Changing how often Windows asks for feedback to never"
    If (!(Test-Path "HKCU:\Software\Microsoft\Siuf")) { 
        New-Item -Path "HKCU:\Software\Microsoft" -Name "Siuf"
    }

    If (!(Test-Path "HKCU:\Software\Microsoft\Siuf\Rules")) {
    New-Item -Path "HKCU:\Software\Microsoft\Siuf" -Name "Rules"
    }
    Set-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0 2>$NULL
    Set-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Type QWORD -Value 0 2>$NULL

    Write-Host " Setting Windows Updates to Check for updates but let me choose whether to download and install them"
    Set-ItemProperty "HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings" -Name UxOption -Type DWORD -Value 2 2>$NULL
   
    Write-Host " Disabling Windows Feedback Notifications"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1 
    
    Write-Host " Setting Sounds > Communications to 'Do Nothing'"
    Set-ItemProperty "HKCU:\Software\Microsoft\MultiMedia\Audio" -Name "UserDuckingPreference" -Value 3 -Type DWord
    
    Write-Host " Disabling Windows Pop-Ups on Start-Up ex. Let's finish setting up your device - Get Even More Out of Windows - Upgrade to Windows 11 Popup"
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement")){
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "UserProfileEngagement"
    }
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Type DWORD -Value 0

    Write-Host " Expanding Explorer Ribbon"
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon")){
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "Ribbon"
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" -Name "MinimizedStateTabletModeOff" -Value 1 2>$NULL
    
    Write-Host " Disabling Show Recent in Explorer Menu"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 0
    
    Write-Host " Disabling Show Frequent in Explorer Menu"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 0
    
    Write-Host " Enabling Snap Assist Flyout"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Value 1
    
    Write-Host " Enabling File Extensions"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
    
    Write-Host " Setting Explorer Launch to This PC"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1
    
    Write-Host " Setting Start Tab in task manager to Performance"
    If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager")){
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Name "TaskManager"
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "StartUpTab" -Value 1 -Type DWord
  
    Write-Host " Adding User Files to desktop"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0
    
    Write-Host " Adding This PC icon to desktop"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0
    
    Write-Host " Disabling Feeds open on hover"
    If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds")){
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Name "Feeds"
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value 0
    
    Write-Host " Disabling Content Delivery & Content Delivery Related Setings - ContentDelivery, Pre-installed Microsoft, Pre-installed OEM Apps, Silent"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContentEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Type DWord -Value 0 

    Write-Host " Removing Registry Related OEM Auto Install Program Keys"
    Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" -Recurse -Force -ErrorAction SilentlyContinue
    
    #Privacy Related
    Write-Host " Disabling Contact Harvesting"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 0 
    
    Write-Host " Restricting Ink and Text Collection (Key-Logger)"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1 
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1 
    
    Write-Host " Declining Microsoft Privacy Policy"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 0 
    
    Write-Host " Disabling App Launch Tracking"
    If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI")){
        New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "EdgeUI"
    }
    Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -Name DisableMFUTracking -Value 1 -Type DWord 2>$NULL

    Write-Host " Disabling Advertiser ID"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name DisabledByGroupPolicy -Value 1 -Type DWord
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name Enabled -Value 0 -Type DWord

    Write-Host "`n `n ======================================== `n `n Registry Modifications Complete `n `n ======================================== `n `n"
    #Write-Host " Disabling Cloud Relating Search Content (OneDrive, SharePoint, Outlook, Bing)"
    #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsMSACloudSearchEnabled" -Value 0 
    #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsAADCloudSearchEnabled" -Value 0 

    #Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null 2>$NULL
    #Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null 2>$NULL
}  

Function UndoRegistry {
    Write-Host "$frmt Undoing Registry Changes $frmt"

    Write-Host " Resetting how often Windows asks for feedback to never"
    Remove-Item "HKCU:\Software\Microsoft\Siuf" -Force -Recurse -ErrorAction SilentlyContinue

    Write-Host " Setting Windows Updates to Never Check for Updates"
    Set-ItemProperty "HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings" -Name UxOption -Type DWORD -Value 0
   
    Write-Host " Enabling Windows Feedback Notifications"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 0
    
    
    Write-Host " Enabling Windows Pop-Ups on Start-Up ex. Let's finish setting up your device - Get Even More Out of Windows - Upgrade to Windows 11 Popup"
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Type DWORD -Value 1

    Write-Host " Enabling Show Recent in Explorer Menu"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 1
    
    Write-Host " Enabling Show Frequent in Explorer Menu"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 1
    
    Write-Host " Hiding Snap Assist Flyout"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Value 1
    
    Write-Host " Hiding File Extensions"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 1
    
    Write-Host " Setting Explorer Launch to Quick Access"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 2
    
    Write-Host " Setting Start Tab in task manager to default"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name StartUpTab -Value 0 -Type DWord

    If ($BuildNumber -lt $WantedBuild) {
        Write-Host " Applying Windows 10 Specific Registry Keys `n"
        Start-Sleep -s 1
        Write-Host " Re-Pinning Cortana Icon on Taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Value 1
        Write-Host " Re-Pinning TaskView Icon from Taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 1
        Write-Host " Changing Search to Bar Format on Taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 2
        
    }
    #11 Specific
    if ($BuildNumber -gt $WantedBuild) {
        Write-Host " Applying Windows 11 Specific Registry Keys `n"
        Write-Host " Re-Pinning Widgets and Teams to taskbar"
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 1
        #Taskbarda is Widgets - Currently Widgets shows temperature bottom left
        #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarDa" -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarMn" -Value 1
        Start-Sleep -s 10
    } 
    
    Write-Host " Removing User Files from desktop"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 1
    
    Write-Host " Removing This PC icon from desktop"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 1
    
    Write-Host " Enabling Feeds open on hover"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value 1
    
    Write-Host " Enabling Content Delivery & Content Delivery Related Setings - ContentDelivery, Pre-installed Microsoft, Pre-installed OEM Apps, Silent"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContentEnabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Type DWord -Value 1 

    #Write-Host " Removing Registry Related OEM Auto Install Program Keys"
    #Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps"
    #Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" 
    
    #Privacy Related
    Write-Host " Enabling Contact Harvesting"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 1
    
    Write-Host " Allowing Ink and Text Collection (Key-Logger)"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 0 
    
    Write-Host " Accepting Microsoft Privacy Policy"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 1
    
    Write-Host " Enabling App Launch Tracking"
    Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -Name DisableMFUTracking -Value 0 -Type DWord

    Write-Host " Enabling Advertiser ID"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name DisabledByGroupPolicy -Value 1 -Type DWord
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Force -Recurse -ErrorAction SilentlyContinue

    Write-Host "`n `n ======================================== `n `n Registry Modifications Complete `n `n ======================================== `n `n"
}  
Function UndoOEMInfo{
    Write-Host "$frmt Undoing OEM Information $frmt "

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Model" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportHours" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportPhone" -Type String -Value "" -Verbose
}
Function OEMInfo{
    Write-Host "$frmt Applying OEM Information $frmt "
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Type String -Value "Mother Computers"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportPhone" -Type String -Value "(250) 479-8561" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportHours" -Type String -Value "Monday - Saturday 9AM-5PM | Sunday - Closed" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Type String -Value "https://www.mothercomputers.com" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Model" -Type String -Value "Mother Computers : 250-479-8561"
}
Function Cleanup {
	
    Write-Host "$frmt Finishing Up$frmt"
	If (!((Get-Process -Name explorer -ErrorAction SilentlyContinue).Id)){
		Start-Process explorer
		write-host " Explorer Started"
    }
	
	#A112
    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq $blstat){
        Write-Host " Bitlocker seems to be enabled. Starting the decryption process."
        manage-bde -off "C:"
        Write-Host " Continuing task in background."
        } else {
        Write-Host " Bitlocker is not enabled on this machine."
    }    #On Charger
    Write-Host " Changing On AC Sleep Settings"
    powercfg -change -standby-timeout-ac "60"
    powercfg -change -monitor-timeout-ac "45"        
    Write-Host " Changing On Battery Sleep Settings"
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"


    Write-Host " Launching Chrome, Please accept UBlock Origin extension popup"
    Start-Sleep -Milliseconds 400
    Start-Process Chrome -ErrorAction SilentlyContinue
    Remove-Item "$Env:Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    If ($EdgeShortcut) { 
        Write-Host " Removing Edge Icon"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If ($edgescpub) { 
        Write-Host " Removing Edge Icon in Public"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If ($vlcsc) { 
        Write-Host " Removing VLC Media Player Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If ($acrosc) { 
        Write-Host " Removing Adobe Acrobat Icon"
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If ($ctemp) { 
        Write-Host " Removing temp folder in C Root"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If ($mocotheme1) { 
        Remove-Item "$mocotheme1" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If ($mocotheme2) { 
        Remove-Item $mocotheme2 -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If ($mocotheme3) { 
        Remove-Item $mocotheme3 -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
}
$customclean.add_click{
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
    [System.Windows.Forms.MessageBox]::Show('                        This Program REMOVES all SELECTED apps



    Press <CTRL> if you want to select and remove mutliple apps at the        same time.')
    Get-AppxPackage -AllUsers | Out-GridView -PassThru | Remove-AppxPackage -Verbose -ErrorAction SilentlyContinue
}
$mssu.add_click{
    Write-Host " Updating Store Applications."
    Start-Sleep -s 3
    $namespaceName = "root\cimv2\mdm\dmmap"
    $className = "MDM_EnterpriseModernAppManagement_AppManagement01"
    $wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className
    $result = $wmiObj.UpdateScanMethod()
    $result
    Write-Host " This process will continue in the background."
}

$powerplanbutton.Add_Click{
    Start-Process powercfg.cpl
}
$themebutton.Add_Click{
    Start-Process explorer.exe "shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}"
}
$programsbutton.Add_Click{
    Start-Process appwiz.cpl
}
$updatesbutton.Add_Click{
    Start-Process ms-settings:windowsupdate
}
$activationbutton.Add_Click{
    Start-Process slui 3
}
$msishortcut.Add_Click{
    Start-Process "https://www.msi.com/support/download"
}
$asusshortcut.Add_Click{
    Start-Process "https://www.asus.com/ca-en/support/download-center/"
}
$nvidiashortcut.Add_Click{
    Start-Process "https://www.nvidia.com/Download/index.aspx?lang=en-us"
}
$amdshortcut.Add_Click{
    Start-Process "https://www.amd.com/en/support"
}
$intelshortcut.Add_Click{
    Start-Process "https://www.intel.com/content/www/us/en/download-center/home.html"
}
$DeviceManager.Add_Click{
    Start-Process devmgmt.msc
}
$ReinstallOneDrive.Add_Click{
    UndoOneDrive
}
$Explorer.Add_Click{
    Start-Process Explorer .\ 
}
$Reboot.Add_Click{
    shutdown -r -t 0
}
$LightMode.Add_Click{
    If ($BuildNumber -gt $WantedBuild) {
        write-Host " Applying Light mode for Windows 11"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/win11-light.deskthemepack" -Destination win11-light.deskthemepack
        Start-Sleep -s 3
        Start-Process "win11-light.deskthemepack"
        Start-Sleep -s 3
        Remove-Item "win11-light.deskthemepack" -Force -Recurse 
        taskkill /F /IM systemsettings.exe 2>$NULL
        Write-Host " Applied Light Theme for Windows 11"
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            #write-Host " Applying Light Mode for Windows 10"
            #If (!(test-path ~\Appdata\Local\Temp\win10-purple.deskthemepack)){
                #}
                
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/win10-purple.deskthemepack" -Destination win10-purple.deskthemepack                
            Start-Sleep 3
            Start-Process "win10-purple.deskthemepack"
            Start-Sleep 3
            Remove-Item "win10-purple.deskthemepack" -Force -Recurse
            taskkill /F /IM systemsettings.exe 2>$NULL
            #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Type DWord -Value 1
            #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Type DWord -Value 1
            Write-Host " Applied Light Theme for Windows 10"
        }
    }
}    

$DarkMode.Add_Click{
    If ($BuildNumber -gt $WantedBuild) {
        write-Host " Applying Dark mode for Windows 11"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/win11-dark.deskthemepack" -Destination win11-dark.deskthemepack
        Start-Sleep -s 2
        Start-Process "win11-dark.deskthemepack"
        Start-Sleep -s 2
        Remove-Item "win11-dark.deskthemepack" -Force -Recurse
        taskkill /F /IM systemsettings.exe 2>$NULL
        Write-Host " Applied Dark Theme for Windows 11"           
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            #write-Host " Applying Dark Mode for Windows 10"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/win10-purple.deskthemepack" -Destination win10-purple.deskthemepack
            Start-Sleep -s 3
            Start-Process "win10-purple.deskthemepack"
            Start-Sleep -s 3
            Remove-Item "win10-purple.deskthemepack" -Force -Recurse  
            taskkill /F /IM systemsettings.exe 2>$NULL               
            #Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Type DWord -Value 0
            #Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Type DWord -Value 0
            Write-Host " Applied Dark Theme for Winodws 10"
        }
    }    
}

If (!(Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe)){
    $reason = " Winget not found
 
 What do I do?:
 Check taskbar for an AppInstaller instance. It should have a button that says update. Click that and let the program install.
 If however that option is not available. Relaunch the script.
 
 What is Winget?:
 https://docs.microsoft.com/en-us/windows/package-manager/winget/
"
} else {
    $health = $health+=35
}

$wantedreason = "OK"
If ($reason -eq $wantedreason){
    Write-Host "`n`n================================================================================================`n`n"
    Write-Host " New Loads`n" #-ForegroundColor Cyan
    Write-Host " Script Version : $programversion"
    Write-Host " Script Intregity: $Health%`n"
    Write-Host " Ideally run updates before continuing with this script." -ForegroundColor Red
    Write-Host "`n`n================================================================================================`n`n`n"
} else {
    Write-Host "`n`n================================================================================================`n`n"
    Write-Host " New Loads`n" #-ForegroundColor Cyan
    Write-Host " Script Version : $programversion"
    Write-Host " Script Intregity: $Health%`n`n"
    Write-Host " Error Message: $reason`n`n" -ForegroundColor DarkRed
    Write-Host " Ideally run updates before continuing with this script." -ForegroundColor Red
    Write-Host "`n`n================================================================================================`n`n`n"
}




#Write-Host "`n `n================================================================================================ `n `n `n New Loads`n Script Version : $programversion`n `n Script Intregity: $Health%`n `n Error Message: $reason `n`nIdeally run updates before continuing with this script. `n `n `n `n================================================================================================ `n `n"


$RunScript.Add_Click{
Start-Transcript -LiteralPath "$env:USERPROFILE\Desktop\Script Run - $dtime.txt"
Write-Host "$frmt Running Script `n `n GUI will be unusable whilst script is running. Please Standby `n$frmt"
#WinG
Programs
OEMInfo
Visuals
StartMenu
Registry
OneDrive
Debloat
Cleanup
Write-Host "$frmt Script Run Completed`n`n Ready for next task $frmt"
Stop-Transcript
}

$RunNoOEM.Add_Click{
Start-Transcript -LiteralPath "$env:USERPROFILE\Desktop\Script Run - No OEM - $dtime.txt"
Write-Host "$frmt Running Script without Branding`n `n GUI will be unusable whilst script is running. Please Standby `n$frmt"
#WinG
Programs
StartMenu
Registry
OneDrive
Debloat
Cleanup
Write-Host "$frmt Script Run`n`n Ready for next task $frmt"
Stop-Transcript
}

$UndoScript.Add_Click{
Start-Transcript -LiteralPath "$env:USERPROFILE\Desktop\Script Run - Undo - $dtime.txt"
Write-Host "$frmt Undoing Changes made by Script `n `n GUI will be unusable whilst script is running. Please Standby `n$frmt"
Start-Sleep 2
UndoOEMInfo
Write-Host "$frmt Reinstalling Bloatware $frmt "
UndoDebloat
Write-Host " Finished Reinstalling Bloatware Apps"
Taskkill /F /IM Explorer.exe
UndoOneDrive
UndoRegistry
If (!((Get-Process -Name explorer -ErrorAction SilentlyContinue).Id)){
	Start-Process explorer
	write-host " Explorer Started"
	} else {
	Write-Host Explorer is running
}
Write-Host "$frmt Script Actions Undone`n`nReady for next task $frmt"
Stop-Transcript
}
$ExitButton.Add_Click{
    $Form.Close()
}
[void]$Form.ShowDialog()


##WORKING DIRECTORY
##$TextBox1                        = New-Object system.Windows.Forms.TextBox
#$TextBox1.multiline              = $false
#$TextBox1.width                  = 317
#$TextBox1.height                 = 20
#$TextBox1.location               = New-Object System.Drawing.Point(1053,24)
#$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

#powershellsubmit.add_click{ 
    #$commandresult = "$textbox1.Text" 
    #$textboxresult = "TEXT"
    #Write-Host "Running command $textboxresult"
    #powershell -command "$textboxresult"
#}
# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUAw3ADAR3c25Bl+ML0CCjE+nH
# uySgggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFOVO8NEroEsV
# hba1E+Gkp+b5jrymMA0GCSqGSIb3DQEBAQUABIIBACH8B7+0v4sdw0PM0Bpo5tZt
# 1MW54MgnBiZx88H+LoJ8zk1BVZtj/oyxQqyjBBqcOWfsnT54kG4lpWJYYoBhPF/Q
# HjJ9i454Zan/e935HTma3PSXzN3z+N6UTd/nYHGo8fydb2xN48013dSfU12EorHV
# 0+Ssqmlov5cbpU8cKWw29ydR8GZBG1hwYH7pDc0QOc1sLAr40wu9R19AnSjC+HW4
# 0U55DlvVIXspGkoWTyD+T1Hpes9/jcuOnx6R/u4NWs6KVLpVbyNfxxgT0Yy5Skw3
# pP2AZoFn2h6yBhwH949UnaRf/PBG3qzstpMICRNhLftzmBqT/n4pAzsJ0u9wsTE=
# SIG # End signature block
