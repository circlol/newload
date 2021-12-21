If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	Exit
}$Title = "Windows New Loads Utility - Created by Mike Ivison"
$host.UI.RawUI.WindowTitle = $Title
$Folder = Get-Location
Import-Module BitsTransfer
Function License { 
    net start w32time 2> $NULL
    reg export HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config "$folder\exported_w32time.reg" /y | Out-Null 2> $NULL
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxNegPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null 2> $NUL
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxPosPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null 2> $NUL
    # w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update
    w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update | Out-Null 2> $NUL
    # w32tm /config /update
    w32tm /config /update | Out-Null 2> $NUL
    # w32tm /resync /rediscover 
    w32tm /resync /rediscover | Out-Null 2> $NUL
    #Restore registry w32time\Config
    reg import "$folder\exported_w32time.reg" | Out-Null 2> $NUL
    Remove-Item "$folder\exported_w32time.reg" | Out-Null 2> $NUL
    Clear-Host
    $Time = (Get-Date -UFormat %Y%m%d)
    $License = 20220630
    $Minimum = 20211211
    If ($Time -gt $License) {
        Write-Host License has Expired. Exiting...
        Start-Sleep 2
        Exit
        } else {
            If ($Time -gt $minimum) {
                Clear-Host
                } else {
                    Write-Host License has Expired. Exiting...
                    Start-Sleep 2
                    Exit
                }
            
        }
}
Function WinGInstallation { 
    if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
        'Winget Already Installed'
    }  
    else{
        #Installs winget from the Microsoft Store
        Write-Host "Winget not found, installing it now."
        Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
        $nid = (Get-Process AppInstaller).Id
        Wait-Process -Id $nid
        Write-Host "Winget Installed"
        Start-Sleep 4
        Stop-Process -Name AppInstaller -Force
    }
}
Function Programs {
    If (!(Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe)) { WinGInstallation }
    $packages = @(
    "Google.Chrome"
    "Adobe.Acrobat.Reader.64-bit"
    "VideoLAN.VLC"
    )

foreach ($Package in $Packages) {
    Write-Host "`n `nInstalling $Package `n" 
    winget install $package -e -h -s winget
    Write-Host "`n `n$Package has been Installed `n"
    }

$Location1 = "$env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
$Location2 = "$env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
$Location3 = "$env:PROGRAMFILES\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
Write-Host "`n"
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
    $BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
    $WantedBuild = "10.0.22000"
    If ($BuildNumber -gt $WantedBuild) {
        write-Host "I have detected that you are on Windows 11 `n `nApplying appropriate theme"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/win11-light.deskthemepack" -Destination win11-light.deskthemepack
        #Start-BitsTransfer -Source "https://www40.zippyshare.com/d/ITnX1PTu/920358/win11-light.deskthemepack" -Destination win11-light.deskthemepack
        Start-Sleep 3
        Start-Process "win11-light.deskthemepack"
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            write-Host "I have detected that you are on Windows 10 `n `nApplying appropriate Theme"
            Import-Module BitsTransfer
            Start-BitsTransfer -Source "https://www40.zippyshare.com/d/HIAEBGvh/266967/win10-purple.deskthemepack" -Destination win10-purple.deskthemepack
            Start-Sleep 3
            Start-Process "win10-purple.deskthemepack"
        }
    }

    Write-Host "`nSetting Wallpaper to Stretch `n"
    REG ADD "HKCU\Control Panel\Desktop" /v WallpaperStyle /f /t REG_SZ /d "2"
	Start-Sleep 1
	taskkill /F /IM systemsettings.exe 2> $NULL

    
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
    taskkill /F /IM explorer.exe | Out-Null
}
Function OneDrive {
Write-Host "Disabling OneDrive..."
If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
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
    New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
}
Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
Write-Host "Disabled OneDrive"
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
    
        foreach ($Program in $Programs) {
            Get-AppxPackage -Name $Program| Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online
            Write-Host "Trying to remove $Program."
        }
    
}
Function Registry {
#On Charger
Write-Host "Changing On AC Sleep Settings"
powercfg -change -standby-timeout-ac "30"
powercfg -change -monitor-timeout-ac "15"
#On Battery
Write-Host "Changing On Battery Sleep Settings"
powercfg -change -standby-timeout-dc "15"
powercfg -change -monitor-timeout-dc "10"
start-sleep 1
REG ADD "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_QWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsAADCloudSearchEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08e02B30309D}" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f | Out-Null
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f | Out-Null
REG ADD "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "UxOption" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "0" /f
REG Add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarOpenOnHover" /t REG_DWORD /d "0" /F
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "HideFileExt" /t REG_DWORD /d "0" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "EnableSnapAssistFlyout" /t REG_DWORD /d "1" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v Enabled /f | Out-Null
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "1" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V "ShowTaskViewButton" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /T REG_DWORD /d "0" /f
#Hides Widgets on Taskbar
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskBarDa" /t REG_DWORD /d "0" /f
#Hides Chat/Microsoft Teams on Taskbar
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskBarMn" /t REG_DWORD /d "0" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Manufacturer" /d "Mother Computers" /t REG_SZ /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportHours" /d "Monday - Saturday 9AM-5PM | Sunday - Closed" /t REG_SZ /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportURL" /d "https://www.mothercomputers.com" /t REG_SZ /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "SupportPhone" /d "(250) 479-8561" /t REG_SZ /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /d "Mother Computers - (250) 479-8561" /t REG_SZ /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "0" /f
REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v "DisablePrivacyExperience" /f | Out-Null 2> $NULL
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v "DisablePrivacyExperience" /t REG_DWORD /d "1" /f
REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /f | Out-Null 2> $NULL
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Speech_OneCore" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Speech_OneCore\Settings" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f
REG DELETE "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /f | Out-Null
REG ADD "HKCU\Software\Microsoft\Speech_OneCore" /f
REG ADD "HKCU\Software\Microsoft\Speech_OneCore\Settings" /f
REG ADD "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d "0" /f
REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /f | Out-Null 2> $NULL
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /f | Out-Null 2> $NULL
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Settings\FindMyDevice" /v "LocationSyncEnabled" /f | Out-Null 2> $NULL
REG ADD "HKLM\SOFTWARE\Microsoft\Settings\FindMyDevice" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Settings\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f
REG DELETE "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /f | Out-Null 2> $NULL
REG ADD "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics" /f
REG ADD "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /f
REG ADD "HKEY_USERS\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /f | Out-Null 2> $NULL
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "1" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /f | Out-Null 2> $NULL
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "1" /f
REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Input\TIPC" /v "Enabled" /f | Out-Null 2> $NULL
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Input" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Input\TIPC" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
REG DELETE "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /f | Out-Null 2> $NULL
REG ADD "HKCU\Software\Microsoft\Input" /f
REG ADD "HKCU\Software\Microsoft\Input\TIPC" /f
REG ADD "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f
REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /f | Out-Null 2> $NULL
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Privacy" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /f | Out-Null 2> $NULL
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f
REG DELETE "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /f | Out-Null 2> $NULL
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f
REG ADD "HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /f | Out-Null 2> $NULL
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1 | Out-Null 2> $NULL
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
Write-Host "`n `n ======================================== `n `n Registry Modifications Complete `n `n ======================================== `n `n"
}
Function Titus {

    # Service tweaks to Manual

    $services = @(
     #"BFE"                                          # Disables Base Filtering Engine (BFE) (is a service that manages firewall and Internet Protocol security)
     #"BFE"                                          # Disables Base Filtering Engine (BFE) (is a service that manages firewall and Internet Protocol security)
     "DiagTrack"                                    # Diagnostics Tracking Service
     "DiagTrack"                                    # Diagnostics Tracking Service
     "lmhosts"                                      # Disables TCP/IP NetBIOS Helper
     "gupdate"                                      # Disables google update
     "gupdatem"                                     # Disable another google update
     "WMPNetworkSvc"                                # Windows Media Player Network Sharing Service
     "diagnosticshub.standardcollector.service"     # Microsoft (R) Diagnostics Hub Standard Collector Service
     "DPS"
     "lfsvc"                                        # Geolocation Service
     "MapsBroker"                                   # Downloaded Maps Manager
     "NetTcpPortSharing"                            # Net.Tcp Port Sharing Service
     "RemoteRegistry"                               # Remote Registry
     "TrkWks"                                       # Distributed Link Tracking Client
     "WSearch"                                      # Windows Search
     "XblAuthManager"                               # Xbox Live Auth Manager
     "XblGameSave"                                  # Xbox Live Game Save Service
     "XboxNetApiSvc"                                # Xbox Live Networking Service
     "XboxGipSvc"                                   # Disables Xbox Accessory Management Service
     "ndu"                                          # Windows Network Data Usage Monitor
     "WerSvc"                                       # disables windows error reporting
     "stisvc"                                       # Disables Windows Image Acquisition (WIA)
     "AJRouter"                                     # Disables (needed for AllJoyn Router Service)
     "MSDTC"                                        # Disables Distributed Transaction Coordinator
     "PhoneSvc"                                     # Disables Phone Service(Manages the telephony state on the device)
     "PrintNotify"                                  # Disables Windows printer notifications and extentions
     "PcaSvc"                                       # Disables Program Compatibility Assistant Service
     "WPDBusEnum"                                   # Disables Portable Device Enumerator Service
     "FontCache"                                    # Disables Windows font cache
     "ALG"                                          # Disables Application Layer Gateway Service(Provides support for 3rd party protocol plug-ins for Internet Connection Sharing)
     "BthAvctpSvc"                                   # AVCTP service (This is Audio Video Control Transport Protocol service.)
     "iphlpsvc"                                      # Disables ipv6 but most websites don't use ipv6 they use ipv4
     "edgeupdate"                                    # Disables one of edge update service
     "MicrosoftEdgeElevationService"                 # Disables one of edge  service
     "edgeupdatem"                                   # disbales another one of update service (disables edgeupdatem)
     "PerfHost"                                      # Disables  remote users and 64-bit processes to query performance .
     "BcastDVRUserService_48486de"                   # Disables GameDVR and Broadcast   is used for Game Recordings and Live Broadcasts
     "CaptureService_48486de"                        # Disables ptional screen capture functionality for applications that call the Windows.Graphics.Capture API.
     "cbdhsvc_48486de"                               # Disables   cbdhsvc_48486de (clipboard service it disables)
     "WpnService"                                    # Disables WpnService (Push Notifications may not work )
     "RtkBtManServ"                                  # Disables Realtek Bluetooth Device Manager Service
     #Hp services
     "HPAppHelperCap"
     "HPDiagsCap"
     "HPNetworkCap"
     "HPSysInfoCap"
     "HpTouchpointAnalyticsService"
     
     
     ## Disabled ##
     #"dmwappushservice"                             # WAP Push Message Routing Service (see known issues)
     #"RemoteAccess"                                 # Routing and Remote Access
     #"SharedAccess"                                 # Internet Connection Sharing (ICS)
     #WbioSrvc"                                     # Windows Biometric Service (required for Fingerprint reader / facial detection)
     #"WlanSvc"                                      # WLAN AutoConfig
     #"wscsvc"                                       # Windows Security Center Service
     #"Spooler"                                      # Disables your printer
     #"Fax"                                          # Disables fax
     #"fhsvc"                                        # Disables fax histroy
     #"LicenseManager"                               # Disable LicenseManager(Windows store may not work properly)
     #"seclogon"                                     # Disables  Secondary Logon(disables other credentials only password will work)
     #"wisvc"                                        # Disables Windows Insider program(Windows Insider will not work)
     #"SysMain"                                      # Disables sysmain
     #"RetailDemo"                                   # Disables RetailDemo whic is often used when showing your device
     #"BrokerInfrastructure"                         # Disables Windows infrastructure service that controls which background tasks can run on the system.
     #"SCardSvr"                                     # Disables Windows smart card
     #"EntAppSvc"                                    # Disables enterprise application management.
     #"BDESVC"                                       # Disables bitlocker
     #FrameServer"                                  # Disables Windows Camera Frame Server(this allows multiple clients to access video frames from camera devices.)
     #SEMgrSvc"                                     # Disables Payments and NFC/SE Manager (Manages payments and Near Field Communication (NFC) based secure elements)
     #"PNRPsvc"                                      # Disables peer Name Resolution Protocol ( some peer-to-peer and collaborative applications, such as Remote Assistance, may not function, Discord will still work)
     #"p2psvc"                                       # Disbales Peer Name Resolution Protocol(nables multi-party communication using Peer-to-Peer Grouping.  If disabled, some applications, such as HomeGroup, may not function. Discord will still work)
     #"HvHost"                                       # Disables HyperV
     #"p2pimsvc"                                     # Disables Peer Networking Identity Manager (Peer-to-Peer Grouping services may not function, and some applications, such as HomeGroup and Remote Assistance, may not function correctly.Discord will still work)
     #"BluetoothUserService_48486de"                 # Disbales BluetoothUserService_48486de (The Bluetooth user service supports proper functionality of Bluetooth features relevant to each user session.)
     #"StorSvc"                                      # Disables StorSvc (usb external hard drive will not be reconised by windows)
 
     
     )
 
 foreach ($service in $services) {
     # -ErrorAction SilentlyContinue is so it doesn't write an error to stdout if a service doesn't exist
 
     Write-Host "Setting $service StartupType to Manual"
     Get-Service -Name $service -ErrorAction SilentlyContinue | Set-Service -StartupType Manual
 }
 
}
Function PrivacyProtection {
 #Creates a PSDrive to be able to access the 'HKCR' tree
 New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
     
 #Disables Windows Feedback Experience
 Write-Output "Disabling Windows Feedback Experience program"
 $Advertising = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
 If (Test-Path $Advertising) {
     Set-ItemProperty $Advertising -Name Enabled -Value 0 -Verbose
 }
     
 #Stops Cortana from being used as part of your Windows Search Function
 Write-Output "Stopping Cortana from being used as part of your Windows Search Function"
 $Search = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
 If (Test-Path $Search) {
     Set-ItemProperty $Search -Name AllowCortana -Value 0 -Verbose
 }
     
 #Stops the Windows Feedback Experience from sending anonymous data
 Write-Output "Stopping the Windows Feedback Experience program"
 $Period1 = 'HKCU:\Software\Microsoft\Siuf'
 $Period2 = 'HKCU:\Software\Microsoft\Siuf\Rules'
 $Period3 = 'HKCU:\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds'
 If (!(Test-Path $Period3)) { 
     mkdir $Period1 -ErrorAction SilentlyContinue
     mkdir $Period2 -ErrorAction SilentlyContinue
     mkdir $Period3 -ErrorAction SilentlyContinue
     New-ItemProperty $Period3 -Name PeriodInNanoSeconds -Value 0 -Verbose -ErrorAction SilentlyContinue
 }
            
 Write-Output "Adding Registry key to prevent bloatware apps from returning"
 #Prevents bloatware applications from returning
 $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
 If (!(Test-Path $registryPath)) {
     Mkdir $registryPath -ErrorAction SilentlyContinue
     New-ItemProperty $registryPath -Name DisableWindowsConsumerFeatures -Value 1 -Verbose -ErrorAction SilentlyContinue
 }          
 
 Write-Output "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
 $Holo = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic'    
 If (Test-Path $Holo) {
     Set-ItemProperty $Holo -Name FirstRunSucceeded -Value 0 -Verbose
 }
 
 #Disables live tiles
 Write-Output "Disabling live tiles"
 $Live = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'    
 If (!(Test-Path $Live)) {
     mkdir $Live -ErrorAction SilentlyContinue     
     New-ItemProperty $Live -Name NoTileApplicationNotification -Value 1 -Verbose
 }
 
 #Turns off Data Collection via the AllowTelemtry key by changing it to 0
 Write-Output "Turning off Data Collection"
 $DataCollection = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'    
 If (Test-Path $DataCollection) {
     Set-ItemProperty $DataCollection -Name AllowTelemetry -Value 0 -Verbose
 }
 
 #Disables People icon on Taskbar
 Write-Output "Disabling People icon on Taskbar"
 $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
 If (Test-Path $People) {
     Set-ItemProperty $People -Name PeopleBand -Value 0 -Verbose
 }

 #Disables suggestions on start menu
 Write-Output "Disabling suggestions on the Start Menu"
 $Suggestions = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'    
 If (Test-Path $Suggestions) {
     Set-ItemProperty $Suggestions -Name SystemPaneSuggestionsEnabled -Value 0 -Verbose
 }
 
 
  Write-Output "Removing CloudStore from registry if it exists"
  $CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
  If (Test-Path $CloudStore) {
  Stop-Process -Name explorer -Force 2> $NULL
  Remove-Item $CloudStore -Recurse -Force
  Start-Process Explorer.exe -Wait
 }

 #Loads the registry keys/values below into the NTUSER.DAT file which prevents the apps from redownloading. Credit to a60wattfish
 reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
 Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
 Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
 Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
 reg unload HKU\Default_User
 
 #Disables scheduled tasks that are considered unnecessary 
 Write-Output "Disabling scheduled tasks"
 #Get-ScheduledTask -TaskName XblGameSaveTaskLogon | Disable-ScheduledTask -ErrorAction SilentlyContinue
 Get-ScheduledTask -TaskName XblGameSaveTask | Disable-ScheduledTask -ErrorAction SilentlyContinue
 Get-ScheduledTask -TaskName Consolidator | Disable-ScheduledTask -ErrorAction SilentlyContinue
 Get-ScheduledTask -TaskName UsbCeip | Disable-ScheduledTask -ErrorAction SilentlyContinue
 Get-ScheduledTask -TaskName DmClient | Disable-ScheduledTask -ErrorAction SilentlyContinue
 Get-ScheduledTask -TaskName DmClientOnScenarioDownload | Disable-ScheduledTask -ErrorAction SilentlyContinue
}
Function KeyRemoval {

    $Keys = @(
        #Converted From Registry.PS1
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView\Enabled"
        "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions"
        "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps"

        #Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        
        #Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        
        #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        
        #Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        
        #Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
           
        #Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )
    
    #This writes the output of each key it is removing and also removes the keys listed above.
    ForEach ($key in $Keys) {
        Write-Output "Removing $Key from registry"
        Remove-Item $Key -Recurse -ErrorAction SilentlyContinue
    }
}

Function FixApps {
    
    If(!(Get-AppxPackage -AllUsers | Select-Object Microsoft.Paint3D, Microsoft.MSPaint, Microsoft.WindowsCalculator, Microsoft.WindowsStore, Microsoft.MicrosoftStickyNotes, Microsoft.WindowsSoundRecorder, Microsoft.Windows.Photos)) {
    
    #Credit to abulgatz for the 4 lines of code
    Get-AppxPackage -allusers Microsoft.Paint3D | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
    Get-AppxPackage -allusers Microsoft.MSPaint | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
    Get-AppxPackage -allusers Microsoft.WindowsCalculator | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
    Get-AppxPackage -allusers Microsoft.WindowsStore | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
    Get-AppxPackage -allusers Microsoft.MicrosoftStickyNotes | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
    Get-AppxPackage -allusers Microsoft.WindowsSoundRecorder | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
    Get-AppxPackage -allusers Microsoft.Windows.Photos | ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"} }
}

Function CheckDMWService {
    
    If (Get-Service -Name dmwappushservice | Where-Object {$_.StartType -eq "Disabled"}) {
        Set-Service -Name dmwappushservice -StartupType Automatic}
    
    If(Get-Service -Name dmwappushservice | Where-Object {$_.Status -eq "Stopped"}) {
       Start-Service -Name dmwappushservice
    } 
}
Function Cleanup { 

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
}

#Powershell -ExecutionPolicy RemoteSigned -WindowStyle Maximized -NonInteractive -Command "exit"
License
Write-Host "`n ================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n Fresh Loads Utility For Windows 10 & 11 `n `n Created by Mike Ivison `n `n `n `n Ideally run updates before this script. `n `n `n `n `n `n `n `n `n `n `n `n `n ================================================================================================ `n `n"
Start-Transcript -OutputDirectory "$Folder" > $NULL
Write-Host "`n `n ======================================== `n `n Checking for WinGet `n `n ======================================== `n `n"                                    
WinGInstallation 
Write-Host "`n `n ======================================== `n `n Installing Apps `n Please be patient as the programs install in the background. `n `n ============================================================= `n `n"
Start-Sleep 5
Programs
Write-Host "`n `n ======================================== `n `n Applying Visual Tweaks `n `n ======================================== `n `n"
Visuals
Write-Host "`n `n ======================================== `n `n Removing OneDrive `n `n ======================================== `n `n"
OneDrive
Write-Host "`n `n ======================================== `n `n Removing Bloatware from PC `n `n ======================================== `n `n"
Debloat
Write-Host "`n `n ======================================== `n `n Applying Registry Changes `n `n ======================================== `n `n"
Registry
KeyRemoval 
Write-Host "`n `n ======================================== `n `n Applying Privacy Changes `n `n ======================================== `n `n"
PrivacyProtection
Titus
Write-Host "`n `n ======================================== `n `n Looking for Broken AppxPackages `n `n ======================================== `n `n"
FixApps
CheckDMWService
Cleanup
Stop-Transcript
Write-Host "`n `n ================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n `n `n Script Completed `n `n `n `n `n `n `n `n `n `n `n `n `n `n `n ================================================================================================ `n `n"
Start-Sleep 5
Exit