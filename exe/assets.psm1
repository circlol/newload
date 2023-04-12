$Global:BackgroundColor = "Black"
$Global:ForegroundColor = "DarkCyan"
Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor $ForegroundColor -Backgroundcolor $BackgroundColor
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "]`n" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "> " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionFailed() {
    [CmdletBinding()]
    param (
        [String] $Text = "Failed"
    )
    Write-Host "==" -ForegroundColor Red -BackgroundColor $BackgroundColor -NoNewline
    Write-Host "> " -NoNewline -ForegroundColor DarkRed -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionSucceed() {
    [CmdletBinding()]
    param (
        [String] $Text = "Success"
    )
    Write-Host "==" -NoNewline -ForegroundColor Green -BackgroundColor $BackgroundColor
    Write-Host "> " -NoNewline -ForegroundColor DarkGreen -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionWarning() {
    [CmdletBinding()]
    param (
        [String] $Text = "Warning"
        )
        Write-Host "==" -NoNewline -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        Write-Host "> " -NoNewline -ForegroundColor DarkYellow -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-Section() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-Status() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Array]  $Types,
        [Parameter(Mandatory)]
        [String] $Status,
        [Switch] $Warning,
        [Switch] $NoNewLineLast
    )
        ForEach ($Type in $Types) {
        Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
        Write-Host "$Type" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
        Write-Host "]" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
    If ($Warning) {
        If ($NoNewLine){
            Write-Host "-> $Status" -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        }else{
            Write-Host "-> $Status" -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        }
    } Else {
        If ($NoNewLine){
            Write-Host "-> $Status" -ForegroundColor White -BackgroundColor $BackgroundColor
        }else{
            Write-Host "-> $Status" -ForegroundColor White -BackgroundColor $BackgroundColor
        }
    }
}
Function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text",
        [Switch] $NoNewLineLast
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "<" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-TitleCounter() {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )
    #$Counter += 1
    Write-Host "`n`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "]" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host " (" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host " $Counter/$MaxLength " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ") " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "|" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host " $Text " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function NewLoadsModules() {
    $Modules = (Get-ChildItem -Path ".\lib" -Include "*.psm1" -Recurse).Name
    ForEach ($Module in $Modules) {
    Import-Module .\lib\"$Module" -Force -Global
    }
}
Function Restart-Explorer {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    $explorer = Get-Process -Name explorer -ErrorAction SilentlyContinue
    if ($explorer) {
        try {
            if ($PSCmdlet.ShouldProcess("Stop explorer process")) {
                taskkill /f /im explorer.exe
            }
        }
        catch {
            Write-Warning "Failed to stop Explorer process: $_"
            return
        }
        Start-Sleep -Milliseconds 1500
    }
    try {
        if ($PSCmdlet.ShouldProcess("Start explorer process")) {
            Start-Process explorer -ErrorAction Stop
        }
    }
    catch {
        Write-Error "Failed to start Explorer process: $_"
        return
    }
}
Function NewLoads() {
    $WindowTitle = "New Loads Utility" 
    $host.UI.RawUI.WindowTitle = $WindowTitle
    $wc = New-Object System.Net.WebClient
    CheckNetworkStatus
    $Script = $wc.DownloadString($NewLoadsURL)
    Invoke-Expression $Script

}
function Get-CPU {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Switch] $NameOnly,
        [String] $Separator = '|'
    )
    try {
        $cpuName = (Get-CimInstance -Class Win32_Processor).Name
    }
    catch {
        Write-Error "Error retrieving CPU information: $_"
        return
    }
    if ($NameOnly) {
        return $cpuName
    }
    $cores = (Get-CimInstance -class Win32_Processor).NumberOfCores
    $threads = (Get-CimInstance -class Win32_Processor).NumberOfLogicalProcessors
    $cpuCoresAndThreads = "($cores`C/$threads`T)"
    return "$Env:PROCESSOR_ARCHITECTURE $Separator $cpuName $cpuCoresAndThreads"
}
function Get-GPU() {
    $gpu = Get-WmiObject Win32_VideoController | Select-Object Name | Out-String
    return $gpu.Trim()
}
function Get-RAM() {
    $ram = Get-CimInstance Win32_ComputerSystem | Select-Object TotalPhysicalMemory
    $ram = $ram.TotalPhysicalMemory / 1GB
    return "{0:N2} GB" -f $ram
}
function Get-OSArchitecture() {
    $osarch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    return $osarch
}
function Get-OSDriveType() {
    $osdrive = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").DriveType
    return $osdrive
}
function Get-DriveSpace {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidatePattern("^([a-zA-Z]:\\)?$")]
        [String] $DriveLetter = $env:SystemDrive[0]
    )

    try {
        $SystemDrive = Get-PSDrive -Name $DriveLetter -ErrorAction Stop
        $AvailableStorage = $SystemDrive.Free / 1GB
        $UsedStorage = $SystemDrive.Used / 1GB
        $TotalStorage = $AvailableStorage + $UsedStorage

        return "$DriveLetter`: $($AvailableStorage.ToString("#.#"))/$($TotalStorage.ToString("#.#")) GB ($((($AvailableStorage / $TotalStorage) * 100).ToString("#.#"))%)"
    }
    catch {
        Write-Warning "Failed to retrieve drive space for drive $($DriveLetter.ToUpper()): $_"
        return $null
    }
}
function Get-SystemSpec() {
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $false)]
        [String] $Separator = '|'
    )

    #Write-Status -Types "@" -Status "Loading system specs..."
    # Adapted From: https://www.delftstack.com/howto/powershell/find-windows-version-in-powershell/#using-the-wmi-class-with-get-wmiobject-cmdlet-in-powershell-to-get-the-windows-version
    $WinVer = (Get-CimInstance -class Win32_OperatingSystem).Caption -replace 'Microsoft ', ''
    $DisplayVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
    $OldBuildNumber = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    $DisplayedVersionResult = '(' + @{ $true = $DisplayVersion; $false = $OldBuildNumber }[$null -ne $DisplayVersion] + ')'

    return <#$(Get-OSDriveType), $Separator,#> $WinVer, $DisplayedVersionResult, $Separator, $(Get-RAM), $Separator, $(Get-CPU -Separator $Separator), $Separator, $(Get-GPU)
}
Function Variables () {
    New-Variable -Name "newloads" -Value ".\" -Scope Global -Force
    New-Variable -Name "MaxLength" -Value '12' -Scope Global -Force
    New-Variable -Name "ErrorLog" -Value ".\ErrorLog.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Log" -Value ".\Log.txt" -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Scope Global -Force
    New-Variable -Name "Win11" -Value "22000" -Scope Global -Force
    New-Variable -Name "22H2" -Value "22621" -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value [System.Environment]::OSVersion.Version.Build -Scope Global -Force
    New-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    New-Variable -Name "Connected" -Value "Internet" -Scope Global -Force
    New-Variable -Name "NewLoadsURL" -Value "https://raw.githubusercontent.com/circlol/newload/main/New%20Loads.ps1" -Scope Global -Force
    New-Variable -Name "NewLoadsURLMain" -Value "https://raw.githubusercontent.com/circlol/newload/main/" -Scope Global -Force
    #New-Variable -Name "HVECCodec" -Value ".\assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx" -Scope Global    
    New-Variable -Name "HVECCodec" -Value  "Assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx" -Scope Global -Force
    New-Variable -Name "Programs" -Value @(
        "Microsoft.3DBuilder"                       # 3D Builder
        "Microsoft.Appconnector"
        "Microsoft.BingFinance"                     # Finance
        "Microsoft.BingFoodAndDrink"                # Food And Drink
        "Microsoft.BingHealthAndFitness"            # Health And Fitness
        "Microsoft.BingNews"                        # News
        "Microsoft.BingSports"                      # Sports
        "Microsoft.BingTranslator"                  # Translator
        "Microsoft.BingTravel"                      # Travel
        "Microsoft.BingWeather"                     # Weather
        "Microsoft.CommsPhone"
        "Microsoft.ConnectivityStore"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftPowerBIForWindows"
        "Microsoft.MicrosoftSolitaireCollection"    # MS Solitaire
        "Microsoft.MinecraftEducationEdition"
        "Microsoft.MinecraftUWP"
        "Microsoft.MixedReality.Portal"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.Office.Hub"
        "Microsoft.Office.Lens"
        "Microsoft.Office.OneNote"                  # MS Office One Note
        "Microsoft.Office.Sway"
        "Microsoft.OneConnect"
        "Microsoft.OneDriveSync"
        "Microsoft.People"                          # People
        "Microsoft.SkypeApp"                        # Skype (Who still uses Skype? Use Discord)
        "MicrosoftTeams"                            # Microsoft Teams / Preview
        "Microsoft.Todos"                           # Microsoft To Do
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"                      # Microsoft Whiteboard
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsReadingList"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.ZuneMusic"                       # Groove Music / (New) Windows Media Player
        "Microsoft.ZuneVideo"                       # Movies & TV
        # 3rd party Apps
        "*AdobePhotoshopExpress*"                   # Adobe Photoshop Express
        "AdobeSystemsIncorporated.AdobeLightroom"   # Adobe Lightroom
        "AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    # Adobe Creative Cloud Express
        "*Amazon.com.Amazon*"                       # Amazon
        "AmazonVideo.PrimeVideo"                    # Amazon Prime Video
        "57540AMZNMobileLLC.AmazonAlexa"            # Amazon Alexa
        "*BubbleWitch3Saga*"                        # Bubble Witch 3 Saga
        "*CandyCrush*"                              # Candy Crush
        "*DisneyMagicKingdoms*"
        "Disney.37853FC22B2CE"
        "*Disney*"
        "*Dolby*"                                   # Dolby Products (Like Atmos)
        "*DropboxOEM*"
        "Evernote.Evernote"
        "*ExpressVPN*"
        "*Facebook*"                                # Facebook
        "*Flipboard*"                               # Flipboard
        "*Hulu*"
        "*McAfee*"
        "5A894077.McAfeeSecurity"
        "4DF9E0F8.Netflix"
        "*PicsArt-PhotoStudio*"
        "*Pinterest*"
        "1424566A.147190DF3DE79"
        "SpotifyAB.SpotifyMusic"
        "*Twitter*"                                 # Twitter
        "*TikTok*"
        "5319275A.WhatsAppDesktop"
        # Acer OEM Bloat
        "AcerIncorporated.AcerRegistration"
        "AcerIncorporated.QuickAccess"
        "AcerIncorporated.UserExperienceImprovementProgram"
        "AcerIncorporated.AcerCareCe nterS"
        "AcerIncorporated.AcerCollectionS"
        # HP Bloat
        "AD2F1837.HPSupportAssistant"
        "AD2F1837.HPPrinterControl"
        "AD2F1837.HPQuickDrop"
        "AD2F1837.HPSystemEventUtility"
        "AD2F1837.HPPrivacySettings"
        "AD2F1837.HPInc.EnergyStar"
        "AD2F1837.HPAudioCenter"
        # Common HP & Acer Bloat
        "CyberLinkCorp.ac.PowerDirectorforacerDesktop"
        "CyberLinkCorp.ac.PhotoDirectorforacerDesktop"
        "CorelCorporation.PaintShopPro"
        "26720RandomSaladGamesLLC.HeartsDeluxe"
        "26720RandomSaladGamesLLC.SimpleSolitaire"
        "26720RandomSaladGamesLLC.SimpleMahjong"
        "26720RandomSaladGamesLLC.Spades"
        # Samsung Bloat
        "SAMSUNGELECTRONICSCO.LTD.1412377A9806A"
        "SAMSUNGELECTRONICSCO.LTD.NewVoiceNote"
        "SAMSUNGELECTRONICSCO.LTD.SamsungWelcome"
        "SAMSUNGELECTRONICSCO.LTD.SamsungUpdate"
        "SAMSUNGELECTRONICSCO.LTD.SamsungSecurity1.2"
        "SAMSUNGELECTRONICSCO.LTD.SamsungScreenRecording"
        "SAMSUNGELECTRONICSCO.LTD.SamsungQuickSearch"
        "SAMSUNGELECTRONICSCO.LTD.SamsungPCCleaner"
        "SAMSUNGELECTRONICSCO.LTD.SamsungCloudBluetoothSync"
        "SAMSUNGELECTRONICSCO.LTD.OnlineSupportSService"
    ) -Scope Global -Force -Option ReadOnly


    New-Variable -Name "UsersFolder" -Value "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Force -Scope Global
    New-Variable -Name "ThisPC" -Value "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Force -Scope Global

    New-Variable -Name "livesafe" -Value "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "webadvisor" -Value "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "WildGames" -Value "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "EdgeShortcut" -Value "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "acrosc" -Value "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "edgescpub" -Value "$Env:PUBLIC\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "vlcsc" -Value "$Env:PUBLIC\Desktop\VLC Media Player.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "zoomsc" -Value "$Env:PUBLIC\Desktop\Zoom.lnk" -Option ReadOnly -Scope Global -Force
    
    New-Variable -Name "commonapps" -Value "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Option ReadOnly -Scope Global -Force
    #Wallpaper
    New-Variable -Name "wallpaper" -Value "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "WallpaperDestination" -Value "$Env:Appdata\Microsoft\Windows\Themes\wallpaper.jpg" -Scope Global -Force
    New-Variable -Name "currentwallpaper" -Value (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper -Option ReadOnly -Scope Global -Force
    New-Variable -Name "sysmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme -Option ReadOnly -Scope Global -Force
    New-Variable -Name "appmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme -Option ReadOnly -Scope Global -Force
    #Office Removal
    New-Variable -Name "PathToOffice86" -Value "C:\Program Files (x86)\Microsoft Office" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToOffice64" -Value "C:\Program Files\Microsoft Office 15" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "officecheck" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "office32" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "office64" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "SaRA" -Value "$newloads\SaRA.zip" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Sexp" -Value "$newloads\SaRA" -Option ReadOnly -Scope Global -Force
    #Reg
    New-Variable -Name "PathToChromeExtensions" -Value "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToChromeLink" -Value "https://clients2.google.com/service/update2/crx" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "siufrules" -Value "HKCU:\Software\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "lfsvc" -Value "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToWifiSense" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "regcam" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "website" -Value "https://www.mothercomputers.com" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "hours" -Value "Monday - Saturday 9AM-5PM | Sunday - Closed"  -Option ReadOnly -Scope Global -Force
    New-Variable -Name "phone" -Value "(250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "store" -Value "Mother Computers" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "model" -Value "Mother Computers - (250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "page" -Value "Model" -Option ReadOnly -Scope Global -Force


    New-Variable -Name "TimeoutScreenBattery" -Value 5 -Force -Scope Global
    New-Variable -Name "TimeoutScreenPluggedIn" -Value 10 -Force -Scope Global
    New-Variable -Name "TimeoutStandByBattery" -Value 15 -Force -Scope Global
    New-Variable -Name "TimeoutStandByPluggedIn" -Value 30 -Force -Scope Global
    New-Variable -Name "TimeoutDiskBattery" -Value 15 -Force -Scope Global
    New-Variable -Name "TimeoutDiskPluggedIn" -Value 30 -Force -Scope Global
    New-Variable -Name "TimeoutHibernateBattery" -Value 15 -Force -Scope Global
    New-Variable -Name "TimeoutHibernatePluggedIn" -Value 30 -Force -Scope Global

    New-Variable -Name "PathToUsersControlPanelDesktop" -Value "Registry::HKEY_USERS\.DEFAULT\Control Panel\Desktop" -Force -Scope Global
    New-Variable -Name "PathToCUControlPanelDesktop" -Value "HKCU:\Control Panel\Desktop" -Force -Scope Global
    New-Variable -Name "PathToCUGameBar" -Value "HKCU:\SOFTWARE\Microsoft\GameBar" -Force -Scope Global
    New-Variable -Name "PathToOEMInfo" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorerLocalMachine" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegSystem" -Value "HKLM:\Software\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegInputPersonalization" -Value "HKCU:\Software\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegCurrentVersion" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegContentDelivery" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorer" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorerAdv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegAdvertising" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegPersonalize" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToPrivacy" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegSearch" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
    # Initialize all Path variables used to Registry Tweaks
    New-Variable -Name "PathToLMActivityHistory" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMAutoLogger" -Value "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" -Option ReadOnly -Scope Global -Force
    #$PathToLMDeliveryOptimizationCfg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
    New-Variable -Name "PathToLMPoliciesAdvertisingInfo" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesCloudContent" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesEdge" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force -Scope Global
    New-Variable -Name "PathToLMPoliciesPsched" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Psched" -Force -Scope Global
    New-Variable -Name "PathToLMPoliciesSQMClient" -Value "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesTelemetry" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesTelemetry2" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesToWifi" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesWindowsStore" -Value "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Force -Scope Global
    #$PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    New-Variable -Name "PathToLMWindowsTroubleshoot" -Value "HKLM:\SOFTWARE\Microsoft\WindowsMitigation" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUAccessibility" -Value "HKCU:\Control Pane\Accessibility" -Scope Global -Force
    New-Variable -Name "PathToCUContentDeliveryManager" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUDeviceAccessGlobal" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUInputPersonalization" -Value "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUInputTIPC" -Value "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUOnlineSpeech" -Value "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUPoliciesCloudContent" -Value "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUSearch" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUSiufRules" -Value "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUUserProfileEngagemment" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Scope Global -Force
    New-Variable -Name "PathToVoiceActivation" -Value "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToBackgroundAppAccess" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMMultimediaSystemProfile" -Value "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force -Scope Global
    New-Variable -Name "PathToLMMultimediaSystemProfileOnGameTasks" -Value "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Force -Scope Global
}
Function CheckFiles() {
    Try {
        $folders = @("bin", "assets", "lib")
        $folders | ForEach-Object {
            if (!(Test-Path ".\$_" -PathType Container -ErrorAction SilentlyContinue)) {
                Write-Status -Types "+" -Status "Creating $_ Folder."
                New-Item -ItemType Directory -Path ".\$_" -Force | Out-Null
            }
        }
        If (Test-Path ".\tmp.txt") {
            Write-Status -Types "-" -Status "Removing a previously runs tmp.txt."
            Remove-Item ".\tmp.txt" -Force -ErrorAction SilentlyContinue
        }
        If (Test-Path .\ErrorLog.txt) {
            Write-Status -Types "-" -Status "Removing a previous runs ErrorLog.txt."
            Remove-Item -Path ".\ErrorLog.txt" -Force -ErrorAction SilentlyContinue
        }
    }
    Catch {
        Write-Error "An error occurred while creating folders or removing files: $_"
    }
    
    #"lib\Templates.psm1",
    #"lib\Variables.psm1",
    #"Assets\settings-revert.cfg"
    Write-Section -Text "Scanning Exisitng Files"
    $Files = @(        
        "lib\Optimize-GeneralTweaks.psm1",
        "lib\Optimize-Performance.psm1",
        "lib\Optimize-Privacy.psm1",
        "lib\Optimize-Security.psm1",
        "lib\Optimize-Services.psm1",
        "lib\Optimize-TaskScheduler.psm1",
        "lib\Optimize-WindowsOptionalFeatures.psm1",
        "lib\Remove-Office.psm1",
        "lib\Set-ItemPropertyVerified.psm1",
        "lib\Set-Scheduled-Task-State.psm1",
        "lib\Set-ServiceStartup.psm1",
        "lib\Set-Windows-Feature-State.psm1",
        "assets\10.jpg",
        "assets\10_mGaming.png",
        "assets\11.png",
        "assets\11_mGaming.png",
        "assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx",
#        "Assets\settings.cfg"
        "assets\start.bin" 
        "assets\start2.bin" 
        )
    # Creates an array for missing files
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) {
        If (Test-Path ".\$file" -PathType Leaf -ErrorAction SilentlyContinue) {
            Write-CaptionSucceed -Text "$file Validated"
        }
        else {
            Write-CaptionFailed -Text "$file Failed to validate."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }
    else {
        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        CheckNetworkStatus
        Write-Section -Text "Downloading Missing Files"
        ForEach ($url in $urls) {
                $link = $NewLoadsURLMain + $url
                Write-Status -Types "+","Modules" -Status "Attempting to Download $url"
                Start-BitsTransfer -Dynamic -Source "$link" -Destination ".\$url" -Verbose -TransferType Download -Confirm:$False -OutVariable bitsTransfers
                Check
        }
        While ((Get-BitsTransfer | Where-Object {$_.JobState -eq "Transferring"})) {
            Write-Verbose "Waiting for downloads to complete..."
            Start-Sleep -Seconds 1
        }
        $status = Get-BitsTransfer | Where-Object {$_.JobState -eq "Error"}
        If ($status) {
            Write-Error "An error occurred while downloading files : $status"
        }
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile -Force -ErrorAction SilentlyContinue
        }
        
        Write-Section "Importing Modules"
        ForEach ($url in $URLs){
        If (Test-Path ".\$url" -Include "*.psm1" -ErrorAction SilentlyContinue) {
            Write-Status -Types "+","Modules" -Status "Attempting to Import Module: $url"
            Import-Module -DisableNameChecking ".\$url"
            Check
        }
    }

}
Function Set-ScriptCategory() {
    param(
        [String]$Category
    )
    $Global:TweakType = $Category
    $WindowTitle = "New Loads - $Category"
    $host.UI.RawUI.WindowTitle = $WindowTitle
}
<#
Write-Break ; Write-Caption -Text "This is a Test Message" ; Write-CaptionFailed -Text "This is a Test Message" ; Write-CaptionSucceed -Text "This is a Test Message" ; Write-CaptionWarning -Text "This is a Test Message" ; Write-Section -Text "This is a Test Message" ; Write-Status -Types "+" , "Test" -Status "This is a Test Message" ; Write-Title -Text "This is a Test Message" ; Write-TitleCounter -Counter "4" -MaxLength "15" -Text "This is a Test Message"
#>

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrQ3FqKB04ie/lWpu9ClZm9PB
# pBCgggMQMIIDDDCCAfSgAwIBAgIQeokdU+IlOplKdeWKCux2rDANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDQxMTE4
# MTI0N1oXDTI0MDQxMTE4MzI0N1owHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALtQ3KS4tiFLpVaa
# iwbD/7SaF5Z1FzsB3FCfjb9oYyirUycVAn3J8Y5WBCj01+/4X5CnbuAzTMbEQoYX
# GcYAXZeK7dE7MtFu+UPklcxJgj0cmFWFSqoIXW/u++a2tz5umCu+cVKl4KRhi3jV
# AEwegr+0t0rVeRf9laJ5jMnwqnQX1OK/Io+lnZczPiDaqRh41iP0QxBRnhI4JzY0
# Bvgw5fIEQHhdCkJbuR2B8lwJ+dNqNYWywk9gwfj5gboExlKINPgrRTvFwRKZwxEy
# jB/4/EoeKVgIY0nVZ3h5JIMXMvessQboeTCQZZnOpy05UfjtRx2QJEYel03cRY89
# J6U6mcUCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBRDigo9jC2UTikf0HvKxvTbR6SbATANBgkqhkiG9w0BAQsF
# AAOCAQEAlGw+ujETSZYwIRdpzsQlQYyZNgDhex68Q2UVwZlbvbd9kpWUCSM2swTh
# uvvnKuCRXhxm9d47Y0dTR2sz4tb7p1uctXS62itj01ol8yGU4+CWBna5WkBAVRz0
# SSYfijYA8GmzMbU9p25VegeCEr20gRXQGlKBq5yObKuok/KLIAwHDn/NT4+iRf7Y
# F/GhA0GMNk8KdVGSkpkRXwvIyh9GszfMyv+71jxZeZ6rmpYAwf9Hu0aFP9cUKQJF
# L0I8kQHtjTJPx9YV29ZYn/lEQz8poeoPWZokHq1rQ97LE/P9NayaFjRqeSMMmnjz
# IXkBte/WsvSrxQO2bdJdM2tty+VsEzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQeokdU+IlOplKdeWKCux2rDAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUlZixdcF5fMTYnSTIGXlpq8RzaY4wDQYJKoZIhvcNAQEBBQAEggEABzA7
# Yefht3alOyB0WqpbnozvARHJT6xwS6SFN593zzpZL19RFvSS8oHNIc1n6vaAwMTJ
# GUo9YU4oLQWH+yegsZlgKwQTo2tVVOx52OnauXPaHrbXsUi7dWg8O6tmTHIU9pIE
# fGsBTxTLjmh7T9VD7DuxgujNecU5E9MkyrRSlw37XPge0QPQ/1NuX+QFBkbk+03D
# MEGf0Y8u9MTsxs6j/AOIGFOlIECgNMGFX/Ex0ijxYklLvxC9q6Kl6t8QD0QB0Kmj
# 2hr2RV/lE5Tt8l7hU3Gn1LjZVXHK8W6gTqEusJRZ0x2iuNsRQ1KQm4OhutUMMqo2
# tOr1/IiBdOj5fnvKtQ==
# SIG # End signature block
