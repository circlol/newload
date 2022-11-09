try { Set-Variable -Name ScriptVersion -Value "2201027" ; If (!{$!}){Write-Section -Text "Script Version has been updated" } ;  }catch {}

Function Programs() { 
    Try {
    $TweakType = "Apps"
    Write-Host "`n" ; Write-TitleCounter -Counter '2' -MaxLength $MaxLength -Text "Program Installation"
    Write-Title -Text "Downloading Applications"
    Write-Section -Text "Google Chrome"
    #Google
    If (!(Test-Path -Path:$Location1)) {
        If (Test-Path -Path:$gcoi) {
            Write-Status -Types "+", $TweakType -Status "Google Chrome"
            Start-Process -FilePath:$gcoi -ArgumentList /passive -Verbose -Wait
            Write-Status -Types "+", "Registry" -Status "Flagging Google Chrome to Install UBlock Origin"
            REG ADD $PathToChromeExtensions /v update_url /t REG_SZ /d $PathToChromeLink /f | Out-Null
            Check
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading Google Chrome"
            Start-BitsTransfer -Source $package1dl -Destination $package1lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 -Verbose | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Google Chrome"
            Start-Process -FilePath:$package1lc -ArgumentList /passive -Verbose -Wait
            Write-Status -Types "+", "Registry" -Status "Flagging Google Chrome to Install UBlock Origin"
            REG ADD $PathToChromeExtensions /v update_url /t REG_SZ /d $PathToChromeLink /f | Out-Null
            Check
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Google Chrome is already Installed on this PC." -warning
    }

    Write-Section -Text "VLC Media Player"
    #VLC
    If (!(Test-Path -Path:$Location2)) {
        If (Test-Path -Path:$vlcoi) {
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$vlcoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading VLC Media Player"
            Start-BitsTransfer -Source $Package2dl -Destination $package2lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 -Verbose | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing VLC Media Player"
            Start-Process -FilePath:$package2lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "VLC Media Player is already Installed on this PC." -Warning
    }
        
    Write-Section -Text "Zoom"
    #Zoom
    If (!(Test-Path -Path:$Location3)) {
        If (Test-Path -Path:$zoomoi) {
            Write-Status -Types "+", $tweaktype -Status "Installing Zoom"
            Start-Process -FilePath:$zoomoi -ArgumentList /quiet -Verbose -Wait
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading Zoom"
            Start-BitsTransfer -Source $Package3dl -Destination $package3lc -TransferType Download -RetryInterval 60 -RetryTimeout 60  -Verbose | Out-Host
            Check
            Write-Status -Types "+", $TweakType -Status "Installing Zoom"
            Start-Process -FilePath:$package3lc -ArgumentList /quiet -Verbose -Wait
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Zoom is already Installed on this PC." -Warning
    }
        
    Write-Section -Text "Adobe Acrobat"
    #Adobe
    If (!(Test-Path -Path:$Location4)) {
        If (Test-Path -Path:$aroi) {
            Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64" 
            Start-Process -FilePath:$aroi -ArgumentList /sPB -Verbose
        }
        else {
            CheckNetworkStatus
            Write-Status -Types "+", $TweakType -Status "Downloading Adobe Acrobat Reader x64"
            Start-BitsTransfer -Source $Package4dl -Destination $package4lc -TransferType Download -RetryInterval 60 -RetryTimeout 60 -Verbose | Out-Host
            Check
            If ($? -eq $true){
                Write-Status -Types "+", $TweakType -Status "Installing Adobe Acrobat Reader x64"
                Start-Process -FilePath:$package4lc -ArgumentList /sPB -Verbose    
            }
        }
    }
    else {
        Write-Status -Types "?", $TweakType -Status "Adobe Acrobat is already Installed on this PC." -warning
    }

    Write-Status -Types "+" -Status "Adding support to HEVC/H.265 video codec (MUST HAVE)..."
    Add-AppPackage -Path ".\assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx" -ErrorAction SilentlyContinue
    Check
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function Visuals() { 
    Try {
    $TweakType = "Visual"
    Write-Host "`n" ; Write-TitleCounter -Counter '3' -MaxLength $MaxLength -Text "Visuals"
    If ($BuildNumber -Ge '22000') {
        Write-Title -Text "Detected Windows 11"
        Write-Status -Types "+", "$TweakType" -Status "Applying Wallpaper for Windows 11"
        $PathToFile = Get-ChildItem -Path ".\Assets" -Recurse -Filter "11.jpg" | ForEach-Object { $_.FullName }
        $WallpaperDestination = "$env:appdata\Microsoft\Windows\Themes\11.jpg"
        If (!(Test-Path $WallpaperDestination)){
            Copy-Item -Path $PathToFile -Destination $WallpaperDestination -Force -Confirm:$False
        }
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $WallpaperDestination
        Set-ItemProperty -Path $PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1
        RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine ; Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted"
        $Status = ($?) ; If ($Status) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set" } elseif (!$Status) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper" -Warning } else { Write-Host " idk wtf happened" }
        
    }
    elseif ($BuildNumber -Lt '22000') {
        Write-Title -Text "Detected Windows 10"
        Write-Status -Types "+", "$TweakType" -Status "Applying Wallpaper for Windows 10"
        $PathToFile = Get-ChildItem -Path ".\Assets" -Recurse -Filter "10.jpg" | ForEach-Object { $_.FullName }
        $WallpaperDestination = "$env:appdata\Microsoft\Windows\Themes\11.jpg"
        If (!(Test-Path $WallpaperDestination)){
        Copy-Item -Path $PathToFile -Destination $WallpaperDestination -Force -Confirm:$False
        }
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $WallpaperDestination
        Set-ItemProperty -Path $PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1
        RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine ; Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted"
        $Status = ($?) ; If ($Status) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set" } elseif (!$Status) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper" -Warning } else { Write-Host " idk wtf happened" }
    }
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function Branding() { 
    Try {
    Write-Host "`n" ; Write-TitleCounter -Counter '4' -MaxLength $MaxLength -Text "Mothers Branding"
    $TweakType = "Branding"
    If ((Get-ItemProperty -Path $PathToOEMInfo).Manufacturer -eq "$store") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "Manufacturer" -Type String -Value "$store"
        Check
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportPhone -eq $phone) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportPhone" -Type String -Value "$phone"
        Check
        
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportHours -eq "$hours") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportHours" -Type String -Value "$hours"
        Check
    }
    
    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportURL -eq $website) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportURL" -Type String -Value $website
        Check
    }
    If ((Get-ItemProperty -Path $PathToOEMInfo).Model -eq "$model") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }
    else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name $page -Type String -Value "$Model"
        Check
    }
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function StartMenu() { 
    Try {
    Write-Host "`n" ; Write-TitleCounter -Counter '5' -MaxLength $MaxLength -Text "StartMenuLayout.xml Modification"
    Write-Title -Text "Applying Taskbar Layout"
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
    If (Test-Path $layoutFile) { Remove-Item $layoutFile -Verbose | Out-Null }
    
    #Creates a new layout file
    $StartLayout | Out-File $layoutFile -Encoding ASCII

    $regAliases = @("HKLM", "HKCU")

    #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
    foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        If (!(Test-Path -Path $keyPath)) { New-Item -Path $basePath -Name "Explorer" -Verbose | Out-Null }
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
    }
    
    #Restart Explorer
    Restart-Explorer ; Start-Sleep -s 4
    $wshell = new-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 4 ; Restart-Explorer
    
    #Enable the ability to pin items again by disabling "LockedStartLayout"
    Foreach ($regAlias in $regAliases) {
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value ""
    }

    If ($BuildNumber -Ge $Win11){
        xcopy ".\assets\start.bin" "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" /y
        xcopy ".\assets\start.bin" "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" /y
        #Copy-Item -Path .\Assets\start.bin -Destination "$env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
    }
    
    #the next line makes clean start menu default for all new users
    Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
    
    $StartLayout = @"
    <LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
    <StartLayoutCollection>
    <defaultlayout:StartLayout GroupCellWidth="6" />
    </StartLayoutCollection>
    </DefaultLayoutOverride>
    <CustomTaskbarLayoutCollection PinListPlacement="Add">
    <defaultlayout:TaskbarLayout>
    <taskbar:TaskbarPinList>
    </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
    </LayoutModificationTemplate>
"@
    
    #Restarts Explorer and removes layout file
    $StartLayout | Out-File $layoutFile -Encoding ASCII
    Remove-Item $layoutFile -Verbose

    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function Debloat() { 
    Try {
    $TweakType = "Debloat"
    Write-Host "`n" ; Write-TitleCounter -Counter '6' -MaxLength $MaxLength -Text "Debloat"
    
    Write-Section -Text "Checking for Win32 Pre-Installed Bloat"
    $TweakTypeLocal = "Win32"

    #McAfee Live Safe Removal
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee Live Safe..."
        Start-Process "$livesafe"
    }
    #WebAdvisor Removal
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee WebAdvisor Uninstall."
        Start-Process "$webadvisor"
    }
    #Preinsatlled on Acer machines primarily WildTangent Games
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal WildTangent Games."
        Start-Process $WildGames 
    }
    #ExpressVPN on Acer and HP Machines
    $CheckExpress = Get-ChildItem -Path "C:\ProgramData\Package Cache" -Name "*ExpressVPN*.exe" -recurse -ErrorAction SilentlyContinue | Out-Null
    If ($CheckExpress){ $ExpressVPN = "C:\ProgramData\Package Cache\" + $CheckExpress }
    If ($ExpressVPN){ Try { Write-Status "+" , $TweakType -Status "Starting ExpressVPN Silent Uninstaller"
    Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attempting Removal of ExpressVPN."
    Start-Process $ExpressVPN -ArgumentList "/Uninstall /quiet" -ErrorAction SilentlyContinue
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append ; Write-Host "$($_.Exception)"}}
    
    #Norton cuz LUL Norton
    $CheckNorton = Get-ChildItem -Path "C:\Program Files (x86)\NortonInstaller\" -Name "InstStub.exe" -Recurse -ErrorAction SilentlyContinue | Out-Null
    If ($CheckNorton) { Try { $Norton = "C:\Program Files (x86)\NortonInstaller\" + $CheckNorton 
    Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of Norton..."
    Start-Process $Norton -ArgumentList "/X /ARP"
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append ; Write-Host "$($_.Exception)"}}
    
    #Avast Cleanup Premium
    $AvastCleanupLocation = "C:\Program Files\Common Files\Avast Software\Icarus\avast-tu\icarus.exe"
    If (Test-Path $AvastCleanupLocation){ Try {
        Start-Process $AvastCleanupLocation -ArgumentList "/manual_update /uninstall:avast-tu"
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append ; Write-Host "$($_.Exception)"}}
    
    #Avast Antivirus
    $AvastLocation = "C:\Program Files\Avast Software\Avast\setup\Instup.exe"
    If (Test-Path $AvastLocation){ Try {
        Start-Process $AvastLocation -ArgumentList "/control_panel"
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append ; Write-Host "$($_.Exception)"}}

    $apps = @(
        "Amazon"
        "Booking"
        "Bookings"
        "Booking.com"
        "Bookings.com"
        "Forge of Empires"
        "Planet9 Link"
    )

    $TweakTypeLocal = "Shortcuts"

    ForEach ($app in $apps) {
        
        If (Test-Path -Path "$commonapps\$app.url") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.url"
            Remove-Item -Path "$commonapps\$app.url" -Force
        }

        If (Test-Path -Path "$commonapps\$app.lnk") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.lnk"
            Remove-Item -Path "$commonapps\$app.lnk" -Force
        }
    }
    Write-Host "" ; Write-Section -Text "Removing UWP Apps"
    $TweakTypeLocal = "UWP"
    $Programs = @(
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
        #"Microsoft.GamingServices"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
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
        #"Microsoft.MSPaint"                         # Paint 3D (Where every artist truly start as a kid, i mean, on original Paint, not this 3D)
        #"Microsoft.Print3D"                         # Print 3D
        "Microsoft.SkypeApp"                        # Skype (Who still uses Skype? Use Discord)
        "Microsoft.Todos"                           # Microsoft To Do
        "Microsoft.Wallet"
        "Microsoft.Whiteboard"                      # Microsoft Whiteboard
        #"Microsoft.WindowsAlarms"                   # Alarms
        #"microsoft.windowscommunicationsapps"
        "Microsoft.WindowsMaps"                     # Maps
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsReadingList"
        "Microsoft.WindowsSoundRecorder"
        #"Microsoft.XboxApp"                         # Xbox Console Companion (Replaced by new App)
        #"Microsoft.XboxGameCallableUI"
        #"Microsoft.XboxGameOverlay"
        #"Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.YourPhone"                       # Your Phone
        #"Microsoft.ZuneMusic"                       # Groove Music / (New) Windows Media Player
        #"Microsoft.ZuneVideo"                       # Movies & TV
        
        # Default Windows 11 apps
        #"MicrosoftWindows.Client.WebExperience"     # Taskbar Widgets
        "MicrosoftTeams"                            # Microsoft Teams / Preview
        
        # 3rd party Apps
        #"*ACGMediaPlayer*"
        #"*ActiproSoftwareLLC*"
        "*AdobePhotoshopExpress*"                   # Adobe Photoshop Express
        "AdobeSystemsIncorporated.AdobeLightroom"   # Adobe Lightroom
        "AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    # Adobe Creative Cloud Express
        "*Amazon.com.Amazon*"                       # Amazon
        "AmazonVideo.PrimeVideo"                    # Amazon Prime Video
        "57540AMZNMobileLLC.AmazonAlexa"            # Amazon Alexa
        #"*Asphalt8Airborne*"                       # Asphalt 8 Airbone
        "89006A2E.AutodeskSketchBook"               # SketchBook
        "*AutodeskSketchBook*"
        "*BubbleWitch3Saga*"                        # Bubble Witch 3 Saga
        #"*CaesarsSlotsFreeCasino*"
        "*CandyCrush*"                              # Candy Crush
        #"*Clipchamp*"                               # ClipChamp Video Editor
        #"*COOKINGFEVER*"
        "*CyberLinkMediaSuiteEssentials*"
        "*DisneyMagicKingdoms*"
        "Disney.37853FC22B2CE"
        "*Disney*"
        "*Dolby*"                                   # Dolby Products (Like Atmos)
        #"*DrawboardPDF*"
        "*DropboxOEM*"
        #"*Duolingo-LearnLanguagesforFree*"          # Duolingo
        "*EclipseManager*"
        "Evernote.Evernote"
        "*Facebook*"                                # Facebook
        "*FarmVille2CountryEscape*"
        "*FitbitCoach*"
        "*Flipboard*"                               # Flipboard
        "*HiddenCity*"
        "*Hulu*"
        "*iHeartRadio*"
        "*LinkedInforWindows*"
        #"*MarchofEmpires*"
        "*McAfee*"
        "5A894077.McAfeeSecurity"
        "4DF9E0F8.Netflix"
        #"*NYTCrossword*"
        #"*OneCalendar*"
        #"*PandoraMediaInc*"
        #"*PhototasticCollage*"
        "*PicsArt-PhotoStudio*"
        "*Pinterest*"
        "1424566A.147190DF3DE79"
        #"*Plex*"                                   # Plex
        "*PolarrPhotoEditorAcademicEdition*"
        #*RoyalRevolt*"                             # Royal Revolt
        #"*Shazam*"
        #"*Sidia.LiveWallpaper*"                     # Live Wallpaper
        #"*SlingTV*"
        #"*Speed Test*"
        "SpotifyAB.SpotifyMusic"
        "SpotifyAB.SpotifyMusic_zpdnekdrzrea0"
        "*Sway*"
        "*TuneInRadio*"
        "*Twitter*"                                 # Twitter
        "*TikTok*"
        #"*Viber*"
        #"*WinZipUniversal*"
        "5319275A.WhatsAppDesktop" 
        #"*Wunderlist*"
        #"*XING*"
        
        # Lenovo Bloat

        "E0469640.LenovoUtility"
        
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

        # Samsung Bloat                 -  More Samsung bloat available in #Disabled
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
        
        
        # DISABLED BLOAT
        # SAMSUNG Bloat
        #"SAMSUNGELECTRONICSCO.LTD.SamsungSettings1.2"          # Allow user to Tweak some hardware settings
        #"SAMSUNGELECTRONICSCoLtd.SamsungNotes"
        #"SAMSUNGELECTRONICSCoLtd.SamsungFlux"
        #SAMSUNGELECTRONICSCO.LTD.StudioPlus"
        #"SAMSUNGELECTRONICSCO.LTD.SamsungRecovery"             # Used to Factory Reset
        #"SAMSUNGELECTRONICSCO.LTD.PCGallery"
        #"4AE8B7C2.BOOKING.COMPARTNERAPPSAMSUNGEDITION"
        # Apps which other apps depend on
        #"Microsoft.Advertising.Xaml"
        )

            Remove-UWPAppx -AppxPackages $Programs
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }

}
Function OneDriveRemoval() { 
    Try {
        Write-Host "`n" ; Write-TitleCounter -Counter '8' -MaxLength $MaxLength -Text "OneDrive Removal"
        Write-Status -Types "?" -Status "Disabled for now."
        Start-Sleep -S 10
        <#
        If (Test-Path $Location5 -ErrorAction SilentlyContinue) {
                If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue) {
                    Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
                    Write-Status -Types "-" -Status "Removing OneDrive."
                }
                    Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose
            }
        
        #Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose
        If ($env:OneDrive){
            If (Test-Path -Path $env:OneDrive -ErrorAction SilentlyContinue | Out-Null) { 
                Remove-Item -Path $env:OneDrive -Force -Recurse -ErrorAction SilentlyContinue ; Check
            }
        }
        If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") { Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue ; Check}
        If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") { Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse  -ErrorAction SilentlyContinue ; Check}
        
        Write-Output "Removing scheduled task"
        Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -Verbose -ErrorAction SilentlyContinue
        

        Write-Status -Types "-","$TweakType" -Status "Removing OneDrive Installation Hook for New Users"
        # Thank you Matthew Israelsson
        reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
        If (Get-ItemProperty -Path REGISTRY::HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name "OneDriveSetup" -ErrorAction SilentlyContinue){
            reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f 2> $Null | Out-Null
        }
        reg unload "hku\Default" 
        ##>

    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
    
}
Function BitlockerDecryption() { 
    Try {
    Write-Host "`n" ; Write-TitleCounter -Counter '15' -MaxLength $MaxLength -Text "Bitlocker Decryption"

    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq "On") {
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        Disable-Bitlocker -MountPoint C:\
        #manage-bde -off "C:"
    }
    else {
        Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" -Warning
    }
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function Cleanup() { 
    Try {
    Write-Host "`n" ; Write-TitleCounter -Counter '17' -MaxLength $MaxLength -Text "Cleaning Up"
    $TweakType = 'Cleanup'
    Restart-Explorer
    Write-Status -Types "+" , $TweakType -Status "Enabling F8 boot menu options"
    #    bcdedit /set {bootmgr} displaybootmenu yes | Out-Null
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    If (Test-Path $location1) {
        Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
        Start-Process Chrome
    }    

    Write-Section -Text "Cleanup"

    Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"

    Remove-Item "$env:localappdata\temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue  -Exclude "New Loads" 2>$NULL
    If (Test-Path $vlcsc) { 
        Write-Status -Types "-", $TweakType -Status "Removing VLC Media Player Desktop Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $acrosc) { 
        Write-Status -Types "-" , $TweakType -Status "Removing Acrobat Desktop Icon"
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $zoomsc) {
        Write-Status -Types "-", $TweakType -Status "Removing Zoom Desktop Icon"
        Remove-Item -path $zoomsc -force | Out-Null
    }

    Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Exclude "New Loads" | Out-Null
    
    
    If (Test-Path $EdgeShortcut) { 
        Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in User Folder"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $edgescpub) { 
        Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in Public Desktop"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    If (Test-Path $ctemp) { 
        Write-Status -Types "-" , $TweakType -Status "Removing C:\Temp"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue 2> $NULL | Out-Null
    }
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function New-RestorePoint() { 
    Try {
    $TweakType = "Backup"
    Write-Host "`n" ; Write-TitleCounter -Counter '16' -MaxLength $MaxLength -Text "Creating Restore Point"
    Write-Status -Types "+", $TweakType -Status "Enabling system drive Restore Point..."
    Enable-ComputerRestore -Drive "$env:SystemDrive\"
    Checkpoint-Computer -Description "Mother Computers Courtesy Restore Point" -RestorePointType "MODIFY_SETTINGS"

    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function Backup-HostsFile() { 
    Try {
    $PathToHostsFile = "$env:SystemRoot\System32\drivers\etc"

    Write-Status -Types "+" -Status "Doing Backup on Hosts file..."
    $Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Push-Location "$PathToHostsFile"

    If (!(Test-Path "$PathToHostsFile\Hosts_Backup")) {
        Write-Status -Types "?" -Status "Backup folder not found! Creating a new one..."
        mkdir -Path "$PathToHostsFile\Hosts_Backup"
    }
    Push-Location "Hosts_Backup"

    Copy-Item -Path ".\..\hosts" -Destination "hosts_$Date"

    Pop-Location
    Pop-Location
    }Catch{ "Error: $($_.Exception)" | Out-File "$ErrorLog" -Append
        Write-Host "$($_.Exception)"
        Continue
    }
}
Function EmailLog() {
    $EndTime = Get-Date -DisplayHint Time
    $ElapsedTime = $EndTime - $StartTime
    $CurrentDate = Get-Date
    $IP = (New-Object System.Net.WebClient).DownloadString("http://ifconfig.me/ip")
    $Mobo = wmic baseboard get product
    $CPU = Get-CPU
    $RAM = Get-RAM
    $GPU = Get-GPU
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption
    $SSD = Get-OSDriveType
    $DriveSpace = Get-DriveSpace

    Stop-Transcript | Out-Null
	systeminfo | Sort-Object | Out-File -Append $log -Encoding ascii
    [String]$SystemSpec = Get-SystemSpec

    If (Test-Path -Path "$Location1") { $chromeyns = "X" }else { $chromeyns = "" }
    If (Test-Path -Path "$Location2") { $vlcyns = "X" }else { $vlcyns = "" }
    If (Test-Path -Path "$Location3") { $zoomyns = "X" }else { $zoomyns = "" }
    If (Test-Path -Path "$Location4") { $adobeyns = "X" }else { $adobeyns = "" }
    If ($CurrentWallpaper -eq $Wallpaper){$WallpaperApplied = "YES"}Else{$WallpaperApplied = "NO"}
    
    #Motherboard
    $TempFile = "$Env:Temp\tempmobo.txt" ; $Mobo | Out-File $TempFile -Encoding ASCII 
    (Get-Content $TempFile).replace('Product', '') | Set-Content $TempFile
    (Get-Content $TempFile).replace("  ", '') | Set-Content $TempFile
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile
    
    $CheckIfErrorLogCreated = Test-path -Path ".\ErrorLog.txt"
    If ($CheckIfErrorLogCreated -eq $True){$Log = @("$Log" , ".\ErrorLog.txt")}
    
    $StartBinLocation = "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\start.bin"
    If (Test-Path $StartBinLocation){
        $StartbinHash = (Get-FileHash $StartBinLocation).Hash
        $ModifiedStartBinHash = (Get-FileHash ".\assets\Start.bin").Hash
        If ($StartBinHash -eq $ModifiedStartBinHash){$StartMenuLayout = "YES"}
    }


    Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "New Loads Log" -Attachments "$Log" -Priority High -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -Verbose -ErrorAction SilentlyContinue -Body "
        ############################################################################
        #==========================================================================#                                
        #=                                                                        =#
        #=                         NEW LOADS SCRIPT LOG                           =#
        #=                                                                        =#
        #==========================================================================#  
        ############################################################################
                                        
                    New Loads was run on a computer for $ip\$env:USERNAME, 
                                Completing in $ElapsedTime

    Date: $CurrentDate
    
    Script Info:
    Program Version: $programversion
    Script Version: $ScriptVersion
    Script Start Time: $StartTime
    Script End Time: $EndTime


    Computer Information:
    CPU: $CPU
    Motherboard: $Mobo
    RAM: $RAM
    GPU: $GPU
    SSD: $SSD
    OS: $WindowsVersion
    Version: $DisplayVersion

    Drives:
    $DriveSpace

    <#$SystemSpec#>

    Script Run Information:

    Applications Installed: $appsyns
    Chrome: [$chromeyns]
    VLC: [$vlcyns] 
    Adobe: [$adobeyns] 
    Zoom: [$zoomyns]
    

    Wallpaper Applied: [$WallpaperApplied]
    Windows 11 Start Layout Applied: [$StartMenuLayout]

    Packages Removed During Debloat: [$PackagesRemovedCount]
    $PackagesRemoved


    "
}
Function JC() {
    Write-Host ""
    Write-Status "GUI" -Status "Ready for Next Selection"
}

If (!$GUI){

        #$MaxLength = '17'
        #Variables
        #BootCheck
        #ScriptInfo
        #CheckFiles
        Start-Transcript -Path $Log ; $StartTime = Get-Date -DisplayHint Time

        Write-Status -Types "?" , "Activation" -Status "Checking Windows Activation Status.." -Warning
        $ActiStat = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object PartialProductKey).LicenseStatus
        If ($ActiStat -ne 1) { Write-CaptionFailed -Text "Windows is not activated. Feel free to Activate Windows while New Loads runs.."; Start-Sleep -Seconds 3 ; Start-Process slui -ArgumentList '3' 
        }else {Write-CaptionSucceed -Text "Windows is Activated. Proceeding"}

        Programs
        Visuals
        Branding
        StartMenu
        Debloat
        #OOS
        #Adw
        OfficeCheck
        OneDriveRemoval
        AdvRegistry

        Optimize-Performance
        Optimize-Privacy
        Optimize-Security
        Optimize-ServicesRunning
        Optimize-TaskScheduler

        BitlockerDecryption
        New-RestorePoint
        Backup-HostsFile
        EmailLog
        Cleanup

        Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB "
        Request-PCRestart

}else{

        CheckNetworkStatus
        GUI

}

### END OF SCRIPT ###


# SIG # Begin signature block
# MIIGiwYJKoZIhvcNAQcCoIIGfDCCBngCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKCw+FD71Gkoc11F/c0B0F7ZZ
# M6OgggPGMIIDwjCCAqqgAwIBAgIQG23ehsglIKxDyVeFlzqJzzANBgkqhkiG9w0B
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
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFBAI78SCeZTD
# dp4Ny0kvBj2j1vaoMA0GCSqGSIb3DQEBAQUABIIBABMdO//HEUKnFyd674sKNpMf
# Y5KCOIJUNQ6KRp1wgu8I9Nvn9/p/5ZBQLjo9RloVfuGEfV+CIWyLE2bDH57YHFzo
# qFMqHjXSOPOdLX6+ioftVIicX3vlj0Blb4WRYyqfcKZoQDn+GrsY1oU2SyP4mh3h
# /k4HrBgjPt+KmBAosXCA2DELa06xgUnH8Be3IzZNSQG7Pn0wuv+rx1DPYpcEEHK9
# rgyFeKOh1F6gnjOVs7QIKLXm0TQqwVLHoUZeJ7Fm/YAhJL8JzrOmznBKyvKYY1QU
# TQuqgoDv6UADjJB2uyB6fBwi2Ndr3ToUO0YU63GdHR7YcftNrV6+rrXzMekzlz0=
# SIG # End signature block
