#requires -runasadministrator
Write-Host "Initializing New Loads"
$WindowTitle = "New Loads - Initializing" ; $host.UI.RawUI.WindowTitle = $WindowTitle
#Install-Module -Name BurntToast -Force
$StartTime = $(get-date)
$programversion             = "22724"

If (!([System.Environment]::Is64BitOperatingSystem -eq $true)){
    Write-Host "ERROR: System is not running a 64-Bit Operating System" -ForegroundColor Red
    Start-Sleep -Seconds 4
    Exit
}

$1909                       = "19000"
#$1809                       = "17763"
#$2004                       = "19041"
$20H2                       = "19042" 
#$21H1                       = "19043"
$Win11                      = "22000"
$22H2                       = "22593"
$BuildNumber                = [System.Environment]::OSVersion.Version.Build
#$BuildNumber                = [int]$BuildNumber

If ($BuildNumber -lt $1909){
    Write-Host "ERROR: Windows out of date. Cannot run on devices with builds older than 2004." -ForegroundColor Red
    Start-Sleep -Seconds 4
    Exit
}

If ($BuildNumber -lt $20H2){
    Write-Host "Warning: This computer is running a build older than 1 year.. Running your Updates is " -NoNewline -ForegroundColor Yellow ; Write-Host "STRONGLY RECOMMENDED" -ForegroundColor RED
    Start-Sleep -Seconds 10
}


try {
    stop-transcript|out-null
    }
    catch [System.InvalidOperationException]{}


$newloads                   = "$env:UserProfile\AppData\Local\Temp\New Loads\"
$log                        = "$newloads" + "New Loads Log.txt"
$newlog                     = "$newloads" + "New Loads *.txt"


#$jc                         = "`n Task completed. Ready for next input`n"
$health                     = 100
$wantedreason               = "OK"
$frmt                       = "`n`n========================================`n`n"
$blstat                     = "on"              #Bitlocker Value
$reason                     = "OK"
#$s                          = 'SKIPPED'
#$n                         = 'X'
$y                          = '√'

$path86                     = "C:\Program Files (x86)\Microsoft Office"
$path64                     = "C:\Program Files\Microsoft Office 15"
$officecheck                = $false
$office32                   = $false
$office64                   = $false
$SaRA                       = $newloads + "SaRA.Zip"
$Sexp                       = $newloads + "SaRA"

##########
## APPS ##
##########

$package1                   = "googlechromestandaloneenterprise64.msi"
$package2                   = "vlc-3.0.17-win64.msi"
$package3                   = "ZoomInstallerFull.msi"
$package4                   = "AcroRdrDCx642200120085_MUI.exe"

$oi                         = ".\Offline Installers\"
$gcoi                       = $oi + $package1
$vlcoi                      = $oi + $package2
#$zoomoi                    = $oi + $package3
$aroi                       = $oi + $package4

$package1lc                 = $newloads + $package1
$package2lc                 = $newloads + $package2
$package3lc                 = $newloads + $package3
$package4lc                 = $newloads + $package4

$package1dl                 = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$package2dl                 = "https://github.com/circlol/newload/raw/main/Assets/BAF/vlc-3.0.17-win64.msi"
$package3dl                 = "https://zoom.us/client/5.10.4.5035/ZoomInstallerFull.msi?archType=x64"
$package4dl                 = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2200120085/AcroRdrDCx642200120085_MUI.exe"

$location1                  = $Env:PROGRAMFILES + "\Google\Chrome\Application\chrome.exe"
$location2                  = $Env:PROGRAMFILES + "\VideoLAN\VLC\vlc.exe"
$location3                  = $Env:PROGRAMFILES + "\Zoom\bin\Zoom.exe"
$location4                  = $Env:PROGRAMFILES + "\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
$webadvisor                 = "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe"
$WildGames                  = "C:\Program Files (x86)\WildGames\Uninstall.exe"
$livesafe                   = "C:\Program Files\McAfee\MSC\mcuihost.exe"

$acrosc                     = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
$edgescpub                  = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
$vlcsc                      = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
$zoomsc                     = "$Env:PUBLIC\Desktop\Zoom.lnk"
$EdgeShortcut               = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
#$onedrivelocation           = "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe"
$temp                       = "$Env:temp"
$ctemp                      = "C:\Temp"

$chromeyns                  = $y
$adobeyns                   = $y
$vlcyns                     = $y
$zoomyns                    = $y
$debloatyns                 = $y
$onedriveyns                = $y


################
## WALLPAPERS ##
################

$wallpaper                  = "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg"
$currentwallpaper           = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper
$sysmode                    = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme
$appmode                    = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme

###################
## REGISTRY KEYS ##
###################
$lfsvc                      = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
$wifisense                  = "HKLM:\Software\Microsoft\PolicyManager\default\WiFi"
$regcam                     = "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
$regexlm                    = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$regsys                     = "HKLM:\Software\Policies\Microsoft\Windows\System"

#$regpersonalize             = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$siufrules                  = "HKCU:\Software\Microsoft\Siuf\Rules"
$reginp                     = "HKCU:\Software\Microsoft\InputPersonalization"
$regcv                      = "HKCU:\Software\Microsoft\Windows\CurrentVersion"
$regadvertising             = "$regcv" + "\AdvertisingInfo"
$regcdm                     = "$regcv" + "\ContentDeliveryManager"
$regex                      = "$regcv" + "\Explorer"
$regexadv                   = "$regcv" + "\Explorer\Advanced"
$regsearch                  = "$regcv" + "\Search"

$unviewdest                 = $newloads + "unview.exe"
$list                       = $newloads + "ProgList.txt"
$html                       = "C:\ProgList.html"
$link                       = "https://github.com/circlol/newload/raw/main/Assets/unview.exe"


If (!(Test-Path -Path:"$newloads")){
    New-Item -Path:"$Env:Temp" -Name:"New Loads" -ItemType:Directory -Force | Out-Null
}
Function ProductConfirmation {
    $processor = (Get-ComputerInfo).CsProcessors.Name
    $product = (Get-WmiObject win32_baseboard).Product
    $gpuname = (Get-WmiObject win32_videocontroller).Name
    $gpudesc = (Get-WmiObject win32_videocontroller).Description
    #systeminfo | Select-String  'BIOS Version', 
    #                            'Network Card(s)', 
    #                            'OS Name', 
    #                            'OS Version', 
    #                            'System Manufacturer', 
    #                            'System Model', 
    #                            'System Type', 
    #                            'Time Zone'
    
    Write-Host "`nCPU: $processor"
    Write-Host "Motherboard: $product"
    Write-Host "GPU Name: $gpuname"
    Write-Host "GPU Description: $gpudesc"    
    Write-Host " RAM INFORMATION"
    Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Select-Object 'Manufacturer', 
                                                                                'DeviceLocator', 
                                                                                'PartNumber', 
                                                                                'ConfiguredClockSpeed'
    ''    
    systeminfo | Select-String  'Total Physical Memory'
    Write-Host "`n Generating Hard Drive Report`n"
    Write-Host " Double check all drives that should be with this computer are connected." -ForegroundColor RED
    $size = 60GB
    Get-Volume | Where-Object {$_.Size -gt $Size} | Sort-Object {$_.DriveLetter} | Out-Host
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
        } else{
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
            Start-Sleep -Milliseconds 300
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

        } else{
            Write-Host "`n`n Downloading $Package4" 
            Start-BitsTransfer -Source $Package4dl -Destination $package4lc
            Check
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

    #Write-Host " Generating Program List $frmt"
    If (!(Test-Path -Path "$newloads")){
        New-Item -Path "$Env:Temp" -Name:"New Loads" -ItemType:Directory -Force
    }

    If (Test-Path -Path "$html"){
        Remove-Item -Path $html -Force -Verbose
    }
    If (Test-Path -Path "$list"){
        Remove-Item -Path "$list" -Force -Verbose
    }
    
    If (!(Test-Path -Path "$unviewdest")){
        #Write-Host " Unview not found, Downloading." >> $list
        Start-BitsTransfer -Source "$link" -Destination "$unviewdest"
        Start-Process "$unviewdest" -ArgumentList "/shtml $html"
        } Else {
        #Write-Host " Running Uninstall View by NirSoft"
        Start-Process "$unviewdest" -ArgumentList "/shtml $html"
    }
    
    #Generating a win32 product list 
    #Write-Host " Generating an alphabetical list of all win32 applications`n" >> $list
    (Get-WmiObject win32_product).Name | Sort-Object >> $list
    
    #Write-Host " Adding list of installed Windows Apps to $list`n" ; 
    Write-Output "`n`n Generating list of installed Windows Apps`n Executing Command Get-AppxPackage." >> $list
    (Get-AppxPackage -AllUsers).PackageFamilyName >> $list
    
    If (Test-Path "~\AppData\Local\Microsoft\WindowsApps\winget.exe"){
        #Write-Host " Adding list of Winget Packages to $list" ; 
        Write-Output "`n`n Generating List of Winget Packages" >> $list
        winget list -s winget --accept-source-agreements >> $list
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
    If ($BuildNumber -ge $Win11) {
        Write-Host " Downloading Wallpaper"
        Write-Host " I have detected that you are on Windows 11"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/11.jpg" -Destination $wallpaper -Verbose
    } else {
        If ($BuildNumber -lt $Win11) {
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
    If ((Get-ItemProperty -Path $regoeminfo).Manufacturer -eq "$store"){  Write-Host " Skipping" } else { Set-ItemProperty -Path $regoeminfo -Name "Manufacturer" -Type String -Value "$store" -Verbose }

    $phone = "(250) 479-8561"
    If ((Get-ItemProperty -Path $regoeminfo).SupportPhone -eq $phone){ Write-Host " Skipping" } else { Set-ItemProperty -Path $regoeminfo -Name "SupportPhone" -Type String -Value "$phone" -Verbose }

    $hours = "Monday - Saturday 9AM-5PM | Sunday - Closed" 
    If ((Get-ItemProperty -Path $regoeminfo).SupportHours -eq "$hours"){ Write-Host " Skipping" } else { Set-ItemProperty -Path $regoeminfo -Name "SupportHours" -Type String -Value "$hours" -Verbose }

    $website = "https://www.mothercomputers.com"
    If ((Get-ItemProperty -Path $regoeminfo).SupportURL -eq $website){ Write-Host " Skipping" } else { Set-ItemProperty -Path $regoeminfo -Name "SupportURL" -Type String -Value $website -Verbose }

    $model = "Mother Computers - (250) 479-8561"
    If ((Get-ItemProperty -Path $regoeminfo).Model -eq "$model"){ Write-Host " Skipping" } else { Set-ItemProperty -Path $regoeminfo -Name "Model" -Type String -Value "$Model" }
}
Function StartMenu {
    $WindowTitle = "New Loads - StartMenuLayout.xml" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Pinning Apps to taskbar , Clearing Start Menu Pins. $frmt"

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
    If(Test-Path $layoutFile){Remove-Item $layoutFile}

    #Creates a new layout file
    $StartLayout | Out-File $layoutFile -Encoding ASCII

    $regAliases = @("HKLM", "HKCU")

    #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        If (!(Test-Path -Path $keyPath)) {  New-Item -Path $basePath -Name "Explorer"  }
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
    }

    #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
    If (!(Get-Process Explorer)){
        Start-Process Explorer -Verbose
    } Else {
        Stop-Process -Name Explorer -ErrorAction SilentlyContinue
        Start-Sleep -s 3
        Start-Process Explorer -Verbose
    }
    Start-Sleep -s 4
    $wshell = new-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 4

    #Enable the ability to pin items again by disabling "LockedStartLayout"
    Foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
    }

    #Restart Explorer and delete the layout file
    Stop-Process -name Explorer 

    #the next line makes clean start menu default for all new users
    Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

    Remove-Item $layoutFile -Verbose
    Write-Host "$jc"
}
Function OneDriveRe {
    $WindowTitle = "New Loads - Removing OneDrive" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    If (Test-Path "C:\Windows\SysWOW64\OneDriveSetup.exe" -ErrorAction SilentlyContinue){
        If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue){
            Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
            Write-Host " Found OneDrive in its dirty house, Stopping & Uninstalling."
        }
        Start-Process -FilePath:C:\Windows\SysWOW64\OneDriveSetup.exe -ArgumentList /uninstall -Verbose
        If (Test-Path -Path $env:OneDrive){Remove-Item -Path "$env:OneDrive" -Force -Recurse}
        If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive"){Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse}
        If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp"){Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse}
    }
}
Function Debloat {
    $WindowTitle = "New Loads - Debloating Computer" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Removing Bloatware $frmt "
    
    #WebAdvisor Removal
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue){
        Write-Host " Attemping Removal of McAfee WebAdvisor Uninstall"
        Start-Process "$webadvisor"
    }
    #Preinsatlled on Acer machines primarily WildTangent Games
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue){
        Write-Host " Attemping Removal WildTangent Games"
        Start-Process $WildGames 
    }
    #McAfee Live Safe Removal
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue){
        Write-Host " Attemping Removal of McAfee Live Safe"
        Start-Process "$livesafe"
    }
    
    $commonapps = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs"
    $apps = @(
        "Amazon"
        "Booking.com"
        "Forge of Empires"
        "Planet9 Link"
        )

    ForEach ($app in $apps){
        If (Test-Path -Path "$commonapps\$app.url"){
                Write-Host "$app was found. Removing" -ForegroundColor Green
                Remove-Item -Path "$commonapps\$app.url" -Force -Verbose
            } else {
                Write-Host "$app not found" -ForegroundColor Yellow
            }
        }

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
        "Microsoft.WindowsMaps"
        )
        #$provpkg = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\PackageState\S-1-5-21-3668021648-1202156387-2837978000-1001"
        Foreach ($Program in $Programs) {
            If (Get-AppxPackage -Name $program){
                Write-Host " Attempting to remove package $Program." -ForegroundColor Yellow
                Get-AppxPackage -Name $Program | Remove-AppxPackage | Out-Host
                If ($?){Write-Host "$Program was successfully removed for this account $env:COMPUTERNAME\$env:USERNAME" -ForegroundColor Green
                } else {Write-Host "$Program was successfully removed for this account $env:COMPUTERNAME\$env:USERNAME" -ForegroundColor Red
                }
                Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Host
                If ($?){Write-Host "$Program was successfully debloated from future accounts" -ForegroundColor Green
                } else { Write-Host "$Program was unsuccessfully debloated from future accounts" -ForegroundColor Red
                }
            } else {
            Write-Host "$Program not found" -ForegroundColor Yellow
            }
        }
    }
    Function OfficeCheck {
        Write-Host "`n`n Checking for Office "
        If (Test-Path "$path64")    {    $office64 = $true}             Else {    $office64 = $false}
        If (Test-Path "$path86")    {    $Office32 = $true}             Else {    $office32 = $false}
        If ($office32 -eq $true)    {    $officecheck = $true}       
        If ($office64 -eq $true)    {    $officecheck = $true}    
        If ($officecheck -eq $true) {    Write-Host " Office Exists"}   Else {    Write-Host " Office does not exist"}
        If ($officecheck -eq $true) {    Office_Removal_AskUser}
    }
Function Registry {
    $WindowTitle = "New Loads - Applying Registry" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt $title Registry Changes $frmt"
    Write-Host " Applying"

    Write-Host " Removing Unnecessary printers"
    Remove-Printer -Name "Microsoft XPS Document Writer" -ErrorAction SilentlyContinue -Verbose
    Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue -Verbose 
    Remove-Printer -Name "OneNote" -ErrorAction SilentlyContinue -Verbose

    If ($BuildNumber -lt $Win11) {            ## Windows 10
        Write-Host " $title Windows 10 Specific Registry Keys`n"
        ## Changes search box to an icon
        Write-Host ' Changing Searchbox to Icon Format on Taskbar' ; Set-ItemProperty -Path $regsearch -Name "SearchboxTaskbarMode" -Value 1 
        ## Removes Cortana from the taskbar
        Write-Host ' Removing Cortana Icon from Taskbar' ; Set-ItemProperty -Path $regexadv -Name "ShowCortanaButton" -Value 0 
        ## Unpins taskview from Windows 10 Taskbar
        Write-Host ' Unpinning Task View Icon' ; Set-ItemProperty -Path $regexadv -Name "ShowTaskViewButton" -Value 0 
        ##  Hides 3D Objects from "This PC"
        Write-Host ' Hiding 3D Objects icon from This PC' ; Remove-Item -Path "$regexlm\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse  -EA SilentlyContinue

        ## Expands explorers ribbon
        If (!(Test-Path -Path $regex\Ribbon)){
            New-Item -Path "$regex" -Name "Ribbon" -Force 
        }
        Write-Host ' Expanding Ribbon in Explorer' ; Set-ItemProperty -Path $regex\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value 0 

        ## Disabling Feeds Open on Hover
        If (!(Test-Path -Path $regcv\Feeds)){
            New-Item -Path $regcv -Name "Feeds" 
        }
        Write-Host ' Disabling Feeds open on hover' ; Set-ItemProperty -Path $regcv\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 
        
        
        #Disables live feeds in search
        If (!(Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB")){
            New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "DSB" -Force 
        }
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "ShowDynamicContent" -Value 0 -type DWORD -Force 
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value 0 -Type DWORD -Force         
    }

    If ($BuildNumber -gt $Win11) {            ## Windows 11
        Write-Host " $title Windows 11 Specific Registry Keys`n"

        #Write-Host " Checking Network Information" | Out-File $Log
        #Invoke-RestMethod -Uri ('http://ipinfo.io/'+(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content) > $log 2>&1

        #Sets start layout to show more pins.
        If ($BuildNumber -gt $22H2){ 
            Write-Host " Setting Start Menu to Show More Pins" ; Set-ItemProperty -Path $regexadv -Name Start_Layout -Value 1 -Type DWORD -Force 
        }
        
        Write-Host " Removing Chats from taskbar" ; Set-ItemProperty -Path $regexadv -Name "TaskBarMn" -Value 0 

        If (!(Test-Path $regcv\Policies\Explorer)){ New-Item $regcv\Policies\ -Name Explorer -Force}
        Write-Host ' Removing "Meet Now" button from taskbar' ; Set-ItemProperty -Path $regcv\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value 1 

    }


    Write-Host " Enabling Game Mode" ; Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1 -Force 

    Write-Host ' Disabling Show Recent in Explorer Menu' ; Set-ItemProperty -Path $regex -Name "ShowRecent" -Value 0 
    
    Write-Host ' Disabling Show Frequent in Explorer Menu' ; Set-ItemProperty -Path $regex -Name "ShowFrequent" -Value 0 

    Write-Host ' Enabling Snap Assist Flyout' ; Set-ItemProperty -Path $regexadv -Name "EnableSnapAssistFlyout" -Value 1 

    Write-Host ' Enabling File Extensions' ; Set-ItemProperty -Path $regexadv -Name "HideFileExt" -Value 0 

    Write-Host ' Setting Explorer Launch to This PC' ; Set-ItemProperty -Path $regexadv -Name "LaunchTo" -Value 1 

    Write-Host ' Adding User Files to desktop' ; Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0

    Write-Host ' Adding This PC icon to desktop' ; Set-ItemProperty -Path $regex\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0

    If (!(Test-Path $regex\OperationStatusManager)){New-Item -Path $regex\OperationStatusManager -Name EnthusiastMode -Type DWORD -Force}

    Write-Host ' Showing file operations details' ; If (!(Test-Path "$regex\OperationStatusManager")) {New-Item -Path "$regex\OperationStatusManager"}
                                                    Set-ItemProperty -Path "$regex\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value 1 
    ### Privacy
    #Write-Host ' Disabling Content Delivery Related Setings'
    If (!(Test-Path -Path $regcdm)){New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "ContentDeliveryManager"}
    If (Test-Path -Path $regcdm\Subscriptionn){Remove-Item -Path $regcdm\Subscriptionn -Recurse -Force}
    If (Test-Path -Path $regcdm\SuggestedApps){Remove-Item -Path $regcdm\SuggestedApps -Recurse -Force}
    
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
        If ((Get-ItemProperty -Path $regcdm).$cdm -eq 1){            Write-Host " Skipping"        } else {
            Write-Host " Setting $cdm to 0"
            Set-ItemProperty -Path $regcdm -Name $cdm -Value 0
        }
    }


    Write-Host ' Disabling Advertiser ID' ;     Set-ItemProperty -Path $regadvertising -Name "DisabledByGroupPolicy" -Value 1 -Type DWORD
                                                Set-ItemProperty -Path $regadvertising -Name "Enabled" -Value 0

    If (!(Test-Path -Path:HKCU:\Software\Policies\Microsoft\Windows\EdgeUI)){ New-Item -Path:HKCU:\Software\Policies\Microsoft\Windows -Name "EdgeUI" }
    Write-Host ' Disabling App Launch Tracking' ; Set-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value 1 -Type DWORD
    
    Write-Host ' Disabling Contact Harvesting' ; Set-ItemProperty -Path $reginp\TrainedDataStore -Name "HarvestContacts" -Value 0

    Write-Host ' Declining Microsoft Privacy Policy' ; Set-ItemProperty -Path:HKCU:\Software\Microsoft\Personalization\Settings -Name "AcceptedPrivacyPolicy" -Value 0

    Write-Host ' Restricting Text Collection' ; Set-ItemProperty -Path $reginp -Name "RestrictImplicitTextCollection" -Value 0

    Write-Host ' Restricting Ink Collection' ; Set-ItemProperty -Path $reginp -Name "RestrictImplicitInkCollection" -Value 0
    
    
    ### Disables Feedback to Microsoft.
    If (!(Test-Path -Path:HKCU:\Software\Microsoft\Siuf)) { 
        New-Item -Path:HKCU:\Software\Microsoft -Name "Siuf"
    }
    If (!(Test-Path -Path $siufrules)) {
        New-Item -Path HKCU:\Software\Microsoft\Siuf -Name "Rules"
    }
    Set-ItemProperty -Path $siufrules -Name "NumberOfSiufInPeriod" -Type DWORD -Value 0
    Set-ItemProperty -Path $siufrules -Name "PeriodInNanoSeconds" -Type QWORD -Value 0
    
    If (!((Get-Service -Name DiagTrack).Status -eq "Disabled")){        Write-Host " Skipping"    } else {
        Stop-Service "DiagTrack" -WarningAction SilentlyContinue
        Set-Service "DiagTrack" -StartupType Disabled
    }    

    


    If ((Get-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection).DoNotShowFeedbackNotifications -eq 1){        Write-Host " Skipping"    } else {
        Write-Host ' Disabling Windows Feedback Notifications' ; Set-ItemProperty -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value 1
    }


    If ((Get-ItemProperty -Path $regsys).EnableActivityFeed -eq 1){        Write-Host " Skipping"    } else {
        Write-Host ' Disabling Activity History' ; Set-ItemProperty -Path $regsys -Name "EnableActivityFeed" -Type DWORD -Value 0
        
    }

    Set-ItemProperty -Path $regsys -Name "PublishUserActivities" -Type DWORD -Value 0 
    Set-ItemProperty -Path $regsys -Name "UploadUserActivities" -Type DWORD -Value 0

    If (!(Test-Path -Path:$regcam)) {New-Item -Path:$regcam -Force}
    
    Write-Host ' Disabling Location Tracking'
    Set-ItemProperty -Path "$regcam" -Name "Value" -Type String -Value "Deny"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWORD -Value 0
    Set-ItemProperty -Path "$lfsvc" -Name "Status" -Type DWORD -Value 0


    If ((Get-ItemProperty -Path HKLM:\System\Maps).AutoUpdateEnabled -eq 0){        Write-Host " Skipping"    } else {
        Write-Host ' Disabling automatic Maps updates' ; Set-ItemProperty -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value 0
    }


    If (!((Get-Service -Name dmwappushservice).Status -eq "Disabled")){        Write-Host " Skipping"    } else {
        Write-Host ' Stopping and disabling WAP Push Service'
        Stop-Service "dmwappushservice" -WarningAction SilentlyContinue
        Set-Service "dmwappushservice" -StartupType Disabled
    }
    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection").AllowTelemetry -eq 0){        Write-Host " Skipping"    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value 0
    }

    If ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection").AllowTelemetry -eq 0){        Write-Host " Skipping"    } else {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWORD -Value 0
    }
    
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" 
    Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" 


    If (!(Test-Path -Path $wifisense\AllowWiFiHotSpotReporting)) {
        New-Item -Path $wifisense\AllowWiFiHotSpotReporting -Force
    }
    If ((Get-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots).Value -eq 0){        Write-Host " Skipping"    } else {
        Write-Host ' Disabling Wi-Fi Sense' ; Set-ItemProperty -Path $wifisense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value 0
    }
    If ((Get-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting).Value -eq 0){        Write-Host " Skipping"    } else {
        Write-Host ' Disabling HotSpot Reporting to Microsoft' ; Set-ItemProperty -Path $wifisense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value 0
    }



    $cloudcontent = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    If (!(Test-Path -Path $cloudcontent)) {
    New-Item -Path $cloudcontent -Force
    }
    If ((Get-ItemProperty -Path $cloudcontent).DisableWindowsConsumerFeatures -eq 1){        Write-Host " Skipping"    } else {
        Set-ItemProperty -Path $cloudcontent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value 1
    }


    $key1 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"
    $key2 = "TailoredExperiencesWithDiagnosticDataEnabled"
    If ((Get-ItemProperty -Path $key1).$key2 -eq 0){        Write-Host " Skipping"    } else {
        Set-ItemProperty -Path $key1 -Name "$key2" -Value 0 -Type DWORD -Force
    }


    ### System
    <#
    If ($BuildNumber -lt $22h2){
        Write-Host ' Showing Details in Task Manager, also setting default tab to Performance'
        $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
        Do {
            Start-Sleep -Milliseconds 100
            $preferences = Get-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -ErrorAction SilentlyContinue
        } Until ($preferences)
        Stop-Process $taskmgr
        $preferences.Preferences[28] = 0
        
        Set-ItemProperty -Path $regcv\TaskManager -Name "Preferences" -Type Binary -Value $preferences.Preferences
        Set-ItemProperty -Path $regcv\TaskManager -Name "StartUpTab" -Value 1 -Type DWORD
    } else {
        Write-Host " This PC is running 22H2 with a new task manager. Skipping this action."
    }
    #>
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)){        Write-Host " Skipping"    } else {
        Write-Host ' Stopping and disabling Home Groups services'
        Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue 
    }
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)){        Write-Host " Skipping"    } else {
        Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue 
    }

    If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped'){        Write-Host " Skipping"    } else {
        Write-Host ' Stopping and disabling Superfetch service'
        Stop-Service "SysMain" -WarningAction SilentlyContinue
        Set-Service "SysMain" -StartupType Disabled
    }

    #Sets Communications tab in Sound to Do Nothing
    Set-ItemProperty -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD 

    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
    Write-Host ' Grouping svchost.exe processes' ; Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram  -Force

    Set-ItemProperty -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30 

    
    Write-Host "$frmt Registry changes completed $frmt"
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
Function EmailLog {
    $automated = "New Loads Automated"
    $auto = $automated
    $versionrun = $auto
    $sysinfo = systeminfo | Sort-Object | Out-File -Append $log -Encoding ascii
    $newloads = "$env:temp" + "\New Loads\"
    $attachlog = (Get-ChildItem -Path "$env:temp\New Loads\" -Recurse -Filter "New Loads*.txt").Name
	$attachlog = "$newloads" + "$attachlog"
	
    $html = "C:\ProgList.html"
    $proglist = "$newloads" + "ProgList.txt"
    
    $ip = (New-Object System.Net.WebClient).DownloadString('http://ifconfig.me/ip')
    $ipinfo = (New-Object System.Net.WebClient).DownloadString('http://ipinfo.io/'+"$ip")

    $chromeloc                  = $Env:PROGRAMFILES + "\Google\Chrome\Application\chrome.exe"
    $vlcloc                  = $Env:PROGRAMFILES + "\VideoLAN\VLC\vlc.exe"
    $adobeloc                  = $Env:PROGRAMFILES + "\Adobe\Acrobat DC\Acrobat\"
    $zoomloc                  = $Env:PROGRAMFILES + "\Zoom\bin\Zoom.exe"

    If (Test-Path -Path "$chromeloc"){
        $chromeyns = "X"
    }else{ 
        $chromeyns = ""
    }
    If (Test-Path -Path "$vlcloc"){
        $vlcyns = "X"
    }else{
        $vlcyns = ""
    }
    If (Test-Path -Path "$adobeloc"){ 
        $adobeyns = "X"
    }else{ 
        $adobeyns = ""
    }
    If (
        Test-Path -Path "$zoomloc"){
        $zoomyns = "X"
    }else{
        $zoomyns = ""
    }


    $elapsedTime = $(get-date) - $StartTime
    $totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    #$WindowsVersion = (Get-Computerinfo).OsName
    $WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption

    Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "$versionrun Log - Generated at $dtime" -Attachments $attachlog , $html , $proglist -Priority High -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -Verbose -ErrorAction SilentlyContinue -Body "
    The script was run in $auto, on a computer for $ip\$env:USERNAME, Completing in $totaltime
    
    Windows Version: $WindowsVersion, $DisplayVersion
    Script Version: $programversion
    Script Start Time: $Starttime
    Script End Time: $elapsedtime
    
    Script Log $dtime.txt
    
    System Information
    xxxxxx


    Applications Installed: $appsyns
    [$chromeyns] Chrome
    [$vlcyns] VLC Media Player
    [$adobeyns] Adobe Acrobat DC
    [$zoomyns] Zoom
    
    Visuals: [$visualsyn]
    OEM Applied: $oemyn
    
    Functions Run:
    Debloat: $debloatyns
    OneDrive: $onedriveyns

    Network Information of this PC: 
    $ipinfo"
}
Function Office_Removal_AskUser{
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('Office Detected on this computer, Would you like to remove it?','New Loads','YesNo','Question')

    switch  ($msgBoxInput) {
    
        'Yes' {
            Start-BitsTransfer -Source:https://aka.ms/SaRA_CommandLineVersionFiles -Destination:"$SaRA" #-Verbose
            Expand-Archive -Path "$SaRA" -DestinationPath "$Sexp" -Force -Verbose 
            If($?){
                Write-Host " Extracted Successfully"
            }
            Write-Host " This program takes a few minutes to run. However it removes all Office 16 versions."
            Start-Process "$Env:temp\New Loads\SaRA\SaRAcmd.exe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -Officeversion All -CloseOffice" -Wait -Verbose -NoNewWindow | Out-Host
            }
    
        'No' {
            Write-Host " Leaving Office Alone"
        }
    }
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
    $WindowTitle = "New Loads - Cleanup" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Finishing Up$frmt"
    $app = 'Explorer'
    If (!(Get-Process -Name $app -ErrorAction SilentlyContinue)){
        Write-Host " $app not found. Restarting."
        Start-Process $app -Verbose
    } else {
        Write-Host " Restarting $app"
        taskkill /f /im "$app.exe"
        Start-Sleep -Seconds 2
        Start-Process $app 
    }
    Write-Host ' Changing On AC Sleep Settings'
    powercfg -change -standby-timeout-ac "60"
    powercfg -change -monitor-timeout-ac "45"        
    Write-Host ' Changing On Battery Sleep Settings'
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"
#    Disabled - Does not work on UEFI computers. Useless for the store.
    Write-Host ' Enabling F8 boot menu options'
    bcdedit /set {bootmgr} displaybootmenu yes | Out-Null
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    


	Write-Host " Checking Windows Activation Status.."
    #WAS = Windows Activation Status
    $WAS = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object PartialProductKey).LicenseStatus
    If ($WAS -ne 1) {Write-Warning " Windows is not activated" ; Start-Sleep -Milliseconds 125 ; Start-Process slui -ArgumentList '3'} else {Write-Host "Windows is Activated. Proceeding"}
    

	
    #A112
    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq $blstat){
        Write-Warning " Bitlocker seems to be enabled. Would you like to start the decryption process?."
        ###Requires -RunSilent
    
        [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null 
        $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('BitLocker seems to be enabled. Would you like to disable it?','New Loads','YesNo','Question')
        switch  ($msgBoxInput) {
        'Yes' {
            manage-bde -off "C:"
            Write-Host " Continuing task in background."
        }
        'No'{
            Write-Host " Moving on."
        }
    
        }
    }


    If (Test-Path $zoomsc){
        Remove-Item -path $zoomsc -force -verbose
    }
    Start-Process Chrome
    If (Test-Path $vlcsc) { 
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $acrosc) { 
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    
    }


    Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL

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
    $WindowTitle = "New Loads"

}
Function NewLoadsCleanup {
    If (!(Test-Path $Newloads)){
        Write-Host " New Loads temp folder does not exist.`n Skipping"

    }
    Write-Warning " Cleaning up temporary files used by New Loads."
    Remove-Item "$newloads" -Recurse -Force -Verbose 

    If (Test-Path C:\ProgList.html){
        Remove-Item C:\ProgList.html -Force -Confirm:$false -ErrorAction SilentlyContinue -Verbose
    }
}
Function Check {
    If($?){
        Write-Host " Successful"
    } else {
        Write-Warning " Unsuccessful"
    }
}
Function RebootComputer {
    Write-Host " Script Completed. Please reboot computer."
    Start-Process Powershell -WindowStyle Hidden -ArgumentList '-Command iwr -useb "https://raw.githubusercontent.com/circlol/newload/main/Assets/AskToReboot.ps1" | iex'
}

If (Test-Path $newlog){
    Remove-Item $NewLog -Force
}
Start-Transcript -LiteralPath "$log"

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



ProductConfirmation
ProgList
Programs
Visuals
OEMInfo
StartMenu
Registry
#AdvRegistry -Action Apply
OneDrivere
Debloat
OfficeCheck
Cleanup
RestorePoint
Stop-Transcript
$EndTime = $(get-date)
Start-Sleep -s 3
EmailLog
Start-Sleep -s 3
#Notify("Script has Completed. Please Reboot Computer.")
#NewLoadsCleanup
RebootComputer
Write-Host " New Loads Completed."
Write-Host "`n Exiting"
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