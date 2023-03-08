#Requires -RunAsAdministrator
try { Set-Variable -Name ScriptVersion -Value "230224" ; If (! { $! }) { Write-Section -Text "Script Version has been updated" } ; }catch {throw}
Function Programs() {
    Try{
    # Set Window Title
    $WindowTitle = "New Loads - Programs"; $host.UI.RawUI.WindowTitle = $WindowTitle
    "" ; Write-TitleCounter -Counter '2' -MaxLength $MaxLength -Text "Program Installation"
    Write-Section -Text "Application Installation"
    $chrome = @{
        Name = "Google Chrome"
        Location = "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
        DownloadURL = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        Installer = ".\bin\googlechromestandaloneenterprise64.msi"
        ArgumentList = "/passive"
    }
    $vlc = @{
        Name = "VLC Media Player"
        Location = "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
        DownloadURL = "https://get.videolan.org/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
        Installer = ".\bin\vlc-3.0.18-win64.exe"
        ArgumentList = "/S /L=1033"
    }
    $zoom = @{
        Name = "Zoom"
        Location = "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe"
        DownloadURL = "https://zoom.us/client/5.13.5.12053/ZoomInstallerFull.msi?archType=x64"
        Installer = ".\bin\ZoomInstallerFull.msi"
        ArgumentList = "/quiet"
    }
    $acrobat = @{
        Name = "Adobe Acrobat Reader"
        Location = "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
        DownloadURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe"
        Installer = ".\bin\AcroRdrDCx642200120085_MUI.exe"
        ArgumentList = "/sPB"
    }
    ## Initiates the program download and install process
    foreach ($program in $chrome, $vlc, $zoom, $acrobat) {
        Write-Section -Text $program.Name
        # Checks if the Program is already installed
        If (!(Test-Path -Path:$program.Location)) {
            # Checks if the installer isn't in the 
            If (!(Test-Path -Path:$program.Installer)) {
                CheckNetworkStatus
                Write-Status -Types "+", "Apps" -Status "Downloading $($program.Name)"
                Start-BitsTransfer -Source $program.DownloadURL -Destination $program.Installer -TransferType Download -Dynamic
            }
        
            # Installs Each Application - 
            # If its Google Chrome, it will wait
            # If its VLC Media Player, it will install the H.265 codec
            Write-Status -Types "+", "Apps" -Status "Installing $($program.Name)"
            If ($($program.Name) -eq "Google Chrome"){
                Start-Process -FilePath:$program.Installer -ArgumentList $program.ArgumentList -Wait
                Write-Status "+", "Apps" -Status "Adding UBlock Origin to Google Chrome"
                REG ADD "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" /v update_url /t REG_SZ /d "https://clients2.google.com/service/update2/crx" /f
            }Else {
                Start-Process -FilePath:$program.Installer -ArgumentList $program.ArgumentList 
            }
        If ($($Program.Name) -eq "VLC Media Player"){
            Write-Status -Types "+", "Apps" -Status "Adding support to HEVC/H.265 video codec (MUST HAVE)..."
            Add-AppPackage -Path $HVECCodec -ErrorAction SilentlyContinue
        }
        } else {
            Write-Status -Types "@", "Apps" -Status "$($program.Name) already seems to be installed on this system.. Skipping Installation"
        }
    }
    $WindowTitle = "New Loads"; $host.UI.RawUI.WindowTitle = $WindowTitle
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}


function Visuals() {
    try {
        $TweakType = "Visual" ; $WindowTitle = "New Loads - Visuals" ; $host.UI.RawUI.WindowTitle = $WindowTitle
        Write-Host "`n" ; Write-TitleCounter -Counter '3' -MaxLength $MaxLength -Text "Visuals"
        $os = Get-CimInstance -ClassName Win32_OperatingSystem
        $global:osVersion = $os.Caption
        If ($osVersion -like "*10*") {
            # code for Windows 10
            Write-Title -Text "Detected Windows 10"
            $wallpaperPath = ".\Assets\10.jpg"
        }elseif ($osVersion -like "*11*") {
            # code for Windows 11
            Write-Title -Text "Detected Windows 11"
            $wallpaperPath = ".\Assets\11.jpg"
        }else {
            # code for other operating systems
            # Check Windows version
            Throw "Unsupported operating system version."
        }
        Write-Status -Types "+", $TweakType -Status "Applying Wallpaper"
        # Copy wallpaper file
        $wallpaperDestination = "$env:appdata\Microsoft\Windows\Themes\wallpaper.jpg"
        Copy-Item -Path $wallpaperPath -Destination $wallpaperDestination -Force -Confirm:$False
        # Update wallpaper settings
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Force
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaperDestination
        Set-ItemProperty -Path $PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 0
        Set-ItemProperty -Path $PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1
        #Invoke-Expression "RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters"
        Start-Process "RUNDLL32.EXE" "user32.dll, UpdatePerUserSystemParameters"
        $Status = ($?) ; If ($Status) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set`n" } elseif (!$Status) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper`n" -Warning } else { }

        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
        Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted`n"
    }
    catch {
        $errorMessage = $_.Exception.Message
        $errorType = $_.Exception.GetType().FullName
        $lineNumber = $_.InvocationInfo.ScriptLineNumber
        $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

        $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
        $global:ErrorLog += $errorLogEntry
    }
}

Function Branding() {
    try{
    $WindowTitle = "New Loads - Branding"; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '4' -MaxLength $MaxLength -Text "Mothers Branding"
    $TweakType = "Branding"
    # Applies Mother Computers Branding, Phone number, and Hours to Settings Page
    If ((Get-ItemProperty -Path $PathToOEMInfo).Manufacturer -eq "$store") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }else {
        Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "Manufacturer" -Type String -Value "$store"
        Check
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportPhone -eq $phone) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }else {
        Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportPhone" -Type String -Value "$phone"
        Check
    }
    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportHours -eq "$hours") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportHours" -Type String -Value "$hours"
        Check
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportURL -eq $website) {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }else {
        Write-Status -Types "+", $TweakType -Status "Adding Store URL to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportURL" -Type String -Value $website
        Check
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).Model -eq "$model") {
        Write-Status -Types "?" -Status "Skipping" -Warning
    }else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name $page -Type String -Value "$Model"
        Check
    }
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}
Function StartMenu () {
    try{
    $WindowTitle = "New Loads - Start Menu"; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '5' -MaxLength $MaxLength -Text "StartMenuLayout.xml Modification"
    Write-Section -Text "Applying Taskbar Layout"
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
            <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
            <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
            </taskbar:TaskbarPinList>
        </defaultlayout:TaskbarLayout>
        </CustomTaskbarLayoutCollection>
    </LayoutModificationTemplate>
"@
        Write-Status -Types "+" -Status "Applying Taskbar Layout"
        $layoutFile = "$Env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml"
        If (Test-Path $layoutFile) { Remove-Item $layoutFile -Verbose | Out-Null }
        $StartLayout | Out-File $layoutFile -Encoding ASCII
        Check
        Restart-Explorer
        Start-Sleep -Seconds 4
        Remove-Item $layoutFile

        If ($osVersion -like "*11*"){
        Write-Section -Text "Applying Start Menu Layout"
        Write-Status -Types "+" -Status "Generating Layout File"
        $StartBinDefault = "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\"
        $StartBinCurrent = "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
        $StartBinFiles = @(
            ".\assets\start.bin"
            ".\assets\start2.bin"
            )
            Foreach ($StartBinFile in $StartBinFiles){
                If (Test-Path $StartBinFile){
                    $Pass = 0
                    Write-Status -Types "+" -Status "Copying $StartBinFile for new users ($pass/2)"
                    xcopy $StartBinFile $StartBinDefault /y
                    Check
                    Write-Status -Types "+" -Status "Copying $StartBinFile to current user ($pass/2)"
                    xcopy $StartBinFile $StartBinCurrent /y
                    Check
                    $pass++
                }
            }
            Taskkill /f /im StartMenuExperienceHost.exe
        }
    }
    catch {
        $errorMessage = $_.Exception.Message
        $errorType = $_.Exception.GetType().FullName
        $lineNumber = $_.InvocationInfo.ScriptLineNumber
        $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

        $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
        $global:ErrorLog += $errorLogEntry
    }
}
Function Remove-UWPAppx() {
    [CmdletBinding()]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"
    # Store the original progress preference
    #$originalProgressPreference = $ProgressPreference
    # Set the progress preference to 'SilentlyContinue' to suppress all other output
    #$ProgressPreference = 'SilentlyContinue'
    try{
    ForEach ($AppxPackage in $AppxPackages) {
        $appxPackageToRemove = Get-AppxPackage -AllUsers -Name $AppxPackage -ErrorAction SilentlyContinue
        if ($appxPackageToRemove) {
            $appxPackageToRemove | ForEach-Object {
                Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage from ALL users..."
                Remove-AppxPackage $_.PackageFullName  -EA SilentlyContinue -WA SilentlyContinue >$NULL | Out-Null #4>&1 | Out-Null
                If ($?){ $Global:Removed++ } elseif (!($?)) { $Global:Failed++ }
            }
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
            If ($?){ $Global:Removed++ } elseif (!($?)) { $Global:Failed++ }
        } else {
            $Global:NotFound++
        }
    }
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
    # Reset the progress preference to the original value
    #$ProgressPreference = $originalProgressPreference
}
Function Debloat() {
    Try{
    $TweakType = "Debloat"
    $WindowTitle = "New Loads - Debloat"; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '6' -MaxLength $MaxLength -Text "Debloat"

    Write-Section -Text "Checking for Win32 Pre-Installed Bloat"
    $TweakTypeLocal = "Win32"

    #McAfee Live Safe Removal
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee Live Safe..."
        Start-Process "$livesafe"
    }    #WebAdvisor Removal
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee WebAdvisor Uninstall."
        Start-Process "$webadvisor"
    }

    #Preinsatlled on Acer machines primarily WildTangent Games
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal WildTangent Games."
        Start-Process $WildGames
    }

    #Norton cuz LUL Norton
    $NortonPath = "C:\Program Files (x86)\NortonInstaller\"
    $CheckNorton = Get-ChildItem -Path $NortonPath -Name "InstStub.exe" -Recurse -ErrorAction SilentlyContinue | Out-Null
    If ($CheckNorton) {
        $Norton = $NortonPath + $CheckNorton
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of Norton..."
        Start-Process $Norton -ArgumentList "/X /ARP"
    }

    #Avast Cleanup Premium
    $AvastCleanupLocation = "C:\Program Files\Common Files\Avast Software\Icarus\avast-tu\icarus.exe"
    If (Test-Path $AvastCleanupLocation) {
        Start-Process $AvastCleanupLocation -ArgumentList "/manual_update /uninstall:avast-tu"
    }

    #Avast Antivirus
    $AvastLocation = "C:\Program Files\Avast Software\Avast\setup\Instup.exe"
    If (Test-Path $AvastLocation) {
        Start-Process $AvastLocation -ArgumentList "/control_panel"
    }

    $apps = @(
        "Adobe offers"
        "Amazon"
        "Booking"
        "Booking.com"
        "ExpressVPN"
        "Forge of Empires"
        "Free Trials"
        "Planet9 Link"
        "Utomik - Play over 1000 games"
    )

    Write-Section -Text "Checking for Start Menu Ads"
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
    )

    Write-Section -Text "Checking for UWP Apps"
    $TweakType = "UWP"

    $TotalItems = $Programs.Count
    $CurrentItem = 0
    $PercentComplete = 0
    ForEach($Program in $Programs){
    Write-Progress -Activity "Debloating System" -Status " $PercentComplete% Complete:" -PercentComplete $PercentComplete
    Remove-UWPAppx -AppxPackages $Program
    $CurrentItem++
    $PercentComplete = [int](($CurrentItem / $TotalItems) * 100)
    }
    
    Write-Host "Debloat Completed!`n" -Foregroundcolor Green
    Write-Host "Successfully Removed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Removed" -ForegroundColor Green
    Write-Host "Failed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Failed" -ForegroundColor Red
    Write-Host "Not Found: " -NoNewline -ForegroundColor Gray ; Write-Host "$NotFound`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 4
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}
Function BitlockerDecryption() {
    try{
    $WindowTitle = "New Loads - Bitlocker Decryption"; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '10' -MaxLength $MaxLength -Text "Bitlocker Decryption"

    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq "On") {
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        Disable-Bitlocker -MountPoint C:\
        #manage-bde -off "C:"
    }
    else {
        Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" -Warning
    }
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}
Function CheckForMsStoreUpdates() {
    try{
    Write-Status -Types "+" -Status "Checking for updates in Microsoft Store"
    $wmiObj = Get-WmiObject -Namespace "root\cimv2\mdm\dmmap" -Class "MDM_EnterpriseModernAppManagement_AppManagement01"
    $result = $wmiObj.UpdateScanMethod()
    if ($result.ReturnValue -eq 0) {
    Write-Status -Types "+" -Status "Microsoft Store updates check successful"
    } else {
    Write-Status -Types "?" -Status "Error checking for Microsoft Store updates" -Warning
    }
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}
Function Cleanup() {
    try{
    $WindowTitle = "New Loads - Cleanup"; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '12' -MaxLength $MaxLength -Text "Cleaning Up"
    $TweakType = 'Cleanup'
    Restart-Explorer
    Write-Status -Types "+" , $TweakType -Status "Enabling F8 boot menu options"
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
        If (Test-Path $location1) {
            Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
            Start-Process Chrome -ErrorAction SilentlyContinue | Out-Null
        }
        Write-Section -Text "Cleanup"
        Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"
        Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -Exclude "New Loads" -ErrorAction SilentlyContinue | Out-Null

        Write-Status -Types "-", $TweakType -Status "Removing VLC Media Player Desktop Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

        Write-Status -Types "-" , $TweakType -Status "Removing Acrobat Desktop Icon"
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

        Write-Status -Types "-", $TweakType -Status "Removing Zoom Desktop Icon"
        Remove-Item -path $zoomsc -force -ErrorAction SilentlyContinue | Out-Null

        Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in User Folder"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
        
        Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in Public Desktop"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

        Write-Status -Types "-" , $TweakType -Status "Removing C:\Temp"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}
Function OOS10 {
    try{
    param (
        [switch] $Revert
    )
    Write-Section -Text "O&O ShutUp 10"

    $ShutUpDl = "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe"
    $ShutUpOutput = ".\bin\OOSU10.exe"
    Start-BitsTransfer -Source "$ShutUpDl" -Destination $ShutUpOutput

    If ($Revert) {
        Write-Status -Types "*" -Status "Running ShutUp10 and REVERTING to default settings..."
        Start-Process -FilePath $ShutUpOutput -ArgumentList ".\Assets\settings-revert.cfg", "/quiet" -Wait
    } Else {
        Write-Status -Types "+" -Status "Running ShutUp10 and applying Recommended settings..."
        Start-Process -FilePath $ShutUpOutput -ArgumentList ".\Assets\settings.cfg", "/quiet" -Wait
    }

    Remove-Item "$ShutUpOutput" -Force
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}
Function ADWCleaner() {
    Try{
    Write-Section -Text "ADWCleaner"
    $adwLink = "https://github.com/circlol/newload/raw/main/adwcleaner.exe"
    $adwDestination = ".\bin\adwcleaner.exe"
    If (!(Test-Path ".\bin\adwcleaner.exe")){
        Write-Status -Types "+","ADWCleaner" -Status "Downloading ADWCleaner"
        Start-BitsTransfer -Source $adwLink -Destination $adwDestination
    }

    Write-Status -Types "+","ADWCleaner" -Status "Starting ADWCleaner with ArgumentList /Scan & /Clean"
    Start-Process -FilePath $adwDestination -ArgumentList "/EULA","/PreInstalled","/Clean","/NoReboot" -Wait

    #Removes ADWCleaner from the system
    Write-Status -Types "-","ADWCleaner" -Status "Removing traces of ADWCleaner"
    Start-Process -FilePath $adwDestination -ArgumentList "/Uninstall","/NoReboot" -Wait
}
catch {
    $errorMessage = $_.Exception.Message
    $errorType = $_.Exception.GetType().FullName
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $timeOfError = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"

    $errorLogEntry = @"
Time Of Error: $timeOfError 
Command Run: Visuals
Error Message: $errorMessage
Error Type: $errorType
Line Number: $lineNumber

"@
    $global:ErrorLog += $errorLogEntry
}
}
Function CreateRestorePoint() {
    $TweakType = "Backup"
    Write-Host "`n" ; Write-TitleCounter -Counter '11' -MaxLength $MaxLength -Text "Creating Restore Point"
    Write-Status -Types "+", $TweakType -Status "Enabling system drive Restore Point..."
    Enable-ComputerRestore -Drive "$env:SystemDrive\"
    Checkpoint-Computer -Description "Mother Computers Courtesy Restore Point" -RestorePointType "MODIFY_SETTINGS"
}
Function EmailLog() {
    $EndTime = Get-Date -DisplayHint Time
    $ElapsedTime = $EndTime - $StartTime
    $CurrentDate = Get-Date
    $IP = (New-Object System.Net.WebClient).DownloadString("http://ifconfig.me/ip")
    $Mobo = (Get-CimInstance -ClassName Win32_BaseBoard).Product
    $CPU = Get-CPU
    $RAM = Get-RAM
    $GPU = Get-GPU
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    $SSD = Get-OSDriveType
    $DriveSpace = Get-DriveSpace

    Stop-Transcript
    Get-ComputerInfo | Out-File -Append $log -Encoding ascii
    [String]$SystemSpec = Get-SystemSpec
    $SystemSpec | Out-Null

    If ($CurrentWallpaper -eq $Wallpaper) { $WallpaperApplied = "YES" }Else { $WallpaperApplied = "NO" }
    $TempFile = "$Env:Temp\tempmobo.txt" ; $Mobo | Out-File $TempFile -Encoding ASCII
    (Get-Content $TempFile).replace('Product', '') | Set-Content $TempFile
    (Get-Content $TempFile).replace("  ", '') | Set-Content $TempFile
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile
    

Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "New Loads Log" -Attachments "$Log" -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -Verbose -ErrorAction SilentlyContinue -Body "
    ############################
    #   NEW LOADS SCRIPT LOG   #
    ############################

New Loads was run on a computer for $ip\$env:computername\$env:USERNAME

- Computer Information:
    - CPU: $CPU
    - Motherboard: $Mobo
    - RAM: $RAM
    - GPU: $GPU
    - SSD: $SSD
    - Drive Space: $DriveSpace free
    - OS: $WindowsVersion ($DisplayVersion)

- Script Information:
    - Program Version: $programversion
    - Script Version: $ScriptVersion
    - Start Time: $StartTime
    - End Time: $EndTime
    - Elapsed Time: $ElapsedTime

- Script Run Information:
    - Applications Installed: $appsyns
    - Chrome: $chromeyns
    - VLC: $vlcyns
    - Adobe: $adobeyns
    - Zoom: $zoomyns
    - Wallpaper Applied: $WallpaperApplied
    - Windows 11 Start Layout Applied: $StartMenuLayout
    - Packages Removed During Debloat: $PackagesRemovedCount

$PackagesRemoved
"
}
Function Request-PcRestart() {
    switch (Show-YesNoCancelDialog -YesNoCancel -Message "Would you like to reboot the system now? ") {
        'Yes' {
            Write-Host "You choose to Restart now"
            Restart-Computer
        }
        'No' {
            Write-Host "You choose to Restart later"
        }
        'Cancel' {
            # With Yes, No and Cancel, the user can press Esc to exit
            Write-Host "You choose to Restart later"
        }
    }
}

If (!($GUI)) {
    Start-Transcript -Path $Log ; $StartTime = Get-Date -DisplayHint Time
    Programs
    Visuals
    Branding
    StartMenu
    Debloat
    #OOS10
    AdwCleaner
    OfficeCheck
    #OneDriveRemoval
    CheckForMsStoreUpdates
    Optimize-Windows
    BitlockerDecryption
    CreateRestorePoint
    EmailLog
    Cleanup
    Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB "
    Request-PCRestart
}
else {
    CheckNetworkStatus
    GUI
}

### END OF SCRIPT ###

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKzRDXuVwiXsTlrXZK3FMXsFC
# weOgggMQMIIDDDCCAfSgAwIBAgIQEznIweLy56VByeu0DO3dHDANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDIyNTAx
# MTcwMFoXDTI0MDIyNTAxMzcwMFowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMOp0Oy3ZpODBBu9
# SqwzirkvXJYu8inamkKf8D40b5DlSP78UvJxbrfqWUejfqX9pUhIS5bFazZ/3OUH
# TdTGp2Wy85/VUL/3kWIRfRX6cScvGfA5zBHAJ5weTSM9umcogh1fWJmmYl0xgfOP
# dZaWBmnVDJKo/JuOTOmQ0gyIk1JJStgAT8ix5PetmQ9yoCh02UfRO4dfwhEHNS7e
# H9OavAMQStFvycJL63Lz1CqwjBwkq8mBCy1TcP3HzyqGOAulW6WocanOKZm8BoXr
# jaFWpxU16hiVtyP9arbaW91bmFIfNMACQje/9nIdYXN7Eu1gS2Werox5YJ0vntPm
# I3Tun8ECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBSneCZHJdvBbeTvpAb04yuxIcE0MTANBgkqhkiG9w0BAQsF
# AAOCAQEAk9ThUUX5Pjr6hbnR8B20RPRgCPkvNrF4EaMweA8uF5/A84AnxL63X+Bv
# O/9VRCbP08c3N0uG0tkDhCFC3kld2FI77ZCwPNNKbgu8JEvB+Iq16p6DBlWCQ8Ac
# vCLuqtUZHoQEv/+HR4VFjyV3DQdhBorGr6t+HyEEuR56W21D2W1AP+OBJ1yvArky
# pLjWoQobtg1k3Wzwo15hIis95vz4QNjvMEX2PSe67KC4yRZv8SbAYX8okwm3VbJW
# MOEOSfBqZ6aA8V5BvJNpqBWwRFuoutKwl37jPlKA7pZG5BT/iXRF3DgXBti3s2hZ
# n1K1S/S3o113XkKBDsdx1JdQEGlCcTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQEznIweLy56VByeu0DO3dHDAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQU8SKChz0L0q/R26okurZKaUyu46AwDQYJKoZIhvcNAQEBBQAEggEASm8y
# 5BIVcUT24FuIBxFrjtaVSHja67Z63SfxePowKiFpARvBOKWNS+80PbNMbJi0i9uh
# CacLRmZVtLTYCf/ItoR7dOjlNiKeJhKWBmNkiaT7wWUqE67otzspdFRTEX/UXWim
# zaJEYUfBcbrtQipfEw686w6jkWOlN+tPVzs+M0QAzWG2NldovBAkfchYYANYV5uf
# 4lQEI3cbaIq3zvl11uKumsV8Q6zWgA6PtOHBANhctFA8+P1XPJYls7Xb6UUsbCR/
# Ufaa/cCkKUHwD5eKwkHSrPfwkM+KAb55sN22iXeqDtdRMgZ2EAPPhKSLwKmdauxa
# wFBajsTzpUaSXAS98w==
# SIG # End signature block
