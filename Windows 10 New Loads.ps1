#If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
#	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
	#Exit
#}
$Title = "Windows New Loads Utility Automated - Created by Mike Ivison"
$host.UI.RawUI.WindowTitle = $Title
Import-Module BitsTransfer
$Folder = Get-Location

Function WinGInstallation { 
    if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
        Write-Host " Winget was found"
    }  
    else{
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
Write-Host "`n"
#If (!(Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe)) { WinGInstallation }
#    $packages = @(
#    "Google.Chrome"
#    "Adobe.Acrobat.Reader.64-bit"
#    "VideoLAN.VLC"
#    )

#foreach ($Package in $Packages) {
#    Write-Host "`n `nInstalling $Package `n" 
#    winget install $package -e -h -s winget
#    Write-Host "`n `n$Package has been Installed"
#    }

$package1  = "Google.Chrome"
$package2  = "Adobe.Acrobat.Reader.64-bit"
$package3  = "VideoLAN.VLC"
$Location1 = "$env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
$Location2 = "$env:PROGRAMFILES\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
$Location3 = "$env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
If (!(Test-Path $Location1)) {
    Write-Host "`n `n Installing $Package1 `n" 
    winget install $package1 -s winget -e -h
    } else {
    Write-Host " Verified $package1 is already Installed. Moving on."
    }
If (!(Test-Path $Location2)) {
    Write-Host "`n `n Installing $Package2 `n" 
    winget install $package2 -s winget -e -h
    } else {
    Write-Host " Verified $package2 is already Installed. Moving on."
    }    
If (!(Test-Path $Location3)) {
    Write-Host "`n `n Installing $Package3 `n" 
    winget install $package3 -s winget -e -h
    } else {
    Write-Host " Verified $package3 is already Installed."
    }
}            
Function Visuals {
    $BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
    $WantedBuild = "10.0.22000"
    If ($BuildNumber -gt $WantedBuild) {
        write-Host "I have detected that you are on Windows 11 `n `nApplying appropriate theme"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/win11-light.deskthemepack" -Destination "$env:temp\win11-light.deskthemepack"
        #Start-BitsTransfer -Source "https://www40.zippyshare.com/d/ITnX1PTu/920358/win11-light.deskthemepack" -Destination win11-light.deskthemepack
        Start-Sleep 3
        Start-Process "$env:temp\win11-light.deskthemepack"
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            write-Host "I have detected that you are on Windows 10 `n `nApplying appropriate Theme"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/win10-purple.deskthemepack" -Destination "$env:temp\win10-purple.deskthemepack"
            Start-Sleep 3
            Start-Process "$env:temp\win10-purple.deskthemepack"
        }
    }

    Write-Host "`n Setting Wallpaper to Stretch `n"
}
Function StartMenu {
    Write-host "$frmt Applying Start Menu & Pinning Taskbar Layout $frmt"
    REG ADD "HKCU\Control Panel\Desktop" /v WallpaperStyle /f /t REG_SZ /d "2"
	Start-Sleep 1
	taskkill /F /IM systemsettings.exe 2> $NULL
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
    Write-Host " Restarting Explorer Service"
    Stop-Process -name explorer -force | Out-Null
    Start-Sleep -s 5
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 5
    Write-Host " Locking Start Menu Layout"
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
    }
    Write-Host " Clearing Pinned Start Icons"
    Stop-Process -name explorer -force | Out-Null
    Write-Host " Applying Taskbar Icons"
    Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
    Write-Host " Applied Taskbar Icons"
    Write-Host " Removing layout.xml files "
    Remove-Item $layoutFile
    taskkill /F /IM explorer.exe | Out-Null
}
Function OneDrive {
    Write-Host " Disabling OneDrive..."
    If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
    Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    Write-Host " Uninstalling OneDrive..."
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
    Write-Host " Disabled OneDrive"

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
            Get-AppxPackage -Name $Program | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online| Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online
            Write-Host " Attempting removal of $Program."
        }
    
}
Function Registry {
    Write-Host "$frmt Applying Registry Changes $frmt"
    #On Charger
    Write-Host " Changing On AC Sleep Settings"
    powercfg -change -standby-timeout-ac "30"
    powercfg -change -monitor-timeout-ac "15"
    #On Battery
    Write-Host " Changing On Battery Sleep Settings"
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"
    start-sleep 1
    
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f 2> $NULL
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f 2> $NULL
    REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MultiTaskingView\AllUpView" /v Enabled /f 2> $NULL
    REG ADD "HKCU\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f 2> $NULL
    REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f 2> $NULL
    REG ADD "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_QWORD /d "0" /f 2> $NULL
    REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /T REG_DWORD /d "0" /f 2> $NULL
    REG ADD "HKLM\Software\Microsoft\WindowsUpdate\UX\Settings" /v "UxOption" /t REG_DWORD /d "1" /f 2> $NULL
    REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" /v "MinimizedStateTabletModeOff" /t REG_DWORD /d "0" /f 2> $NULL
    REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d "0" /f 2> $NULL
    REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "1" /f 2> $NULL
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V "ShowTaskViewButton" /t REG_DWORD /d "0" /f 2> $NULL
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f 2> $NULL
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f 2> $NULL
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f 2> $NULL
    
    #Explorer Related Settings    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "EnableSnapAssistFlyout" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Value 0     -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarDa" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarMn" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08e02B30309D}" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Verbose
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 -Verbose
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 1 -Verbose
    
    
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Type String -Value "Mother Computers"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportPhone" -Type String -Value "(250) 479-8561" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportHours" -Type String -Value "Monday - Saturday 9AM-5PM | Sunday - Closed" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Type String -Value "https://www.mothercomputers.com" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Model" -Type String -Value "Mother Computers - (250) 479-8561"
    Write-Host " `n Applying Special Sauce `n"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0 
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Type DWord -Value 0 
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
    
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 0 
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1 
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1 
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 0 
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsMSACloudSearchEnabled" -Value 0 
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsAADCloudSearchEnabled" -Value 0 
    
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
    

    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1 
        

    Write-Host "$frmt Registry Modifications Complete $frmt"
} 
Function checkme { 
    net start w32time | Out-Null
    reg export HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config "$folder\exported_w32time.reg" /f | Out-Null
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxNegPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null
    reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\w32time\Config /v MaxPosPhaseCorrection /d 0xFFFFFFFF /t REG_DWORD /f | Out-Null
    # w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update
    w32tm /config /manualpeerlist:time.windows.com,0x1 /syncfromflags:manual /reliable:yes /update | Out-Null
    # w32tm /config /update
    w32tm /config /update | Out-Null
    # w32tm /resync /rediscover 
    w32tm /resync /rediscover | Out-Null
    #Restore registry w32time\Config
    reg import "$folder\exported_w32time.reg" | Out-Null
    Remove-Item "$folder\exported_w32time.reg" | Out-Null
    $Lie = " License has Expired. Exiting.."
    $Time = (Get-Date -UFormat %Y%m%d)
    $License = 20220330
    If ($Time -gt $License) {
        Write-Host $lie
        Start-Sleep 2
        Clear-Host
        Exit
        }
}
Function Cleanup {
    Write-Host "$frmt Finishing Up $frmt"
    Write-Host " Explorer Restarted"
    Start-Process Explorer

    Start-Process https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm

    Remove-Item "$Env:Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2> $NULL
    $EdgeShortcut = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
    If ($EdgeShortcut) { 
        Write-Host " Removing Edge Icon"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2> $NULL
    }
    $edgescpub = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
    If ($edgescpub) { 
        Write-Host " Removing Edge Icon"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2> $NULL
    }
    $vlcsc = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
    If ($vlcsc) { 
        Write-Host " Removing VLC Media Player Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2> $NULL
    }
    $acrosc = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
    If ($acrosc) { 
        Write-Host " Removing Adobe Acrobat Icon"
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2> $NULL
    }
    $ctemp = "C:\Temp"
    If ($ctemp) { 
        Write-Host " Removing temp folder in C Root"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2> $NULL
    }

    $mocotheme1 = "$Env:USERPROFILE\desktop\win11-light.deskthemepack"
    $mocotheme2 = "$Env:USERPROFILE\desktop\win11-dark.deskthemepack"
    $mocotheme3 = "$Env:USERPROFILE\desktop\win10-purple.deskthemepack"
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

checkme
clear-host
Start-Transcript -OutputDirectory "$env:USERPROFILE\Desktop" > $NULL
Write-Host "`n `n `n `n `n `n `n `n `n `n `n `n `n `n================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n New Loads Utility For Windows 10 & 11 `n `n Created by Mike Ivison `n `n Script will run in : Automatic Mode`n `n Ideally run updates before continuing with this script. `n `n `n `n `n `n `n `n `n `n `n `n `n================================================================================================ `n `n"
Start-Sleep 5
WinGInstallation 
Write-Host "`n `n======================================== `n `n Installing Apps `n Please be patient as the programs install in the background. `n `n============================================================= `n `n"
Programs
Write-Host "`n `n======================================== `n `n Applying Visual Tweaks `n `n======================================== `n `n"
Visuals
Write-Host "`n `n======================================== `n `n Removing Bloatware from PC `n `n======================================== `n `n"
Debloat
OneDrive
Write-Host "`n `n======================================== `n `n Applying Registry Changes `n `n======================================== `n `n"
Registry
Write-Host "`n `n======================================== `n `n Finishing Up `n `n======================================== `n `n"
Cleanup
Stop-Transcript
Write-Host "`n `n ================================================================================================ `n `n `n `n `n `n `n `n `n `n `n `n `n `n `n Script Completed `n `n `n `n `n `n `n `n `n `n `n `n `n `n `n ================================================================================================ `n `n"
Start-Sleep 5
Exit