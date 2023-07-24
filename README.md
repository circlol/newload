# 



![Logo](https://github.com/circlol/newload/raw/main/assets/icons/newloads-github.png)

New Loads, a comprehensive and seamless Windows 10 & 11 setup utility, has been meticulously crafted using Powershell from the very beginning. By incorporating tailored functions, it offers a simple and efficient means of enhancing both security and performance effortlessly.

# ![](https://raw.githubusercontent.com/circlol/newload/main/icon/curved-monitor_result%2064x64.png) **New Loads Overview**

- **Program Installation** (Chrome, VLC, Acrobat, Zoom)

  [^]: Use switch parameter `-SkipPrograms` to skip this section

- **Mother Computer's Specific Branding** (Wallpaper, OEM Info in *_About your PC_*)

  [^]: Use switch parameter `-NoBranding` to skip this section

- **Custom Start Menu and Taskbar Layout**

- **Debloat**

- **Malwarebytes ADWCleaner**

  [^]: Use switch parameter `-SkipADW` to skip this section

- **Office Removal** - _by confirmation_

- **Optimization**

  - General Tweaks
  - Performance related tweaks
  - Privacy
  - Security
  - Services
  - Task Scheduler
  - Windows Optional Features 

- **Bitlocker Decryption**

  [^]: Use switch parameter `-SkipBitlocker` to skip this section

​	 



<h2>⚠️Things to keep in mind before running</h2>

1. New Loads is primarily used by Mother Computers, a west coast canadian retail/repair shop, therefor the script will set the time-zone of the system it's run on to Pacific Standard Time.
2. Unless run with switch parameter `-NoBranding` the script will apply OEM information in settings and a wallpaper will be applied. The OEM information is tied to Mother Computers.
3. New Loads was not designed to account for an already lived in OS, it is meant to be run on a fresh operating system. Please note that you may experience unwanted changes.

⚠️ **DISCLAIMER:** _You are using this software at your own risk, I am not responsible for any data loss or damage that may occur. It's not guaranteed that every feature removed from the system can be easily restored._



<h2>Download: </h2>

<div align="center">
  <table>
    <thead align="center">
      <tr>
        <th>Direct Download</th>
        <th>Supported OS's</th>
        <th>Edition(s)</th>
        <th>Requirements</th>
      </tr>
    </thead>
    <tbody align="center">
      <tr>
        <td>
            <h4><a href="https://github.com/circlol/newload/raw/main/exe/newloads.exe">⬇️ Main</a></h4>(Stable)
        </td>
        <td rowspan="2">Windows 10 and 11<br> 20H2 and Above</td>
        <td rowspan="2">Home / Pro / Edu / Ent / Server </td>
        <td rowspan="2">Admin<br>Powershell v5.1+<br></td>
      </tr>
      <tr>
        <td>
            <h4><a href="https://github.com/circlol/newloadsTesting/raw/main/exe/newloads.exe">⬇️ Develop</a></h4>(Newer)
        </td>
      </tr>
    </tbody>
  </table>
</div>




Github Main branch: [Link](https://github.com/circlol/newload)

Github Development branch: [Link](https://github.com/circlol/newloadsTesting) 



### Usage of New Loads


<h6>Usage Directly through powershell</h6>

```powershell
irm "https://raw.githubusercontent.com/circlol/newload/main/exe/New%20Loads.ps1" | iex
```

<h6>Command Line Usage</h6>

`& .\New Loads.exe -GUI` : Initiates New Loads with a WinForm GUI - Cannot be used with other arguments

`& .\New Loads.exe -NoBranding` : Skips **Branding** and **Visuals** sections of the script

`& .\New Loads.exe -SkipADW` : Skips Malwarebytes ADWCleaner scan

`& .\New Loads.exe -SkipBitlocker` : Skips disabling bitlocker

`& .\New Loads.exe -SkipPrograms` : Skips installing programs



<h2>☑️ In Depth Script Breakdown</h2>

<details>
  <summary>Click to Expand</summary>

- Start-Bootup checks requirements and sets execution policy
- All Variables are imported from function Import-Variables
- [Assets](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/exe/New%20Loads.ps1#L669) are acquired and imported

​	**Applies to pressing start in GUI_**

- [Get-Programs](https://github.com/circlol/newloadsTesting/blob/73f06a02cbc738639a279486f7dbbbc2c3e039ce/lib/scripts/Programs.psm1#L1) downloads Google Chrome, VLC Media Player, Acrobat Reader, and Zoom

  [^]: Use -SkipPrograms to skip installing these apps.

  [^]: Also installs H.265 Codec from Device Manufacturer and UBlock Origin into Chrome

- [Set-Visuals](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Visuals.psm1#L1) applies a wallpaper, sets to stretch and changes system to light mode

- [Set-Branding](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Branding.psm1#L1) sets Mother Computer's support info     _Seen in Settings -> About Your PC_

- [Set-StartMenu](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/StartMenu.psm1#L1) applies a taskbar layout then a  custom start menu layout in 11 and clears pinned tiles in 10. 

- [Debloat](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Debloat.psm1#L1) checks common Win32 Programs, UWP bloat, Start Menu Ads (Internet Shortcuts) and removes them

  <details>
    <summary>Click to Expand for a list of Debloat Apps</summary>
  ###### _To make suggestions submit a change or send an email to newloads@shaw.ca_


  ```powershell
  #        Win32
  "Avast"
  "ExpressVPN"
  "McAfee"
  "Norton"
  "WildTangent Games"
  
  #        Internet Shortcuts
  "Adobe Offers"
  "Amazon"
  "Booking.com"
  "ExpressVPN"
  "Forge Of Empires"
  "*Free Trials*"
  "Planet9 Link"
  "Utomik"
  
  #        UWP
  # Microsoft Applications
  "Microsoft.549981C3F5F10"                   			# Cortana
  "Microsoft.3DBuilder"                       			# 3D Builder
  "Microsoft.Appconnector"                    			# App Connector
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
  "Microsoft.SkypeApp"                        			# Skype
  "MicrosoftTeams"                            			# Teams / Preview
  "Microsoft.Todos"                           			# To Do
  "Microsoft.Wallet"                          			# Wallet
  "Microsoft.Whiteboard"                      			# Microsoft Whiteboard
  "Microsoft.WindowsPhone"                    			# Your Phone Alternate
  "Microsoft.WindowsReadingList"              			# Reading List
  "Microsoft.ZuneMusic"                       			# Groove Music 
  "Microsoft.ZuneVideo"                       			# Movies & TV
  #          3rd party Apps
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
  "Evernote.Evernote"                         			# Evernote
  "*ExpressVPN*"                              			# ExpressVPN
  "*Facebook*"                                			# Facebook
  "*Flipboard*"                               			# Flipboard
  "*Hulu*"                                    			# Hulu
  "*Instagram*"                               			# Instagram
  "*McAfee*"                                  			# McAfee
  "5A894077.McAfeeSecurity"                   			# McAfee Security
  "4DF9E0F8.Netflix"                          			# Netflix
  "*PicsArt-PhotoStudio*"                     			# PhotoStudio
  "*Pinterest*"                               			# Pinterest
  "142F4566A.147190D3DE79"                    			# Pinterest
  "1424566A.147190DF3DE79"                    			# Pinterest
  "SpotifyAB.SpotifyMusic"                    			# Spotify
  "*Twitter*"                                 			# Twitter
  "*TikTok*"                                  			# TikTok
  "5319275A.WhatsAppDesktop"                  			# WhatsApp
  
  #         Acer OEM Bloat
  "AcerIncorporated.AcerRegistration"         			# Acer Registration
  "AcerIncorporated.QuickAccess"              			# Acer Quick Access
  "AcerIncorporated.UserExperienceImprovementProgram"     # Acer User Experience Improvement Program
  "AcerIncorporated.AcerCollectionS"          			# Acer Collections 
  
  #         HP Bloat
  "AD2F1837.HPPrivacySettings"                			# HP Privacy Settings
  "AD2F1837.HPInc.EnergyStar"                 			# Energy Star
  "AD2F1837.HPAudioCenter"                    			# HP Audio Center
  
  #         Common HP & Acer Bloat
  "CyberLinkCorp.ac.PowerDirectorforacerDesktop"          # CyberLink Power Director for Acer
  "CorelCorporation.PaintShopPro"                         # Coral Paint Shop Pro
  "26720RandomSaladGamesLLC.HeartsDeluxe"                 # Hearts Deluxe
  "26720RandomSaladGamesLLC.SimpleSolitaire"              # Simple Solitaire
  "26720RandomSaladGamesLLC.SimpleMahjong"                # Simple Mahjong
  "26720RandomSaladGamesLLC.Spades"                       # Spades
  ```

  </details>

- [Get-Office](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Office.psm1#L1) checks for any installed version of Office and prompts user for removal

  [^]: Uses Microsoft SaRACmd to remove Office

- [General tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/GeneralTweaks.psm1#L1) does things like removes chat, cortana from the taskbar, changes search into an icon, expands explorer ribbon, enables compact view, ect. General Tweaks

- [Performance tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Performance.psm1#L1) sets a few things to the max, for example games/multimedia usage set to 100%, enables hardware accelerated gpu scheduling, and more.

- [Privacy tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Privacy.psm1#L2) disables a surprisingly large amount of tracking and telemetry.

- [Security tweaks](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Security.psm1#L2) applies various patches and exploit protections

- [Services](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Services.psm1#L1C10-L1C18) are optimized - listed below are all the services that are disabled

  <details>
    <summary>Click to Expand for a list of Disabled Services</summary>

  ​      _To make suggestions submit a change or send an email to newloads@shaw.ca_

​		Disabled

  ```powershell
  "DiagTrack"			# DEFAULT: Automatic | Connected User Experiences and Telemetry
  "diagnosticshub.standardcollector.service"  # DEFAULT: Manual | Microsoft (R) Diagnostics Hub Standard Collector Service  Application Protocol (WAP)
  "GraphicsPerfSvc"   # DEFAULT: Manual    | Graphics performance monitor service
  "HomeGroupListener" # NOT FOUND (Win 10+)| HomeGroup Listener
  "HomeGroupProvider" # NOT FOUND (Win 10+)| HomeGroup Provider
  "lfsvc"         # DEFAULT: Manual    | Geolocation Service
  "MapsBroker"    # DEFAULT: Automatic | Downloaded Maps Manager
  "PcaSvc"        # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
  "RemoteAccess"  # DEFAULT: Disabled  | Routing and Remote Access
  "RemoteRegistry"# DEFAULT: Disabled  | Remote Registry
  "RetailDemo"    # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
  "TrkWks"        # DEFAULT: Automatic | Distributed Link Tracking Client
  "WSearch"       # DEFAULT: Automatic | Windows Search (100% Disk usage on HDDs)
  "NPSMSvc_df772"
  "LanmanServer"	
  ```

​		Manual

  ```powershell
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
  ```

-  Changes to the [task scheduler](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/TaskScheduler.psm1#L2) are mostly tracking related but are also listed below

  <details>
    <summary>Click to Expand for a list of Scheduled Tasks</summary>
  ######   _To make suggestions submit a change or send an email to newloads@shaw.ca_
  
  Enabled
  
  ```powershell
  "\Microsoft\Windows\Defrag\ScheduledDefrag"
  "\Microsoft\Windows\Maintenance\WinSAT"
  "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"
  "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
  ```
  
  Disabled
  
  ```powershell
  "\Microsoft\Office\OfficeTelemetryAgentLogOn"
  "\Microsoft\Office\OfficeTelemetryAgentFallBack"
  "\Microsoft\Office\Office 15 Subscription Heartbeat"
  "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
  "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
  "\Microsoft\Windows\Application Experience\StartupAppTask"
  "\Microsoft\Windows\Autochk\Proxy"
  "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         
  "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"       
  "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
  "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              
  "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
  "\Microsoft\Windows\Location\Notifications"                                       
  "\Microsoft\Windows\Location\WindowsActionDialog"                                 
  "\Microsoft\Windows\Maps\MapsToastTask"                                           
  "\Microsoft\Windows\Maps\MapsUpdateTask"                                          
  "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"                
  "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"                   
  "\Microsoft\Windows\Retail Demo\CleanupOfflineContent"                            
  "\Microsoft\Windows\Shell\FamilySafetyMonitor"                                    
  "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"                                
  "\Microsoft\Windows\Shell\FamilySafetyUpload"
  "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"    
  ```

​		</details>

- [Optional Features](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/OptionalFeatures.psm1#L1C10-L1C18) removes old legacy features

  <details>
    <summary>Click to Expand for a list of Optional Features</summary>

###### 		 _To make suggestions submit a change or send an email to newloads@shaw.ca_

​		Disabled

  ```powershell
  "IIS-*"                                # Internet Information Services
  "Internet-Explorer-Optional-*"         # Internet Explorer
  "LegacyComponents"                     # Legacy Components
  "MediaPlayback"                        # Media Features (Windows Media Player)
  "MicrosoftWindowsPowerShellV2"         # PowerShell 2.0
  "MicrosoftWindowsPowershellV2Root"     # PowerShell 2.0
  "Printing-XPSServices-Features"        # Microsoft XPS Document Writer
  "WorkFolders-Client"                   # Work Folders Client
  ```

  </details>

- Disables [Bitlocker](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/Start-BitLockerDecryption.psm1#L1C10-L1C18) on the system

  [^]: Use switch `-SkipBitlocker` to avoid this feature


- [Restore point](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/New-SystemRestorePoint.psm1#L1C10-L1C18) is created at the end
- Script [Cleanup](https://github.com/circlol/newloadsTesting/blob/48d061e9e1352ad0cebe9d7b2dc0dbbcc0f20514/lib/scripts/Cleanup.psm1#L1C1-L1C1)

​	</details>

## Documentation

[Documentation](https://linktodocumentation)

<a href="https://www.flaticon.com/free-icons/monitor" title="monitor icons">Monitor icons created by Freepik - Flaticon</a>