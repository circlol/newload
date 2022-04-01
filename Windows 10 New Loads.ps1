Write-Host "Initializing Script"
#requires -runasadministrator

$oi = ".\Offline Installers\"
$gcoi = $oi + "googlechromestandaloneenterprise64.msi"
$aroi = $oi + "AcroRdrDCx642200120085_MUI.exe"
$vlcoi = $oi + "vlc-3.0.17-win64.msi"

$package1  = "Google.Chrome"
$package2  = "VideoLAN.VLC"
$package3  = "Adobe.Acrobat.Reader.64-bit"

$package1dl = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$package2dl = "https://github.com/circlol/newload/raw/main/Assets/BAF/vlc-3.0.17-win64.msi"
$package3dl = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2200120085/AcroRdrDCx642200120085_MUI.exe"

$package1lc = "$env:temp\googlechromestandaloneenterprise64.msi"
$package2lc = "$env:temp\vlc-3.0.17-win64.msi"
$package3lc = "$env:temp\AcroRdrDCx642200120085_MUI.exe"

$Location1 = "$env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
$Location2 = "$env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
$Location3 = "$env:PROGRAMFILES\Adobe\Acrobat DC\Acrobat\Acrobat.exe"

$programversion = "22331.2120"
$reason = "OK"
$BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
$dtime = (Get-Date -UFormat %H.%M-%Y.%m.%d)
$WantedBuild = "10.0.22000"
$frmt = "`n `n======================================== `n `n"
$onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
$EdgeShortcut = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
$acrosc = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
$edgescpub = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
$vlcsc = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
$ctemp = "C:\Temp"
$mocotheme1 = "$Env:USERPROFILE\desktop\win11-light.deskthemepack"
$mocotheme2 = "$Env:USERPROFILE\desktop\win11-dark.deskthemepack"
$mocotheme3 = "$Env:USERPROFILE\desktop\win10-purple.deskthemepack"
$CustomTheme = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\Mother Co\Mother Co.Theme"
$CurrentTheme = (Get-ItemProperty -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\ -Name "CurrentTheme").CurrentTheme


If (!(Get-Module -ListAvailable -Name BitsTransfer)){
    Write-Host " Importing BitsTransfer"
    Import-Module BitsTransfer
    Start-Sleep -s 2
    If (!(Get-Module -ListAvailable -Name BitsTransfer)){
        Write-Host " For some reason one of the modules wasn't found. Trying again."
        Import-Module BitsTransfer -Verbose
        Start-Sleep -s 2
        If (!(Get-Module -ListAvailable -Name BitsTransfer)){
            $reason = "$reason - BitsTransfer Module NOT Found"
        } 
    }
}
Function Programs {
    Write-Host "$frmt Installing Apps`n Please be patient as the programs may take a while.$frmt"

    #Google
    If (!(Test-Path $Location1)){
        If (Test-Path $gcoi){
            Write-Host " Found Offline Installer : Google Chrome"
            Write-Host " Starting Offline Installer : Google Chrome"
            Start-Process $gcoi /passive -Wait
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
        } else {
            Write-Host "`n`n Downloading $Package1" 
            Start-BitsTransfer -Source $package1dl -Destination $package1lc
            Write-Host " Installing $Package1`n"
            Start-Process $package1lc /passive -Wait
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
        }

    } else {
            Write-Host "`n Verified $package1 is already Installed. Moving On. "
    }

    #VLC
    If (!(Test-Path $Location2)) {
        If (Test-Path $vlcoi){
            Write-Host " Found Offline Installer : VLC Media Player"
            Write-Host " Starting Offline Installer : VLC Media Player"
            Start-Process $vlcoi /quiet
        } else {
            Write-Host "`n`n Downloading $Package2" 
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc
            Write-Host " Installing $Package2 in the background`n" 
            Start-Process $package2lc /quiet
       
        }
    } else {
            Write-Host "`n Verified $package2 is already installed. Skipping"
    }

    #Adobe
    If (!(Test-Path $Location3)) {
        If (Test-Path $aroi){
            Write-Host " Found Offline Installer : Adobe Acrobat"
            Write-Host " Starting Offline Installer : Adobe Acrobat"
            Start-Process $aroi /sPB -Wait
        } else {
            Write-Host "`n`n Downloading $Package3" 
            Start-BitsTransfer -Source $Package3dl -Destination $package3lc
            Write-Host " Installing $Package3`n" 
            Start-Process $package3lc /sPB -Wait
            Write-Host " $package3 Installed."
        }    
    
    } else {
            Write-Host "`n Verified $package3 is already installed.`n Moving on`n`n"
        } 
}
Function Visuals {
    If (!((Get-Process -Name explorer -ErrorAction SilentlyContinue).Id)){
    Write-Host " Explorer not found."
    Start-Process explorer -Verbose 
    Write-host " Explorer Started"
    }
    Write-Host " Checking your OS.."

If (!($CurrentTheme -eq $CustomTheme)){
    Write-Host " Visuals will need to be applied"

    If ($BuildNumber -gt $WantedBuild) {
        Write-Host " I have detected that you are on Windows 11 `n `n Applying Appropriate Theme & Flagging Required Settings"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/Mother%20Computers%20Win11.deskthemepack" -Destination "$env:temp\Mother Computers Win11.deskthemepack"
        Start-Process "$env:temp\Mother Computers Win11.deskthemepack" -Wait
        Start-Sleep -s 3
        taskkill /F /IM systemsettings.exe 2>$NULL
        } else {

            If ($BuildNumber -lt $WantedBuild) {
                Write-Host " I have detected that you are on Windows 10 `n `n Applying Appropriate Theme & Flagging Required Settings"
                Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/Mother%20Computers%20Win10.deskthemepack" -Destination "$env:temp\Mother Computers Win10.deskthemepack"
                Start-Process "$env:temp\Mother Computers Win10.deskthemepack" -Wait
                Start-Sleep -s 4
                Taskkill /F /IM systemsettings.exe 2>$NULL
            }
        }

    Write-Host "`n Setting Wallpaper to Stretch `n"
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Type String -Value 2 -ErrorAction SilentlyContinue
    Stop-Process -Name Explorer -Verbose -Erroraction SilentlyContinue
    } else {
        Write-Host " Visuals have already been applied. Skipping"
    }
}

Function StartMenu {
    Write-host "$frmt Pinning Apps to taskbar , Clearing Start Menu Pins. $frmt"

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
            <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer"/>
            <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
            <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
            <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
            <taskbar:DesktopApp DesktopApplicationID="Chrome" />
            </taskbar:TaskbarPinList>
        </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@

$layoutFile="C:\Windows\StartMenuLayout.xml"

#Delete layout file if it already exists
If(Test-Path $layoutFile)
{
    Remove-Item $layoutFile
}

#Creates the blank layout file
$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

$regAliases = @("HKLM", "HKCU")

#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    IF(!(Test-Path -Path $keyPath)) { 
        New-Item -Path $basePath -Name "Explorer"
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
}


#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
If (!(Get-Process Explorer)){
    Start-Process Explorer
} else {
    Stop-Process -Name Explorer -ErrorAction SilentlyContinue
    Start-SLeep -s 3
    Start-Process Explorer
}
Start-Sleep -s 5
$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
Start-Sleep -s 5

#Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}

#Restart Explorer and delete the layout file
Stop-Process -name explorer 

# Uncomment the next line to make clean start menu default for all new users
#Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

Remove-Item $layoutFile -Verbose
}

Function OneDrive {
    Write-Host " Stopping OneDrive"
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
}
Function Debloat {
    Write-Host "$frmt Removing Bloatware $frmt "
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

    # non-Microsoft All Machines
    "Disney.37853FC22B2CE"
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
    "613EBCEA.PolarrPhotoEditorAcademicEdition"
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
    "ClearChannelRadioDigital.iHeartRadio"
    "CyberLinkCorp.ac.PowerDirectorforacerDesktop"
    "CyberLinkCorp.ac.PhotoDirectorforacerDesktop"
    "CAF9E577.Plex"  
    "D52A8D61.FarmVille2CountryEscape"
    "DB6EA5DB.CyberLinkMediaSuiteEssentials"
    "Drawboard.DrawboardPDF"
    "E0469640.LenovoUtility"
    "Evernote.Evernote"
    "FACEBOOK.*"
    "FACEBOOK.317180B0BB486"
    "Fitbit.FitbitCoach"
    "flaregamesGmbH.RoyalRevolt2"
    "*Flipboard*"
    "GAMELOFTSA.Asphalt8Airborne"
    "KeeperSecurityInc.Keeper"
    "MirametrixInc.GlancebyMirametrix"
    "NAVER.LINEwin8"
    "NORDCURRENT.COOKINGFEVER"
    "Playtika.CaesarsSlotsFreeCasino"
    "ShazamEntertainmentLtd.Shazam"
    "SlingTVLLC.SlingTV"
    "ThumbmunkeysLtd.PhototasticCollage"
    "TuneIn.TuneInRadio"
    "WikimediaFoundation.Wikipedia"
    "WinZipComputing.WinZipUniversal"
    "XINGAG.XING"
    
    "*ActiproSoftwareLLC*"
    "*ACGMediaPlayer*"
    "*AdobePhotoshopExpress*"
    "*BubbleWitch3Saga*"
    "*CandyCrush*"
    "*Duolingo-LearnLanguagesforFree*"
    "*EclipseManager*"
    "*Hulu*"
    "*HiddenCity*"
    "*HiddenCityMysteryofShadows*"
    "*OneCalendar*"
    "*PandoraMediaInc*"
    "*Royal Revolt*"
    "*Sway*"
    "*Speed Test*"
    "*TikTok*"
    "*Twitter*"
    "*Viber*"
    "*Wunderlist*"
    )

        foreach ($Program in $Programs) {
            Get-AppxPackage -Name $Program | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online| Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online
            Write-Host " Attempting removal of $Program."   
        }
    
    }

Function Registry {
    Write-Host "$frmt Applying Registry Changes $frmt"

    If ($BuildNumber -lt $WantedBuild) {
        Write-Host " Applying Windows 10 Specific Registry Keys `n"
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
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0
        #Taskbarda is Widgets - Currently Widgets shows temperature bottom left
        #Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarDa" -Value 0
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskBarMn" -Value 0
    }

    Write-Host " Changing how often Windows asks for feedback to never"
    If (!(Test-Path "HKCU:\Software\Microsoft\Siuf")) { 
        New-Item -Path "HKCU:\Software\Microsoft" -Name "Siuf"
    }

    If (!(Test-Path "HKCU:\Software\Microsoft\Siuf\Rules")) {
    New-Item -Path "HKCU:\Software\Microsoft\Siuf" -Name "Rules"
    }
    Set-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0
    Set-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Type QWORD -Value 0

    Write-Host " Setting Windows Updates to Check for updates but let me choose whether to download and install them"
    Set-ItemProperty "HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings" -Name UxOption -Type DWORD -Value 2
    
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
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon" -Name "MinimizedStateTabletModeOff" -Value 1


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
    Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -Name DisableMFUTracking -Value 1 -Type DWord

    Write-Host " Disabling Advertiser ID"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name DisabledByGroupPolicy -Value 1 -Type DWord
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name Enabled -Value 0 -Type DWord

    Write-Host "$frmt Registry changes applied $frmt"
}


Function Cleanup {

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

    If ($perform_apps.checked -eq $true){
        Start-Process Chrome
        If (Test-Path $vlcsc) { 
            Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
        }
        If (Test-Path $acrosc) { 
            Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
        }
    }
    Remove-Item "$Env:Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    If (Test-Path $EdgeShortcut) { 
        #Write-Host " Removing Edge Icon"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $edgescpub) { 
        Write-Host " Removing Edge Icon in Public"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }

    If (Test-Path $ctemp) { 
        Write-Host " Removing temp folder in C Root"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $mocotheme1) { 
        Remove-Item "$mocotheme1" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $mocotheme2) { 
        Remove-Item "$mocotheme2" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $mocotheme3) { 
        Remove-Item "$mocotheme3" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
}

Start-Transcript -LiteralPath "$env:USERPROFILE\Desktop\Automated Script Run - $dtime.txt"
Start-Sleep -s 2
$health = 100

$wantedreason = "OK"
If ($reason -eq $wantedreason){
    Write-Host "`n`n================================================================================================`n`n"
    Write-Host " New Loads`n" -ForegroundColor Cyan
    Write-Host " Script Version : $programversion"
    Write-Host " Script Intregity: $Health%`n"
    Write-Host " Ideally run updates before continuing with this script." -ForegroundColor Red
    Write-Host "`n`n================================================================================================`n`n`n"
} else {
    $health = $health - 30
    Write-Host "`n`n================================================================================================`n`n"
    Write-Host " New Loads`n" -ForegroundColor Cyan
    Write-Host " Script Version : $programversion"
    Write-Host " Script Intregity: $Health%`n`n"
    Write-Host " Error Message: $reason`n`n" -ForegroundColor DarkRed
    Write-Host " Ideally run updates before continuing with this script." -ForegroundColor Red
    Write-Host "`n`n================================================================================================`n`n`n"
}



Programs
Visuals
StartMenu
Registry
OneDrive
Debloat
Write-Host "$frmt Finishing Up $frmt"
Cleanup
Stop-Transcript
Write-Host "Script Completed.`nExiting."
Start-Sleep -s 3
Exit
# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDDiE/zI422alNi5vza8UnVmv
# FBmgggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFMe5syH+pQrA
# M0b97qKaLBRQIvKhMA0GCSqGSIb3DQEBAQUABIIBADyjqk4XHkzEUyiIzM7+E4QI
# 65zpvUQuxdPtrbDu+lEBSSJcrVnPeFLuBLPOF1gEgoOvrihk7oqeElsaTyIPyMPQ
# pFEwbKLU1EWYAlyhCnnKS6F//fD8M+E7scZqj/9UOIAxM4WN07STs0f1MzxtAeY2
# a/0g4idx74CYhuAE8p9I0bBNmJ7l+22T1RUExcqEeT3UB2hei6ZyWMvujp4vq5tC
# VYl/IPfmbCsZpAr2U7JYgsg29z+B7yc39NBZ4W9ziyVfKm477LemW0kRlCSISYn4
# TX6e0g3o4E/XysDKBQCN0Q6illxIe5EIIOagmw92QZ9S/FNi1vErerGCCYrii9I=
# SIG # End signature block
