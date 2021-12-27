Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(633,590)
$Form.text                       = "Windows New Loads Utility - Created by Mike Ivison"
$Form.TopMost                    = $false
$Form.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#4b4b4b")
$form.StartPosition              = "CenterScreen"
#$form.StartPosition              = "manual"
#$form.Location                   = New-Object System.Drawing.Size(1400, 300)
#$Form.AutoScaleDimensions        = '192, 192'
#$Form.AutoScaleMode              = "Dpi"
#$Form.AutoSize                   = $True
#$Form.AutoScroll                 = $True
$Form.FormBorderStyle            = 'FixedSingle'

$RunScript                       = New-Object system.Windows.Forms.Button
$RunScript.text                  = "Run Script"
$RunScript.width                 = 240
$RunScript.height                = 90
$RunScript.location              = New-Object System.Drawing.Point(356,434)
$RunScript.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',13,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RunScript.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$RunNoOEM                        = New-Object system.Windows.Forms.Button
$RunNoOEM.text                   = "Run without Branding"
$RunNoOEM.width                  = 240
$RunNoOEM.height                 = 36
$RunNoOEM.location               = New-Object System.Drawing.Point(356,386)
$RunNoOEM.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',9)
$RunNoOEM.ForeColor              = [System.Drawing.ColorTranslator]::FromHtml("")
$RunNoOEM.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$UndoScript                      = New-Object system.Windows.Forms.Button
$UndoScript.text                 = "Undo Changes"
$UndoScript.width                = 118
$UndoScript.height               = 34
$UndoScript.location             = New-Object System.Drawing.Point(355,535)
$UndoScript.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$UndoScript.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$UndoScript.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#f8e71c")

$ExitButton                      = New-Object system.Windows.Forms.Button
$ExitButton.text                 = "Exit"
$ExitButton.width                = 118
$ExitButton.height               = 34
$ExitButton.location             = New-Object System.Drawing.Point(478,535)
$ExitButton.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ExitButton.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$ExitButton.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$mocologo                        = New-Object system.Windows.Forms.PictureBox
$mocologo.width                  = 303
$mocologo.height                 = 211
$mocologo.location               = New-Object System.Drawing.Point(-47,370)
$mocologo.imageLocation          = "https://github.com/circlol/newload/blob/main/logo.png?raw=true"
$mocologo.SizeMode               = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$nvidiashortcut                  = New-Object system.Windows.Forms.Button
$nvidiashortcut.text             = "NVIDIA"
$nvidiashortcut.width            = 102
$nvidiashortcut.height           = 53
$nvidiashortcut.location         = New-Object System.Drawing.Point(379,63)
$nvidiashortcut.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$nvidiashortcut.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$nvidiashortcut.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#7ed321")

$amdshortcut                     = New-Object system.Windows.Forms.Button
$amdshortcut.text                = "AMD"
$amdshortcut.width               = 102
$amdshortcut.height              = 53
$amdshortcut.location            = New-Object System.Drawing.Point(494,63)
$amdshortcut.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$amdshortcut.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$amdshortcut.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#d0021b")

$DriverWebsites                  = New-Object system.Windows.Forms.Label
$DriverWebsites.text             = "Driver Websites"
$DriverWebsites.AutoSize         = $true
$DriverWebsites.width            = 25
$DriverWebsites.height           = 10
$DriverWebsites.location         = New-Object System.Drawing.Point(442,38)
$DriverWebsites.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DriverWebsites.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")

$asusshortcut                    = New-Object system.Windows.Forms.Button
$asusshortcut.text               = "ASUS"
$asusshortcut.width              = 102
$asusshortcut.height             = 53
$asusshortcut.location           = New-Object System.Drawing.Point(379,132)
$asusshortcut.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$asusshortcut.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$asusshortcut.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$msishortcut                     = New-Object system.Windows.Forms.Button
$msishortcut.text                = "MSI"
$msishortcut.width               = 102
$msishortcut.height              = 53
$msishortcut.location            = New-Object System.Drawing.Point(494,132)
$msishortcut.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$msishortcut.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$msishortcut.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$Shortcuts                       = New-Object system.Windows.Forms.Label
$Shortcuts.text                  = "Shortcuts"
$Shortcuts.AutoSize              = $true
$Shortcuts.width                 = 25
$Shortcuts.height                = 10
$Shortcuts.location              = New-Object System.Drawing.Point(116,38)
$Shortcuts.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Shortcuts.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")

$activationbutton                = New-Object system.Windows.Forms.Button
$activationbutton.text           = "Activation"
$activationbutton.width          = 102
$activationbutton.height         = 53
$activationbutton.location       = New-Object System.Drawing.Point(149,66)
$activationbutton.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$activationbutton.ForeColor      = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$activationbutton.BackColor      = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$programsbutton                  = New-Object system.Windows.Forms.Button
$programsbutton.text             = "Programs"
$programsbutton.width            = 102
$programsbutton.height           = 53
$programsbutton.location         = New-Object System.Drawing.Point(36,132)
$programsbutton.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$programsbutton.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$programsbutton.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$updatesbutton                   = New-Object system.Windows.Forms.Button
$updatesbutton.text              = "Updates"
$updatesbutton.width             = 102
$updatesbutton.height            = 53
$updatesbutton.location          = New-Object System.Drawing.Point(36,66)
$updatesbutton.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$updatesbutton.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$updatesbutton.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$ThemeButton                     = New-Object system.Windows.Forms.Button
$ThemeButton.text                = "Themes"
$ThemeButton.width               = 102
$ThemeButton.height              = 53
$ThemeButton.location            = New-Object System.Drawing.Point(149,132)
$ThemeButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$ThemeButton.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ThemeButton.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$powerplanbutton                 = New-Object system.Windows.Forms.Button
$powerplanbutton.text            = "Power Plan"
$powerplanbutton.width           = 102
$powerplanbutton.height          = 53
$powerplanbutton.location        = New-Object System.Drawing.Point(93,196)
$powerplanbutton.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$powerplanbutton.ForeColor       = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$powerplanbutton.BackColor       = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "Program owned by Mike Ivison"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(6,575)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Label3.ForeColor                = [System.Drawing.ColorTranslator]::FromHtml("#555555")

$intelshortcut                   = New-Object system.Windows.Forms.Button
$intelshortcut.text              = "Intel"
$intelshortcut.width             = 102
$intelshortcut.height            = 53
$intelshortcut.location          = New-Object System.Drawing.Point(438,201)
$intelshortcut.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$intelshortcut.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$intelshortcut.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#4a90e2")

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(64,468)
$Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($RunScript,$RunNoOEM,$UndoScript,$ExitButton,$mocologo,$nvidiashortcut,$amdshortcut,$DriverWebsites,$asusshortcut,$msishortcut,$Shortcuts,$activationbutton,$programsbutton,$updatesbutton,$ThemeButton,$powerplanbutton,$Label3,$intelshortcut,$Label4))


#region Logic 
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}
Import-Module BitsTransfer
$Location1 = "$env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
$Location2 = "$env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
$Location3 = "$env:PROGRAMFILES\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
$Folder = Get-Location
$frmt = "`n `n======================================== `n `n"
$Lie = "License has Expired. Please Contact Mike for a New License"
$BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
$WantedBuild = "10.0.22000"
$Minimum = 20211211
$Time = (Get-Date -UFormat %Y%m%d)
$License = 20220330

    net start w32time 2> $NULL
    reg export HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config "$folder\exported_w32time.reg" /y | Out-Null 2> $NULL
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxNegPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null 2> $NULL
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxPosPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null 2> $NULL
    # w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update
    w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update | Out-Null 2> $NULL
    # w32tm /config /update
    w32tm /config /update | Out-Null 2> $NULL
    # w32tm /resync /rediscover 
    w32tm /resync /rediscover | Out-Null 2> $NULL
    #Restore registry w32time\Config
    reg import "$folder\exported_w32time.reg" | Out-Null 2> $NULL
    Remove-Item "$folder\exported_w32time.reg" | Out-Null 2> $NULL

    If ($Time -gt $License) {
        Clear-Host
        Write-Host $lie
        Start-Sleep 2
        Exit
        } else {
            If ($Time -gt $minimum) {
                Clear-Host
                } else {
                Clear-Host
                Write-Host $lie
                Start-Sleep 2
                Exit
            }
        }
Start-Transcript -OutputDirectory "$env:USERPROFILE\Desktop" > $NULL
Clear-Host
Write-Host "`n `n `n `n `n `n `n `n `n `n `n `n `n `n================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n Fresh Loads Utility For Windows 10 & 11 `n `n Created by Mike Ivison `n `n `n `n Ideally run updates before this script. `n `n `n `n `n `n `n `n `n `n `n `n `n================================================================================================ `n `n"
Function WinG{
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
    'Winget was found'
    } else {
    #Installs winget from the Microsoft Store
    Write-Host " Winget not found, installing it now."
    Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
    $nid = (Get-Process AppInstaller).Id
    Wait-Process -Id $nid
    Write-Host " Winget Installed"
    Start-Sleep 4
    Stop-Process -Name AppInstaller -Force
    }
}

Function Programs {
    Write-Host "$frmt Installing Apps `n Please be patient as the programs install in the background.$frmt"
    If (!(Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe)){
        Write-Host " Winget not found, installing it now."
        Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
        $nid = (Get-Process AppInstaller).Id
        Wait-Process -Id $nid
        Write-Host " Winget Installed"
        Start-Sleep 4
        Stop-Process -Name AppInstaller -Force
    }
    $packages = @(
    "Google.Chrome"
    "Adobe.Acrobat.Reader.64-bit"
    "VideoLAN.VLC"
    )

foreach ($Package in $Packages) {
    Write-Host "`n `nInstalling $Package `n" 
    winget install $package -e -h -s winget
    Write-Host "`n `n$Package has been Installed"
    }


Write-Host "$frmt Double Checking App Installs $frmt"
If (!(Test-Path $Location1)) {
    winget install Google.Chrome -s winget -e -h --force
    } else {
    Write-Host "Verified Chrome Install"
    }
If (!(Test-Path $Location2)) {
    winget install Adobe.Acrobat.Reader.64-bit -s winget -e -h --force 
    } else {
    Write-Host "Verified Acrobat Reader Install"
    }    
If (!(Test-Path $Location3)) {
    winget install VideoLAN.VLC -s winget -e -h --force 
    } else {
    Write-Host "Verified VLC Install"
    }
}            
Function Visuals {
    If ($BuildNumber -gt $WantedBuild) {
        write-Host "I have detected that you are on Windows 11 `n `nApplying appropriate theme"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/win11-light.deskthemepack" -Destination win11-light.deskthemepack
        #Start-BitsTransfer -Source "https://www40.zippyshare.com/d/ITnX1PTu/920358/win11-light.deskthemepack" -Destination win11-light.deskthemepack
        Start-Sleep 3
        Start-Process "win11-light.deskthemepack"
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            write-Host "I have detected that you are on Windows 10 `n `nApplying appropriate Theme"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/win10-purple.deskthemepack" -Destination win10-purple.deskthemepack
            Start-Sleep 3
            Start-Process "win10-purple.deskthemepack"
        }
    }
    Write-Host "`nSetting Wallpaper to Stretch `n"
    REG ADD "HKCU\Control Panel\Desktop" /v WallpaperStyle /f /t REG_SZ /d "2"
	Start-Sleep 1
	taskkill /F /IM systemsettings.exe 2> $NULL
    taskkill /F /IM explorer.exe 2> $NULL
}

Function StartMenu {
    Write-Host "$frmt Applying Visual Tweaks $frmt "
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
    
    $layoutFile="C:\Windows\StartMenuLayout.xml"
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
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
    }
    Stop-Process -name explorer -force | Out-Null
    Start-Sleep -s 5
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 5
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
    }
    Stop-Process -name explorer -force | Out-Null
    Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
    Remove-Item $layoutFile
}
Function UndoOneDrive{
    Start-Process "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /Silent /AllUsers
    Write-Host "`n `nOneDrive has been Reinstalled"
}
Function OneDrive {
    Write-Host "Disabling OneDrive..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
    Write-Host "Uninstalling OneDrive..."
    Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
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
    If (!(Test-Path "HKCR:")) {
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
    }
    Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
    Write-Host "Disabled OneDrive"
    Start-Process Explorer
    Write-Host "Restarted Explorer"
}
Function UndoDebloat{
    Get-AppxPackage -AllUsers| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml”} 2< $NULL
    Write-Host "Attempted to reinstall bloatware"
    }
Function Debloat {
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
        "Microsoft.MinecraftUWP"
        "Microsoft.GamingServices"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
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
        "Microsoft.WindowsAlarms"
        #"Microsoft.WindowsCommunicationsApps"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.XboxApp"
        "Microsoft.ConnectivityStore"
        "Microsoft.CommsPhone"
        #"Microsoft.ScreenSketch"
        "Microsoft.Xbox.TCUI"
        #"Microsoft.XboxGameOverlay"
        #"Microsoft.XboxGameCallableUI"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.MixedReality.Portal"
        "Microsoft.XboxIdentityProvider"
        #"Microsoft.ZuneMusic"
        #"Microsoft.ZuneVideo"
        "Microsoft.YourPhone"
        "Microsoft.Getstarted"
        "Microsoft.MicrosoftOfficeHub"
        # Realtek Audio
        #"RealtekSemiconductorCorp.RealtekAudioControl"
        
        # non-Microsoft
        "26720RandomSaladGamesLLC.HeartsDeluxe"
        "26720RandomSaladGamesLLC.SimpleSolitaire"
        "26720RandomSaladGamesLLC.SimpleMahjong "
        "26720RandomSaladGamesLLC.Spades"
        "Disney.37853FC22B2CE"
        "2FE3CB00.PicsArt-PhotoStudio"
        "5319275A.WhatsAppDesktop"
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
        "ClearChannelRadioDigital.iHeartRadio"
        "D52A8D61.FarmVille2CountryEscape"
        "DB6EA5DB.CyberLinkMediaSuiteEssentials"
        "DolbyLaboratories.DolbyAccess"
        "DolbyLaboratories.DolbyAccess"
        "Drawboard.DrawboardPDF"
        "Fitbit.FitbitCoach"
        "GAMELOFTSA.Asphalt8Airborne"
        "KeeperSecurityInc.Keeper"
        "NORDCURRENT.COOKINGFEVER"
        "Playtika.CaesarsSlotsFreeCasino"
        "ShazamEntertainmentLtd.Shazam"
        "SlingTVLLC.SlingTV"
        "SpotifyAB.SpotifyMusic"
        "ThumbmunkeysLtd.PhototasticCollage"
        "TuneIn.TuneInRadio"
        "WinZipComputing.WinZipUniversal"
        "XINGAG.XING"
        "flaregamesGmbH.RoyalRevolt2"
        "Evernote.Evernote"
        "4DF9E0F8.Netflix"
        "C27EB4BA.DropboxOEM"
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
        "*Facebook*"
    
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
    )
            Write-Host "$frmt Removing Bloatware from PC $frmt "
            foreach ($Program in $Programs) {
            Get-AppxPackage -Name $Program| Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online
            Write-Host "Trying to remove $Program."
        }
    
}
Function UndoRegistry {
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f | Out-Null
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f | Out-Null
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v Enabled /f | Out-Null
    REG ADD "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "0" /f
    #REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
    #REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_QWORD /d "0" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /T REG_DWORD /d "1" /f
    REG ADD "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "UxOption" /t REG_DWORD /d "0" /f
    REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "1" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "1" /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
    
    #Explorer Related Settings    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 1 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Value 0 -Verbose    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarDa" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarMn" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08e02B30309D}" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 1 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 1 -Verbose
    
    
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Model" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportHours" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Type String -Value "" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportPhone" -Type String -Value "" -Verbose
    
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContentEnabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 0 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 1 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsMSACloudSearchEnabled" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsAADCloudSearchEnabled" -Value 1 -Verbose
    
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 0 -Verbose
    Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
    Enable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
    

    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 0 -Verbose
} 

Function Registry {
    Write-Host "$frmt Applying Registry Changes $frmt "

    #On Charger
    Write-Host "Changing On AC Sleep Settings"
    powercfg -change -standby-timeout-ac "30"
    powercfg -change -monitor-timeout-ac "15"
    #On Battery
    Write-Host "Changing On Battery Sleep Settings"
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"
    start-sleep 1
    
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f | Out-Null
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f | Out-Null
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v Enabled /f | Out-Null
    REG ADD "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f
    REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
    REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_QWORD /d "0" /f
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /T REG_DWORD /d "0" /f
    REG ADD "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "UxOption" /t REG_DWORD /d "1" /f
    REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "0" /f
    REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f
    
    #Explorer Related Settings    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarDa" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarMn" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08e02B30309D}" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Verbose
 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContentEnabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 0 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsMSACloudSearchEnabled" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsAADCloudSearchEnabled" -Value 0 -Verbose
    
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1 -Verbose
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
    

    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1 -Verbose
        

    Write-Host "Registry Modifications Complete $frmt"
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
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Type String -Value "Mother Computers" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Model" -Type String -Value "(250) 479-8561" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportHours" -Type String -Value "Monday - Saturday 9AM-5PM | Sunday - Closed" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Type String -Value "https://www.mothercomputers.com" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportPhone" -Type String -Value "Mother Computers - (250) 479-8561" -Verbose
}
Function Cleanup {
    Write-Host "$frmt Finishing Up $frmt "
    Start-Process https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
    Remove-Item "$Env:Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    $EdgeShortcut = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
    If ($EdgeShortcut) { 
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }
    $edgescpub = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
    If ($edgescpub) { 
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }
    $vlcsc = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
    If ($vlcsc) { 
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }
    $acrosc = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
    If ($acrosc) { 
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }
    $ctemp = "C:\Temp"
    If ($ctemp) { 
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }

    $mocotheme1 = "$Env:USERPROFILE\win11-light.deskthemepack"
    $mocotheme2 = "$Env:USERPROFILE\win11-dark.deskthemepack"
    $mocotheme3 = "$Env:USERPROFILE\win10-purple.deskthemepack"
    If ($mocotheme1) { 
        Remove-Item "$mocotheme1" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }
    If ($mocotheme2) { 
        Remove-Item $mocotheme2 -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }
    If ($mocotheme3) { 
        Remove-Item $mocotheme3 -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL
    }

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

$RunScript.Add_Click{
Write-Host "$frmt Running Script `n `nGUI will be unusable whilst script is running. Please Standby `n$frmt"
WinG
Programs
StartMenu
Visuals
OEMInfo
OneDrive
Debloat
Registry
Cleanup
Write-Host "`n `n ================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n `n `nRequested Action Completed `n `n `n `n `n `n `n `n `n `n `n `n `n `n `n ================================================================================================ `n `n"
Stop-Transcript
}

$RunNoOEM.Add_Click{
Write-Host "$frmt Running Script without Branding $frmt"
WinG
Programs
StartMenu
OneDrive
Debloat
Registry
Cleanup
Write-Host "`n `n ================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n `n `nRequested Action Completed `n `n `n `n `n `n `n `n `n `n `n `n `n `n `n ================================================================================================ `n `n"
Stop-Transcript
}

$UndoScript.Add_Click{
Write-Host "$frmt Undoing Changes made by Script $frmt "
Start-Sleep 2
UndoOEMInfo
#Write-Host "$frmt Reinstalling Bloatware $frmt"
#UndoDebloat
Write-Host "$frmt Reinstalling OneDrive $frmt"
UndoOneDrive
Write-Host "$frmt Undoing Registry Changes $frmt"
UndoRegistry
Write-Host "`n `n ================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n `n `nScript Actions Undone `n `n `n `n `n `n `n `n `n `n `n `n `n `n `n ================================================================================================ `n `n"
Stop-Transcript
}


$ExitButton.Add_Click{
    $Form.Close()
}
#endregion

[void]$Form.ShowDialog()