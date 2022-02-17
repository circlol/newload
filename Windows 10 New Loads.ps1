Import-Module BitsTransfer
$health = 35
#$Folder = Get-Location
$dtime = (Get-Date -UFormat %H.%M-%Y.%m.%d)
$programversion = "22.10.00"
Function Programs {
Write-Host "`n"
$package1  = "Google.Chrome"
$package2  = "Adobe.Acrobat.Reader.64-bit"
$package3  = "VideoLAN.VLC"
$Location1 = "$env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
$Location2 = "$env:PROGRAMFILES\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
$Location3 = "$env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
If (!(Test-Path $Location1)) {
    	Write-Host "`n `n Installing $Package1 `n" 
    	winget install $package1 -s winget -e -h
    	
	### Create an ittt for each extension ###
	Write-Host " Adding Extension Flag for UBlock Origin"
	REG ADD "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
	Write-Host " Adding Extension Flag for Microsoft Defender Browser Protection"
	REG ADD "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Google\Chrome\Extensions\bkbeeeffjjeopflfhgeknacdieedcoml" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
    
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
    Write-Host "Checking your OS.."
    If (!((Get-Process -name explorer).Id)){
        Start-Process explorer
        write-host "Explorer Started"
        } else {
        Write-Host Explorer is running}
    Start-Sleep -s 2
    If ($BuildNumber -gt $WantedBuild) {
        write-Host "I have detected that you are on Windows 11 `n `nApplying Appropriate Theme & Flagging Required Settings"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/win11-light.deskthemepack" -Destination "$env:temp\win11-light.deskthemepack"
        #Start-BitsTransfer -Source "https://www40.zippyshare.com/d/ITnX1PTu/920358/win11-light.deskthemepack" -Destination win11-light.deskthemepack
        Start-Process "$env:temp\win11-light.deskthemepack"
        Start-Sleep -s 3
        taskkill /F /IM systemsettings.exe 2>$NULL
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            write-Host "I have detected that you are on Windows 10 `n `nApplying Appropriate Theme & Flagging Required Settings"
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
    If (!((Get-Process -name explorer).Id)){
        Start-Process explorer
        write-host "Explorer Started"
        } else {
            Stop-Process -name explorer -force
        }
    Stop-Process -name explorer -force | Out-Null 2>$NULL
    Start-Sleep -s 3
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 3
    Write-Host " Locking Start Menu Layout"
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
Function OneDrive {
    Write-Host " Stopping OneDrive"
    Stop-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 500
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
        
        $BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
        $WantedBuild = "10.0.22000"
        If ($BuildNumber -lt $WantedBuild) {
            Write-Host " Applying Windows 10 Specific Registry Keys `n"
            Start-Sleep 1
            Write-Host " Unpinning Cortana Icon on Taskbar"
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" -Value 0
            Write-Host " Unpinning TaskView Icon from Taskbar"
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
            Write-Host " Changing Searchbox to Icon Format on Taskbar"
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 1
            
        }
        #11 Specific
        if ($BuildNumber -gt $WantedBuild) {
            Write-Host " Applying Windows 11 Specific Registry Keys `n"
            #Write-Host " Unpinning Widgets and Teams from taskbar"
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
            #Taskbarda is Widgets - Currently Widgets shows temperature bottom left
            #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarDa" -Value 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarMn" -Value 0
            Start-Sleep 10
        } 
    Write-Host " Changing how often Windows asks for feedback to never"
    If (!(Test-Path "HKCU:\Software\Microsoft\Siuf")) { 
        New-Item -Path "HKCU:\Software\Microsoft" -Name "Siuf"
    }

    Write-Host "Setting Sounds > Communications to 'Do Nothing'"
    Set-ItemProperty "HKCU:\Software\Microsoft\MultiMedia\Audio" -Name "UserDuckingPreference" -Value 3 -Type DWord

    If (!(Test-Path "HKCU:\Software\Microsoft\Siuf\Rules")) {
    New-Item -Path "HKCU:\Software\Microsoft\Siuf" -Name "Rules"
    }
    Set-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0 2>$NULL
    Set-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Type QWORD -Value 0 2>$NULL

    Write-Host " Setting Windows Updates to Check for updates but let me choose whether to download and install them"
    Set-ItemProperty "HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings" -Name UxOption -Type DWORD -Value 2 2>$NULL
   
    Write-Host " Disabling Windows Feedback Notifications"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1 
    
    
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
    Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -Name "DisableMFUTracking" -Value 1 -Type DWord

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
Function Cleanup {
    Write-Host "$frmt Finishing Up$frmt"
    Write-Host " Restarting Explorer"
    Start-Sleep -s 1
    Start-Process Explorer
    #On Charger
    Write-Host " Changing On AC Sleep Settings"
    powercfg -change -standby-timeout-ac "30"
    powercfg -change -monitor-timeout-ac "15"        
    #On Battery
    Write-Host " Changing On Battery Sleep Settings"
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"
    Write-Host " Launching Chrome, Please accept UBlock Origin extension popup"
    Start-Sleep -Milliseconds 400
    Start-Process Chrome -ErrorAction SilentlyContinue
    Remove-Item "$Env:Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    $EdgeShortcut = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
    If ($EdgeShortcut) { 
        Write-Host " Removing Edge Icon"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    $edgescpub = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
    If ($edgescpub) { 
        Write-Host " Removing Edge Icon"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    $vlcsc = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
    If ($vlcsc) { 
        Write-Host " Removing VLC Media Player Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    $acrosc = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
    If ($acrosc) { 
        Write-Host " Removing Adobe Acrobat Icon"
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    $ctemp = "C:\Temp"
    If ($ctemp) { 
        Write-Host " Removing temp folder in C Root"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    
    $mocotheme1 = "$Env:USERPROFILE\desktop\win11-light.deskthemepack"
    $mocotheme2 = "$Env:USERPROFILE\desktop\win11-dark.deskthemepack"
    $mocotheme3 = "$Env:USERPROFILE\desktop\win10-purple.deskthemepack"
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
If(!(Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe)){
    $health = "ERROR: WINGET NOT INSTALLED - $health"
} else {
    $health = $health+=45
}
Start-Transcript -LiteralPath "$env:USERPROFILE\Desktop\Automated Script Run - $dtime.txt"
$health = $health+=20
Write-Host "`n `n================================================================================================ `n `n `n New Loads`n Script Version : $programversion`n `n Script Integrity: $Health%`n Ideally run updates before continuing with this script. `n `n `n `n================================================================================================ `n `n"
#Start-Sleep -s 5
#WinGInstallation 
Write-Host "`n `n======================================== `n `n Installing Apps `n Please be patient as the programs install in the background. `n `n============================================================= `n `n"
Programs
StartMenu
Write-Host "`n `n======================================== `n `n Applying Registry Changes `n `n======================================== `n `n"
Registry
OneDrive
Write-Host "`n `n======================================== `n `n Removing Bloatware from PC `n `n======================================== `n `n"
Debloat
Write-Host "`n `n======================================== `n `n Applying Visual Tweaks `n `n======================================== `n `n"
Visuals
Write-Host "`n `n======================================== `n `n Finishing Up `n `n======================================== `n `n"
Cleanup
Stop-Transcript
Write-Host "Script Completed.`nExiting."
Exit