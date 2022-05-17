#requires -runasadministrator
Write-Host "Initializing New Loads"
$WindowTitle = "New Loads - Initializing" ; $host.UI.RawUI.WindowTitle = $WindowTitle
#Install-Module -Name BurntToast -Force
$programversion = "22516"
$reason = "OK"
$WantedBuild = "10.0.22000"
$BuildNumber = (Get-ItemProperty -Path c:\windows\system32\hal.dll).VersionInfo.ProductVersion
$dtime = (Get-Date -UFormat %H.%M-%Y.%m.%d)
$frmt = "`n`n========================================`n`n"
$22h2 = "0.0.22593"
$newloads = $env:temp + "\New Loads\"
$log = "$newloads" + "\New Loads Automated Log - $dtime.txt"
$oi = ".\Offline Installers\"
$dtime = (Get-Date -UFormat %H.%M-%Y.%m.%d)
##########
## APPS ##
##########
#Google Chrome
$package1  = "googlechromestandaloneenterprise64.msi"
$package1dl = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$package1lc = $newloads + $package1
$location1 = $env:PROGRAMFILES + "\Google\Chrome\Application\chrome.exe"
$gcoi = $oi + $package1

#VLC Media Player
$package2  = "vlc-3.0.17-win64.msi"
$package2dl = "https://github.com/circlol/newload/raw/main/Assets/BAF/vlc-3.0.17-win64.msi"
$package2lc = $newloads + $package2
$location2 = $env:PROGRAMFILES + "\VideoLAN\VLC\vlc.exe"
$vlcoi = $oi + $package2

#Zoom
$package3 = "ZoomInstallerFull.msi"
$package3dl = "https://zoom.us/client/5.10.4.5035/ZoomInstallerFull.msi?archType=x64"
$package3lc = $newloads + $package3
$location3 = $env:PROGRAMFILES + "\Zoom\bin\Zoom.exe"
#$zoomoi = $oi + $package4

#Adobe Acrobat Reader DC 64GB
$package4  = "AcroRdrDCx642200120085_MUI.exe"
$package4dl = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2200120085/AcroRdrDCx642200120085_MUI.exe"
$package4lc = $newloads + $package4
$location4 = $env:PROGRAMFILES + "\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
$aroi = $oi + $package4

$EdgeShortcut = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
$edgescpub = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
$vlcsc = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
$acrosc = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
$zoomsc = "$Env:PUBLIC\Desktop\Zoom.lnk"
$ctemp = "C:\Temp"

$chromeyns = $y
$adobeyns = $y
$vlcyns = $y
$zoomyns = $y
$debloatyns = $y
$onedriveyns = $y

$webadvisor = "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe"
$WildGames = "C:\Program Files (x86)\WildGames\Uninstall.exe"
$livesafe = "C:\Program Files\McAfee\MSC\mcuihost.exe"
###################
## REGISTRY KEYS ##
###################
$regcam = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
$regcdm = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
$lfsvc = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
$regoeminfo = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
$wifisense = "HKLM:\Software\Microsoft\PolicyManager\default\WiFi"
$siufrules = "HKCU:\Software\Microsoft\Siuf\Rules"
$reginp = "HKCU:\Software\Microsoft\InputPersonalization"
$cloudcontent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$regexlm = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$regsys = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$regpersonalize = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$regadvertising = "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
$regexadv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$regex = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$regcv = "HKCU:\Software\Microsoft\Windows\CurrentVersion"
$regsearch = "$regcv" + "\Search"
$regex = "$regcv" + "\Explorer"
$regcdm = "$regcv" + "\ContentDeliveryManager"
$regexadv = "$regcv" + "\Explorer\Advanced"
$regadvertising = "$regcv" + "\AdvertisingInfo"

################
## WALLPAPERS ##
################
$storage = "$env:appdata\Microsoft\Windows\Themes"
$wallpaper = $storage + "\MotherComputersWallpaper.jpg"
$currentwallpaper = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper
$sysmode = (Get-ItemProperty -Path $regpersonalize -Name SystemUsesLightTheme).SystemUsesLightTheme
$appmode = (Get-ItemProperty -Path $regpersonalize -Name AppsUseLightTheme).AppsUseLightTheme
###############
## PROG LIST ##
###############
$unviewdest = "$newloads" + "\unview.exe"
$html = "$newloads" + "\ProgList.html"
$list = "$newloads" + "\ProgList.txt"
$link = "https://github.com/circlol/newload/raw/main/Assets/unview.exe"
$line = "`n`n==================================================`n`n"


If (!(Test-Path -Path:"$newloads")){
    New-Item -Path:"$Env:Temp" -Name:"New Loads" -ItemType:Directory -Force | Out-Null
}

Function Check {
    If($?){
        Write-Host " Successful"
    } else {
        Write-Warning " Unsuccessful"
    }
}
Function Programs {
    $WindowTitle = "New Loads - Installing Applications" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "$frmt Installing Apps.$frmt"

    #Google
    If (!(Test-Path -Path:$Location1)){
        If (Test-Path -Path:$gcoi){
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx /f > $Null
            Write-Host " Installing $Package1`n"
            #Start-Process $gcoi /passive -Wait
            Start-Process -FilePath:$gcoi -ArgumentList /passive -Verbose -Wait
        } else {
            Write-Host " Flagging UBlock Origin for Installation"
            REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d https://clients2.google.com/service/update2/crx /f > $Null
            Write-Host "`n`n Downloading $Package1" 
            Start-BitsTransfer -Source $package1dl -Destination $package1lc
            Check
            Write-Host " Installing $Package1`n"
            Start-Process -FilePath:$package1lc -ArgumentList /passive -Verbose -Wait
        }
        } else {
            Write-Host "`n Verified $package1 is already Installed. Moving On. "

        }
    #VLC
    If (!(Test-Path -Path:$Location2)) {
        If (Test-Path -Path:$vlcoi){
            Write-Host " Installing $Package2`n"
            Start-Process -FilePath:$vlcoi -ArgumentList /quiet -Verbose -Wait

            #$vlcyns
        } else {
            Write-Host "`n`n Downloading $Package2" 
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc
            Check
            Write-Host " Installing $Package2`n"
            Start-Process -FilePath:$package2lc -ArgumentList /quiet -Verbose -Wait
            #Start-Process $package2lc /quiet


        }

    } else {
            Write-Host "`n Verified $package2 is already installed. Skipping"

    }
    #Zoom
    If (!(Test-Path -Path:$Location3)) {
        Write-Host "`n`n Downloading $Package3" 
        Start-BitsTransfer -Source $Package3dl -Destination $package3lc
        Check
        Start-Sleep -s 3
        Write-Host " Installing $Package3`n"
        Start-Process -FilePath:$package3lc -ArgumentList /quiet -Verbose -Wait
        } else {
        Write-Host "`n Verified $package3 is already installed. Skipping"
    }

    #Adobe
    If (!(Test-Path -Path:$Location4)) {
        If (Test-Path -Path:$aroi){
            Write-Host " Installing $package4"
            #Start-Process $aroi /sPB -Wait
            Start-Process -FilePath:$aroi -ArgumentList /sPB -Verbose

        } else {
            Write-Host "`n`n Downloading $Package4" 
            Start-BitsTransfer -Source $Package4dl -Destination $package4lc
                If ($?){
                    Write-Host " Successful"
                }
                    Write-Host " Installing $Package4`n" 
            Start-Process -FilePath:$package4lc -ArgumentList /sPB -Verbose
        }    

        } else {
            Write-Host "`n Verified $package4 is already installed.`n Moving on`n`n"
        } 
    
    
        If (Test-Path -Path $webadvisor){
            Write-Host " Attemping Removal of McAfee WebAdvisor Uninstall"
            Start-Process "$webadvisor"
        }

        If (Test-Path -Path $WildGames){
            Write-Host " Attemping Removal WildTangent Games"
            Start-Process $WildGames 
        }
        
        If (Test-Path -Path $livesafe){
            Write-Host " Attemping Removal of McAfee Live Safe"
            Start-Process "$livesafe"
            #Start-Process -Path $Livesafe -ArgumentList /body:misp://MSCJsRes.dll::uninstall.html /id:uninstall -Force
        }

    
} 
Function ProgList {
    $Title = "New Loads - ProgList Extractor" ; $host.UI.RawUI.WindowTitle = $Title
        
    Write-Host " Generating Program List $line"
    If (!(Test-Path -Path "$newloads")){
        New-Item -Path "$Env:Temp" -Name:"New Loads" -ItemType:Directory -Force
    }


    If (Test-Path -Path $html){
        Remove-Item $html -Force -Verbose
    }
    If (Test-Path -Path $list){
        Remove-Item $list -Force -Verbose
    }
    
    If (!(Test-Path -Path "$unviewdest")){
    

        Write-Host " Unview not found, Downloading." >> $list
        Start-BitsTransfer -Source "$link" -Destination "$newloads\unview.exe" -Verbose
        & $unviewdest /shtml "$html"
    
        } Else {
    
        Write-Host " Running Uninstall View by NirSoft"
        & $unviewdest /shtml "$html"
        
    
    }
    
    #Generating a win32 product list 
    Write-Host " Generating an alphabetical list of all win32 applications`n" >> $list
    (Get-WmiObject win32_product).Name | Sort-Object >> $list
    
    Write-Host " Adding list of installed Windows Apps to $list`n" ; Write-Output "`n`n Generating list of installed Windows Apps`n Executing Command Get-AppxPackage." >> $list
    (Get-AppxPackage -AllUsers).PackageFamilyName >> $list
    
    If (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
    
        Write-Host " Adding list of Winget Packages to $list" ; Write-Output "`n`n Generating List of Winget Packages" >> $list
        winget list -s winget --accept-source-agreements >> $list
        
    } else {
    
        Write-Host " Winget does not exist on this PC."
    
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
        $ret
}
Function Visuals {
    $WindowTitle = "New Loads - Applying Wallpaper" ; $host.UI.RawUI.WindowTitle = $WindowTitle
	If (!(Get-Process -Name:Explorer)){
		Start-Process Explorer -Verbose
		Write-Host " Explorer Started"
    }
    Write-Host "$frmt Applying Visuals $frmt"

    If (!(Test-Path -Path $Wallpaper)){
    If ($BuildNumber -gt $WantedBuild) {
        Write-Host " Downloading Wallpaper"
        Write-Host " I have detected that you are on Windows 11"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/11.jpg" -Destination $wallpaper -Verbose
    } else {
        If ($BuildNumber -lt $WantedBuild) {
            Write-Host " I have detected that you are on Windows 10"
            Write-Host " Downloading Wallpaper"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/10.jpg" -Destination $wallpaper -Verbose
            If($? -eq $True){
                Write-Host " Successful"
                
            }
        }
    }
    } else {
        Write-Host " Wallpaper already exists on this system."
    }
    Write-Host " Checking if wallpaper is applied"
    If (!($currentwallpaper -eq $wallpaper)){
        Write-Host " It is not. Setting."
        Set-WallPaper -Image $wallpaper -Style Stretch
    } else {
        Write-Host " Detected wallpaper is set to New Loads"
    }

    If (!($sysmode -eq 0)){
        Write-Host " Setting System Theme to Dark Mode"
        Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name "SystemUsesLightTheme" -Value 0 -Verbose
    } else {
        Write-Host " New Loads detected System Mode is set to Dark Theme"
    }
    If (!($appmode -eq 0)){
        Write-Host " Setting App Theme to Dark Mode"
        Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name "AppsUseLightTheme" -Value 0 -Verbose
    } else {
        Write-Host " New Loads detected App Mode is set to Dark Theme"
    }


}
Function OEMInfo{
    $WindowTitle = "New Loads - OEM Info" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Applying OEM Information $frmt "
    $regoeminfo = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"

    $store = "Mother Computers"
    If ((Get-ItemProperty -Path $regoeminfo).Manufacturer -eq "$store"){
        Write-Host " Skipping"
    }else {
        Set-ItemProperty -Path $regoeminfo -Name "Manufacturer" -Type String -Value "$store" -Verbose
    }

    $phone = "(250) 479-8561"
    If ((Get-ItemProperty -Path $regoeminfo).SupportPhone -eq $phone){
        Write-Host " Skipping"
    }else {
    Set-ItemProperty -Path $regoeminfo -Name "SupportPhone" -Type String -Value "$phone" -Verbose
        
    }

    $hours = "Monday - Saturday 9AM-5PM | Sunday - Closed" 
    If ((Get-ItemProperty -Path $regoeminfo).SupportHours -eq "$hours"){
        Write-Host " Skipping"
    }else {
    Set-ItemProperty -Path $regoeminfo -Name "SupportHours" -Type String -Value "$hours" -Verbose
        
    }

    $website = "https://www.mothercomputers.com"
    If ((Get-ItemProperty -Path $regoeminfo).SupportURL -eq $website){
        Write-Host " Skipping"

    }else {
    Set-ItemProperty -Path $regoeminfo -Name "SupportURL" -Type String -Value $website -Verbose
        
    }

    $model = "Mother Computers - (250) 479-8561"
    If ((Get-ItemProperty -Path $regoeminfo).Model -eq "$model"){
        Write-Host " Skipping"
    }else {
    Set-ItemProperty -Path $regoeminfo -Name "Model" -Type String -Value "$Model"
    }
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
    Check
}
If (Test-Path -Path:C:\Windows\SysWOW64\OneDriveSetup.exe){
    ' Found OneDrive in its dirty house, Starting Uninstaller'
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
            Write-Warning " Attempting removal of $Program."   
            Get-AppxPackage -Name $Program | Remove-AppxPackage | Out-Host
            Get-AppxProvisionedPackage -Online| Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online | Out-Host
        }
}
Function AdvRegistry {
    param (
        [Parameter(Mandatory=$True)]
        [String]$Action
    )
    

    $Vari = Switch ($Action) {

        "Apply" {"1"}
        "Undo" {"2"}
        "*" {"3"}
    }

    If ($vari -eq '1'){
        Write-Host " Applying"
        $1 = 1
        $0 = 0
        $regjob = "Applied"
        $title = "Applying"
    } else {
        If ($Vari -eq '2'){
            Write-Host " Undoing Changes"
            $1 = '0'
            $0 = '1'
            $regjob = "Undone"
            $title = "Undoing"
        } else {
            Write-Host " ERROR: Option specified is not valid. Try again" -ForegroundColor Red
            Exit
        }
        
    }

    ####################### COMMAND INPUT BELOW THIS #######################
    $WindowTitle = "New Loads - Registry" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt $title Registry Changes $frmt"
    If ($1 -eq 0){
        Write-Host " Skipping"
    } else {

        Write-Host " Removing Unnecessary printers"
        Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction SilentlyContinue -Verbose
        Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue -Verbose 
        Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue -Verbose
    }


    If ($BuildNumber -lt $WantedBuild) {            ## Windows 10

        Write-Host " Applying Windows 10 Specific Registry Keys`n"
        ## Changes search box to an icon
        If ($vari -eq '1'){
            $tbm = 1
        } elseif ($vari -eq '2') {
            $tbm = 2
        } else {
            Write-Host " Error" -ForegroundColor Red
        }
        If ((Get-ItemProperty -Path $regsearch).SearchBoxTaskbarMode -eq $1){
            Write-Host " Skipping"
        } Else {
            Write-Host ' Changing Searchbox to Icon Format on Taskbar'
            Set-ItemProperty -Path $regsearch -Name "SearchboxTaskbarMode" -Value $tbm -Verbose
        }

        ## Removes Cortana from the taskbar
        If ((Get-ItemProperty -Path $regexadv).ShowCortanaButton -eq $0){
            Write-Host " Skipping"
        } Else {
        Write-Host ' Removing Cortana Icon from Taskbar'
        Set-ItemProperty -Path $regexadv -Name "ShowCortanaButton" -Value $0 -Verbose
        }

        ## Unpins taskview from Windows 10 Taskbar
        If ((Get-ItemProperty -Path $Regexadv).ShowTaskViewButton -eq $0){
            Write-Host " Skipping"
        } else {
        Write-Host ' Unpinning Task View Icon'
        Set-ItemProperty -Path $regexadv -Name "ShowTaskViewButton" -Value $0 -Verbose
        }

        ##  Hides 3D Objects from "This PC"
        If (Test-Path -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"){
            Write-Host ' Hiding 3D Objects icon from This PC'
            Remove-Item -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -Verbose
        }

        ## Expands explorers ribbon
        If (!(Test-Path -Path $regex\Ribbon)){
            New-Item -Path "$regex" -Name "Ribbon" -Force -Verbose
        }

        If ((Get-ItemProperty -Path "$regex\Ribbon").MinimizedStateTabletModeOff -eq $0) { 
            Write-Host " Skipping"
        } else {
            Write-Host ' Expanding Ribbon in Explorer'
            Set-ItemProperty -Path $regex\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $0 -Verbose
        }

        ## Disabling Feeds Open on Hover
        If ((Get-ItemProperty -Path $regcv\Feeds).ShellFeedsTaskbarOpenOnHover -eq $0){
            Write-Host " Skipping"
        } else {
            Write-Host ' Disabling Feeds open on hover'
            If (!(Test-Path -Path $regcv\Feeds)){
                New-Item -Path $regcv -Name "Feeds" -Verbose
            }
            Set-ItemProperty -Path $regcv\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value $0 -Verbose
        }
    }

    if ($BuildNumber -gt $WantedBuild) {            ## Windows 11
        
        Write-Host " Applying Windows 11 Specific Registry Keys`n"
        
        If ((Get-ItemProperty -Path $regexadv).TaskbarMn -eq $0){
            Write-Host " Skipping"
        } else {
            Write-Host " Removing Chats from taskbar"
            Set-ItemProperty -Path $regexadv -Name "TaskBarMn" -Value $0 -Verbose
        }
        If (!(Test-Path $regcv\Policies\Explorer)){
            New-Item $regcv\Policies\ -Name Explorer -Force -Verbose
        }
        If ((Get-ItemProperty -Path "$regcv\Policies\Explorer").HideSCAMeetNow -eq $1){
            Write-Host " Skipping"
        } else {
            Write-Host ' Removing "Meet Now" button from taskbar'
            Set-ItemProperty -Path $regcv\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value $1 -Verbose
        }
    }


    # Checks current value for Game mode and E.
    $key1 = "HKCU:\Software\Microsoft\GameBar"
    $key2 = "AutoGameModeEnabled"
    $agme = (Get-ItemProperty -Path $key1).$key2
    If ($agme -eq 1){
        Write-Host " Skipping"
    } else {
        Write-Host " Enabling Game Mode"
        Set-ItemProperty -Path $key1 -Name $key2 -Value $1 -Verbose -Force
    }
    

    ### Explorer related
    If ((Get-ItemProperty -Path $regex).ShowRecent -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling Show Recent in Explorer Menu'
        Set-ItemProperty -Path $regex -Name "ShowRecent" -Value 0 -Verbose
    }
    
    If ((Get-ItemProperty -Path $regex).ShowFrequent -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling Show Frequent in Explorer Menu'
        Set-ItemProperty -Path $regex -Name "ShowFrequent" -Value 0 -Verbose
    }

    If ((Get-ItemProperty -Path $regexadv).EnableSnapAssistFlyout -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Enabling Snap Assist Flyout'
        Set-ItemProperty -Path $regexadv -Name "EnableSnapAssistFlyout" -Value $1 -Verbose
    }

    If ((Get-ItemProperty -Path $regexadv).HideFileExt -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Enabling File Extensions'
        Set-ItemProperty -Path $regexadv -Name "HideFileExt" -Value 0 -Verbose
    }

    If ((Get-ItemProperty -Path $regexadv).LaunchTo -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Setting Explorer Launch to This PC'
        Set-ItemProperty -Path $regexadv -Name "LaunchTo" -Value $1 -Verbose
    }

    If (!(Test-Path -Path "$regexadv\HideDesktopIcons\NewStartPanel")){
        New-Item -Path "$regexadv\HideDesktopIcons" -Name NewStartPanel -Verbose -Force
    }
    $UsersFolder = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
    If ((Get-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel).$UsersFolder -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Adding User Files to desktop'
        Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value 0 -Verbose
    }

    $ThisPC = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    If ((Get-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel).$ThisPC -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Adding This PC icon to desktop'
        Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value 0 -Verbose
    }

    If (!(Test-Path $regex\OperationStatusManager)){
        New-Item -Path $regex\OperationStatusManager -Name EnthusiastMode -Type DWORD -Verbose -Force
    }
    If ((Get-ItemProperty -Path $regex\OperationStatusManager).EnthusiastMode -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Showing file operations details'
        If (!(Test-Path "$regex\OperationStatusManager")) {
            New-Item -Path "$regex\OperationStatusManager" -Verbose
        }
        Set-ItemProperty -Path "$regex\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $1 -Verbose
    }


    ### Privacy
    #Write-Host ' Disabling Content Delivery Related Setings'
    If (!(Test-Path -Path $regcdm)){
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ContentDeliveryManager" -Verbose
    }
    If (Test-Path -Path $regcdm\Subscriptionn){
        Remove-Item -Path $regcdm\Subscriptionn -Recurse -Force -Verbose
    }
    If (Test-Path -Path $regcdm\SuggestedApps){
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
        If ((Get-ItemProperty -Path $regcdm).$cdm -eq $0){
            Write-Host " Skipping"
        } else {
            Write-Host " Setting $cdm to $0"
            Set-ItemProperty -Path $regcdm -Name $cdm -Value $0 -Verbose
        }
    }


    If ((Get-ItemProperty -Path $regadvertising).DisabledByGroupPolicy -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling Advertiser ID'
        Set-ItemProperty -Path $regadvertising -Name "DisabledByGroupPolicy" -Value $1 -Type DWORD -Verbose
    }


    If ((Get-ItemProperty -Path $regadvertising).Enabled -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path $regadvertising -Name "Enabled" -Value $0 -Verbose
    }


    If (!(Test-Path -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI)){
        New-Item -Path:HKCU:\Software\Policies\Microsoft\Windows -Name "EdgeUI" -Verbose
    }
    If ((Get-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI).DisableMFUTracking -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling App Launch Tracking'
        Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $1 -Type DWORD -Verbose
    }
    If ($vari -eq '2'){
        Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force -Verbose
    }

    
    If ((Get-ItemProperty -Path $reginp\TrainedDataStore).HarvestContacts -eq $0){
        Write-Host " Skipping"        
    } else {
        Write-Host ' Disabling Contact Harvesting'
        Set-ItemProperty -Path $reginp\TrainedDataStore -Name "HarvestContacts" -Value $0 -Verbose
    }


    If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\Personalization\Settings).AcceptedPrivacyPolicy -eq $0){
        Write-Host " Skipping"        
    } else {
        Write-Host ' Declining Microsoft Privacy Policy'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\Personalization\Settings -Name "AcceptedPrivacyPolicy" -Value $0 -Verbose
    }


    If ((Get-ItemProperty -Path $reginp).RestrictImplicitTextCollection -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Restricting Text Collection'
        Set-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Value $1 -Verbose
        
    } 

    If ((Get-ItemProperty -Path $reginp).RestrictImplicitInkCollection -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Restricting Ink Collection'
        Set-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Value $1 -Verbose

    }
    
    
    ### Disables Feedback to Microsoft.
    If (!(Test-Path -Path:HKCU:\Software\Microsoft\Siuf)) { 
        New-Item -Path:HKCU:\Software\Microsoft -Name "Siuf" -Verbose
    }
    If (!(Test-Path -Path $siufrules)) {
        New-Item -Path HKCU:\Software\Microsoft\Siuf -Name "Rules" -Verbose
    }
    If (!((Get-Service -Name DiagTrack).Status -eq "Disabled")){
        Write-Host " Skipping"
    } else {
        Stop-Service "DiagTrack" -WarningAction SilentlyContinue -Verbose
        Set-Service "DiagTrack" -StartupType Disabled -Verbose
    }    
    If ((Get-ItemProperty -Path $siufrules).PeriodInNanoSeconds -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path $siufrules -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0 -Verbose
    }
    If ((Get-ItemProperty -Path $siufrules).PeriodInNanoSeconds -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path $siufrules -Name "PeriodInNanoSeconds" -Type QWORD -Value 0 -Verbose
    }
    
    


    If ((Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection).DoNotShowFeedbackNotifications -eq $1){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling Windows Feedback Notifications'
        Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $1 -Verbose
    }


    If ((Get-ItemProperty -Path $regsys).EnableActivityFeed -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling Activity History'
        Set-ItemProperty -Path $regsys -Name "EnableActivityFeed" -Type DWORD -Value $0 -Verbose
        
    }

    If ((Get-ItemProperty -Path $regsys).PublishUserActivities -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path $regsys -Name "PublishUserActivities" -Type DWORD -Value $0 -Verbose
        
    }

    If ((Get-ItemProperty -Path $regsys).UploadUserActivities -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path $regsys -Name "UploadUserActivities" -Type DWORD -Value $0 -Verbose
    }



    If (!(Test-Path -Path:$regcam)) {
        New-Item -Path:$regcam -Force -Verbose
    }
    If ((Get-ItemProperty -Path "$regcam" -Name Value).Value -eq "Deny"){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling Location Tracking'
        Set-ItemProperty -Path "$regcam" -Name "Value" -Type String -Value "Deny" -Verbose
    }

    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name SensorPermissionState).SensorPermissionState -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWORD -Value $0 -Verbose
    }

    If ((Get-ItemProperty -Path $lfsvc -Name Status).Status -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path "$lfsvc" -Name "Status" -Type DWORD -Value $0 -Verbose
    }



    If ((Get-ItemProperty -Path HKLM:\System\Maps).AutoUpdateEnabled -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling automatic Maps updates'
        Set-ItemProperty -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $0 -Verbose
    }


    If (!((Get-Service -Name dmwappushservice).Status -eq "Disabled")){
        Write-Host " Skipping"
    } else {
        Write-Host ' Stopping and disabling WAP Push Service'
        Stop-Service "dmwappushservice" -WarningAction SilentlyContinue -Verbose
        Set-Service "dmwappushservice" -StartupType Disabled -Verbose
    }
    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection").AllowTelemetry -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value $0 -Verbose
    }

    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection").AllowTelemetry -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value $0 -Verbose



    }
    

    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" -Verbose 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" -Verbose 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" -Verbose 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" -Verbose 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" -Verbose 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -Verbose 


    If (!(Test-Path -Path $wifisense\AllowWiFiHotSpotReporting)) {
        New-Item -Path $wifisense\AllowWiFiHotSpotReporting -Force -Verbose
    }
    If ((Get-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots).Value -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling Wi-Fi Sense'
        Set-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value $0 -Verbose
    }
    If ((Get-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting).Value -eq $0){
        Write-Host " Skipping"
    } else {
        Write-Host ' Disabling HotSpot Reporting to Microsoft'
        Set-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value $0 -Verbose
    }



    $cloudcontent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    If (!(Test-Path -Path $cloudcontent)) {
    New-Item -Path $cloudcontent -Force -Verbose
    }
    If ((Get-ItemProperty -Path $cloudcontent).DisableWindowsConsumerFeatures -eq $1){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path $cloudcontent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $1 -Verbose
    }


    $key1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
    $key2 = "TailoredExperiencesWithDiagnosticDataEnabled"
    If ((Get-ItemProperty -Path $key1).$key2 -eq $0){
        Write-Host " Skipping"
    } else {
        Set-ItemProperty -Path $key1 -Name "$key2" -Value $0 -Type DWORD -Force -Verbose
    }


    ### System
    $22h2 = 22593
    Write-Host ' Showing Details in Task Manager, also setting default tab to Performance'
    If ($BuildNumber -lt $22h2){
        Write-Host ' Showing task manager details'
        $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru -Verbose
        Do {
            Start-Sleep -Milliseconds 100
            $preferences = Get-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -ErrorAction SilentlyContinue
        } Until ($preferences)
        Stop-Process $taskmgr
        $preferences.Preferences[28] = 0
        Set-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -Type Binary -Value $preferences.Preferences -Verbose
        Write-Host ' Setting default tab to Performance'
        Set-ItemProperty -Path $regcv\TaskManager -Name "StartUpTab" -Value $1 -Type DWORD -Verbose
    } else {
        Write-Host " This PC is running 22H2 with a new task manager. Skipping this action."
    }


    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)){
        Write-Host " Skipping"
    } else {
        Write-Host ' Stopping and disabling Home Groups services'
        Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue 
    }
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)){
        Write-Host " Skipping"
    } else {
        Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue 
    }

    If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped'){
        Write-Host " Skipping"
    } else {
        Write-Host ' Stopping and disabling Superfetch service'
        Stop-Service "SysMain" -WarningAction SilentlyContinue
        Set-Service "SysMain" -StartupType Disabled
    }

    

    If ((Get-ItemProperty -Path HKCU:\Software\Microsoft\MultiMedia\Audio).UserDuckingPreference -eq 3){
        Write-Host " Skipping"
    } else {
        Write-Host ' Setting Sounds > Communications to "Do Nothing"'
        Set-ItemProperty -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD -Verbose
    }

    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
    If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control).SvcHostSplitThresholdInKB -eq $ram){
        Write-Host " Skipping"
    } else {
        Write-Host ' Grouping svchost.exe processes'
        Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram -Force -Verbose
    }

    If ((Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters).IRPStackSize -eq 30){
        Write-Host " Skipping"
    } else {
        Write-Host ' Increasing stack size up to 30'
        Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30 -Verbose
        
    }

    
    If ($vari -eq 2){
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Force -Verbose
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Force -Verbose
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Force -Verbose
        Remove-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Force -Verbose
        Remove-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Force -Verbose
        Set-Service "DiagTrack" -StartupType Automatic -Verbose
        Set-Service "dmwappushservice" -StartupType Automatic -Verbose
        Set-Service "SysMain" -StartupType Automatic -Verbose
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" -Verbose 
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" -Verbose 
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" -Verbose 
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" -Verbose 
        Enable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" -Verbose 
        Enable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" -Verbose
        }

    Write-Host "$frmt Registry changes $regjob $frmt"
}
Function Registry {
    $WindowTitle = "New Loads - Registry" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; 
    Write-Host "$frmt Applying Registry Changes $frmt"
    

    If ($BuildNumber -lt $WantedBuild) {            ## Windows 10

        Write-Host " Applying Windows 10 Specific Registry Keys`n"
        Write-Host ' Changing Searchbox to Icon Format on Taskbar'
        Set-ItemProperty -Path $regcv\Search -Name "SearchboxTaskbarMode" -Value 1 -Verbose
        Write-Host ' Removing Cortana Icon from Taskbar'
        Set-ItemProperty -Path $regexadv -Name "ShowCortanaButton" -Value 0 -Verbose
        
        Write-Host ' Pinning Task View Icon'
        Set-ItemProperty -Path $regexadv -Name "ShowTaskViewButton" -Value 0 -Verbose
        
        If (Test-Path -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"){
            Write-Host ' Hiding 3D Objects icon from This PC'
            Remove-Item -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -Verbose
        }

        If ((Get-ItemProperty -Path $regex\Ribbon).MinimizedStateTabletModeOff -eq 1) { 
            Write-Host ' Expanding Ribbon in Explorer'
            Set-ItemProperty -Path $regex\Ribbon -Name "MinimizedStateTabletModeOff" -Value 0 -Verbose
        }

        Write-Host ' Disabling Feeds open on hover'
        If (!(Test-Path -Path $regcv\Feeds)){
            New-Item -Path $regcv -Name "Feeds" -Verbose
        }
        Set-ItemProperty -Path $regcv\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 -Verbose
    

    }

    if ($BuildNumber -gt $WantedBuild) {            ## Windows 11
        
        Write-Host " Applying Windows 11 Specific Registry Keys`n"

    
        Write-Host ' Removing Chat from taskbar'
        Set-ItemProperty -Path $regexadv -Name "TaskBarMn" -Value 0 -Verbose
    
        Write-Host ' Removing "Meet Now" button from taskbar'
        If (!(Test-Path -Path $regcv\Policies\Explorer)) {
            New-Item -Path $regcv\Policies\Explorer -Force -Verbose
        }
        Set-ItemProperty -Path $regcv\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value 1 -Verbose
        
            
    }
    

    # Checks current value for Game mode and E.
    $key1 = "HKCU:\Software\Microsoft\GameBar"
    $key2 = "AutoGameModeEnabled"
    $agme = (Get-ItemProperty -Path $key1).$key2
    If ($agme -eq 1){
        Write-Host " Game Mode is already enabled."
    } else {
        Write-Host " Enabling Game Mode"
        Set-ItemProperty -Path $key1 -Name $key2 -Value 1 -Verbose -Force
    }

    Write-Host " Removing Unnecessary printers"
    Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction SilentlyContinue -Verbose
    Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue -Verbose 
    Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue -Verbose

    ### Explorer related

    Write-Host ' Disabling Show Recent in Explorer Menu'
    Set-ItemProperty -Path $regex -Name "ShowRecent" -Value 0 -Verbose
        
    Write-Host ' Disabling Show Frequent in Explorer Menu'
    Set-ItemProperty -Path $regex -Name "ShowFrequent" -Value 0 -Verbose

    Write-Host ' Enabling Snap Assist Flyout'
    Set-ItemProperty -Path $regexadv -Name "EnableSnapAssistFlyout" -Value 1 -Verbose

    Write-Host ' Enabling File Extensions'
    Set-ItemProperty -Path $regexadv -Name "HideFileExt" -Value 0 -Verbose

    Write-Host ' Setting Explorer Launch to This PC'
    Set-ItemProperty -Path $regexadv -Name "LaunchTo" -Value 1 -Verbose
    
    Write-Host ' Adding User Files to desktop'
    Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0 -Verbose
    
    Write-Host ' Adding This PC icon to desktop'
    Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Verbose

    Write-Host ' Showing file operations details'
    If (!(Test-Path "$regex\OperationStatusManager")) {
        New-Item -Path "$regex\OperationStatusManager" -Verbose
    }
    Set-ItemProperty -Path "$regex\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value 1 -Verbose







    ### Privacy
    Write-Host ' Disabling Content Delivery Related Setings'

    If (!(Test-Path -Path $regcdm)){
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ContentDeliveryManager" -Verbose
    }
    Set-ItemProperty -Path $regcdm -Name "ContentDeliveryAllowed" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "OemPreInstalledAppsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "PreInstalledAppsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "PreInstalledAppsEverEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SilentInstalledAppsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContentEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-310093Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-338387Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-338388Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-338389Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-338393Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-353694Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-353696Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SubscribedContent-353698Enabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SystemPaneSuggestionsEnabled" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regcdm -Name "SoftLandingEnabled" -Type DWORD -Value 0 -Verbose
    If (Test-Path -Path $regcdm\Subscriptionn){
        Remove-Item -Path $regcdm\Subscriptionn -Recurse -Force -Verbose
    }
    If (Test-Path -Path $regcdm\SuggestedApps){
        Remove-Item -Path $regcdm\SuggestedApps -Recurse -Force -Verbose
    }
    Write-Host ' Disabling Advertiser ID'
    Set-ItemProperty -Path $regadvertising -Name "DisabledByGroupPolicy" -Value 1 -Type DWORD -Verbose
    Set-ItemProperty -Path $regadvertising -Name "Enabled" -Value 0 -Type DWORD -Verbose

    Write-Host ' Disabling App Launch Trackin'
    If (!(Test-Path -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI)){
        New-Item -Path:HKCU:\Software\Policies\Microsoft\Windows -Name "EdgeUI" -Verbose
    }
    Set-ItemProperty -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value 1 -Type DWORD -Verbose

    Write-Host ' Disabling Contact Harvesting'
    Set-ItemProperty -Path $reginp\TrainedDataStore -Name "HarvestContacts" -Value 0 -Verbose

    Write-Host ' Declining Microsoft Privacy Policy'
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\Personalization\Settings -Name "AcceptedPrivacyPolicy" -Value 0 -Verbose

    Write-Host ' Restricting Ink and Text Collection'
    Set-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Value 1 -Verbose
    Set-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Value 1 -Verbose
    
    Write-Host ' Disabling Feedback'

    If (!(Test-Path -Path:HKCU:\Software\Microsoft\Siuf)) { 
        New-Item -Path:HKCU:\Software\Microsoft -Name "Siuf" -Verbose
    }
    If (!(Test-Path -Path $siufrules)) {
    New-Item -Path HKCU:\Software\Microsoft\Siuf -Name "Rules" -Verbose
    }
    Stop-Service "DiagTrack" -WarningAction SilentlyContinue -Verbose
    Set-Service "DiagTrack" -StartupType Disabled -Verbose
    Set-ItemProperty -Path $siufrules -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $siufrules -Name "PeriodInNanoSeconds" -Type QWORD -Value 0 -Verbose

    Write-Host ' Disabling Windows Feedback Notifications'
    Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value 1 -Verbose
    
    Write-Host ' Disabling Activity History'

    Set-ItemProperty -Path $regsys -Name "EnableActivityFeed" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regsys -Name "PublishUserActivities" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $regsys -Name "UploadUserActivities" -Type DWORD -Value 0 -Verbose

    Write-Host ' Disabling Location Tracking'
    If (!(Test-Path -Path:$regcam)) {
        New-Item -Path:$regcam -Force -Verbose
    }
    Set-ItemProperty -Path "$regcam" -Name "Value" -Type String -Value "Deny" -Verbose
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path "$lfsvc" -Name "Status" -Type DWORD -Value 0 -Verbose

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
    If (!(Test-Path -Path $wifisense\AllowWiFiHotSpotReporting)) {
        New-Item -Path $wifisense\AllowWiFiHotSpotReporting -Force -Verbose
    }
    Set-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value 0 -Verbose
    Set-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value 0 -Verbose

    If (!(Test-Path -Path $cloudcontent)) {
    New-Item -Path $cloudcontent -Force -Verbose
    }
    Set-ItemProperty -Path $cloudcontent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value 1 -Verbose

    $key1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
    $key2 = "TailoredExperiencesWithDiagnosticDataEnabled"
    $defaultvalue = (Get-ItemProperty -Path $key1).TailoredExperiencesWithDiagnosticDataEnabled
    $wantedvalue = 0
    If ($defaultvalue -eq $wantedvalue){
        Write-Host " Value doesn't need to be changed"
    } else {
        Set-ItemProperty -Path $key1 -Name "$key2" -Value 0 -Type DWORD -Force -Verbose
    }


    ### System
    
    Write-Host ' Showing Details in Task Manager, also setting default tab to Performance'
    If ($BuildNumber -lt $22h2){
        Write-Host ' Showing task manager details'
        $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru -Verbose
        Do {
            Start-Sleep -Milliseconds 100
            $preferences = Get-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -ErrorAction SilentlyContinue
        } Until ($preferences)
        Stop-Process $taskmgr
        $preferences.Preferences[28] = 0
        Set-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -Type Binary -Value $preferences.Preferences -Verbose
        Write-Host ' Setting default tab to Performance'
        Set-ItemProperty -Path $regcv\TaskManager -Name "StartUpTab" -Value 1 -Type DWORD -Verbose
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
Function Notify([string]$arg) {
    $Miliseconds=50000
    $Text=$arg
    $Title="Attention Technician"
    
    Add-Type -AssemblyName System.Windows.Forms 
    $global:balloon = New-Object System.Windows.Forms.NotifyIcon
    $path = (Get-Process -id $pid).Path
    $balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
    $balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info 
    $balloon.BalloonTipText = "$Text"
    $balloon.BalloonTipTitle = "$Title" 
    $balloon.Visible = $true 
    $balloon.ShowBalloonTip($Miliseconds)
    
}
Function Reboot {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null
    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null
    $TimeStart = Get-Date
    $TimeEnd = $timeStart.addminutes(360)
    Do
    {
        $TimeNow = Get-Date
        if ($TimeNow -ge $TimeEnd)
        {
            
            Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue
            Remove-Event click_event -ErrorAction SilentlyContinue
            [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
            [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
            Exit
        }
        else
        {
            $Balloon = new-object System.Windows.Forms.NotifyIcon
            $path = (Get-Process -id $pid).Path
            $Balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
            $Balloon.BalloonTipText = "New Loads Completed. Please Restart Computer."
            $balloon.BalloonTipTitle = "New Loads" 
            $Balloon.BalloonTipIcon = "Warning"
            $Balloon.Visible = $true;
            $Balloon.ShowBalloonTip(20000);
            $Balloon_MouseOver = [System.Windows.Forms.MouseEventHandler]{ $Balloon.ShowBalloonTip(20000) }
            $Balloon.add_MouseClick($Balloon_MouseOver)
            Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue
            Register-ObjectEvent $Balloon BalloonTipClicked -sourceIdentifier click_event -Action {
                Add-Type -AssemblyName Microsoft.VisualBasic
                
                If ([Microsoft.VisualBasic.Interaction]::MsgBox('Would you like to reboot your machine now?', 'YesNo,MsgBoxSetForeground,Question', 'New Loads') -eq "NO")
                { }
                else
                {
                    Restart-Computer -Force
                }
                
            } | Out-Null
            
            Wait-Event -timeout 7200 -sourceIdentifier click_event > $null
            Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue
            $Balloon.Dispose()
        }
    
    }
    Until ($TimeNow -ge $TimeEnd)
}
Function EmailLog{

    $auto = "New Loads Automated"
    $versionrun = $auto
    $dtwritten = (Get-Date)
    $user = $env:USERNAME
    $compname = $env:COMPUTERNAME
    
    $newloads = "$env:temp" + "\New Loads\"
    $attachlog = (Get-ChildItem -Path "$env:temp\New Loads\" -Recurse -Filter "New Loads*.txt").Name
	$attachlog = "$newloads" + "$attachlog"
	
    $html = "$newloads" + "ProgList.html"
    $proglist = "$newloads" + "ProgList.txt"
    
    
    Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "$versionrun Log - Generated at $dtime" -Attachments $attachlog , $html , $proglist -Priority High -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -Verbose -ErrorAction SilentlyContinue -Body "This script was run in $versionrun mode on $dtwritten.. The Computer it was run on was named $compname with a username $user.
    
    Script Results at a glance:
    
    Applications Installed: $appsyns
    [$chromeyns] Chrome
    [$vlcyns] VLC Media Player
    [$adobeyns] Adobe Acrobat DC
    [$zoomyns] Zoom
    
    Visuals: [$visualsyn]
    OEM Applied: $oemyn
    
    Functions Run:
    Debloat: $debloatyns
    OneDrive: $onedriveyns"
}
    
Function RestorePoint {
    $desc = "Mother Computers Courtesy Restore Point"
    If ((Get-ComputerRestorePoint).Description -eq $desc){
    Write-Host "$desc found. Skipping."
    } else {
    
    Write-Host " Enabling System Restore"
    Enable-ComputerRestore -Drive "C:\"
    
    Write-Host " `n Creating Courtesy Restore Point"
    Checkpoint-Computer -Description "$desc" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    }
}


Function Cleanup {
    $WindowTitle = "New Loads - Cleanup" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Finishing Up $frmt"

    Write-Host ' Changing On AC Sleep Settings'
    powercfg -change -standby-timeout-ac "60"
    powercfg -change -monitor-timeout-ac "45"        
    Write-Host ' Changing On Battery Sleep Settings'
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"

    

    

    If (!((Get-Process -Name explorer -ErrorAction SilentlyContinue).Id)){
        Start-Process Explorer -Verbose
        Write-Host " Explorer Started"
    }

    Write-Host ' Enabling F8 boot menu options'
    bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null

    
    Write-Host " Checking Windows Activation Status.."
    $Status = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object PartialProductKey).LicenseStatus
    If ($Status -ne 1) {Write-Warning " Windows is not activated" ; slui 3} else {Write-Host "Windows is Activated. Proceeding"}

    #Checks if BitLocker is enabled, if so it prompts user to ask if they'd like to disable & decrypt the hard drive.
    #This process works in the background.
    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq $blstat){
        Write-Warning " Bitlocker seems to be enabled. Would you like to disable it and start the decryption process?."
        [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
        $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('BitLocker seems to be enabled. Would you like to disable it?','New Loads','YesNo','Question')
        switch  ($msgBoxInput) {
        'Yes' {
            manage-bde -off "C:"
            Write-Host " Drive will continue to decrypt in the background."
        }
        'No'{
            Write-Host " Leaving BitLocker enabled."
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

    If (Test-Path $Zoomsc){
        Remove-Item -path $Zoomsc -force -verbose
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
Function NewLoadsCleanup {
    If (!(Test-Path $Newloads)){
        Write-Host " New Loads temp folder does not exist.`n Skipping"

    }
    Write-Warning " Cleaning up temporary files used by New Loads."
    Start-Sleep -s 4
    Remove-Item "$newloads" -Recurse -Force -Verbose
}
Function RebootComputer {
    Write-Host " Script Completed. Please reboot computer."
    Start-Process Powershell -WindowStyle Hidden -ArgumentList '-Command iwr -useb "https://raw.githubusercontent.com/circlol/newload/main/Assets/AskToReboot.ps1" | iex'
}

$newlog = "$newloads" + "New Loads *.txt"
If (Test-Path $newlog){
    Remove-Item $NewLog -Force
}
Start-Transcript -LiteralPath "$log"
$health = 100
$wantedreason = "OK"
If ($reason -eq $wantedreason){
    Write-Host "`n`n================================================================================================`n`n"
    Write-Host " New Loads`n" #-ForegroundColor Cyan
    Write-Host " New Loads Version : $programversion"
    Write-Host " Script Intregity: $Health%`n"
    Write-Host " Ideally run updates before continuing with this program." -ForegroundColor Red
    Write-Host "`n`n================================================================================================`n`n`n"
} else {
    Write-Host "`n`n================================================================================================`n`n"
    Write-Host " New Loads`n" #-ForegroundColor Cyan
    Write-Host " New Loads Version : $programversion"
    Write-Host " Script Intregity: $Health%`n`n"
    Write-Host " Error Message: $reason`n`n" -ForegroundColor DarkRed
    Write-Host " Ideally run updates before continuing with this program." -ForegroundColor Red
    Write-Host "`n`n================================================================================================`n`n`n"
}
ProgList
Programs
Visuals
OEMInfo
StartMenu
#Registry
AdvRegistry -Action Apply
OneDrive
Debloat
Cleanup
RestorePoint
Stop-Transcript
EmailLog
#Notify("Script has Completed. Please Reboot Computer.")
Write-Host "New Loads Completed.`nExiting."
RebootComputer
NewLoadsCleanup
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