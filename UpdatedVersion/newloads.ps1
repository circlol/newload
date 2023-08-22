#
$WindowTitle = "New Loads"
$host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.ForegroundColor = 'White'
$host.UI.RawUI.BackgroundColor = 'Black'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$NewLoads = $env:temp
$Variables = @{
    "ForegroundColor" = "DarkMagenta"
    "BackgroundColor" = "Black"
    "LogoColor" = "DarkMagenta"
    "ProgramVersion" = "v1.06"
    "ReleaseDate" = "August 14th, 2023"
    "SelectedParameters" = @()
    "temp" = $Env:temp
    "MaxLength" = "11"
    "Win11" = "22000"
    "Win22H2" = "22621"
    "OSVersion" = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    "BuildNumber" = [System.Environment]::OSVersion.Version.Build
    "NetStatus" = (Get-NetConnectionProfile).IPv4Connectivity
    "Connected" = "Internet"
    # Local File Paths
    "WallpaperDestination" = "C:\Windows\Resources\Themes\mother.jpg"
    "WallpaperPath" = "$NewLoads\mother.jpg"
    "ErrorLog" = "$env:userprofile\Desktop\New Loads Errors.txt"
    "Log" = "$env:userprofile\Desktop\New Loads.txt"
    "adwDestination" = "$NewLoads\adwcleaner.exe"
    "DriverSelectorPath" = "$NewLoads\Driver Grabber.exe"
    "WindowsUpdatesPath" = "$NewLoads\Windows Updates.exe"
    "SaRA" = "$newloads\SaRA.zip"
    "Sexp" = "$newloads\SaRA"
    "SaRAURL" = "https://github.com/circlol/newload/raw/main/SaRACmd_17_1_0268_3.zip"
    "PackagesRemoved" = @()
    "Removed" = 0
    "Failed" = 0
    "NotFound" = 0
    "StartBinDefault" = "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\"
    "StartBinCurrent" = "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
    "LayoutFile" = "$Env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml"
    "adwLink" = "https://github.com/circlol/newload/raw/main/adwcleaner.exe"
    "livesafe" = "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe"
    "WebAdvisor" = "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe"
    "WildGames" = "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe"
    #New-Variable -Name "AcroSC" = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
    "EdgeShortcut" = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
    "AcroSC" = "$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk"
    "EdgeSCPub" = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
    "VLCSC" = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
    "ZoomSC" = "$Env:PUBLIC\Desktop\Zoom.lnk"
    "CommonApps" = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs"
    #Wallpaper
    #New-Variable -Name "Wallpaper" = "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg"
    "CurrentWallpaper" = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper
    #Office Removal
    "PathToOffice86" = "${env:ProgramFiles(x86)}\Microsoft Office"
    "PathToOffice64" = "$env:ProgramFiles\Microsoft Office 15"
    "OfficeCheck" = "$false"
    "Office32" = "$false"
    "Office64" = "$false"
    "UsersFolder" = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
    "ThisPC" = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    "PathToUblockChrome" = "HKLM:\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm"
    "PathToChromeLink" = "https://clients2.google.com/service/update2/crx"
    "PathToLFSVC" = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
    "RegCAM" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
    "Website" = "https://www.mothercomputers.com"
    "Hours" = "Monday - Saturday 9AM-5PM | Sunday - Closed" 
    "Phone" = "(250) 479-8561"
    "Store" = "Mother Computers"
    "Model" = "Mother Computers - (250) 479-8561"
    "Page" = "Model"
    "TimeoutScreenBattery" = 5
    "TimeoutScreenPluggedIn" = 10
    "TimeoutStandByBattery" = 15
    "TimeoutStandByPluggedIn" = 30
    "TimeoutDiskBattery" = 15
    "TimeoutDiskPluggedIn" = 30
    "TimeoutHibernateBattery" = 15
    "TimeoutHibernatePluggedIn" = 30
    "PathToUsersControlPanelDesktop" = "Registry::HKEY_USERS\.DEFAULT\Control Panel\Desktop"
    "PathToCUControlPanelDesktop" = "HKCU:\Control Panel\Desktop"
    "PathToCUGameBar" = "HKCU:\SOFTWARE\Microsoft\GameBar"
    "PathToGraphicsDrives" = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
    "PathToOEMInfo" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
    "PathToRegExplorerLocalMachine" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    "PathToRegCurrentVersion" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
    "PathToRegAdvertising" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    "PathToRegPersonalize" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    "PathToPrivacy" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
    
    # Initialize all Path variables used to Registry Tweaks
    "PathToLMActivityHistory" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    "PathToLMAutoLogger" = "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger"
    "PathToLMControl" = "HKLM:\SYSTEM\CurrentControlSet\Control"
    "PathToLMCurrentVersion" = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    "PathToLMConsentStoreUAI" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
    "PathToLMConsentStoreUN" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener"
    "PathToLMConsentStoreAD" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
    "PathToLMDeviceMetaData" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" 
    "PathToLMDriverSearching" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"
    "PathToLMEventKey" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey"
    "PathToLMLanmanServer" = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
    "PathToLMMemoryManagement" = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    "PathToLMNdu" = "HKLM:\SYSTEM\ControlSet001\Services\Ndu"
    #$PathToLMDeliveryOptimizationCfg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
    "PathToLMPoliciesAdvertisingInfo" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
    "PathToLMPoliciesAppCompact" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
    "PathToLMPoliciesCloudContent" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    "PathToLMPoliciesEdge" = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    "PathToLMPoliciesExplorer" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    "PathToLMPoliciesMRT" = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
    "PathToLMPoliciesPsched" = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
    "PathToLMPoliciesSQMClient" = "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
    "PathToLMPoliciesTelemetry" = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    "PathToLMPoliciesTelemetry2" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    "PathToLMPoliciesToWifi" = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi"
    "PathToLMPoliciesWindowsStore" = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
    "PathToLMPoliciesSystem" = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    "PathToLMOldDotNet" = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"
    "PathToLMWowNodeOldDotNet" = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319"
    #$PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    "PathToLMWindowsTroubleshoot" = "HKLM:\SOFTWARE\Microsoft\WindowsMitigation"
    "PathToCUAccessibility" = "HKCU:\Control Pane\Accessibility"
    "PathToCUAppHost" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"
    "PathToCUContentDeliveryManager" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    "PathToCUConsentStoreAD" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
    "PathToCUConsentStoreUAI" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
    "PathToCUDeviceAccessGlobal" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global"
    "PathToCUExplorer" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    "PathToCUExplorerAdvanced" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    "PathToCUInputPersonalization" = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
    "PathToCUInputTIPC" = "HKCU:\SOFTWARE\Microsoft\Input\TIPC"
    "PathToCUMouse" = "HKCU:\Control Panel\Mouse"
    "PathToCUFeedsDSB" = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB"
    "PathToCUOnlineSpeech" = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
    "PathToCUPersonalization" = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
    "PathToCUPoliciesCloudContent" = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    "PathToCUSearch" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    "PathToCUSearchSettings" = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
    "PathToCUSiufRules" = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
    "PathToCUUserProfileEngagemment" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
    "PathToCUUP" = "HKCU:\Control Panel\International\User Profile"
    "PathToVoiceActivation" = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps"
    "PathToBackgroundAppAccess" = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
    "PathToLMMultimediaSystemProfile" = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    "PathToLMMultimediaSystemProfileOnGameTasks" = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    # - Shortcuts
    "Shortcuts" = @(
        "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
        "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
        "$Env:PUBLIC\Desktop\Adobe Reader.lnk"
        "$Env:PUBLIC\Desktop\Adobe Reader DC.lnk"
        "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
        "$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk"
        "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
        "$Env:PUBLIC\Desktop\Zoom.lnk"
    )
    # - Scheduled Tasks
    # Adapted from: https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-vdi-recommendations#task-scheduler
    "EnableScheduledTasks" = @(
        "\Microsoft\Windows\Defrag\ScheduledDefrag"                 # Defragments all internal storages connected to your computer
        "\Microsoft\Windows\Maintenance\WinSAT"                     # WinSAT detects incorrect system configurations, that causes performance loss, then sends it via telemetry | Reference (PT-BR): https://youtu.be/wN1I0IPgp6U?t=16
        "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"        # Verify the Recovery Environment integrity, it's the Diagnostic tools and Troubleshooting when your PC isn't healthy on BOOT, need this ON.
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting" # Windows Error Reporting event, needed to improve compatibility with your hardware
    )
    "DisableScheduledTasks" = @(
        "\Microsoft\Office\OfficeTelemetryAgentLogOn"
        "\Microsoft\Office\OfficeTelemetryAgentFallBack"
        "\Microsoft\Office\Office 15 Subscription Heartbeat"
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
        "\Microsoft\Windows\Application Experience\StartupAppTask"
        "\Microsoft\Windows\Autochk\Proxy"
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         # Recommended state for VDI use
        "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"       # Recommended state for VDI use
        "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              # Recommended state for VDI use
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
        "\Microsoft\Windows\Location\Notifications"                                       # Recommended state for VDI use
        "\Microsoft\Windows\Location\WindowsActionDialog"                                 # Recommended state for VDI use
        "\Microsoft\Windows\Maps\MapsToastTask"                                           # Recommended state for VDI use
        "\Microsoft\Windows\Maps\MapsUpdateTask"                                          # Recommended state for VDI use
        "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"                # Recommended state for VDI use
        "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"                   # Recommended state for VDI use
        "\Microsoft\Windows\Retail Demo\CleanupOfflineContent"                            # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyMonitor"                                    # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"                                # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyUpload"
        "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"                          # Recommended state for VDI use
    )
    #"IsSystemDriveSSD" = $(Get-OSDriveType) -eq "SSD"
    # - Services
    "EnableServicesOnSSD" = @("SysMain", "WSearch", "fhsvc")
    # Services which will be totally disabled
    "ServicesToDisabled" = @(
        "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
        "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
        "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
        "GraphicsPerfSvc"                           # DEFAULT: Manual    | Graphics performance monitor service
        "HomeGroupListener"                         # NOT FOUND (Win 10+)| HomeGroup Listener
        "HomeGroupProvider"                         # NOT FOUND (Win 10+)| HomeGroup Provider
        "lfsvc"                                     # DEFAULT: Manual    | Geolocation Service
        "MapsBroker"                                # DEFAULT: Automatic | Downloaded Maps Manager
        "PcaSvc"                                    # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
        "RemoteAccess"                              # DEFAULT: Disabled  | Routing and Remote Access
        "RemoteRegistry"                            # DEFAULT: Disabled  | Remote Registry
        "RetailDemo"                                # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
        "TrkWks"                                    # DEFAULT: Automatic | Distributed Link Tracking Client
        "NPSMSvc_df772"
        "LanmanServer"
    )
    # Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
    "ServicesToManual" = @(
        "BITS"                           # DEFAULT: Manual    | Background Intelligent Transfer Service
        "BDESVC"                         # DEFAULT: Manual    | BItLocker Drive Encryption Service
        "edgeupdate"                     # DEFAULT: Automatic | Microsoft Edge Update Service
        "edgeupdatem"                    # DEFAULT: Manual    | Microsoft Edge Update Service²
        "FontCache"                      # DEFAULT: Automatic | Windows Font Cache
        "iphlpsvc"                       # DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
        "lmhosts"                        # DEFAULT: Manual    | TCP/IP NetBIOS Helper
        "ndu"                            # DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
        "PhoneSvc"                       # DEFAULT: Manual    | Phone Service (Manages the telephony state on the device)
        "SCardSvr"                       # DEFAULT: Manual    | Smart Card Service
        "SharedAccess"                   # DEFAULT: Manual    | Internet Connection Sharing (ICS)
        "stisvc"                         # DEFAULT: Automatic | Windows Image Acquisition (WIA) Service
        "WbioSrvc"                       # DEFAULT: Manual    | Windows Biometric Service (required for Fingerprint reader / Facial detection)
        "Wecsvc"                         # DEFAULT: Manual    | Windows Event Collector Service
        "WerSvc"                         # DEFAULT: Manual    | Windows Error Reporting Service
        "wisvc"                          # DEFAULT: Manual    | Windows Insider Program Service
        "WMPNetworkSvc"                  # DEFAULT: Manual    | Windows Media Player Network Sharing Service
        "WpnService"                     # DEFAULT: Automatic | Windows Push Notification Services (WNS)
        # - Diagnostic Services
        "DPS"                            # DEFAULT: Automatic | Diagnostic Policy Service
        "WdiServiceHost"                 # DEFAULT: Manual    | Diagnostic Service Host
        "WdiSystemHost"                  # DEFAULT: Manual    | Diagnostic System Host
        # - Bluetooth services
        "BTAGService"                    # DEFAULT: Manual    | Bluetooth Audio Gateway Service
        "BthAvctpSvc"                    # DEFAULT: Manual    | AVCTP Service
        "bthserv"                        # DEFAULT: Manual    | Bluetooth Support Service
        "RtkBtManServ"                   # DEFAULT: Automatic | Realtek Bluetooth Device Manager Service
        # - Xbox services
        "XblAuthManager"                 # DEFAULT: Manual    | Xbox Live Auth Manager
        "XblGameSave"                    # DEFAULT: Manual    | Xbox Live Game Save
        "XboxGipSvc"                     # DEFAULT: Manual    | Xbox Accessory Management Service
        "XboxNetApiSvc"                  # DEFAULT: Manual    | Xbox Live Networking Service
        # - 3rd Party Services
        "gupdate"                        # DEFAULT: Automatic | Google Update Service
        "gupdatem"                       # DEFAULT: Manual    | Google Update Service²
        "DisplayEnhancementService"      # DEFAULT: Manual    | A service for managing display enhancement such as brightness control.
        "DispBrokerDesktopSvc"           # DEFAULT: Automatic | Manages the connection and configuration of local and remote displays
    )
    # - Content Delivery
    "ContentDeliveryManagerDisableOnZero" = @(
        "SubscribedContent-310093Enabled"           # "Show me the Windows Welcome Experience after updates and when I sign in highlight whats new and suggested"
        "RotatingLockScreenOverlayEnabled"          # Rotation Lock
        "RotatingLockScreenEnabled"                 # Rotation Lock
        # Prevents Apps from re-installing
        "ContentDeliveryAllowed"                    # Disables Content Delivery
        "FeatureManagementEnabled"                  #
        "OemPreInstalledAppsEnabled"                # OEM Advertising
        "PreInstalledAppsEnabled"                   # Preinstalled apps like Disney+, Adobe Express, ect.
        "PreInstalledAppsEverEnabled"               # Preinstalled apps like Disney+, Adobe Express, ect.
        "RemediationRequired"                       #
        "SilentInstalledAppsEnabled"                #
        "SoftLandingEnabled"                        #
        "SubscribedContent-314559Enabled"           #
        "SubscribedContent-314563Enabled"           # My People Suggested Apps
        "SubscribedContent-338387Enabled"           # Facts, Tips and Tricks on Lock Screen
        "SubscribedContent-338388Enabled"           # App Suggestions on Start
        "SubscribedContent-338389Enabled"           # Tips, Tricks, and Suggestions Notifications
        "SubscribedContent-338393Enabled"           # Suggested content in Settings
        'SubscribedContent-353694Enabled'           # Suggested content in Settings
        'SubscribedContent-353696Enabled'           # Suggested content in Settings
        "SubscribedContent-353698Enabled"           # Timeline Suggestions
        "SubscribedContentEnabled"                  # Disables Subscribed content
        "SystemPaneSuggestionsEnabled"              #
    )
    # - Optional Features
    "DisableFeatures" = @(
        #"FaxServicesClientPackage"             # Windows Fax and Scan
        #"Printing-PrintToPDFServices-Features" # Microsoft Print to PDF
        "IIS-*"                                # Internet Information Services
        "Internet-Explorer-Optional-*"         # Internet Explorer
        "LegacyComponents"                     # Legacy Components
        "MediaPlayback"                        # Media Features (Windows Media Player)
        "MicrosoftWindowsPowerShellV2"         # PowerShell 2.0
        "MicrosoftWindowsPowershellV2Root"     # PowerShell 2.0
        "Printing-XPSServices-Features"        # Microsoft XPS Document Writer
        "WorkFolders-Client"                   # Work Folders Client
    )
    "EnableFeatures" = @(
        "NetFx3"                            # NET Framework 3.5
        "NetFx4-AdvSrvs"                    # NET Framework 4
        "NetFx4Extended-ASPNET45"           # NET Framework 4.x + ASPNET 4.x
    )
    # - Debloat
    "Programs" = @(
        # Microsoft Applications
        "Microsoft.549981C3F5F10"                   			# Cortana
        "Microsoft.3DBuilder"                       			# 3D Builder
        "Microsoft.Appconnector"                    			# App Connector
        "*Microsoft.Advertising.Xaml*"
        "Microsoft.BingFinance"                     			# Finance
        "Microsoft.BingFoodAndDrink"                			# Food And Drink
        "Microsoft.BingHealthAndFitness"            			# Health And Fitness
        "Microsoft.BingNews"                        			# News
        "Microsoft.BingSports"                      			# Sports
        "Microsoft.BingTranslator"                  			# Translator
        "Microsoft.BingTravel"                      			# Travel
        "Microsoft.BingWeather"                     			# Weather
        "Microsoft.CommsPhone"                      			# Your Phone
        "Microsoft.ConnectivityStore"               			# Connectivity Store
        "Microsoft.Messaging"                       			# Messaging
        "Microsoft.Microsoft3DViewer"               			# 3D Viewer
        "Microsoft.MicrosoftOfficeHub"              			# Office
        "Microsoft.MicrosoftPowerBIForWindows"      			# Power Automate
        "Microsoft.MicrosoftSolitaireCollection"    			# MS Solitaire
        "Microsoft.MinecraftEducationEdition"       			# Minecraft Education Edition for Windows 10
        "Microsoft.MinecraftUWP"                    			# Minecraft
        "Microsoft.MixedReality.Portal"             			# Mixed Reality Portal
        "Microsoft.Office.Hub"                     	 			# Office Hub
        "Microsoft.Office.Lens"                     			# Office Lens
        "Microsoft.Office.OneNote"                  			# Office One Note
        "Microsoft.Office.Sway"                     			# Office Sway
        "Microsoft.OneConnect"                     				# OneConnect
        "Microsoft.People"                          			# People
        "Microsoft.SkypeApp"                        			# Skype (Who still uses Skype? Use Discord)
        "MicrosoftTeams"                            			# Teams / Preview
        "Microsoft.Todos"                           			# To Do
        "Microsoft.Wallet"                          			# Wallet
        "Microsoft.Whiteboard"                      			# Microsoft Whiteboard
        "Microsoft.WindowsPhone"                    			# Your Phone Alternate
        "Microsoft.WindowsReadingList"              			# Reading List
        #"Microsoft.WindowsSoundRecorder"            			# Sound Recorder
        "Microsoft.ZuneMusic"                       			# Groove Music / (New) Windows Media Player
        "Microsoft.ZuneVideo"                       			# Movies & TV
        "Microsoft.XboxApp"                                     # Xbox
        "Microsoft.Xbox.TCUI"                                   # Xbox
        #"Microsoft.XboxGameCallableUI"                          # Xbox Game Callable UI ## NON-REMOVABLE = TRUE
        "Microsoft.XboxIdentityProvider"                        # Xbox Identity Provider
        "Microsoft.XboxGameOverlay"                             # Xbox Game Overlay
        "Microsoft.XboxSpeechToTextOverlay"                     # Xbox Text To Speech Overlay
        # 3rd party Apps
        "*ACGMediaPlayer*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*AdobePhotoshopExpress*"                   			# Adobe Photoshop Express
        "AdobeSystemsIncorporated.AdobeLightroom"   			# Adobe Lightroom
        "AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    # Adobe Creative Cloud Express
        "AdobeSystemsIncorporated.AdobeExpress"    				# Adobe Creative Cloud Express
        "*Amazon.com.Amazon*"                       			# Amazon
        "AmazonVideo.PrimeVideo"                    			# Amazon Prime Video
        "57540AMZNMobileLLC.AmazonAlexa"            			# Amazon Alexa
        "*BubbleWitch3Saga*"                        			# Bubble Witch 3 Saga
        "*CandyCrush*"                              			# Candy Crush
        "Clipchamp.Clipchamp"                       			# Clip Champ
        "*DisneyMagicKingdoms*"                     			# Disney Magic Kingdom
        "Disney.37853FC22B2CE"                      			# Disney Plus
        "*Disney*"                                  			# Disney Plus
        "*Dolby*"                                   			# Dolby Products (Like Atmos)
        "*DropboxOEM*"                              			# Dropbox
        "*Duolingo-LearnLanguagesforFree*"
        "*EclipseManager*"
        "Evernote.Evernote"                         			# Evernote
        "*ExpressVPN*"                              			# ExpressVPN
        "*Facebook*"                                			# Facebook
        "*Flipboard*"                               			# Flipboard
        "*HiddenCity*"
        "*HiddenCityMysteryofShadows*"
        "*HotspotShieldFreeVPN*"
        "*Hulu*"                                    			# Hulu
        "*Instagram*"                               			# Instagram
        "*LinkedInforWindows*"
        "*McAfee*"                                  			# McAfee
        "5A894077.McAfeeSecurity"                   			# McAfee Security
        "4DF9E0F8.Netflix"                          			# Netflix
        "*Netflix*"
        "*OneCalendar*"
        "*PandoraMediaInc*"
        "*PicsArt-PhotoStudio*"                     			# PhotoStudio
        "*Pinterest*"                               			# Pinterest
        "142F4566A.147190D3DE79"                    			# Pinterest
        "1424566A.147190DF3DE79"                    			# Pinterest
        "*Royal Revolt*"
        "*Speed Test*"
        "SpotifyAB.SpotifyMusic"                    			# Spotify
        "*Sway*"
        "*Twitter*"                                 			# Twitter
        "*TikTok*"                                  			# TikTok
        "*Viber*"
        "5319275A.WhatsAppDesktop"                  			# WhatsApp
        "*Wunderlist*"
        # Acer OEM Bloat
        "AcerIncorporated.AcerRegistration"         			# Acer Registration
        "AcerIncorporated.QuickAccess"              			# Acer Quick Access
        "AcerIncorporated.UserExperienceImprovementProgram"     # Acer User Experience Improvement Program
        #"AcerIncorporated.AcerCareCenterS"         			# Acer Care Center
        "AcerIncorporated.AcerCollectionS"          			# Acer Collections
        # HP Bloat
        "AD2F1837.HPPrivacySettings"                			# HP Privacy Settings
        "AD2F1837.HPInc.EnergyStar"                 			# Energy Star
        "AD2F1837.HPAudioCenter"                    			# HP Audio Center
        # Common HP & Acer Bloat
        "CyberLinkCorp.ac.PowerDirectorforacerDesktop"          # CyberLink Power Director for Acer
        "CorelCorporation.PaintShopPro"                         # Coral Paint Shop Pro
        "26720RandomSaladGamesLLC.HeartsDeluxe"                 # Hearts Deluxe
        "26720RandomSaladGamesLLC.SimpleSolitaire"              # Simple Solitaire
        "26720RandomSaladGamesLLC.SimpleMahjong"                # Simple Mahjong
        "26720RandomSaladGamesLLC.Spades"                       # Spades
    )
}
[Int]$Counter = 0
if ($GUI) { $Variables.specifiedParameters += '-GUI' }
if ($NoBranding) { $Variables.specifiedParameters += '-NoBranding' }
if ($Undo) { $Variables.specifiedParameters += '-Undo' }
if ($SkipADW) { $Variables.specifiedParameters += '-SkipADW' }
if ($SkipBitlocker) { $Variables.specifiedParameters += '-SkipBitlocker' }
if ($SkipPrograms) { $Variables.specifiedParameters += '-SkipPrograms' }
if ($WhatIf) { $Variables.specifiedParameters += '-WhatIf' }
$parametersString = $Variables.specifiedParameters -join ', '
Clear-Host


function Find-OptionalFeature {
    <#
.SYNOPSIS
    Checks if a specified Windows optional feature is available on the host.

.DESCRIPTION
    The Find-OptionalFeature function is used to check if a specified Windows optional feature is available on the host machine. It queries the installed optional features using `Get-WindowsOptionalFeature` cmdlet and returns a boolean value indicating if the feature is found or not.

.PARAMETER OptionalFeature
    Specifies the name of the Windows optional feature to check for. This parameter is mandatory.
#>
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $OptionalFeature
    )

    $feature = Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature -ErrorAction SilentlyContinue
    if ($feature) {
        return $true
    }
    else {
        Write-Status -Types "?", $TweakType -Status "The $OptionalFeature optional feature was not found."
        return $false
    }
}
function Find-ScheduledTask {
    <#
.SYNOPSIS
    Checks if a specified scheduled task exists on the host.

.DESCRIPTION
    The Find-ScheduledTask function is used to check if a specified scheduled task exists on the host machine. It queries the scheduled tasks using the `Get-ScheduledTaskInfo` cmdlet and returns a boolean value indicating if the task is found or not.

.PARAMETER ScheduledTask
    Specifies the name of the scheduled task to check for. This parameter is mandatory.

#>
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $ScheduledTask
    )

    If (Get-ScheduledTaskInfo -TaskName $ScheduledTask -ErrorAction SilentlyContinue) {
        return $true
    }
    Else {
        Write-Status -Types "?", $TweakType -Status "The $ScheduledTask task was not found." -WriteWarning
        return $false
    }
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
        $cores = (Get-CimInstance -class Win32_Processor).NumberOfCores
        $threads = (Get-CimInstance -class Win32_Processor).NumberOfLogicalProcessors
    }
    catch {
        Write-Error "Error retrieving CPU information: $_"
        return
    }
    if ($NameOnly) {
        write-output $cpuName
    }
    $cpuCoresAndThreads = "($cores`C/$threads`T)"
    Write-Output "$cpuName $cpuCoresAndThreads"
}
function Get-DriveInfo {
    [CmdletBinding()]
    param ()

    $driveInfo = @()
    $physicalDisks = Get-PhysicalDisk | Where-Object { $null -ne $_.MediaType }

    foreach ($disk in $physicalDisks) {
        $model = $disk.FriendlyName
        $driveType = $disk.MediaType
        $sizeGB = [math]::Round($disk.Size / 1GB)
        $healthStatus = $disk.HealthStatus

        $driveInfo += [PSCustomObject]@{
            Status   = $healthStatus
            Model    = $model
            Type     = $driveType
            Capacity = "${sizeGB} GB"
        }
    }

    write-output $driveInfo
}
function Get-DriveSpace {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [String] $DriveLetter = $env:SystemDrive[0]
    )
    process {
        $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -ge 0 -and $_.Used -ge 0 }
        foreach ($drive in $drives) {
            $driveLetter = $drive.Name
            $availableStorage = $drive.Free / 1GB
            $totalStorage = ($drive.Free + $drive.Used) / 1GB
            $percentageAvailable = [math]::Round(($availableStorage / $totalStorage) * 100, 1)

            $driveInfo = "$driveLetter`: $([math]::Round($availableStorage, 1))/$([math]::Round($totalStorage, 1)) GB ($percentageAvailable% Available)"
            Write-Output "$driveInfo`n"
        }
    }
}
function Get-GPU {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $gpu = Get-CimInstance -Class Win32_VideoController | Select-Object -ExpandProperty Name
    return $gpu.Trim()
}
function Get-RAM {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $ram = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
    $ram = $ram / 1GB
    return "{0:N2} GB" -f $ram
}
function Get-Motherboard {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $motherboardModel = Get-CimInstance -Class Win32_BaseBoard | Select-Object -ExpandProperty Product
    $motherboardOEM = Get-CimInstance -Class Win32_BaseBoard | Select-Object -ExpandProperty Manufacturer

    Write-Output "$MotherboardOEM $MotherboardModel"
}
function Get-SystemSpec {
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $false)]
        [String] $Separator = '|-----------|'
    )    
    $osarch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    $WinVer = (Get-CimInstance -class Win32_OperatingSystem).Caption -replace 'Microsoft ', ''
    $DisplayVersion = (Get-ItemProperty $Variables.PathToLMCurrentVersion).DisplayVersion
    $OldBuildNumber = (Get-ItemProperty $Variables.PathToLMCurrentVersion).ReleaseId
    $DisplayedVersionResult = '(' + @{ $true = $DisplayVersion; $false = $OldBuildNumber }[$null -ne $DisplayVersion] + ')'
    $completedWindowsName = "$WinVer $osarch $DisplayedVersionResult"
    write-output "CPU: $(Get-CPU)`n$Separator`nMotherboard: $(Get-Motherboard)`n$Separator`nGPU: $(Get-GPU)`n$Separator`nRAM: $(Get-RAM)`n$Separator`nOS: $completedWindowsName`n$Separator`nDrives:`n$(Get-DriveSpace)"
}
Function Get-ADWCleaner {
    If ($SkipADW -or $Revert) {
        Write-Status -Types "@" -Status "Parameter -SkipADW or -Undo detected.. Malwarebytes ADWCleaner will be skipped.." -WriteWarning -ForegroundColorText RED
    }
    else {
        # - Checks if executable exists
        If (!(Test-Path $Variables.adwDestination)) {
            Write-Status -Types "+", "ADWCleaner" -Status "Downloading ADWCleaner"
            # - Downloads ADW
            Start-BitsTransfer -Source $Variables.adwLink -Destination $Variables.adwDestination -Dynamic
        }
        Write-Status -Types "+", "ADWCleaner" -Status "Starting ADWCleaner with ArgumentList /Scan & /Clean"
        # - Runs ADW
        Start-Process -FilePath $Variables.adwDestination -ArgumentList "/EULA", "/PreInstalled", "/Clean", "/NoReboot" -Wait -NoNewWindow
        Write-Status -Types "-", "ADWCleaner" -Status "Removing traces of ADWCleaner"
        # - Removes traces of adw from system
        Start-Process -FilePath $Variables.adwDestination -ArgumentList "/Uninstall", "/NoReboot" -WindowStyle Minimized
    }
}
Function Get-InstalledProgram() {
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [string]$Keyword
    )
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $installedPrograms = Get-ChildItem -Path $registryPath
    $matchingPrograms = $installedPrograms | Where-Object {
        ($_.GetValue("DisplayName") -like "*$Keyword*") -or
        ($_.GetValue("DisplayVersion") -like "*$Keyword*") -or
        ($_.GetValue("Publisher") -like "*$Keyword*") -or
        ($_.GetValue("Comments") -like "*$Keyword*")
    }
    # - Output the matching programs as a list of objects with Name, Version, Publisher, and UninstallString properties
    $matchingPrograms | ForEach-Object {
        [PSCustomObject]@{
            Name            = $_.GetValue("DisplayName")
            UninstallString = $_.GetValue("UninstallString")
            Version         = $_.GetValue("DisplayVersion")
            Publisher       = $_.GetValue("Publisher")
        }
    }
}
Function Get-NetworkStatus {
    <#
.SYNOPSIS
Checks the network connectivity status and waits for an active internet connection.

.DESCRIPTION
The Get-NetworkStatus function checks the network connectivity status and waits for an active internet connection to proceed with the application. It checks the IPv4 connectivity status (by default) of the current network connection profile. If there is no internet connectivity, the function displays a warning message and waits until the internet connection is established.

.PARAMETER NetworkStatusType
Specifies the network status type to check. The default value is "IPv4Connectivity." Other possible values include "IPv4Connectivity" and "IPv6Connectivity."

.NOTES
The Get-NetworkStatus function is typically used to ensure that the application has an active internet connection before performing specific tasks that require internet access.
#>
    [CmdletBinding()]
    param(
        [string]$NetworkStatusType = "IPv4Connectivity"
    )
    $Variables.NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
    if ($Variables.NetStatus -ne 'Internet') {
        Write-Status -Types "WAITING" -Status "Seems like there's no network connection. Please reconnect." -WriteWarning
        while ($Variables.NetStatus -ne 'Internet') {
            Write-Output "Waiting for Internet"
            Start-Sleep -Milliseconds 350
            $Variables.NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
        }
        Test-Connection -ComputerName $Env:COMPUTERNAME -AsJob
        Write-Output "Connected: Moving On"
    }
}
Function Get-Office {
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path $Variables.PathToOffice64 ) { $Variables.office64 = $true }Else { $Variables.office64 = $false }
    If (Test-Path $Variables.PathToOffice86 ) { $Variables.Office32 = $true }Else { $Variables.office32 = $false }
    If ($Variables.office32 -or $Variables.Office64 -eq $true) { $Variables.officecheck = $true }
    If ($Variables.officecheck -eq $true) { Write-Status -Types "WAITING" -Status "Office Exists" -WriteWarning }
    Else { 
        Write-Status -Types "?" -Status "There are no Microsoft Office products on this device." -WriteWarning 
    }
    If ($Variables.officecheck -eq $true) { Remove-Office }
}
Function Get-Program {
    If ($SkipPrograms -or $Revert) {
        Write-Status -Types "@" -Status "Parameter -SkipProgams or -Undo detected.. Ignoring this section." -WriteWarning -ForegroundColorText RED
    }
    else {
        $chrome = @{
            Name              = "Google Chrome"
            Installed         = Test-Path -Path "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe" -ErrorAction SilentlyContinue
            DownloadURL       = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
            InstallerLocation = "$temp\googlechromestandaloneenterprise64.msi"
            FileExists        = Test-Path -Path "$temp\googlechromestandaloneenterprise64.msi" -ErrorAction SilentlyContinue
            ArgumentList      = "/passive"
        }
        $vlc = @{
            Name              = "VLC Media Player"
            Installed         = Test-Path -Path "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe" -ErrorAction SilentlyContinue
            #DownloadURL         = "https://ftp.osuosl.org/pub/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
            DownloadURL       = "https://get.videolan.org/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
            InstallerLocation = "$temp\vlc-3.0.18-win64.exe"
            FileExists        = Test-Path -Path "$temp\vlc-3.0.18-win64.exe" -ErrorAction SilentlyContinue
            ArgumentList      = "/S /L=1033"
        }
        $zoom = @{
            Name              = "Zoom"
            Installed         = Test-Path -Path "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe" -ErrorAction SilentlyContinue
            DownloadURL       = "https://zoom.us/client/5.15.2.18096/ZoomInstallerFull.msi?archType=x64"
            InstallerLocation = "$temp\ZoomInstallerFull.msi"
            FileExists        = Test-Path -Path "$temp\ZoomInstallerFull.msi" -ErrorAction SilentlyContinue
            ArgumentList      = "/quiet"
        }
        $acrobat = @{
            Name              = "Adobe Acrobat Reader"
            Installed         = Test-Path -Path "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" -ErrorAction SilentlyContinue
            DownloadURL       = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe"
            InstallerLocation = "$temp\AcroRdrDCx642200120085_MUI.exe"
            FileExists        = Test-Path -Path "$temp\AcroRdrDCx642200120085_MUI.exe" -ErrorAction SilentlyContinue
            ArgumentList      = "/sPB"
        }
        $HEVC = @{
            Name              = "HEVC/H.265 Codec"
            Installed         = $False
            DownloadURL       = "https://github.com/circlol/newload/raw/main/assets/Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx"
            InstallerLocation = "$temp\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx"
            FileExists        = Test-Path -Path "$temp\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx" -ErrorAction SilentlyContinue
        }

        foreach ( $program in $chrome, $vlc, $zoom, $acrobat, $hevc ) {
            Write-Section -Text $program.Name
            if ( $program.Installed -eq $false ) {
                if ( $program.FileExists -eq $false ) {
                    Get-NetworkStatus
                    try {
                        Write-Status -Types "+", $TweakType -Status "Downloading $($program.Name)" -NoNewLine
                        Start-BitsTransfer -Source $program.DownloadURL -Destination $program.InstallerLocation -TransferType Download -Dynamic
                        Get-Status
                    }
                    catch {
                        Write-Caption $_ -Type Failed
                        continue
                    }
                }
                If ($program.Name -eq $hevc.Name) {
                    Write-Status -Types "+", $TweakType -Status "Adding support to $($HEVC.name) codec..." -NoNewLine
                    try {
                        Add-AppPackage -Path $HEVC.InstallerLocation -ErrorAction SilentlyContinue
                    }
                    catch {
                        Write-Caption $_ -Type Failed
                        continue
                    }
                    Get-Status
                }
                else {
                    Write-Status -Types "+", $TweakType -Status "Installing $($program.Name)"
                    try {
                        Start-Process -FilePath $program.InstallerLocation -ArgumentList $program.ArgumentList -Wait
                    }
                    catch {
                        Write-Caption $_ -Type Failed
                        continue
                    }
                }
                if ($program.Name -eq $Chrome.name) {
                    Write-Status "+", $TweakType -Status "Adding UBlock Origin to Google Chrome"
                    Set-ItemPropertyVerified -Path $Variables.PathToUblockChrome -Name "update_url" -value $Variables.PathToChromeLink -Type STRING
                    Get-Status
                }
            }
            else {
                Write-Status -Types "@", $TweakType -Status "$($program.Name) already seems to be installed on this system.. Skipping Installation"
                if ($program.Name -eq $Chrome.name) {
                    Write-Status "+", $TweakType -Status "Adding UBlock Origin to Google Chrome"
                    Set-ItemPropertyVerified -Path $Variables.PathToUblockChrome -Name "update_url" -value $Variables.PathToChromeLink -Type STRING
                    Get-Status
                }
            }
        }

    }
}

Function Get-Status {
    <#
.SYNOPSIS
Displays the status of the command execution (successful or unsuccessful) and additional error information if the command fails.

.DESCRIPTION
The Get-Status function is used to display the status of the most recently executed command. If the command is successful, it will show "Successful" with a success caption. If the command is unsuccessful, it will show "Unsuccessful" with a failed caption and also display additional error information, including the error message, error type, and line number where the error occurred.

.PARAMETER None
This function does not accept any parameters.

.NOTES
The Get-Status function is typically used after running a command to quickly check whether it executed successfully or encountered an error.
#>
    if ($?) {
        $CaptionSucceeded = Get-Command Write-Caption -ErrorAction SilentlyContinue
        If ($CaptionSucceeded) {
            Write-Caption -Type Success
        }
        else {
            Write-Host "=> Successful" -ForegroundColor Green
        }
    }
    else {
        $errorMessage = $_.Exception.Message
        $lineNumber = $_.InvocationInfo.ScriptLineNumber
        $command = $_.InvocationInfo.Line
        $errorType = $_.CategoryInfo.Reason
        $errorString = @"
        -
        Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        Command run was: $command
        Reason for error was: $errorType
        Offending line number: $lineNumber
        Error Message: $errorMessage
        -
"@
        Add-Content $Variables.ErrorLog $errorString
        Write-Output $_
        continue
    }
}

Function New-SystemRestorePoint {
    [CmdletBinding(SupportsShouldProcess)]
    Param()
    $description = "Mother Computers Courtesy Restore Point"
    $restorePointType = "MODIFY_SETTINGS"
    $actionDescription = "Enabling system drive Restore Point..."
    if ($PSCmdlet.ShouldProcess($actionDescription, "Enable-SystemRestore")) {
        # Assure System Restore is enabled
        Write-Status -Types "+" -Status "Enabling System Restore"
        Enable-ComputerRestore -Drive "$env:SystemDrive\"
    }
    $actionDescription = "Creating new System Restore Point with description: $description and type: $restorePointType"
    if ($PSCmdlet.ShouldProcess($actionDescription, "Create-RestorePoint")) {
        # Creates a System Restore point
        Write-Status -Types "+" -Status "Creating System Restore Point: $description"
        Checkpoint-Computer -Description $description -RestorePointType $restorePointType
    }
}

Function Optimize-General {
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1
    )

    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )

    If (($Revert)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }

    If ($Variables.osVersion -like "*Windows 10*") {
        # code for Windows 10
        Write-Section -Text "Applying Windows 10 Specific Reg Keys"

        ## Changes search box to an icon
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Search Box to an Icon."
        Set-ItemPropertyVerified -Path $Variables.PathToCUSearch -Name "SearchboxTaskbarMode" -Value $OneTwo -Type DWord

        ## Removes Cortana from the taskbar
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cortana Button from Taskbar..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "ShowCortanaButton" -Value $Zero -Type DWord


        ##  Removes 3D Objects from "This PC"
        $PathToHide3DObjects = "$($Variables.PathToRegExplorerLocalMachine)\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        If (Test-Path -Path $PathToHide3DObjects) {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status)  3D Objects from This PC.."
            Remove-Item -Path $PathToHide3DObjects -Recurse
        }

        # Expands ribbon in 10 explorer
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Expanded Ribbon in Explorer.."
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\Ribbon" -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero

        ## Disabling Feeds Open on Hover
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Feeds Open on Hover..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToRegCurrentVersion)\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value $Zero -Type DWord

        #Disables live feeds in search
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Dynamic Content in Windows Search..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUFeedsDSB -Name "ShowDynamicContent" -Value $Zero -type DWORD
        Set-ItemPropertyVerified -Path $Variables.PathToCUSearchSettings -Name "IsDynamicSearchBoxEnabled" -Value $Zero -Type DWORD
    }
    elseif ($Variables.osVersion -like "*Windows 11*") {
        ## Code for Windows 11
        Write-Section -Text "Applying Windows 11 Specific Reg Keys"
        If ($Variables.BuildNumber -GE $Variables.Win22H2 ) {
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) More Icons in the Start Menu.."
            Set-ItemProperty -Path $Variables.PathToCUExplorerAdvanced -Name Start_Layout -Value $One -Type DWORD -Force
        }

        # Sets explorer to compact mode in 11
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Compact Mode View in Explorer "
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name UseCompactMode -Value $One -Type DWORD

        # Removes Chats from the taskbar in 11
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Chats from the Taskbar..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "TaskBarMn" -Value $Zero -Type DWORD

        # Removes Meet Now from the taskbar in 11
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Meet Now from the Taskbar..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToRegCurrentVersion)\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWORD -Value $One

        <# Adds Most Used Apps to Start Menu in 11
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Most Used Apps to Start Menu"
        Set-ItemPropertyVerified #>
    }
    else {
        # code for other operating systems
        # Check Windows version
        return "Don't know what happened. Closing"
        exit
    }

    Write-Section -Text "Explorer Related"

    ## Unpins taskview from Taskbar
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Task View from Taskbar..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "ShowTaskViewButton" -Value $Zero -Type DWord


    # Pinning This PC to Quick Access Page in Home (11) & Quick Access (10)
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Quick Access..."
    $Folder = (New-Object -ComObject Shell.Application).Namespace(0).ParseName("::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
    $verbs = $Folder.Verbs()
    foreach ($verb in $verbs) {
        if ($verb.Name -eq "Pin to Quick access") {
            $verb.DoIt()
            break
        }
    }

    ### Explorer related
    # Removes recent files in explorer quick menu
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Recents in Explorer..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUExplorer -Name "ShowRecent" -Value $Zero -Type DWORD

    # Removes frequent files in explorer quick menu
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Frequent in Explorer..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUExplorer -Name "ShowFrequent" -Value $Zero -Type DWORD

    # Removes drives without any media (usb hubs, wifi adapters, sd card readers, ect.)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Drives without Media..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "HideDrivesWithNoMedia" -Type DWord -Value $Zero

    # Launches Explorer to This PC
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Explorer Launch to This PC.."
    Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "LaunchTo" -Value $One -Type Dword

    # Adds User shortcut to desktop
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) User Files to Desktop..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\HideDesktopIcons\NewStartPanel" -Name $Variables.UsersFolder -Value $Zero -Type DWORD

    # Adds This PC shortcut to desktop
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Desktop..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\HideDesktopIcons\NewStartPanel" -Name $Variables.ThisPC -Value $Zero -Type DWORD

    # Expands details of file operations window
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Expanded File Operation Details by Default.."
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One


}
Function Optimize-Performance {
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1
    )

    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )

    If (($Revert)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }

    $ExistingPowerPlans = $((powercfg -L)[3..(powercfg -L).Count])
    # Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
    $BuiltInPowerPlans = @{
        "Power Saver"            = "a1841308-3541-4fab-bc81-f71556f20b4a"
        "Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
        "High Performance"       = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        "Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    }
    $UniquePowerPlans = $BuiltInPowerPlans.Clone()

    Write-Caption "Display"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)"
    Set-ItemPropertyVerified -Path $Variables.PathToGraphicsDrives -Name "HwSchMode" -Type DWord -Value 2
    
    # [@] (2 = Enable Ndu, 4 = Disable Ndu)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Ndu High RAM Usage..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMNdu -Name "Start" -Type DWord -Value 4
    # Details: https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
    # Will reduce Processes number considerably on > 4GB of RAM systems

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting SVCHost to match installed RAM size..."
    $RamInKB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
    Set-ItemPropertyVerified -Path $Variables.PathToLMControl -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $RamInKB


    Write-Section "Microsoft Edge Tweaks"
    Write-Caption "System and Performance"

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Edge Startup boost..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesEdge -Name "StartupBoostEnabled" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) run extensions and apps when Edge is closed..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesEdge -Name "BackgroundModeEnabled" -Type DWord -Value $Zero
    Write-Section -Text "Power Plan Tweaks"
    Write-Status -Types "@", $TweakType -Status "Cleaning up duplicated Power plans..."
    ForEach ($PowerCfgString in $ExistingPowerPlans) {
        $PowerPlanGUID = $PowerCfgString.Split(':')[1].Split('(')[0].Trim()
        $PowerPlanName = $PowerCfgString.Split('(')[-1].Replace(')', '').Trim()
        If (($PowerPlanGUID -in $BuiltInPowerPlans.Values)) {
            Write-Status -Types "@", $TweakType -Status "The '$PowerPlanName' power plan` is built-in, skipping $PowerPlanGUID ..."
            Continue
        }
        Try {
            If (($PowerPlanName -notin $UniquePowerPlans.Keys) -and ($PowerPlanGUID -notin $UniquePowerPlans.Values)) {
                $UniquePowerPlans.Add($PowerPlanName, $PowerPlanGUID)
            }
            Else {
                Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
                powercfg -Delete $PowerPlanGUID
            }
        }
        Catch {
            Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
            powercfg -Delete $PowerPlanGUID
        }
    }

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Monitor Timeout to AC: $($Variables.TimeoutScreenPluggedIn) and DC: $($Variables.TimeoutScreenBattery)..."
    powercfg -Change Monitor-Timeout-AC $Variables.TimeoutScreenPluggedIn
    powercfg -Change Monitor-Timeout-DC $Variables.TimeoutScreenBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Standby Timeout to AC: $($Variables.TimeoutStandByPluggedIn) and DC: $($Variables.TimeoutStandByBattery)..."
    powercfg -Change Standby-Timeout-AC $Variables.TimeoutStandByPluggedIn
    powercfg -Change Standby-Timeout-DC $Variables.TimeoutStandByBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Disk Timeout to AC: $($Variables.TimeoutDiskPluggedIn) and DC: $($Variables.TimeoutDiskBattery)..."
    powercfg -Change Disk-Timeout-AC $Variables.TimeoutDiskPluggedIn
    powercfg -Change Disk-Timeout-DC $Variables.TimeoutDiskBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Hibernate Timeout to AC: $($Variables.TimeoutHibernatePluggedIn) and DC: $($Variables.TimeoutHibernateBattery)..."
    powercfg -Change Hibernate-Timeout-AC $Variables.TimeoutHibernatePluggedIn
    Powercfg -Change Hibernate-Timeout-DC $Variables.TimeoutHibernateBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Power Plan to High Performance..."
    powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c


    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Creating the Ultimate Performance hidden Power Plan..."
    powercfg -DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61


    Write-Section "Network & Internet"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Unlimiting your network bandwidth for all your system..." # Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesPsched -Name "NonBestEffortLimit" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfile -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff

    Write-Section "System & Apps Timeout behaviors"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing Time to services app timeout to 2s to ALL users..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMControl -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000 # Default: 20000 / 5000
    Write-Status -Types "*", $TweakType -Status "Don't clear page file at shutdown (takes more time) to ALL users..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMMemoryManagement -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing mouse hover time events to 10ms..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUMouse -Name "MouseHoverTime" -Type String -Value "1000" # Default: 400


    # Details: https://windowsreport.com/how-to-speed-up-windows-11-animations/ and https://www.tenforums.com/tutorials/97842-change-hungapptimeout-value-windows-10-a.html
    ForEach ($DesktopRegistryPath in @($Variables.PathToUsersControlPanelDesktop, $Variables.PathToCUControlPanelDesktop)) {
        <# $DesktopRegistryPath is the path related to all users and current user configuration #>
        If ($DesktopRegistryPath -eq $Variables.PathToUsersControlPanelDesktop) {
            Write-Caption "TO ALL USERS"
        }
        ElseIf ($DesktopRegistryPath -eq $Variables.PathToCUControlPanelDesktop) {
            Write-Caption "TO CURRENT USER"
        }
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Don't prompt user to end tasks on shutdown..."
        Set-ItemPropertyVerified -Path $DesktopRegistryPath -Name "AutoEndTasks" -Type DWord -Value 1 # Default: Removed or 0

        Write-Status -Types "*", $TweakType -Status "Returning 'Hung App Timeout' to default..."
        If ((Get-Item "$DesktopRegistryPath").Property -contains "HungAppTimeout") {
            Remove-Path "$DesktopRegistryPath" -Name "HungAppTimeout"
        }

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing mouse and keyboard hooks timeout to 1s..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "LowLevelHooksTimeout" -Type DWord -Value 1000 # Default: Removed or 5000

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing animation speed delay to 1ms on Windows 11..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "MenuShowDelay" -Type DWord -Value 1 # Default: 400

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing Time to kill apps timeout to 5s..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000 # Default: 20000
    }

    Write-Section "Gaming Responsiveness Tweaks"
    Write-Status -Types "*", $TweakType -Status "Enabling game mode..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUGameBar -Name "AllowAutoGameMode" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path $Variables.PathToCUGameBar -Name "AutoGameModeEnabled" -Type DWord -Value 1

    # Details: https://www.reddit.com/r/killerinstinct/comments/4fcdhy/an_excellent_guide_to_optimizing_your_windows_10/
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reserving 100% of CPU to Multimedia/Gaming tasks..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfile -Name "SystemResponsiveness" -Type DWord -Value 0 # Default: 20

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Dedicate more CPU/GPU usage to Gaming tasks..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "GPU Priority" -Type DWord -Value 8 # Default: 8
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Priority" -Type DWord -Value 6 # Default: 2
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Scheduling Category" -Type String -Value "High" # Default: "Medium"

}
Function Optimize-Privacy {
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1
    )

    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )

    If (($Revert)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }
    Write-Section -Text "Personalization"
    Write-Caption -Text "Start & Lockscreen"

    # Executes the array above
    Write-Status -Types "?", $TweakType -Status "From Path: [$($Variables.PathToCUContentDeliveryManager)]." -WriteWarning
    ForEach ($Name in $Variables.ContentDeliveryManagerDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemPropertyVerified -Path $Variables.PathToCUContentDeliveryManager -Name "$Name" -Type DWord -Value $Zero
    }

    # Disables content suggestions in settings
    Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) 'Suggested Content in the Settings App'..."
    If (Test-Path "$($Variables.PathToCUContentDeliveryManager)\Subscriptions") {
        Remove-Item -Path "$($Variables.PathToCUContentDeliveryManager)\Subscriptions" -Recurse
    }

    # Disables content suggestion in start
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Show Suggestions' in Start..."
    If (Test-Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps") {
        Remove-Item -Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps" -Recurse
    }

    Write-Section -Text "Privacy -> Windows Permissions"
    Write-Caption -Text "General"

    # Disables Advertiser ID through permissions and group policy.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Let apps use my advertising ID..."
    Set-ItemPropertyVerified -Path $Variables.PathToRegAdvertising -Name "Enabled" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesAdvertisingInfo -Name "DisabledByGroupPolicy" -Type DWord -Value $One

    # Disables locally relevant content
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Let websites provide locally relevant content by accessing my language list'..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUUP -Name "HttpAcceptLanguageOptOut" -Type DWord -Value $One

    Write-Caption -Text "Speech"
    # Removes consent for online speech recognition services.
    # [@] (0 = Decline, 1 = Accept)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Online Speech Recognition..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUOnlineSpeech -Name "HasAccepted" -Type DWord -Value $Zero

    Write-Caption -Text "Inking & Typing Personalization"
    # Disables personalization of inking and typing data (Keystrokes)
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUInputPersonalization)\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitInkCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitTextCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path $Variables.PathToCUPersonalization -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero -ErrorAction SilentlyContinue

    Write-Caption -Text "Diagnostics & Feedback"
    #Disables Telemetry
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) telemetry..."
    # [@] (0 = Security (Enterprise only), 1 = Basic Telemetry, 2 = Enhanced Telemetry, 3 = Full Telemetry)
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry2 -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry -Name "AllowDeviceNameInTelemetry" -Type DWord -Value $Zero


    # Disables Microsofts collection of inking and typing data
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) send inking and typing data to Microsoft..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUInputTIPC -Name "Enabled" -Type DWord -Value $Zero

    # Disables Microsoft's tailored experiences.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experiences..."
    Set-ItemPropertyVerified -Path $Variables.PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value $Zero

    # Disables transcript of diagnostic data for collection
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) View diagnostic data..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMEventKey -Name "EnableEventTranscript" -Type DWord -Value $Zero

    # Sets feedback frequency to 0
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) feedback frequency..."
    If ((Test-Path "$($Variables.PathToCUSiufRules)\PeriodInNanoSeconds")) {
        Remove-ItemProperty -Path $Variables.PathToCUSiufRules -Name "PeriodInNanoSeconds"
    }
    Set-ItemPropertyVerified -Path $Variables.PathToCUSiufRules -Name "NumberOfSIUFInPeriod" -Type DWord -Value $Zero

    Write-Caption -Text "Activity History"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Activity History..."
    $ActivityHistoryDisableOnZero = @(
        "EnableActivityFeed"
        "PublishUserActivities"
        "UploadUserActivities"
    )
    Write-Status -Types "?", $TweakType -Status "From Path: [$($Variables.PathToLMActivityHistory)]" -WriteWarning
    ForEach ($Name in $ActivityHistoryDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemPropertyVerified -Path $Variables.PathToLMActivityHistory -Name $Name -Type DWord -Value $Zero
    }

    # Disables Suggested ways of getting the most out of windows (Microsoft account spam)
    Write-Status -Types "-" , $TweakType -Status "$($EnableStatus[1].Status) 'Suggest ways i can finish setting up my device to get the most out of windows.')"
    Set-ItemPropertyVerified -Path $Variables.PathToCUUserProfileEngagemment -Name "ScoobeSystemSettingEnabled" -Value $Zero -Type DWord

    ### Privacy
    Write-Section -Text "Privacy"
    If (Test-Path -Path "$($Variables.PathToCUContentDeliveryManager)\Subscriptionn") {
        Remove-Item -Path "$($Variables.PathToCUContentDeliveryManager)\Subscriptionn" -Recurse -Force
    }
    If (Test-Path -Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps") {
        Remove-Item -Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps" -Recurse -Force
    }

    # Disables app launch tracking
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) App Launch Tracking..."
    Set-ItemPropertyVerified -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $One -Type DWORD

    If ($vari -eq '2') {
        Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force -ErrorAction SilentlyContinue
    }

    # Sets windows feeback notifciations to never show
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Feedback Notifications..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One

    # Disables location tracking
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Location Tracking..."
    Set-ItemPropertyVerified -Path $Variables.RegCAM -Name "Value" -Type String -Value "Deny"
    Set-ItemPropertyVerified -Path $Variables.PathToLFSVC -Name "Status" -Type DWORD -Value $Zero

    # Disables map updates (Windows Maps is removed)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Automatic Map Updates..."
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $Zero

    # AutoConnect to Hotspots disabled
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) AutoConnect to Sense Hotspots..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWORD -Value $Zero

    # Disables reporting hotspots to microsoft
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Hotspot Reporting to Microsoft..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowWiFiHotSpotReporting" -Name "Value" -Type DWORD -Value $Zero

    # Disables cloud content from search (OneDrive, Office, Dropbox, ect.)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cloud Content from Windows Search..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $One

    # Disables tailored experience w users diagnostic data.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experience w/ Diagnostic Data..."
    Set-ItemPropertyVerified -Path $Variables.PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value $Zero -Type DWORD

    # Disables HomeGroup
    Write-Status -Types $EnableStatus[1].Symbol, "$TweakType" -Status "Stopping and disabling Home Groups services.."
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
        Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue
    }
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
        Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue
    }

    # Disables SysMain
    If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped') { } else {
        Write-Host ' Stopping and disabling Superfetch service'
        Stop-Service "SysMain" -WarningAction SilentlyContinue
        Set-Service "SysMain" -StartupType Disabled
    }

    # Disables volume lowering during calls
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Volume Adjustment During Calls..."
    Set-ItemPropertyVerified -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD

    # Groups SVChost processes
    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
    Write-Status -Types $EnableStatus[1].Symbol, "$TweakType" -Status "Grouping svchost.exe Processes"
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram

    # Stack size increased for greater performance
    Write-Status -Types $EnableStatus[1].Symbol, "$TweakType" -Status "Increasing Stack Size to 30"
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30

    # Sets DNS settings to Google with CloudFlare as backup
    If (Get-Command Set-DnsClientDohServerAddress -ErrorAction SilentlyContinue) {
        ## Imported text from  win10-debloat-tools on github
        # Adapted from: https://techcommunity.microsoft.com/t5/networking-blog/windows-insiders-gain-new-dns-over-https-controls/ba-p/2494644
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS over HTTPS for Google and Cloudflare (ipv4 and ipv6)..."
        Set-DnsClientDohServerAddress -ServerAddress ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001") -AutoUpgrade $true -AllowFallbackToUdp $true
        Set-DnsClientDohServerAddress -ServerAddress ("8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844") -AutoUpgrade $true -AllowFallbackToUdp $true
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS from Cloudflare and Google (ipv4 and ipv6)..."
        #Get-DnsClientServerAddress # To look up the current config.           # Cloudflare, Google,         Cloudflare,              Google
        Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
        Set-DNSClientServerAddress -InterfaceAlias    "Wi-Fi*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Failed to set up DNS - DNSClient is not Installed..." -WriteWarning
    }

    Write-Section -Text "Ease of Access"
    Write-Caption -Text "Keyboard"
    # Disables Sticky Keys
    Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) Sticky Keys..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUAccessibility)\StickyKeys" -Name "Flags" -Value "506" -Type STRING
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUAccessibility)\Keyboard Response" -Name "Flags" -Value "122" -Type STRING
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUAccessibility)\ToggleKeys" -Name "Flags" -Value "58" -Type STRING

    If ($Revert) {
        Remove-ItemProperty -Path $Variables.PathToLMPoliciesTelemetry -Name AllowTelemetry -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $Variables.PathToLMPoliciesTelemetry2 -Name "AllowTelemetry" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $Variables.PathToCUPersonalization -Name "AcceptedPrivacyPolicy" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitTextCollection" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitInkCollection" -Force -ErrorAction SilentlyContinue
        Set-Service "DiagTrack" -StartupType Automatic -ErrorAction SilentlyContinue
        Set-Service "dmwappushservice" -StartupType Automatic -ErrorAction SilentlyContinue
        Set-Service "SysMain" -StartupType Automatic -ErrorAction SilentlyContinue
    }

    Write-Section -Text "Privacy -> Apps Permissions"
    #Write-Caption -Text "Location"
    #Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    #Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    #Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value $Zero
    #Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "EnableStatus" -Type DWord -Value $Zero

    Write-Caption -Text "Notifications"
    Set-ItemPropertyVerified -Path $Variables.PathToLMConsentStoreUN -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "App Diagnostics"
    Set-ItemPropertyVerified -Path $Variables.PathToCUConsentStoreAD -Name "Value" -Value "Deny" -Type String
    Set-ItemPropertyVerified -Path $Variables.PathToLMConsentStoreAD -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "Account Info Access"
    Set-ItemPropertyVerified -Path $Variables.PathToCUConsentStoreUAI -Name "Value" -Value "Deny" -Type String
    Set-ItemPropertyVerified -Path $Variables.PathToLMConsentStoreUAI -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "Voice Activation"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Voice Activation"
    Set-ItemPropertyVerified -Path $Variables.PathToVoiceActivation -Name "AgentActivationEnabled" -Value $Zero -Type DWord

    Write-Caption -Text "Background Apps"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps"
    Set-ItemPropertyVerified -Path $Variables.PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Value $One -Type DWord
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps Global"
    Set-ItemPropertyVerified -Path $Variables.PathToCUSearch -Name "BackgroundAppGlobalToggle" -Value $Zero -Type DWord

    Write-Caption -Text "Other Devices"
    Write-Status -Types "-", $TweakType -Status "Denying device access..."
    # Disable sharing information with unpaired devices
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUDeviceAccessGlobal)\LooselyCoupled" -Name "Value" -Value "Deny" -Type String
    ForEach ($key in (Get-ChildItem $Variables.PathToCUDeviceAccessGlobal)) {
        If ($key.PSChildName -EQ "LooselyCoupled") { continue }
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Setting $($key.PSChildName) value to 'Deny' ..."
        Set-ItemPropertyVerified -Path "$("$($Variables.PathToCUDeviceAccessGlobal)\" + $key.PSChildName)" -Name "Value" -Value "Deny"
    }

    Write-Caption -Text "Background Apps"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Background Apps..."
    Set-ItemPropertyVerified -Path $Variables.PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path $Variables.PathToCUSearch -Name "BackgroundAppGlobalToggle" -Type DWord -Value 1

    Write-Caption -Text "Troubleshooting"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Automatic Recommended Troubleshooting, then notify me..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMWindowsTroubleshoot -Name "UserPreference" -Type DWord -Value 3

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Spotlight Features..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Third Party Suggestions..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) More Telemetry Features..."

    $CloudContentDisableOnOne = @(
        "DisableWindowsSpotlightFeatures"
        "DisableWindowsSpotlightOnActionCenter"
        "DisableWindowsSpotlightOnSettings"
        "DisableWindowsSpotlightWindowsWelcomeExperience"
        "DisableTailoredExperiencesWithDiagnosticData"      # Tailored Experiences
        "DisableThirdPartySuggestions"
    )

    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUPoliciesCloudContent]." -WriteWarning
    ForEach ($Name in $CloudContentDisableOnOne) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $One"
        Set-ItemPropertyVerified -Path $Variables.PathToCUPoliciesCloudContent -Name "$Name" -Type DWord -Value $One -ErrorAction SilentlyContinue
    }
    Set-ItemPropertyVerified -Path $Variables.PathToCUPoliciesCloudContent -Name "ConfigureWindowsSpotlight" -Type DWord -Value 2
    Set-ItemPropertyVerified -Path $Variables.PathToCUPoliciesCloudContent -Name "IncludeEnterpriseSpotlight" -Type DWord -Value $Zero

    # Disabling app suggestions
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Apps Suggestions..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesCloudContent -Name "DisableThirdPartySuggestions" -Type DWord -Value $One
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWord -Value $One


    # Reference: https://forums.guru3d.com/threads/windows-10-registry-tweak-for-disabling-drivers-auto-update-controversy.418033/
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) automatic driver updates..."
    # [@] (0 = Yes, do this automatically, 1 = No, let me choose what to do, Always install the best, 2 = [...] Install driver software from Windows Update, 3 = [...] Never install driver software from Windows Update
    Set-ItemPropertyVerified -Path $Variables.PathToLMDeviceMetaData -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value $One
    # [@] (0 = Enhanced icons enabled, 1 = Enhanced icons disabled)
    Set-ItemPropertyVerified -Path $Variables.PathToLMDriverSearching -Name "SearchOrderConfig" -Type DWord -Value $Zero


    ## Performance Tweaks and More Telemetry
    Set-ItemPropertyVerified -Path $Variables.PathToLMControl -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
    Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "MenuShowDelay" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
    Remove-ItemProperty -Path $Variables.PathToCUControlPanelDesktop -Name "HungAppTimeout" -ErrorAction SilentlyContinue
    # Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "HungAppTimeout" -Type DWord -Value 4000 # Note: This caused flickering
    Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "AutoEndTasks" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "LowLevelHooksTimeout" -Type DWord -Value 1000
    Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
    Set-ItemPropertyVerified -Path $Variables.PathToLMMemoryManagement -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path $Variables.PathToCUMouse -Name "MouseHoverTime" -Type DWord -Value 10

    # Network Tweaks
    Set-ItemPropertyVerified -Path $Variables.PathToLMLanmanServer -Name "IRPStackSize" -Type DWord -Value 20

    # Gaming Tweaks
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "GPU Priority" -Type DWord -Value 8
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Priority" -Type DWord -Value 6
    Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Scheduling Category" -Type String -Value "High"

    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesSQMClient -Name "CEIPEnable" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesAppCompact -Name "AITEnable" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesAppCompact -Name "DisableUAR" -Type DWord -Value $One

    # Details: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004#windows-system-startup-event-traces-autologgers
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) some startup event traces (AutoLoggers)..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToLMAutoLogger)\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "$($Variables.PathToLMAutoLogger)\SQMLogger" -Name "Start" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: HotSpot Sharing'..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowWiFiHotSpotReporting" -Name "value" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: Shared HotSpot Auto-Connect'..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowAutoConnectToWiFiSenseHotspots" -Name "value" -Type DWord -Value $Zero

    Write-Caption "Deleting useless registry keys..."
    $KeysToDelete = @(
        # Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        # Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        # Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )

    ForEach ($Key in $KeysToDelete) {
        $KeyExist = Test-Path $key
        If ($KeyExist -eq $true) {
            Write-Status -Types "-", $TweakType -Status "Removing Key: [$Key]"
            Remove-Item $Key -Recurse
        }
    }
}
Function Optimize-Security {
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1
    )

    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )

    If (($Revert)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }
    Write-Section "Security Patch"
    Write-Status -Types "+", $TweakType -Status "Applying Security Vulnerability Patch CVE-2023-36884 - Office and Windows HTML Remote Code Execution Vulnerability"
    $SecurityPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BLOCK_CROSS_PROTOCOL_FILE_NAVIGATION"
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Excel.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Graph.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "MSAccess.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "MSPub.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Powerpnt.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Visio.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "WinProj.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "WinWord.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Wordpad.exe" -Type DWORD -Value 1

    Write-Section "Windows Firewall"
    Write-Status -Types "+", $TweakType -Status "Enabling default firewall profiles..."
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

    Write-Section "Windows Defender"
    Write-Status -Types "+", $TweakType -Status "Enabling Microsoft Defender Exploit Guard network protection..." -NoNewLine
    try { 
        Set-MpPreference -EnableNetworkProtection Enabled -Force 
    }
    catch {
        Get-Status
        Write-Caption $_ -Type Failed
        continue
    }
    Get-Status

    Write-Status -Types "+", $TweakType -Status "Enabling detection for potentially unwanted applications and block them..." -NoNewLine
    try { 
        Set-MpPreference -PUAProtection Enabled -Force
    }
    catch {
        Get-Status
        Write-Caption $_ -Type Failed
        continue
    }
    Get-Status

    Write-Section "SmartScreen"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) 'SmartScreen' for Microsoft Edge..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesEdge)\PhishingFilter" -Name "EnabledV9" -Type DWord -Value $One

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) 'SmartScreen' for Store Apps..."
    Set-ItemPropertyVerified -Path $Variables.PathToCUAppHost-Name "EnableWebContentEvaluation" -Type DWord -Value $One
    
    Write-Section "Old SMB Protocol"
    Write-Status -Types "+", $TweakType -Status "Disabling SMB 1.0 protocol..." -NoNewLine
    try { 
        Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force 
    }
    catch {
        Get-Status
        Write-Caption $_ -Type Failed
        continue
    }
    Get-Status

    Write-Section "Old .NET cryptography"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) .NET strong cryptography..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMOldDotNet -Name "SchUseStrongCrypto" -Type DWord -Value $One
    Set-ItemPropertyVerified -Path $Variables.PathToLMWowNodeOldDotNet -Name "SchUseStrongCrypto" -Type DWord -Value $One
    
    Write-Section "Autoplay and Autorun (Removable Devices)"
    Write-Status -Types "-", $TweakType -Status "Disabling Autoplay..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value $One

    Write-Status -Types "-", $TweakType -Status "Disabling Autorun for all Drives..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesExplorer -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

    Write-Section "Windows Explorer"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Show file extensions in Explorer..."
    Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorerAdvanced)" -Name "HideFileExt" -Type DWord -Value $Zero

    Write-Section "User Account Control (UAC)"
    Write-Status -Types "+", $TweakType -Status "Raising UAC level..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesSystem -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesSystem -Name "PromptOnSecureDesktop" -Type DWord -Value 1

    Write-Section "Windows Update"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) offer Malicious Software Removal Tool via Windows Update..."
    Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesMRT -Name "DontOfferThroughWUAU" -Type DWord -Value $Zero
}
Function Optimize-Service {
    If ($Revert) {
        Write-Status -Types "*", "Services" -Status "Reverting the tweaks is set to '$Revert'."
        Set-ServiceStartup -State 'Manual' -Services $Variables.ServicesToDisabled -Filter $Variables.EnableServicesOnSSD
    }
    Else {
        Set-ServiceStartup -State 'Disabled' -Services $Variables.ServicesToDisabled -Filter $Variables.EnableServicesOnSSD
    }
    Write-Section "Enabling services from Windows"
    If ($Variables.IsSystemDriveSSD -or $Revert) {
        Set-ServiceStartup -State 'Automatic' -Services $Variables.EnableServicesOnSSD
    }
    Set-ServiceStartup -State 'Manual' -Services $Variables.ServicesToManual
}
function Optimize-SSD {
    # SSD life improvement
    Write-Section "SSD Optimization"
    Write-Status -Types "+" -Status "Disabling last access timestamps updates on files"
    fsutil behavior set DisableLastAccess 1
    Get-Status
}
Function Optimize-TaskScheduler {
    If ($Revert) {
        Write-Status -Types "*", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
        $CustomMessage = { "Resetting the $ScheduledTask task as 'Ready' ..." }
        Set-ScheduledTaskState -Ready -ScheduledTask $Variables.DisableScheduledTasks -CustomMessage $CustomMessage
    }
    Else {
        Set-ScheduledTaskState -Disabled -ScheduledTask $Variables.DisableScheduledTasks
    }

    Write-Section -Text "Enabling Scheduled Tasks from Windows"
    Set-ScheduledTaskState -Ready -ScheduledTask $Variables.EnableScheduledTasks
}
Function Optimize-WindowsOptional {
    If ($Revert) {
        Write-Status -Types "*", "OptionalFeature" -Status "Reverting the tweaks is set to '$Revert'."
        $CustomMessage = { "Re-Installing the $OptionalFeature optional feature..." }
        Set-OptionalFeatureState -Enabled -OptionalFeatures $Variables.DisableFeatures -CustomMessage $CustomMessage
    }
    Else {
        Set-OptionalFeatureState -Disabled -OptionalFeatures $Variables.DisableFeatures
    }

    Write-Section -Text "Install Optional Features from Windows"
    Set-OptionalFeatureState -Enabled -OptionalFeatures $Variables.EnableFeatures


    Write-Section -Text "Removing Unnecessary Printers"
    $printers = "Microsoft XPS Document Writer", "Fax", "OneNote"
    foreach ($printer in $printers) {
        try {
            Remove-Printer -Name $printer -ErrorAction Stop
            Write-Status -Types "-", "Printer" -Status "Removed $printer..."
        }
        catch {
            Write-Status -Types "?", "Printer" -Status "Failed to remove $printer : $_" -WriteWarning
        }
    }
}

Function Remove-InstalledProgram {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [string]$UninstallString,
        [Parameter(ValueFromPipeline = $true)]
        [string]$Name
    )
    process {
        try {
            $actionDescription = "Uninstalling $Name..."
            if ($PSCmdlet.ShouldProcess($actionDescription, "Uninstall")) {
                Write-Host "Uninstalling $Name..."
                if ($UninstallString -match "msiexec.exe /i*") {
                    # Uninstall using MSIExec
                    $arguments = $UninstallString.Split(" ", 2)[1]
                    Start-Process -FilePath 'msiexec.exe' -ArgumentList "$arguments" -Wait -NoNewWindow
                }
                elseif ($UninstallString -match 'msiexec.exe /x') { <# add this part later #> }
                else {
                    # Uninstall using regular command
                    Start-Process "$UninstallString" -Wait -NoNewWindow
                }
                Write-Host "$Name uninstalled successfully."
            }
        }
        catch {
            Write-Host "An error occurred during program uninstallation: $_"
        }
    }

}

Function Remove-Office {
    [CmdletBinding(SupportsShouldProcess)]
    Param()


    $msgBoxInput = Show-Question -YesNo -Message "  Microsoft Office was found on this system. Would you like to remove it?" -Icon Question
    switch ($msgBoxInput) {
        'Yes' {
            $actionDescription = "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
            if ($PSCmdlet.ShouldProcess($actionDescription, "Download-SaRA")) {
                Write-Status "+", $TweakType -Status "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
                Get-NetworkStatus
                Start-BitsTransfer -Source:$Variables.SaRAURL -Destination:$Variables.SaRA -TransferType Download -Dynamic | Out-Host
                Expand-Archive -Path $Variables.SaRA -DestinationPath $Variables.Sexp -Force
                Get-Status
            }

            $SaRAcmdexe = (Get-ChildItem $Variables.Sexp -Include SaRAcmd.exe -Recurse).FullName

            $actionDescription = "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)..."
            if ($PSCmdlet.ShouldProcess($actionDescription, "Start-OfficeScrubScenario")) {
                Write-Status "+", $TweakType -Status "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)... "
                Start-Process $SaRAcmdexe -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All"
            }
        }
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -WriteWarning
        }
    }
}
Function Remove-PinnedStartMenu {
    [CmdletBinding(SupportsShouldProcess)]
    Param()

    $START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

    $layoutFile = "C:\Windows\StartMenuLayout.xml"

    # Delete layout file if it already exists
    # Creates the blank layout file
    if ($PSCmdlet.ShouldProcess("Out-File $StartlayoutFile -Encoding ASCII", "Remove-LayoutModificationFile")) {
        If (Test-Path $layoutFile) { Remove-Item $layoutFile }
        $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
    }

    $regAliases = @("HKLM", "HKCU")
    #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
    foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer"
        if ($PSCmdlet.ShouldProcess("Setting LockedStartLayout to 1", "Set-ItemPropertyVerified")) {
            Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 1 -Type DWORD
            Set-ItemPropertyVerified -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile -Type ExpandString
        }
    }

    #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
    if ($PSCmdlet.ShouldProcess("Stop-Process -Name Explorer")) {
        Stop-Process -name explorer
    }

    if ($PSCmdlet.ShouldProcess("New-Object")) {
        Start-Sleep -s 5
        $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
        Start-Sleep -s 5
    }

    #Enable the ability to pin items again by disabling "LockedStartLayout"
    foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer"
        if ($PSCmdlet.ShouldProcess("Setting LockedStartLayout to 0", "Set-ItemPropertyVerified")) {
            Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 0 -Type DWORD
        }
    }


    #Restart Explorer and delete the layout file
    if ($PSCmdlet.ShouldProcess("Stop-Process -Name Explorer")) {
        Stop-Process -name explorer
    }
    # Uncomment the next line to make clean start menu default for all new users
    if ($PSCmdlet.ShouldProcess("Import-StartLayout -LayoutPath $($layoutFile) -MountPath $env:SystemDrive\", "Remove-Item $($LayoutFile)")) {
        Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
        Remove-Item $layoutFile
    }
}
Function Remove-UWPAppx {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"
    ForEach ($AppxPackage in $AppxPackages) {
        $appxPackageToRemove = Get-AppxPackage -AllUsers -Name $AppxPackage -ErrorAction SilentlyContinue
        if ($appxPackageToRemove) {
            $actionDescription = "Removing $AppxPackage"
            if ($PSCmdlet.ShouldProcess($actionDescription, "Remove-AppxPackage")) {
                $appxPackageToRemove | ForEach-Object -Process {
                    Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage" -NoNewLine
                    Remove-AppxPackage $_.PackageFullName -ErrorAction SilentlyContinue -WA SilentlyContinue >$NULL | Out-Null #4>&1 | Out-Null
                    If ($?) { Get-Status ; $Variables.Removed++ ; $Variables.PackagesRemoved += $appxPackageToRemove.PackageFullName } elseif (!($?)) { Get-Status ; $Variables.Failed++ }
                }

                $actionDescription = "Removing Provisioned Appx $AppxPackage"
                if ($PSCmdlet.ShouldProcess($actionDescription, "Remove-AppxProvisionedPackage")) {
                    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
                    If ($?) { $Variables.Removed++ ; $Variables.PackagesRemoved += "Provisioned Appx $($appxPackageToRemove.PackageFullName)" } elseif (!($?)) { $Variables.Failed++ }
                }
            }
        }
        else {
            $Variables.NotFound++
        }
    }
}
Function Restart-Explorer {
    <#
.SYNOPSIS
    Restarts the Windows Explorer process.

.DESCRIPTION
    The Restart-Explorer function is used to gracefully restart the Windows Explorer process. It first checks if the Explorer process is running and stops it using the taskkill command. After a brief delay, it starts the Explorer process again using the Start-Process cmdlet.

.PARAMETER None
    This function does not accept any parameters.

.NOTES
    The function supports the ShouldProcess feature for confirmation before stopping and starting the Explorer process.

.EXAMPLE
    Restart-Explorer

    DESCRIPTION
        Restarts the Windows Explorer process. It first stops the Explorer process and then starts it again.

#>
    [CmdletBinding(SupportsShouldProcess)]
    Param()
    # Checks is explorer is running
    $ExplorerActive = Get-Process -Name explorer -ErrorAction SilentlyContinue
    if ($ExplorerActive) {
        try {
            if ($PSCmdlet.ShouldProcess("Stop explorer process")) {
                taskkill /f /im explorer.exe
            }
        }
        catch {
            Write-Warning "Failed to stop Explorer process: $_"
            return
        }
    }
    try {
        if ($PSCmdlet.ShouldProcess("Start explorer process")) {
            Start-Process explorer -ErrorAction SilentlyContinue -Wait
        }
    }
    catch {
        Write-Error "Failed to start Explorer process: $_"
        return
    }
}
Function Request-PCRestart {
    $restartMessage = " It is recommended to to restart computer to apply changes.
                        Do you want to do that now?"
    switch (Show-Question -YesNo -Title "New Loads Completed" -Icon Warning -Message $restartMessage) {
        'Yes' {
            Write-Host "You choose to Restart now"
            Restart-Computer
        }
        'No' {
            Write-Host "You choose to Restart later"
        }
        'Cancel' {
            Write-Host "You choose to Restart later"
        }
    }

}
Function Set-Branding {
    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Switch]$Revert,
        [Switch]$NoBranding
    )

    $TweakType = "Branding"

    If (!$Revert) {
        If ($NoBranding) {
            Write-Status -Types "@" -Status "Parameter -NoBranding detected.. Skipping Mother Computers branding" -WriteWarning -ForegroundColorText RED
        }
        else {
            # - Adds Mother Computers support info to About.
            $actionDescription = "Adding Mother Computers branding"
            if ($PSCmdlet.ShouldProcess($actionDescription)) {
                Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
                Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "Manufacturer" -Type String -Value $Variables.store
                Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
                Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportPhone" -Type String -Value $Variables.phone
                Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
                Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportHours" -Type String -Value $Variables.hours
                Write-Status -Types "+", $TweakType -Status "Adding Store URL to Support Page"
                Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportURL" -Type String -Value $Variables.website
                Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
                Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name $Variables.page -Type String -Value $Variables.Model
            }
        }
    }
    elseif ($Revert) {
        # - Removes Mother Computers support info from About.
        $actionDescription = "Removing Mother Computers branding"
        if ($PSCmdlet.ShouldProcess($actionDescription)) {
            Write-Status -Types "-", $TweakType -Status "Removing Mother Computers from Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "Manufacturer" -Type String -Value ""
            Write-Status -Types "-", $TweakType -Status "Removing Mothers Number from Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportPhone" -Type String -Value ""
            Write-Status -Types "-", $TweakType -Status "Removing Store Hours from Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportHours" -Type String -Value ""
            Write-Status -Types "-", $TweakType -Status "Removing Store URL from Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportURL" -Type String -Value ""
            Write-Status -Types "-", $TweakType -Status "Removing Store Number from Settings Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name $Variables.page -Type String -Value ""
        }
    }
}
Function Set-ItemPropertyVerified {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Alias("V")]
        [Parameter(Mandatory = $true)]
        $Value,

        [Alias("N")]
        [Parameter(Mandatory = $true)]
        $Name,

        [Alias("T")]
        [Parameter(Mandatory = $true)]
        [ValidateSet("String", "ExpandString", "Binary", "DWord", "MultiString", "QWord", "Unknown")]
        $Type,

        [Alias("P")]
        [Parameter(Mandatory = $true)]
        $Path,

        [Alias("F")]
        [Parameter(Mandatory = $False)]
        [Switch]$Force,

        [Parameter(Mandatory = $False)]
        [Switch]$Passthru
    )

    $keyExists = Test-Path -Path $Path
    if (!$keyExists) {
        if ($PSCmdlet.ShouldProcess("Creating key at $Path", "New-Item")) {
            New-Item -Path $Path -Force | Out-Null
            $Global:CreatedKeys++
        }
    }

    $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $currentValue -or $currentValue.$Name -ne $Value) {
        $actionDescription = "Setting $Name to $Value in $Path"
        if ($PSCmdlet.ShouldProcess($actionDescription, "Set")) {
            try {
                Write-Status -Types "+" -Status "$Name set to $Value in $Path" -NoNewLine

                $params = @{
                    Path          = $Path
                    Name          = $Name
                    Value         = $Value
                    Type          = $Type
                    ErrorAction   = 'Stop'
                    Passthru      = $Passthru
                    WarningAction = $warningPreference
                }

                if ($Force) {
                    $params['Force'] = $true
                }
                Set-ItemProperty @params

                if ($? -eq $True) {
                    Get-Status
                    $Global:ModifiedRegistryKeys++
                }
                else {
                    Get-Status
                }
            }
            catch {
                $lineNumber = $_.InvocationInfo.ScriptLineNumber
                $command = $_.InvocationInfo.Line
                $errorType = $_.CategoryInfo.Reason
                $errorString = @"
-
Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Command run was: $command
Reason for error was: $errorType
Offending line number: $lineNumber
Error Message: $_
-
"@
                Add-Content $Variables.ErrorLog $errorString
                Write-Output $_
            }
        }
    }
    else {
        Write-Status -Types "@" -Status "Key already set to the desired value. Skipping"
    }
}
Function Set-OptionalFeatureState {
    <#
.SYNOPSIS
    Enables or disables Windows optional features on the host.

.DESCRIPTION
    The Set-OptionalFeatureState function is used to enable or disable Windows optional features on the host machine. It allows you to specify the features to be enabled or disabled using an array of feature names. You can also set a filter to skip certain features, provide a custom message for each feature, and use the `-WhatIf` switch to preview changes without applying them.

.PARAMETER Disabled
    Indicates that the specified optional features should be disabled. If this switch is present, the function will attempt to uninstall the specified features.

.PARAMETER Enabled
    Indicates that the specified optional features should be enabled. If this switch is present, the function will attempt to install the specified features.

.PARAMETER OptionalFeatures
    Specifies an array of names of the optional features that need to be enabled or disabled. This parameter is mandatory.

.PARAMETER Filter
    Specifies an array of feature names to skip. If a feature name matches any of the names in the filter, it will be skipped. This parameter is optional.

.PARAMETER CustomMessage
    Allows providing a custom message for each feature. If provided, the custom message will be displayed instead of the default messages.

.PARAMETER WhatIf
    If this switch is provided, the function will only preview the changes without actually enabling or disabling the features.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "Microsoft-Windows-Subsystem-Linux", "Telnet-Client"

    DESCRIPTION
        Enables the "Microsoft-Windows-Subsystem-Linux" and "Telnet-Client" optional features on the host.

.EXAMPLE
    Set-OptionalFeatureState -Disabled -OptionalFeatures "Internet-Explorer-Optional-amd64" -Filter "Telnet-Client"

    DESCRIPTION
        Disables the "Internet-Explorer-Optional-amd64" optional feature on the host. If the feature name matches the filter ("Telnet-Client"), it will be skipped.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "Media-Features", "XPS-Viewer" -CustomMessage { "Enabling feature: $_" }

    DESCRIPTION
        Enables the "Media-Features" and "XPS-Viewer" optional features on the host, displaying the custom message for each feature.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "LegacyComponents" -WhatIf

    DESCRIPTION
        Previews the changes of enabling the "LegacyComponents" optional feature without applying the changes.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [ScriptBlock] $CustomMessage,
        [Switch] $Enabled,
        [Switch] $Disabled,
        #[Array] $Filter,
        #[Parameter(Mandatory = $true)]
        [Array] $OptionalFeatures
    )

    $SecurityFilterOnEnable = @("IIS-*")
    $TweakType = "OptionalFeature"

    $OptionalFeatures | ForEach-Object {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $_ -ErrorAction SilentlyContinue
        if ($feature) {
            if ($_.DisplayName -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..."
                return
            }

            if (($_.DisplayName -in $SecurityFilterOnEnable) -and $Enabled) {
                Write-Status -Types "?", $TweakType -Status "Skipping $_ ($($feature.DisplayName)) to avoid a security vulnerability..."
                return
            }

            if (!$CustomMessage) {
                if ($Disabled) {
                    $actionDescription = "Uninstalling the $_ ($($feature.DisplayName)) optional feature..."
                    if ($PSCmdlet.ShouldProcess($actionDescription)) {
                        Write-Status -Types "-", $TweakType -Status $actionDescription
                        try {
                            $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart -WhatIf:$WhatIf
                        }
                        catch {
                            $errorMessage = $_.Exception.Message
                            $lineNumber = $_.InvocationInfo.ScriptLineNumber
                            $command = $_.InvocationInfo.Line
                            $errorType = $_.CategoryInfo.Reason
                            $errorString = @"
                            -
                            Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                            Command run was: $command
                            Reason for error was: $errorType
                            Offending line number: $lineNumber
                            Error Message: $errorMessage
                            -
"@
                            Add-Content $Variables.ErrorLog $errorString
                            Write-Output $_
                            continue
                        }
                    }
                }
                elseif ($Enabled) {
                    $actionDescription = "Installing the $_ ($($feature.DisplayName)) optional feature..."
                    if ($PSCmdlet.ShouldProcess($actionDescription)) {
                        Write-Status -Types "+", $TweakType -Status $actionDescription
                        try {
                            $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart -WhatIf:$WhatIf
                        }
                        catch {
                            $errorMessage = $_.Exception.Message
                            $lineNumber = $_.InvocationInfo.ScriptLineNumber
                            $command = $_.InvocationInfo.Line
                            $errorType = $_.CategoryInfo.Reason
                            $errorString = @"
                            -
                            Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                            Command run was: $command
                            Reason for error was: $errorType
                            Offending line number: $lineNumber
                            Error Message: $errorMessage
                            -
"@
                            Add-Content $Variables.ErrorLog $errorString
                            Write-Output $_
                            continue
                        }
                    }
                }
                else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Enabled)"
                }
            }
            else {
                $customMessageText = $CustomMessage.Invoke($_)
                Write-Status -Types "@", $TweakType -Status $customMessageText
            }
        }
        else {
            Write-Status -Types "?", $TweakType -Status "The $_ optional feature was not found." -WriteWarning
        }
    }
}
function Set-ScheduledTaskState {
    <#
.SYNOPSIS
    Enables or disables scheduled tasks on the host.

.DESCRIPTION
    The Set-ScheduledTaskState function is used to enable or disable scheduled tasks on the host machine. It allows you to specify the tasks to be enabled or disabled using an array of task names. You can also set a filter to skip certain tasks, and use the `-Disabled` or `-Ready` switches to disable or enable the tasks, respectively.

.PARAMETER Disabled
    Indicates that the scheduled tasks should be disabled. If this switch is used, the tasks specified in the `ScheduledTasks` parameter will be disabled.

.PARAMETER Ready
    Indicates that the scheduled tasks should be enabled and set to the "Ready" state. If this switch is used, the tasks specified in the `ScheduledTasks` parameter will be enabled.

.PARAMETER ScheduledTasks
    Specifies an array of scheduled task names for which the state should be modified. This parameter is mandatory.

.PARAMETER Filter
    Specifies an array of scheduled task names to skip. If a task name matches any of the names in the filter, it will be skipped. This parameter is optional.

.EXAMPLE
    Set-ScheduledTaskState -Disabled -ScheduledTasks "Task1", "Task2"

    DESCRIPTION
        Disables the "Task1" and "Task2" scheduled tasks.

.EXAMPLE
    Set-ScheduledTaskState -Ready -ScheduledTasks "Task3", "Task4" -Filter "Task5"

    DESCRIPTION
        Enables the "Task3" and "Task4" scheduled tasks and skips the "Task5" task due to the filter.

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [Switch] $Disabled,
        [Parameter(Mandatory = $false)]
        [Switch] $Ready,
        [Parameter(Mandatory = $true)]
        [Array] $ScheduledTasks,
        [Parameter(Mandatory = $false)]
        [Array] $Filter
    )

    ForEach ($ScheduledTask in $ScheduledTasks) {
        If (Find-ScheduledTask $ScheduledTask) {
            If ($ScheduledTask -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $ScheduledTask ($((Get-ScheduledTask $ScheduledTask).TaskName)) will be skipped as set on Filter..." -WriteWarning
                Continue
            }

            If ($Disabled) {
                $action = "Disable"
            }
            ElseIf ($Ready) {
                $action = "Enable"
            }
            Else {
                Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Ready)" -WriteWarning
                $action = $null
            }

            If ($action) {
                $confirmationMessage = "Are you sure you want to $action the scheduled task '$ScheduledTask'?"
                $caption = "Confirm $action"
                $result = $PSCmdlet.ShouldProcess($ScheduledTask, $confirmationMessage, $caption)

                If ($result) {
                    Write-Status -Types $action.Substring(0, 1), $TweakType -Status "$action the $ScheduledTask task..." -NoNewLine

                    Try {
                        If ($action -eq "Disable") {
                            Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "R*" | Disable-ScheduledTask | Out-Null # R* = Ready/Running
                            Get-Status
                        }
                        ElseIf ($action -eq "Enable") {
                            Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "Disabled" | Enable-ScheduledTask | Out-Null
                            Get-Status
                        }
                    }
                    catch {
                        $errorMessage = $_.Exception.Message
                        $lineNumber = $_.InvocationInfo.ScriptLineNumber
                        $command = $_.InvocationInfo.Line
                        $errorType = $_.CategoryInfo.Reason
                        $errorString = @"
-
Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Command run was: $command
Reason for error was: $errorType
Offending line number: $lineNumber
Error Message: $errorMessage
-
"@
                        Add-Content $Variables.ErrorLog $errorString
                        Write-Output $_
                    }
                }
            }
        }
    }
}
function Set-ServiceStartup {
    <#
.SYNOPSIS
    Sets the startup type for specified Windows services.

.DESCRIPTION
    The Set-ServiceStartup function is used to set the startup type for specified Windows services on the host machine. The function allows you to specify the desired startup state using the ValidateSet attribute for the $State parameter. You can provide an array of service names to apply the change to multiple services at once. Additionally, you can set a filter to skip certain services from being modified.

.PARAMETER State
    Specifies the desired startup type for the services. Valid values are 'Automatic', 'Boot', 'Disabled', 'Manual', and 'System'. This parameter is mandatory.

.PARAMETER Services
    Specifies an array of service names for which the startup type should be modified. This parameter is mandatory.

.PARAMETER Filter
    Specifies an array of service names to skip. If a service name matches any of the names in the filter, it will be skipped. This parameter is optional.

.EXAMPLE
    Set-ServiceStartup -State "Automatic" -Services "Spooler", "BITS"

    DESCRIPTION
        Sets the startup type for the "Spooler" and "BITS" services to "Automatic".

.EXAMPLE
    Set-ServiceStartup -State "Disabled" -Services "Telnet", "wuauserv" -Filter "BITS"

    DESCRIPTION
        Sets the startup type for the "Telnet" and "wuauserv" services to "Disabled". The "BITS" service will be skipped due to the filter.

.EXAMPLE
    Set-ServiceStartup -State "Manual" -Services "Dnscache" -WhatIf

    DESCRIPTION
        Previews the changes of setting the "Dnscache" service startup type to "Manual" without actually applying the changes.

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Automatic', 'Boot', 'Disabled', 'Manual', 'System')]
        [String]      $State,
        [Parameter(Mandatory = $true)]
        [String[]]    $Services,
        [String[]]    $Filter
    )

    Begin {
        $Script:SecurityFilterOnEnable = @("RemoteAccess", "RemoteRegistry")
        $Script:TweakType = "Service"
    }

    Process {
        ForEach ($Service in $Services) {
            If (!(Get-Service $Service -ErrorAction SilentlyContinue)) {
                Write-Status -Types "?", $TweakType -Status "The $Service service was not found." -WriteWarning
                Continue
            }

            If (($Service -in $SecurityFilterOnEnable) -and (($State -eq 'Automatic') -or ($State -eq 'Manual'))) {
                Write-Status -Types "!", $TweakType -Status "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..." -WriteWarning
                Continue
            }

            If ($Service -in $Filter) {
                Write-Status -Types "!", $TweakType -Status "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..." -WriteWarning
                Continue
            }

            Try {
                $target = "$Service ($((Get-Service $Service).DisplayName)) as '$State' on Startup"
                if ($PSCmdlet.ShouldProcess($target, "Set Startup Type")) {
                    Write-Status -Types "@", $TweakType -Status "Setting $target" -NoNewLine
                    If ($WhatIf) {
                        Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State -WhatIf
                    }
                    Else {
                        Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State
                        Get-Status
                    }
                }
            }
            catch {
                $errorMessage = $_.Exception.Message
                $lineNumber = $_.InvocationInfo.ScriptLineNumber
                $command = $_.InvocationInfo.Line
                $errorType = $_.CategoryInfo.Reason
                $errorString = @"
    -
    Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Command run was: $command
    Reason for error was: $errorType
    Offending line number: $lineNumber
    Error Message: $errorMessage
    -
"@
                Add-Content $Variables.ErrorLog $errorString
                Write-Output $_
                Continue
            }
        }
    }
}

Function Set-StartMenu {
    <#
    .SYNOPSIS
    Sets the Start Menu layout and Taskbar pins for Windows 10 and Windows 11.

    .DESCRIPTION
    The Set-StartMenu function applies the Start Menu layout and Taskbar pins for Windows 10 and Windows 11. For Windows 10, it clears all the Start Menu pins. For Windows 11 (build 22000 and higher), it applies a customized Start Menu layout and Taskbar pins based on the specified XML template.

    .PARAMETER WhatIf
    If this switch is provided, the function will only show what would happen without actually making any changes. This is useful to preview the changes that would be applied. 

    .PARAMETER Confirm
    If this switch is provided, the function will ask for confirmation before applying the changes.

    .NOTES
    - This function requires administrative privileges to restart Explorer and modify the registry settings.
    - For Windows 11, the function applies the Start Menu layout using the specified XML template.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param ()

    If ($Variables.osVersion -like "*Windows 10*") {
        Remove-PinnedStartMenu
    }

    If ($Variables.osVersion -like "*Windows 11*") {
        Write-Section -Text "Applying Start Menu Layout"
        Write-Status -Types "+", $TweakType -Status "Generating Layout File"
        $progress = 0
        $StartBinFiles = Get-ChildItem -Path "$newloads" -Filter "start*.bin" -file
        Foreach ($StartBinFile in $StartBinFiles) {
            $progress++
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) for new users ($progress/$TotalBinFiles)" -NoNewLine
            xcopy $StartBinFile.FullName $Variables.StartBinDefault /y | Out-Null
            Get-Status
            $progress++
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) to current user ($($progress)/$TotalBinFiles)" -NoNewLine
            xcopy $StartBinFile.FullName $Variables.StartBinCurrent /y | Out-Null
            Get-Status
        }
    }

    $StartLayout = @"
    <LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
        xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
        xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
        xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
        Version="1">
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
            <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.SecHealthUI" />
            <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
            <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
            <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
            </taskbar:TaskbarPinList>
        </defaultlayout:TaskbarLayout>
        </CustomTaskbarLayoutCollection>
    </LayoutModificationTemplate>
"@
    Write-Status -Types "+" -Status "Applying Taskbar Layout" -NoNewLine
    If (Test-Path $Variables.layoutFile) { Remove-Item $Variables.layoutFile -Verbose | Out-Null }
    $StartLayout | Out-File $Variables.layoutFile -Encoding ASCII
    Get-Status
    Restart-Explorer
    Start-Sleep -Seconds 4
}

function Set-Wallpaper {
    [CmdletBinding(SupportsShouldProcess)]
    param (
    )
    if ($PSCmdlet.ShouldProcess("Apply Wallpaper")) {
        $WallpaperPathExists = Test-Path $Variables.wallpaperPath -ErrorAction SilentlyContinue
        If (!$WallpaperPathExists) {
            $WallpaperURL = "https://raw.githubusercontent.com/circlol/newload/main/assets/mother.jpg"
            Write-Status "@", $TweakType -Status "Downloading Wallpaper"
            Start-BitsTransfer -Source $WallpaperURL -Destination $Variables.WallpaperDestination -Dynamic
            Get-Status
        }
        Write-Status -Types "+", $TweakType -Status "Applying Wallpaper"
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
        Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted`n"
        If (!(Test-Path $Variables.WallpaperDestination)) {
            Write-Status -Types "+", $TweakType -Status "Copying Wallpaper to Destination" -NoNewLine
            Copy-Item -Path $Variables.wallpaperPath -Destination $Variables.WallpaperDestination -Force -Confirm:$False
            Get-Status
        }
        Write-Status -Types "+", $TweakType -Status "Setting WallpaperStyle to 'Stretch'"
        Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name WallpaperStyle -Value '2' -Type String
        Write-Status -Types "+", $TweakType -Status "Setting Wallpaper to Destination"
        Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name Wallpaper -Value $Variables.WallpaperDestination -Type String
        Write-Status -Types "+", $TweakType -Status "Setting System to use Light Mode"
        Set-ItemPropertyVerified -Path $Variables.PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 1 -Type DWord
        Write-Status -Types "+", $TweakType -Status "Setting Apps to use Light Mode"
        Set-ItemPropertyVerified -Path $Variables.PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1 -Type DWord
        Write-Status -Types "+", $TweakType -Status "Updating Wallpaper" -NoNewLine
        Start-Process "RUNDLL32.EXE" "user32.dll, UpdatePerUserSystemParameters"
        Get-Status
    }
}
Function Send-EmailLog {
    # - Stops Transcript
    Stop-Transcript | Out-Null
    Write-Section -Text "Gathering Logs "
    Write-Caption -Text "System Statistics" -Type None
    # - Current Date and Time
    $CurrentDate = Get-Date
    $EndTime = Get-Date -DisplayHint Time
    # Subtracts StartTime from EndTime to get ElapsedTime.
    $ElapsedTime = $EndTime - $StartTime

    # - Gathers some information about host
    $CPU = Get-CPU
    $GPU = Get-GPU
    $RAM = Get-RAM
    $Drives = Get-DriveInfo
    $SystemSpec = Get-SystemSpec
    $Mobo = (Get-CimInstance -ClassName Win32_BaseBoard).Product
    $IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
    $Displayversion = (Get-ItemProperty -Path $Variables.PathToLMCurrentVersion -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption

    # - Removes unwanted characters and blank space from log file
    Write-Caption -Text "Cleaning $($Variables.Log)"
    $logFile = Get-Content $Variables.Log -Raw
    #$pattern = "[\[\]><\+@),|=]"
    $pattern = "[\[\]><+@),|=\\-\\(]"
    # - Replace the unwanted characters with nothing
    $newLogFile = $logFile -replace $pattern
    # - Remove empty lines
    $newLogFile = ($newLogFile | Where-Object { $_ -match '\S' }) -join "`n"
    Set-Content -Path $Variables.Log -Value $newLogFile


    # - Cleans up Motherboards Output
    Write-Caption -Text "Generating New Loads Summary"
    $WallpaperApplied = if ($Variables.CurrentWallpaper -eq $Variables.Wallpaper) { "YES" } else { "NO" }
    $Mobo = ($Mobo -replace 'Product|  ', '') -join "`n"
    
    # - Checks if all the programs got installed
    $ChromeYN = if (Get-InstalledProgram -Keyword "Google Chrome") { "YES" } else { "NO" }
    $VLCYN = if (Get-InstalledProgram -Keyword "VLC") { "YES" } else { "NO" }
    $ZoomYN = if (Get-InstalledProgram -Keyword "Zoom") { "YES" } else { "NO" }
    $AdobeYN = if (Get-InstalledProgram -Keyword "Acrobat") { "YES" } else { "NO" }


    # - Joins log files to send as attachments
    $LogFiles = @()
    if (Test-Path -Path $Variables.log) {
        $LogFiles += $Variables.log
    }
    if (Test-Path -Path "$Variables.errorlog") {
        $LogFiles += $Variables.errorlog
    }

    # - Cleans packages removed text and adds it to email
    ForEach ($Package in $Variables.PackagesRemoved) {
        $Variables.PackagesRemovedOutput = $Variables.PackagesRemovedOutput + "`n - $Package"
    }

    # - Email Settings
    $smtp = 'smtp.shaw.ca'
    $To = '<newloads@shaw.ca>'
    $From = 'New Loads Log <newloadslogs@shaw.ca>'
    $Sub = "New Loads Log"
    $EmailBody = "
    ############################
    #                          #
    #   NEW LOADS SCRIPT LOG   #
    #                          #
    ############################

New Loads summary for $ip\$env:computername\$env:USERNAME

- Script Information:
    - Program Version: $ProgramVersion
    - Script Version: $ScriptVersion
    - Date: $CurrentDate

Completed in - Elapsed Time: $ElapsedTime  - Start Time: $StartTime  - End Time: $EndTime

- Computer Information:
    - OS: $WindowsVersion ($DisplayVersion)
    - CPU: $CPU
    - Motherboard: $Mobo
    - RAM: $RAM
    - GPU: $GPU
    - Drives: $Drives 

    $SystemSpec


- Summary:
    - Applications Installed: $appsyns
    - Chrome: $ChromeYN
    - VLC: $VLCYN
    - Adobe: $AdobeYN
    - Zoom: $ZoomYN
    - Wallpaper Applied: $WallpaperApplied
    - Windows 11 Start Layout Applied: $StartMenuLayout
    - Registry Keys Modified: $ModifiedRegistryKeys
    - Packages Removed During Debloat: $($Variables.Removed)
    $($Variables.PackagesRemoved)
"
    # - Sends the mail
    Send-MailMessage -From $From -To $To -Subject $Sub -Body $EmailBody -Attachments $LogFiles -DN OnSuccess, OnFailure -SmtpServer $smtp -ErrorAction SilentlyContinue
}
Function Show-ScriptLogo {
    <#
.SYNOPSIS
Displays a custom logo and information about the application during its initialization.

.DESCRIPTION
The Show-ScriptLogo function is used to display a custom logo and relevant information about the application during its initialization. The function prints the logo, the creator's name, the last update version, release date, and important notices about updating the system to the latest version of Windows for correct application functionality.

.PARAMETER None
This function does not accept any parameters.

.NOTES
The Show-ScriptLogo function is typically used during the application's bootup process to provide essential information to users.
#>
    $WindowTitle = "New Loads - Initialization" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n`n`n"
    Write-Host "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" -NoNewLine -ForegroundColor $Variables.ForegroundColor -BackgroundColor Blue
    Write-Host "`n`n`n" -NoNewline
    $Logo = "
                        ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
                        ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
                        ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
                        ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
                        ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                        ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝
                        "
    Write-Host "$Logo`n`n" -ForegroundColor $Variables.LogoColor -BackgroundColor Black -NoNewline
    Write-Host "                               Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Papi" -ForegroundColor Red -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$($Variables.ProgramVersion) - $($Variables.ReleaseDate)" -ForegroundColor Green -BackgroundColor Black
    Write-Host "`n`n  Notice: " -NoNewLine -ForegroundColor RED -BackgroundColor Black
    Write-Host "For New Loads to function correctly, it is important to update your system to the latest version of Windows.`n" -ForegroundColor Yellow -BackgroundColor Black
    if ($Variables.specifiedParameters.Count -ne 0) { Write-Host "  Specified Parameters: " -ForegroundColor $Variables.LogoColor -NoNewLine ; Write-Host "$parametersString `n" }
    Write-Host ""
    Write-Host "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" -ForegroundColor Blue -BackgroundColor $Variables.LogoColor
    Write-Host "`n`n"
    $WindowTitle = "New Loads" ; $host.UI.RawUI.WindowTitle = $WindowTitle
}
Function Show-ScriptStatus() {
    param(
        [Switch]$AddCounter,
        [String]$SectionText,
        [String]$TitleText,
        [String]$TitleCounterText,
        [String]$TweakType,
        [String]$WindowTitle
    )
    If ($WindowTitle) {
        $host.UI.RawUI.WindowTitle = "New Loads - $WindowTitle"
    }
    If ($TweakType) {
        Set-Variable -Name 'TweakType' -Value $TweakType -Scope Global -Force
    }
    If ($TitleCounterText) {
        Write-TitleCounter -Counter $Counter -MaxLength $Variables.MaxLength -Text $TitleCounterText
    }
    If ($TitleText) {
        Write-Title -Text $TitleText
    }
    If ($SectionText) {
        Write-Section -Text "Section: $SectionText"
    }
    If ($AddCounter) {
        $Counter++
    }



}
Function Show-Question() {
    <#
.SYNOPSIS
Displays a custom message box dialog with Yes, No, and Cancel buttons.

.DESCRIPTION
The Show-Question function displays a custom message box dialog with Yes, No, and Cancel buttons. You can customize the title and message to show in the dialog. Additionally, you can specify the icon to display with the message box using the Icon parameter, which can take one of the following values: "None" (default), "Information", "Question", "Warning", or "Error."

.PARAMETER Title
Specifies the title of the message box. The default value is "New Loads."

.PARAMETER Message
Specifies the message to display in the message box.

.PARAMETER YesNo
Indicates whether the message box should show Yes and No buttons only. If this switch is present, the YesNoCancel switch will be ignored.

.PARAMETER YesNoCancel
Indicates whether the message box should show Yes, No, and Cancel buttons.

.PARAMETER Icon
Specifies the icon to display with the message box. Possible values are "None" (default), "Information", "Question", "Warning", and "Error."

.EXAMPLE
Show-Question -Title "Confirmation" -Message "Do you want to proceed?" -YesNo
This example shows a custom message box dialog with the title "Confirmation" and the message "Do you want to proceed?" The message box will have Yes and No buttons.

.EXAMPLE
$result = Show-Question -Title "Important" -Message "This action is irreversible. Are you sure you want to continue?" -Icon "Warning" -YesNoCancel
This example displays a custom message box dialog with the title "Important," the message "This action is irreversible. Are you sure you want to continue?" and a warning icon. The message box will have Yes, No, and Cancel buttons, and the result (Yes, No, or Cancel) will be stored in the $result variable.

.NOTES
The Show-Question function uses the Windows Forms MessageBox class to create the message box dialog. It requires a Windows-based PowerShell environment to display the message box properly.
#>
    [CmdletBinding()]
    param (
        [String] $Title = "New Loads",
        [String] $Message = "Set Execution Policy to RemoteSigned?",
        [Switch] $YesNo,
        [Switch] $YesNoCancel,
        [ValidateSet("None", "Information", "Question", "Warning", "Error")]
        [String] $Icon = "None"
    )

    $BackupWindowTitle = $host.UI.RawUI.WindowTitle
    $WindowTitle = "New Loads - WAITING FOR USER INPUT" ; $host.UI.RawUI.WindowTitle = $WindowTitle

    $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Question

    switch ($Icon) {
        "None" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::None }
        "Information" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Information }
        "Question" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Question }
        "Warning" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Warning }
        "Error" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Error }
    }

    if ($YesNoCancel) {
        Start-Chime
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNoCancel, $iconFlag)
    }
    elseif ($YesNo) {
        Start-Chime
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNo, $iconFlag)
    }

    $host.UI.RawUI.WindowTitle = $BackupWindowTitle
    return $result
}
Function Start-BitlockerDecryption() {
    <#
.SYNOPSIS
    Checks if BitLocker is enabled on the host and starts the decryption process if active.

.DESCRIPTION
    The Start-BitlockerDecryption function checks if BitLocker is enabled on the host by examining the protection status of the C: drive. If BitLocker is active, it displays a warning caption and initiates the decryption process for the C: drive using the `Disable-BitLocker` cmdlet. If BitLocker is not enabled, it displays an informational status message indicating that BitLocker is not active on the machine.

.NOTES
    - This function requires administrative privileges to execute `Disable-BitLocker`.

.EXAMPLE
    Start-BitlockerDecryption

    DESCRIPTION
        Checks if BitLocker is enabled on the C: drive. If active, it starts the decryption process. If not enabled, it displays an informational message.

#>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Switch]$SkipBitlocker
    )

    If ($SkipBitlocker) {
        Write-Status -Types "@" -Status "Parameter -SkipBitlocker detected.. Skipping Bitlocker Decryption." -WriteWarning -ForegroundColorText RED
    }
    else {
        # Checks if Bitlocker is active on the host
        $bitlockerVolume = Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        If ($bitlockerVolume -and $bitlockerVolume.ProtectionStatus -eq "On") {
            # Starts Bitlocker Decryption
            Show-Question -YesNo -Title "New Loads" -Icon Warning -Message "Bitlocker was detected turned on. Do you want to start the decryption process?"
            $target = "Bitlocker Decryption on C:"
            if ($PSCmdlet.ShouldProcess($target, "Start Decryption")) {
                Write-Caption -Text "Alert: Bitlocker is enabled. Starting the decryption process" -Type Warning
                Disable-BitLocker -MountPoint C:\
            }
        }
        else {
            Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine"
        }
    }
}
Function Start-Bootup {
    <#
.SYNOPSIS
Starts the bootup process and checks various requirements before running the main application.

.DESCRIPTION
The Start-Bootup function is used to perform several checks and initializations before running the main application. It checks the Windows version, execution policy, administrative privileges, license, and other system requirements. If any of the checks fail, the function displays an error message and exits the application.

.PARAMETER None
This function does not accept any parameters.

.NOTES
Ensure that the user running this function has sufficient privileges and meets the necessary requirements to run the main application successfully.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param()

    $WindowTitle = "New Loads - Checking Requirements" ; $host.UI.RawUI.WindowTitle = $WindowTitle

    # Checks OS version to make sure Windows is atleast v20H2 otherwise it'll display a message and close
    New-Variable -Name "SYSTEMOSVERSION" -Value (Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -Scope Global
    $MINIMUMREQUIREMENT = "19042"  ## Windows 10 v20H2 build version
    If ($SYSTEMOSVERSION -LE $MINIMUMREQUIREMENT) {
        $errorMessage = "
        @|\@@                                                                                    `
        -  @@@@                     New Loads requires a minimum Windows version of 20H2 (19042).`
       /7   @@@@                                                                                 `
      /    @@@@@@                             Please upgrade your OS before continuing.          `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )             `
                                                                         )         (              `
                                                                        (           )             `
                                                                       ( (  )   (  ) )            `
                                                                      (__(__)___(__)__)          `n`n"
        Write-Host $errorMessage -ForegroundColor Yellow
        $readingkey = Read-Host -Prompt "Press any key to close New Loads" ; return $readingkey
        Exit
    }

    # Checks to make sure New Loads is run as admin otherwise it'll display a message and close
    If ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
        $errorMessage = "
        @|\@@                                                                                    `
        -  @@@@                             New Loads REQUIRES administrative privileges         `
       /7   @@@@                                                                                 `
      /    @@@@@@                             for core features to function correctly.           `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )            `
                                                                         )         (             `
                                                                        (           )            `
                                                                       ( (  )   (  ) )           `
                                                                      (__(__)___(__)__)          `n`n"
        Write-Host $errorMessage -ForegroundColor Yellow
        $SelfElevate = Read-Host -Prompt "Do you want to attempt to elevate this prompt?"
        switch ($SelfElevate) {
            "Y" {
                $wtExists = Get-Command wt -ErrorAction SilentlyContinue
                If ($wtExists) {
                    Start-Process wt -verb runas -ArgumentList "new-tab powershell -c ""irm run.newloads.ca | iex"""
                }
                else { Start-Process powershell -verb runas -ArgumentList "-command ""irm run.newloads.ca | iex""" }
            }
            "N" {
                exit
            }
        }
        Exit
    }
    # Function that displays program name, version, creator
    Show-ScriptLogo
    # Updates Time
    Update-Time
    # Gets Year/Month/Day to compare
    New-Variable -Name Time -Value (Get-Date -UFormat %Y%m%d) -Scope Global
    $MinTime = 20230630
    $MaxTime = 20231031

    # Checks the time against the license and minimum required date - This assures New Loads cannot be distributed or used past the granted license date for Mother Computers
    If ($Time -GT $MaxTime -or $Time -LT $MinTime) {
        Clear-Host
        Write-Status -Types ":(", "ERROR" -Status "There was an uncorrectable error.. Closing Application." -WriteWarning -ForegroundColorText RED
        Write-Host "Press any key to close New Loads." -NoNewLine
        Read-Host
        Exit
    }
    #
    try {
        Remove-Item "$env:userprofile\Desktop\New Loads.Log" -Force -ErrorAction SilentlyContinue | out-null
        Remove-Item "$env:userprofile\Desktop\New Loads Errors.Log" -Force -ErrorAction SilentlyCOntinue | out-null
    }
    catch {
        Write-Error "An error occurred while removing the files: $_"
        Continue
    }
}
function Start-Chime {
    <#
    .SYNOPSIS
    Plays a specified sound file (typically an alarm sound) using the SoundPlayer class.

    .DESCRIPTION
    The Start-Chime function is used to play a specified sound file (typically an alarm sound) using the SoundPlayer class from the System.Media namespace. The function checks if the sound file exists at the specified file path before attempting to play the sound. If the file exists, it creates a SoundPlayer object, loads the sound file, plays the sound, waits for the sound to finish playing (optional), and then disposes of the SoundPlayer object to release resources.

    .PARAMETER None
    This function does not accept any parameters.

    .NOTES
    Ensure that the specified sound file exists at the specified file path before running this function. The SoundPlayer class is part of the .NET Framework, so the function should work on Windows systems with the necessary .NET components installed.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        $File = "C:\Windows\Media\Alarm06.wav"
    )


    # Check if the file exists before attempting to play the sound
    if (Test-Path $File) {
        try {
            # Create a SoundPlayer object and load the sound file
            $soundPlayer = New-Object System.Media.SoundPlayer
            $soundPlayer.SoundLocation = $File

            if ($PSCmdlet.ShouldProcess("Play the sound", "Play sound from $File")) {
                # Play the sound
                $soundPlayer.Play()

                # Wait for the sound to finish playing (optional)
                Start-Sleep -Seconds 3

                # Dispose the SoundPlayer object to release resources
                $soundPlayer.Dispose()
            }
        }
        catch {
            Write-Error "An error occurred while playing the sound: $_.Exception.Message"
        }
    }
    else {
        Write-Error "The sound file doesn't exist at the specified path."
    }
}
Function Start-Cleanup {
    <#
.SYNOPSIS
    Performs various cleanup tasks on the host machine.

.DESCRIPTION
    The Start-Cleanup function performs various cleanup tasks on the host machine. It starts Explorer if it isn't already running, enables the F8 Boot Menu options, launches Google Chrome, cleans the Temp folder, removes installed program shortcuts from Public/User Desktop, and removes a layout file.

.NOTES
    - This function may require administrative privileges for certain actions.

.EXAMPLE
    Start-Cleanup

    DESCRIPTION
        Initiates various cleanup tasks on the host machine.

#>
    [CmdletBinding(SupportsShouldProcess)]
    param ()

    If ($Revert) {
        Write-Status -Types "@" -Status "Parameter -Undo was detected.. Skipping this section." -WriteWarning -ForegroundColorText Red
    }
    else {
        # - Starts Explorer if it isn't already running
        If (!(Get-Process -Name Explorer)) {
            Restart-Explorer
        }

        If (Test-Path $Variables.layoutFile) {
            Remove-Item $Variables.layoutFile
        }


        # - Launches Chrome to initiate UBlock Origin
        $target = "Google Chrome"
        if ($PSCmdlet.ShouldProcess($target, "Launch Chrome")) {
            Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
            Start-Process Chrome -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }

        # - Clears Temp Folder
        $target = "Temp Folder"
        if ($PSCmdlet.ShouldProcess($target, "Clean Temp Folder")) {
            Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"
            Remove-Item "$env:temp\*.*" -Force -Recurse -Exclude "New Loads" -ErrorAction SilentlyContinue
        }

        # - Removes installed program shortcuts from Public/User Desktop
        foreach ($shortcut in $Variables.shortcuts) {
            $target = "Shortcut: $shortcut"
            if ($PSCmdlet.ShouldProcess($target, "Remove Shortcut")) {
                $ShortcutExist = Test-Path $shortcut -ErrorAction SilentlyContinue
                If ($ShortcutExist) {
                    Write-Status -Types "-", $TweakType -Status "Removing $shortcut"
                    Remove-Item -Path "$shortcut" -Force -ErrorAction SilentlyContinue | Out-Null
                }
            }
        }

        <#
        # - Removes layout file
        $target = "Layout File"
        if ($PSCmdlet.ShouldProcess($target, "Remove Layout File")) {
            Remove-Item "$layoutFile"
        }
        #>
    }
}
Function Start-Debloat {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Switch] $Revert
    )

    If (!$Revert) {
        <#
        Write-Section "Legacy Apps"
        Write-Caption -Text "Avast"
        Get-InstalledProgram "Avast" -ErrorAction SilentlyContinue | Out-Null
        If ($? -eq $True) { (Get-InstalledProgram "Avast").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
        Write-Caption -Text "ExpressVPN"
        Get-InstalledProgram "ExpressVPN" -ErrorAction SilentlyContinue | Out-Null
        If ($? -eq $True) { (Get-InstalledProgram "ExpressVPN").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
        Write-Caption -Text "McAfee"
        Get-InstalledProgram "McAfee" -ErrorAction SilentlyContinue | Out-Null
        If ($? -eq $True) { (Get-InstalledProgram "McAfee").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
        Write-Caption -Text "Norton"
        Get-InstalledProgram "Norton" -ErrorAction SilentlyContinue | Out-Null
        If ($? -eq $True) { (Get-InstalledProgram "Norton").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
        Write-Caption -Text "WildTangent Games"
        Get-InstalledProgram "WildTangent" -ErrorAction SilentlyContinue | Out-Null
        If ($? -eq $True) { (Get-InstalledProgram "WildTangent").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
        #>

        Write-Section -Text "Checking for Start Menu Ads"
        $apps = @(
            "Adobe offers",
            "Amazon",
            "Booking",
            "Booking.com",
            "ExpressVPN",
            "Forge of Empires",
            "Free Trials",
            "Planet9 Link",
            "Utomik - Play over 1000 games"
        )

        ForEach ($app in $apps) {
            try {
                if (Test-Path -Path "$commonapps\$app.url") {
                    # - Checks common start menu .urls
                    $target = "Start Menu .url: $app"
                    if ($PSCmdlet.ShouldProcess($target, "Remove .url")) {
                        Write-Status -Types "-", "$TweakType", "$TweakTypeLocal" -Status "Removing $app.url" -NoNewLine
                        Remove-Item -Path "$commonapps\$app.url" -Force
                        Get-Status
                    }
                }
                if (Test-Path -Path "$commonapps\$app.lnk") {
                    # - Checks common start menu .lnks
                    $target = "Start Menu .lnk: $app"
                    if ($PSCmdlet.ShouldProcess($target, "Remove .lnk")) {
                        Write-Status -Types "-", "$TweakType", "$TweakTypeLocal" -Status "Removing $app.lnk" -NoNewLine
                        Remove-Item -Path "$commonapps\$app.lnk" -Force
                        Get-Status
                    }
                }
            }
            catch {
                $target = "Start Menu Item: $app"
                Write-Status -Types "!", "$TweakType", "$TweakTypeLocal" -Status "An error occurred while removing $app`: $_"
            }
        }

        Write-Section -Text "UWP Apps"
        $TotalItems = $Variables.Programs.Count
        $CurrentItem = 0
        $PercentComplete = 0
        ForEach ($Program in $Variables.Programs) {
            # - Uses blue progress bar to show debloat progress -- ## Doesn't seem to be working currently.
            Write-Progress -Activity "Debloating System" -Status " $PercentComplete% Complete:" -PercentComplete $PercentComplete
            # - Starts Debloating the system
            $target = "UWP App: $($Program.Name)"
            if ($PSCmdlet.ShouldProcess($target, "Remove UWP App")) {
                Remove-UWPAppx -AppxPackages $Program
                $CurrentItem++
                $Variables.PackagesRemoved = "$PackagesRemoved`n  - $Program"
                $PercentComplete = [int](($CurrentItem / $TotalItems) * 100)
            }
        }

        # Disposing the progress bar after the loop finishes
        Write-Progress -Activity "Debloating System" -Completed

        # - Debloat Completion
        Write-Host "Debloat Completed!`n" -Foregroundcolor Green
        Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray ; Write-Host $Variables.Removed -ForegroundColor Green
        If ($Failed) { Write-Host "Failed: " -NoNewline -ForegroundColor Gray ; Write-Host $Variables.Failed -ForegroundColor Red }
        Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray ; Write-Host "$($Variables.NotFound)`n" -ForegroundColor Yellow
    }
    elseif ($Revert) {
        $target = "Reinstall Default Appx from manifest"
        if ($PSCmdlet.ShouldProcess($target, "Reinstall Default Appx")) {
            Write-Status -Types "+", "Bloat" -Status "Reinstalling Default Appx from manifest"
            Get-AppxPackage -allusers | ForEach-Object { Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode -Verbose -ErrorAction SilentlyContinue } | Out-Host
        }
    }
}
Function Start-NewLoad {
    <#
.SYNOPSIS
Starts the New Loads script, performing system tweaks, optimizations, and cleanups based on user configuration.

.DESCRIPTION
The Start-NewLoad function is the main function that orchestrates the execution of various tasks in the New Loads script. It performs system tweaks, optimizations, and cleanups based on user configuration and preferences. The function calls several sub-functions to carry out specific tasks, such as getting a list of installed programs, applying visual settings, debloating the system, optimizing performance, security, and privacy settings, and more.

.PARAMETER None
This function does not accept any parameters.

.NOTES
The Start-NewLoad function is the entry point for executing the New Loads script. It initiates various sub-functions to perform specific tasks to customize and optimize the system. The function may require administrative privileges to execute some of the tasks, such as system optimizations, debloating, and creating a system restore point.
#>
    [CmdletBinding(SupportsShouldProcess)]
    param()
    Start-Transcript -Path $Variables.Log -NoClobber | Out-Null
    New-Variable -Name "StartTime" -Value (Get-Date -DisplayHint Time) -Scope Global
    $Counter++
    Show-ScriptStatus -WindowTitle "Apps" -TweakType "Apps" -TitleCounterText "Programs" -TitleText "Application Installation"
    Get-Program
    $Counter++
    Show-ScriptStatus -WindowTitle "Start Menu" -TweakType "StartMenu" -TitleCounterText "Start Menu Layout" -TitleText "Taskbar"
    Set-StartMenu
    $Counter++
    Show-ScriptStatus -WindowTitle "Visual" -TweakType "Visuals" -TitleCounterText "Visuals"
    Set-Wallpaper
    $Counter++
    Show-ScriptStatus -WindowTitle "Branding" -TweakType "Branding" -TitleText "Branding" -TitleCounterText "Mother Branding"
    Set-Branding
    $Counter++
    Show-ScriptStatus -WindowTitle "Debloat" -TweakType "Debloat" -TitleCounterText "Debloat" -TitleText "Win32"
    Start-Debloat
    Show-ScriptStatus -TitleText "ADWCleaner"
    Get-AdwCleaner
    $Counter++
    Show-ScriptStatus -WindowTitle "Office" -TweakType "Office" -TitleCounterText "Office"
    Get-Office
    $Counter++
    Show-ScriptStatus -WindowTitle "Bitlocker" -TweakType "Bitlocker" -TitleCounterText "Bitlocker Decryption"
    Start-BitlockerDecryption
    $Counter++
    Show-ScriptStatus -WindowTitle "Optimization" -TweakType "Registry" -TitleCounterText "Optimization" -TitleText "General"
    Optimize-General
    Show-ScriptStatus -TweakType "Performance" -TitleText "Performance" -SectionText "System"
    Optimize-Performance
    Optimize-SSD
    Show-ScriptStatus -TweakType "Privacy" -TitleText "Privacy"
    Optimize-Privacy
    Show-ScriptStatus -TweakType "Security" -TitleText "Security"
    Optimize-Security
    Show-ScriptStatus -TweakType "Services" -TitleText "Services"
    Optimize-Service
    Show-ScriptStatus -TweakType "TaskScheduler" -TitleText "Task Scheduler"
    Optimize-TaskScheduler
    Show-ScriptStatus -TweakType "OptionalFeatures" -TitleText "Optional Features"
    Optimize-WindowsOptional
    $Counter++
    Show-ScriptStatus -WindowTitle "Restore Point" -TweakType "Backup" -TitleCounterText "Creating Restore Point"
    New-SystemRestorePoint
    $Counter++
    Show-ScriptStatus -WindowTitle "Email Log" -TweakType "Email" -TitleCounterText "Email Log"
    Send-EmailLog
    $Counter++
    Show-ScriptStatus -WindowTitle "Cleanup" -TweakType "Cleanup" -TitleCounterText "Cleanup" -TitleText "Cleanup"
    Start-Cleanup
    Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB " -WriteWarning
    Request-PCRestart
}

function Update-Time {
    <#
    .SYNOPSIS
    Updates the system's time zone and synchronizes the time with the specified time zone.

    .DESCRIPTION
    The Update-Time function is used to update the system's time zone and synchronize the time with the specified time zone. It first checks the current time zone and then sets the new time zone using the Set-TimeZone cmdlet. It then synchronizes the time with the server using the w32tm /resync command. If the required time change is too big for automatic synchronization, the function manually updates the system time based on the server time received from the w32tm /resync output.

    .PARAMETER TimeZoneId
    Specifies the time zone ID to set for the system. The default value is "Pacific Standard Time." You can provide a different time zone ID to update the system's time zone accordingly.

    .EXAMPLE
    Update-Time -TimeZoneId "Eastern Standard Time"
    This example updates the system's time zone to "Eastern Standard Time" and synchronizes the time with the specified time zone.

    .NOTES
    The Update-Time function requires administrative privileges to modify the system's time zone and start the W32Time service. Ensure that the user running this function has the necessary privileges to perform these tasks.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string]$TimeZoneId = "Pacific Standard Time"
    )

    try {
        $currentTimeZone = (Get-TimeZone).DisplayName
        Write-Status -Types "" -Status "Current Time Zone: $currentTimeZone"

        # Set time zone
        if ($PSCmdlet.ShouldProcess("Setting Time Zone", "Set-TimeZone -Id $TimeZoneId -ErrorAction Stop")) {
            Set-TimeZone -Id $TimeZoneId -ErrorAction Stop
            Write-Status -Types "+" -Status "Time Zone successfully updated to: $TimeZoneId"
        }

        # Synchronize Time
        $w32TimeService = Get-Service -Name W32Time
        if ($w32TimeService.Status -ne "Running") {
            try {
                if ($PSCmdlet.ShouldProcess("Starting W32Time Service", "Start-Service -Name W32Time -ErrorAction Stop")) {
                    Write-Status -Types "+" -Status "Starting W32Time Service" -NoNewLine
                    Start-Service -Name W32Time -ErrorAction Stop
                    Get-Status
                }
            }
            catch {
                Write-Error "Failed to start the W32Time Service: $_"
            }
        }

        Write-Status -Types "F5" -Status "Syncing Time"
        $resyncOutput = w32tm /resync
        if ($resyncOutput -like "*The computer did not resync because the required time change was too big.*") {
            Write-Status -Types "@" -Status "Time change is too big. Setting time manually." -WriteWarning
            New-Variable -Name currentDateTime -Value (Get-Date) -Force -Scope Global
            $serverDateTime = $resyncOutput | Select-String -Pattern "Time: (\S+)" | ForEach-Object { $_.Matches.Groups[1].Value }

            if ($PSCmdlet.ShouldProcess("Setting System Time", "Set-Date -Date $serverDateTime")) {
                Set-Date -Date $serverDateTime
                Write-Status -Types "+" -Status "System time updated manually to: $serverDateTime"
            }
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}


# # # Formatting functions # # #



Function Write-Break {
    <#
.SYNOPSIS
    Writes a horizontal break line to the console.

.DESCRIPTION
    The Write-Break function is used to display a horizontal break line in the console. The break line is a series of "=" characters enclosed within square brackets, creating a visually distinct separator in the console output.

.PARAMETER ForegroundColor
    Specifies the foreground color for the break line. The default value is the current foreground color of the console.

.PARAMETER BackgroundColor
    Specifies the background color for the break line. The default value is the current background color of the console.

.EXAMPLE
    Write-Break -ForegroundColor Red -BackgroundColor Black

    DESCRIPTION
        Displays a horizontal break line using the "Red" foreground color and the "Black" background color.

.EXAMPLE
    Write-Break

    DESCRIPTION
        Displays a horizontal break line using the default foreground and background colors.

#>
    Write-Host "`n`n[" -NoNewline -ForegroundColor $Variables.ForegroundColor -Backgroundcolor $Variables.BackgroundColor
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "]`n" -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
}
Function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text",
        [ValidateSet("Failed", "Success", "Warning", "none")]
        [String] $Type = "none"
    )
    If ($Text -ne "No Text") {
        $OverrideText = $Text
    }

    switch ($Type.ToLower()) {
        "failed" {
            $foreground = "Red"
            $bgForeground = "DarkRed"
            $text = "Failed"
        }
        "success" {
            $foreground = "Green"
            $bgForeground = "DarkGreen"
            $text = "Success"
        }
        "warning" {
            $foreground = "Yellow"
            $bgForeground = "DarkYellow"
            $text = "Warning"
        }
    }
    
    If ($OverrideText) {
        $Text = $OverrideText
    }

    if ($Type -ne "none") {
        Write-Host "==" -NoNewline -ForegroundColor $foreground -BackgroundColor $Variables.BackgroundColor
        Write-Host "> " -NoNewline -ForegroundColor $bgForeground -BackgroundColor $Variables.BackgroundColor
    }

    Write-Host "$Text" -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
}
Function Write-HostReminder() {
    <#
.SYNOPSIS
    Writes a reminder message enclosed in square brackets with a distinct visual style to the console.

.DESCRIPTION
    The Write-HostReminder function is used to display a reminder message in the console with a visually distinct style. The reminder message is enclosed within square brackets and is highlighted with a red background and white foreground, creating a noticeable visual effect.

.PARAMETER Text
    Specifies the text to be displayed as the reminder message. The default value is "Example text" if no value is provided.

.EXAMPLE
    Write-HostReminder -Text "Remember to save your work."

    DESCRIPTION
        Displays a reminder message "Remember to save your work." enclosed within square brackets with a distinct visual style.

.EXAMPLE
    Write-HostReminder

    DESCRIPTION
        Displays a reminder message with the default text "Example text" enclosed within square brackets with a distinct visual style.

#>
    [CmdletBinding()]
    param (
        [String] $Text = "Example text"
    )
    Write-Host "[" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.ForegroundColor -NoNewline
    Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
    Write-Host "]" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.ForegroundColor -NoNewline
    Write-Host ": $text`n"
}
Function Write-Section() {
    <#
.SYNOPSIS
    Writes a section heading with horizontal bars to the console.

.DESCRIPTION
    The Write-Section function is used to display a section heading in the console. The section heading is enclosed within angle brackets ("< >") and is flanked by horizontal bars to create a visually distinct section in the console output.

.PARAMETER Text
    Specifies the text to be displayed as the section heading. The default value is "No Text" if no value is provided.

.EXAMPLE
    Write-Section -Text "Introduction"

    DESCRIPTION
        Displays a section heading "Introduction" enclosed within angle brackets ("< >") and flanked by horizontal bars.

.EXAMPLE
    Write-Section

    DESCRIPTION
        Displays a section heading with the default text "No Text" enclosed within angle brackets ("< >") and flanked by horizontal bars.
#>
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host ">" -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
}
Function Write-Status() {
    <#
.SYNOPSIS
    Writes a status message with timestamp, message types, and customizable text color to the console.

.DESCRIPTION
    The Write-Status function is used to display a status message in the console with additional information. The status message includes a timestamp, message types, and customizable foreground text color. The message types are displayed within square brackets, and users can provide multiple message types as an array. The status message can be displayed as a regular information message or as a warning message.

.PARAMETER Types
    Specifies an array of message types to be displayed with the status message. Each message type is displayed within square brackets.

.PARAMETER Status
    Specifies the main status message to be displayed in the console.

.PARAMETER WriteWarning
    If this switch is provided, the status message is treated as a warning, and it will be displayed with a "Warning" label. Otherwise, it will be displayed as a regular information message.

.PARAMETER NoNewLine
    By default, the function adds a new line after displaying the status message. If this switch is provided, the new line after the status message will be omitted.

.PARAMETER ForegroundColorText
    Specifies the foreground color for the status message text. The default value is "White" if no value is provided. The available color options are: "Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray", "DarkGray", "Blue", "Green", "Cyan", "Red", "Magenta", "Yellow", and "White".

.EXAMPLE
    Write-Status -Types @("[Action]", "[Progress]") -Status "Processing items" -WriteWarning

    DESCRIPTION
        Displays a status message "Processing items" with message types "[Action]" and "[Progress]" in the console. The status message is treated as a warning, and it will be displayed with a "Warning" label.

.EXAMPLE
    Write-Status -Types @("[Info]", "[Step 2]") -Status "Completed successfully"

    DESCRIPTION
        Displays a status message "Completed successfully" with message types "[Info]" and "[Step 2]" in the console. The status message is displayed as an information message.

.EXAMPLE
    Write-Status -Types @("[Error]") -Status "An error occurred" -ForegroundColorText "Red"

    DESCRIPTION
        Displays a status message "An error occurred" with message type "[Error]" in the console. The status message text will be displayed in red color.

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Array]  $Types,
        [Parameter(Mandatory)]
        [String] $Status,
        [Switch] $WriteWarning,
        [Switch] $NoNewLine,
        [ValidateSet("Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray", "DarkGray",
            "Blue", "Green", "Cyan", "Red", "Magenta", "Yellow", "White")]
        [String] $ForegroundColorText = "White"
    )
    If ($WriteWarning -eq $True -And $ForegroundColorText -eq "White") {
        $ForegroundColorText = "Yellow"
    }
    # Prints date in line, converts to Month Day Year Hour Minute Period
    $Time = Get-Date
    $FormattedTime = $Time.ToString("h:mm:ss tt")
    Write-Host "$FormattedTime " -NoNewline -ForegroundColor DarkGray -BackgroundColor $Variables.BackgroundColor

    ForEach ($Type in $Types) {
        Write-Host "$Type " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    }

    If ($WriteWarning) {
        Write-Host "::Warning:: -> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $Variables.BackgroundColor -NoNewline:$NoNewLine
    }
    Else {
        Write-Host "-> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $Variables.BackgroundColor -NoNewline:$NoNewLine
    }
}
Function Write-Title() {
    <#
.SYNOPSIS
    Writes a custom title with horizontal bars to the console.

.DESCRIPTION
    The Write-Title function is used to display a custom title in the console. The title is enclosed within angle brackets ("< >") and is flanked by horizontal bars to create a visually distinct heading in the console output.

.PARAMETER Text
    Specifies the text to be displayed as the custom title. The default value is "No Text" if no value is provided.

.EXAMPLE
    Write-Title -Text "Welcome to My Script"

    DESCRIPTION
        Displays a custom title "Welcome to My Script" enclosed within angle brackets ("< >") and flanked by horizontal bars.

.EXAMPLE
    Write-Title -Text "Important Message"

    DESCRIPTION
        Displays a custom title "Important Message" without adding a new line after the title.

#>
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host ">" -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
}
Function Write-TitleCounter() {
    <#
.SYNOPSIS
    Writes a custom title with a counter and horizontal bars to the console.

.DESCRIPTION
    The Write-TitleCounter function is used to display a custom title along with a counter in the console. The title is enclosed within angle brackets ("< >") and is flanked by horizontal bars. The counter is displayed in the format "X/Y," where X represents the current counter value and Y represents the maximum length or total count.

.PARAMETER Text
    Specifies the text to be displayed as the custom title. The default value is "No Text" if no value is provided.

.PARAMETER Counter
    Specifies the current counter value to be displayed. The default value is 0 if no value is provided.

.PARAMETER MaxLength
    Specifies the maximum length or total count for the counter. The default value is determined by the caller if no value is provided.

.EXAMPLE
    Write-TitleCounter -Text "Processing Items" -Counter 1 -MaxLength 10

    DESCRIPTION
        Displays a custom title "Processing Items" enclosed within angle brackets ("< >") and flanked by horizontal bars. The counter value is displayed as "1/10".

.EXAMPLE
    Write-TitleCounter -Text "Completed" -Counter 5 -MaxLength 20

    DESCRIPTION
        Displays a custom title "Completed" enclosed within angle brackets ("< >") and flanked by horizontal bars. The counter value is displayed as "5/20".

#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )
    Write-Host "`n`n<" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "]" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host " (" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host " $Counter/$MaxLength " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host ") " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "|" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host " $Text " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host ">" -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
}

# Initiation #

####################################################################################

# Initiates check for OS version,
Start-Bootup
#Import-Variable
Start-NewLoad


####################################################################################



# SIG # Begin signature block
# MIIFiQYJKoZIhvcNAQcCoIIFejCCBXYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBJfvk8GtzVKtlMQxYOdHjdCu
# ZamgggMkMIIDIDCCAgigAwIBAgIQU3x04/OYsb1NqZt3cgzIXTANBgkqhkiG9w0B
# AQsFADAaMRgwFgYDVQQDDA9jaXJjbG9sQHNoYXcuY2EwHhcNMjMwODE1MDQxMTQz
# WhcNMjQwODE1MDQzMTQzWjAaMRgwFgYDVQQDDA9jaXJjbG9sQHNoYXcuY2EwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvOOSeehF7db8BeRjJkV2L6aaD
# pGPa8HAlGyOAafa5/wrSWxMS3XA9XB54ynPwT3xPQxKUp8H3bzpfkAgKx6Nn89vp
# eNsFIr+ktx5ePqkvug9ajI66nsrMXz7iaouwX+tC4QDyBHU2F+jK990TwOEph7WV
# aWK70DwkxaQso9/mC8WlbExdsSnCaQbf2azu7uriZbO/hqgiFrGlIbbRFQ26jfoI
# 0DVYGuNBO3/9o3lUBydN6mpizmoVhexgKnty1cBIQWDIZTL/xR122hi6CAJtKYcf
# 8Ej4nJUCRrP2/bxA0Yw8+93rtdyKU91NH/pYV8v61sYqOxMUbsTZRWZW5EAVAgMB
# AAGjYjBgMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAaBgNV
# HREEEzARgg9jaXJjbG9sQHNoYXcuY2EwHQYDVR0OBBYEFPZu88L4rNaihEgxWlXG
# dNlu490eMA0GCSqGSIb3DQEBCwUAA4IBAQApAtc37CUZZhvpyDXLS3Zi0al6FrfX
# gq1ABwMubo7WCVcrSGo6InHIpgn/oTFuxM/QswH6yCpv6xLOHFbLWpF7ujjRm58o
# IJze+nGpXldW+pgORLpTSj8hxPkC9JopX7YDpPcn9/JJVKXHN7jDD8YvlOSMPR13
# gLt2Oh8nb1tME7aZGepgHyR4aTIp+3dYJ3o1hEMa9YyUFg7SF2hjJFbr3decmKYs
# ofCYIdxFPWh4JvTNwPUxz+XUOgwaMheE3xInEvERwqW69Oh0f+9Ttgbn8tsT0LaD
# 6o9+GPRQFeH2fxK5D76K/AdvELI2mHCh7cC4CUWthYLgAYIJ+lvbAbdbMYIBzzCC
# AcsCAQEwLjAaMRgwFgYDVQQDDA9jaXJjbG9sQHNoYXcuY2ECEFN8dOPzmLG9Tamb
# d3IMyF0wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFMCxT4UIbxOicL9qm/0KzQef4+2OMA0GCSqG
# SIb3DQEBAQUABIIBAJcqGPaN97JqTD6jPobHPHA7kDBSx2Yw1BOp5QeqgixyXlXV
# YlvILCcpuIVfirMckCSoxcNtp41PQ/09wdz2oAzdD0MqwZBuxXv1l12sJNAxDr6Y
# QVVxAPQw7N77MtEaL/2uUBbqegkJUryDuuNCGXOTwx95cfG9G7bT8V3FWP8xAfQI
# zEbcbx7yCTea3aEj5f4scoVLN03ziGIk8eW+eNlE3low2YXtyiQIszP6WSnGk+7o
# aAWPbKdY8wPxzv9SlbwaDYNiKO6m1p/3BV2+qn8BpHTozxslweDJ443Y46g+KtuO
# WEK4lEBDhhRQmqi+atOgB5/tMB143gy87PWj364=
# SIG # End signature block
