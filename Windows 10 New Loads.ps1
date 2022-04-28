#requires -runasadministrator
Write-Host "Initializing Script"
If (!(Test-Path $env:Temp\newloads)) {
    New-Item -Path "$env:temp\New Loads\" -Force -Verbose
}
$WindowTitle = "New Loads - Initializing" ; $host.UI.RawUI.WindowTitle = $WindowTitle
$reason = "OK"
$programversion = "22414.1"
$WantedBuild = "10.0.22000"
$BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
$dtime = (Get-Date -UFormat %H.%M-%Y.%m.%d)
$frmt = "`n`n========================================`n`n"
$22h2 = 22593
Function Programs {
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


    $WindowTitle = "New Loads - Installing Applications" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "$frmt Installing Apps`n Please be patient as the programs may take a while.$frmt"
    #Google
    If (!(Test-Path -Path:$Location1)){
        If (Test-Path -Path:$gcoi){
            Write-Host " Found Offline Installer : Google Chrome"
            Write-Host " Starting Offline Installer : Google Chrome"
            #Start-Process $gcoi /passive -Wait
            Start-Process -FilePath:$gcoi -ArgumentList /passive -Verbose -Wait            
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
        } else {
            Write-Host "`n`n Downloading $Package1" 
            Start-BitsTransfer -Source $package1dl -Destination $package1lc
            Write-Host " Installing $Package1`n"
            Start-Process -FilePath:$package1lc -ArgumentList /passive -Verbose -Wait
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx
        }

    } else {
            Write-Host "`n Verified $package1 is already Installed. Moving On. "
    }

    #VLC
    If (!(Test-Path -Path:$Location2)) {
        If (Test-Path -Path:$vlcoi){
            Write-Host " Found Offline Installer : VLC Media Player"
            Write-Host " Starting Offline Installer : VLC Media Player"
            Start-Process -FilePath:$vlcoi -ArgumentList /quiet -Verbose
        } else {
            Write-Host "`n`n Downloading $Package2" 
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc
            Write-Host " Installing $Package2 in the background`n"
            Start-Process -FilePath:$package2lc -ArgumentList /quiet -Verbose
            #Start-Process $package2lc /quiet
       
        }
    } else {
            Write-Host "`n Verified $package2 is already installed. Skipping"
    }

    #Adobe
    If (!(Test-Path -Path:$Location3)) {
        If (Test-Path -Path:$aroi){
            Write-Host " Found Offline Installer : Adobe Acrobat"
            Write-Host " Starting Offline Installer : Adobe Acrobat"
            #Start-Process $aroi /sPB -Wait
            Start-Process -FilePath:$aroi -ArgumentList /sPB -Verbose
        } else {
            Write-Host "`n`n Downloading $Package3" 
            Start-BitsTransfer -Source $Package3dl -Destination $package3lc
            Write-Host " Installing $Package3`n" 
            Start-Process -FilePath:$package3lc -ArgumentList /sPB -Verbose
            Write-Host " $package3 Installed."
        }    
    
    } else {
            Write-Host "`n Verified $package3 is already installed.`n Moving on`n`n"
        } 
}
Function Set-WallPaper {
    param (
        [parameter(Mandatory=$True)]
        # Provide path to image
        [string]$Image,
        # Provide wallpaper style that you would like applied
        [parameter(Mandatory=$False)] 
        [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
        [string]$Style
    )
     
    $WallpaperStyle = Switch ($Style) {
      
        "Fill" {"10"}
        "Fit" {"6"}
        "Stretch" {"2"}
        "Tile" {"0"}
        "Center" {"0"}
        "Span" {"22"}
      
    }
     
    If($Style -eq "Tile") {
     
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -PropertyType String -Value $WallpaperStyle -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -PropertyType String -Value 1 -Force
     
    }
    Else {
     
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -PropertyType String -Value $WallpaperStyle -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "TileWallpaper" -PropertyType String -Value 0 -Force
     
    }
     
    Add-Type -TypeDefinition @" 
    using System; 
    using System.Runtime.InteropServices;
      
    public class Params
    { 
        [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
        public static extern int SystemParametersInfo (Int32 uAction, 
                                                       Int32 uParam, 
                                                       String lpvParam, 
                                                       Int32 fuWinIni);
    }   
"@ 
      
        $SPI_SETDESKWALLPAPER = 0x0014
        $UpdateIniFile = 0x01
        $SendChangeEvent = 0x02
      
        $fWinIni = $UpdateIniFile -bor $SendChangeEvent
      
        $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}
Function Visuals {
    $WindowTitle = "New Loads - Applying Wallpaper" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    If (!(Get-Process explorer)){
    Write-Host " Explorer not found. Restarting"
    Start-Process Explorer -Verbose
    }    
    Write-Host "$frmt Applying Visuals $frmt"
    $wallpaper = "$env:temp\MotherComputersWallpaper.jpg"
    If ($BuildNumber -gt $WantedBuild) {
        Write-Host " Downloading Wallpaper"
        Write-Host " I have detected that you are on Windows 11"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/11.jpg" -Destination $wallpaper -Verbose
    } else {

        If ($BuildNumber -lt $WantedBuild) {
            Write-Host " I have detected that you are on Windows 10"
            Write-Host " Downloading Wallpaper"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/10.jpg" -Destination $wallpaper -Verbose
        }
    }
    $storage = "$env:appdata\Microsoft\Windows\Themes"
    $storage = "$storage\MotherComputersWallpaper.jpg"
    Copy-Item -Path $wallpaper -Destination $storage -Verbose -Force
    Write-Host " Setting System Theme to Dark Mode"
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name "SystemUsesLightTheme" -Value 0
    Write-Host " Setting App Theme to Dark Mode"
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name "AppsUseLightTheme" -Value 0
    Set-WallPaper -Image $storage -Style Stretch
}
Function OEMInfo{
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation -Name "Manufacturer" -Type String -Value "Mother Computers" -Verbose
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation -Name "SupportPhone" -Type String -Value "(250) 479-8561" -Verbose
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation -Name "SupportHours" -Type String -Value "Monday - Saturday 9AM-5PM | Sunday - Closed" -Verbose
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation -Name "SupportURL" -Type String -Value "https://www.mothercomputers.com" -Verbose
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation -Name "Model" -Type String -Value "Mother Computers - (250) 479-8561"
}
Function StartMenu {
    $WindowTitle = "New Loads - Setting Taskbar Layout" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Pinning Apps to taskbar , Clearing Start Menu Pins. $frmt"

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

If(Test-Path -Path:$layoutFile)
{
    Remove-Item $layoutFile
}

$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

$regAliases = @("HKLM", "HKCU")

foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    IF(!(Test-Path -Path:$keyPath)) { 
        New-Item -Path $basePath -Name "Explorer"
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
}
If (!(Get-Process Explorer)){
    Start-Process Explorer -Verbose
} else {
    Stop-Process -Name:Explorer -ErrorAction SilentlyContinue
    Start-Sleep -s 3
    Start-Process Explorer -Verbose
}
Start-Sleep -s 3
$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')

foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}
Stop-Process -Name:Explorer -Verbose 
# Comment the next line to disable start menu from defaulting for all new users
Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
Remove-Item $layoutFile -Verbose
}
Function OneDrive {
    $WindowTitle = "New Loads - Removing OneDrive" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Stop-Process -Name:OneDrive -Verbose -ErrorAction SilentlyContinue
    Start-Sleep -s 3
If (Test-Path -Path:C:\Windows\System32\OneDriveSetup.exe){
    ' Found OneDrive in sys32, Removing'
    Start-Process -FilePath:C:\Windows\System32\OneDriveSetup.exe -ArgumentList /uninstall -Wait -Verbose -ErrorAction SilentlyContinue
}
If (Test-Path -Path:C:\Windows\SysWOW64\OneDriveSetup.exe){
    ' Found OneDrive in syswow, Removing'
    Start-Process -FilePath:C:\Windows\SysWOW64\OneDriveSetup.exe -ArgumentList /uninstall -Verbose
}
    Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
}
Function Debloat {
    $WindowTitle = "New Loads - Debloating" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "$frmt Removing Bloatware $frmt "
    $Programs = @(
    # non-Microsoft All Machines
    "Clipchamp.Clipchamp"
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


    #Unnecessary Windows 10 AppX Apps
    "Microsoft.3DBuilder"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.AppConnector"
    #"Microsoft.BingFinance"
    #"Microsoft.BingNews"
    #"Microsoft.BingSports"
    #"Microsoft.BingTranslator"
    #"Microsoft.BingWeather"
    #"Microsoft.BingFoodAndDrink"
    #"Microsoft.BingHealthAndFitness"
    #"Microsoft.BingTravel"
    "Microsoft.ConnectivityStore"
    "Microsoft.MinecraftEducationEdition"
    "Microsoft.MinecraftUWP"
    "Microsoft.Messaging"
    "Microsoft.MixedReality.Portal"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.News"
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
    "Microsoft.WindowsMaps"
    )
        foreach ($Program in $Programs) {
            Write-Host " Attempting removal of $Program."   
            Get-AppxPackage -Name $Program | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online| Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online
        }
}
Function REGISTRY {
    $WindowTitle = "New Loads - Registry" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Applying Registry Changes $frmt"
    
    If ($BuildNumber -lt $WantedBuild) {            ## Windows 10

        Write-Host " Applying Windows 10 Specific Registry Keys`n"
        Write-Host ' Changing Searchbox to Icon Format on Taskbar'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name "SearchboxTaskbarMode" -Value 1 -Verbose
        Write-Host ' Removing Cortana Icon from Taskbar'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "ShowCortanaButton" -Value 0 -Verbose
        
        Write-Host ' Pinning Task View Icon'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "ShowTaskViewButton" -Value 0 -Verbose
        
        If (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"){
            Write-Host ' Hiding 3D Objects icon from This PC'
            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -Verbose
        }

        If ((Get-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon).MinimizedStateTabletModeOff -eq 1) { 
            Write-Host ' Expanding Ribbon in Explorer'
            Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name "MinimizedStateTabletModeOff" -Value 0 -Verbose
        }

        Write-Host ' Disabling Feeds open on hover'
        If (!(Test-Path -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds)){
            New-Item -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion -Name "Feeds" -Verbose
        }
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 -Verbose
        

    }

    if ($BuildNumber -gt $WantedBuild) {            ## Windows 11
        
        Write-Host " Applying Windows 11 Specific Registry Keys`n"

    
        Write-Host ' Removing Chat from taskbar'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "TaskBarMn" -Value 0 -Verbose
    
        Write-Host ' Removing "Meet Now" button from taskbar'
        If (!(Test-Path -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer)) {
            New-Item -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Force -Verbose
        }
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value 1 -Verbose
        
            
    }
    
    Write-Host " Removing Unnecessary printers"
    Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction SilentlyContinue -Verbose
    Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue -Verbose 
    Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue -Verbose

    ### Explorer related

    Write-Host ' Disabling Show Recent in Explorer Menu'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name "ShowRecent" -Value 0 -Verbose
        
    Write-Host ' Disabling Show Frequent in Explorer Menu'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name "ShowFrequent" -Value 0 -Verbose

    Write-Host ' Enabling Snap Assist Flyout'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "EnableSnapAssistFlyout" -Value 1 -Verbose

    Write-Host ' Enabling File Extensions'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "HideFileExt" -Value 0 -Verbose

    Write-Host ' Setting Explorer Launch to This PC'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name "LaunchTo" -Value 1 -Verbose
    
    Write-Host ' Adding User Files to desktop'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0 -Verbose
    
    Write-Host ' Adding This PC icon to desktop'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Verbose

    Write-Host ' Showing file operations details'
    If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Verbose
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value 1 -Verbose







    ### Privacy
    Write-Host ' Disabling Content Delivery Related Setings - ContentDelivery, Pre-installed Microsoft, Pre-installed OEM Apps, Silent Apps'
    If (!(Test-Path -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager)){
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ContentDeliveryManager" -Verbose
    }
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "ContentDeliveryAllowed" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "OemPreInstalledAppsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "PreInstalledAppsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "PreInstalledAppsEverEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SilentInstalledAppsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContentEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-310093Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-338387Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-338388Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-338389Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-338393Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-353694Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-353696Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SubscribedContent-353698Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SystemPaneSuggestionsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name "SoftLandingEnabled" -Type DWORD -Value 0 -Verbose
    If (Test-Path -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptionn){
        Remove-Item -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptionn -Recurse -Force -Verbose
    }
    If (Test-Path -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps){
        Remove-Item -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps -Recurse -Force -Verbose
    }
    Write-Host ' Disabling Advertiser ID'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name "DisabledByGroupPolicy" -Value 1 -Type DWORD -Verbose
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name "Enabled" -Value 0 -Type DWORD -Verbose

    Write-Host ' Disabling App Launch Trackin'
    If (!(Test-Path -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI)){
        New-Item -Path:HKCU:\Software\Policies\Microsoft\Windows -Name "EdgeUI" -Verbose
    }
    Set-ItemProperty -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value 1 -Type DWORD -Verbose

    Write-Host ' Disabling Contact Harvesting'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore -Name "HarvestContacts" -Value 0 -Verbose

    Write-Host ' Declining Microsoft Privacy Policy'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Personalization\Settings -Name "AcceptedPrivacyPolicy" -Value 0 -Verbose

    Write-Host ' Restricting Ink and Text Collection'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\InputPersonalization -Name "RestrictImplicitInkCollection" -Value 1 -Verbose
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\InputPersonalization -Name "RestrictImplicitTextCollection" -Value 1 -Verbose
    
    Write-Host ' Disabling Feedback'
    If (!(Test-Path -Path:HKCU:\Software\Microsoft\Siuf)) { 
        New-Item -Path:HKCU:\Software\Microsoft -Name "Siuf" -Verbose
    }
    If (!(Test-Path -Path:HKCU:\Software\Microsoft\Siuf\Rules)) {
    New-Item -Path:HKCU:\Software\Microsoft\Siuf -Name "Rules" -Verbose
    }
    Stop-Service "DiagTrack" -WarningAction SilentlyContinue -Verbose
    Set-Service "DiagTrack" -StartupType Disabled -Verbose
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Siuf\Rules -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Siuf\Rules -Name "PeriodInNanoSeconds" -Type QWORD -Value 0 -Verbose

    Write-Host ' Disabling Windows Feedback Notifications'
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value 1 -Verbose
    
    Write-Host ' Disabling Activity History'
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name "EnableActivityFeed" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name "PublishUserActivities" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name "UploadUserActivities" -Type DWORD -Value 0 -Verbose

    Write-Host ' Disabling Location Tracking'
    If (!(Test-Path -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location)) {
        New-Item -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location -Force -Verbose
    }
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location -Name "Value" -Type String -Value "Deny" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration -Name "Status" -Type DWORD -Value 0 -Verbose

    Write-Host ' Disabling automatic Maps updates'
    Set-ItemProperty -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value 0 -Verbose

    Write-Host ' Stopping and disabling WAP Push Service'
    Stop-Service "dmwappushservice" -WarningAction SilentlyContinue -Verbose
    Set-Service "dmwappushservice" -StartupType Disabled -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value 0 -Verbose
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null

    Write-Host ' Disabling Wi-Fi Sense'
    If (!(Test-Path -Path:HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting)) {
        New-Item -Path:HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Force -Verbose
    }
    Set-ItemProperty -Path:HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path:HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value 0 -Verbose


    If (!(Test-Path -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent)) {
    New-Item -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent -Force -Verbose
    }
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value 1 -Verbose

    ### System
    
    $22h2 = 22593
    Write-Host ' Showing Details in Task Manager, also setting default tab to Performance'
    If ($BuildNumber -lt $22h2){
        Write-Host ' Showing task manager details'
        $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru -Verbose
        Do {
            Start-Sleep -Milliseconds 100
            $preferences = Get-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name "Preferences" -ErrorAction SilentlyContinue
        } Until ($preferences)
        Stop-Process $taskmgr
        $preferences.Preferences[28] = 0
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name "Preferences" -Type Binary -Value $preferences.Preferences -Verbose
        Write-Host ' Setting default tab to Performance'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name "StartUpTab" -Value 1 -Type DWORD -Verbose
    }
    Write-Host ' Enabling F8 boot menu options'
    bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null

    Write-Host ' Stopping and disabling Home Groups services'
    Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue 
    Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue
    
    Write-Host ' Stopping and disabling Superfetch service'
    Stop-Service "SysMain" -WarningAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled

    Write-Host ' Changing On AC Sleep Settings'
    powercfg -change -standby-timeout-ac "60"
    powercfg -change -monitor-timeout-ac "45"        
    Write-Host ' Changing On Battery Sleep Settings'
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"
    
    Write-Host ' Setting Sounds > Communications to "Do Nothing"'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD -Verbose

    Write-Host ' Grouping svchost.exe processes'
    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
    Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram -Force -Verbose
    
    Write-Host ' Increasing stack size up to 30'
    Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30 -Verbose
        
    Write-Host "$frmt Registry changes applied $frmt"
}
Function Cleanup {
    $WindowTitle = "New Loads - Cleanup" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Finishing Up $frmt"
    $EdgeShortcut = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
    $acrosc = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
    $edgescpub = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
    $vlcsc = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
    $ctemp = "C:\Temp"
    If (!((Get-Process -Name explorer -ErrorAction SilentlyContinue).Id)){
        Start-Process Explorer -Verbose
        Write-Host " Explorer Started"
    }
    
	#A112
    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq $blstat){
        Write-Host " Bitlocker seems to be enabled. Would you like to disable it and start the decryption process?."
        ##Requires -RunSilent
    
        [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
        $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('BitLocker seems to be enabled. Would you like to disable it?','New Loads','YesNo','Question')
        switch  ($msgBoxInput) {
        'Yes' {
            manage-bde -off "C:"
            Write-Host " Drive will continue to decrypt in the background."
        }
        'No'{
            Write-Host " Leaving bitlocker enabled."
        }
    
        }
    }

    If ($perform_apps.checked -eq $true){
        Start-Process Chrome
        If (Test-Path -Path:$vlcsc) { 
            Remove-Item -Path:$vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
        }
        If (Test-Path -Path:$acrosc) { 
            Remove-Item -Path:$acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
        }
    }
    Remove-Item "$Env:Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL
    If (Test-Path -Path:$EdgeShortcut) { 
        Write-Host " Removing Edge Icon"
        Remove-Item -Path:$EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path -Path:$edgescpub) { 
        Write-Host " Removing Edge Icon in Public"
        Remove-Item -Path:$edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }

    If (Test-Path -Path:$ctemp) { 
        Write-Host " Removing temp folder in C Root"
        Remove-Item -Path:$ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
}

Start-Transcript -LiteralPath "$env:USERPROFILE\Desktop\Automated Script Run - $dtime.txt"
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
OEMInfo
StartMenu
Registry
OneDrive
Debloat
Cleanup
Stop-Transcript
Write-Host "Script Completed.`nExiting."
Start-Sleep -s 1
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
