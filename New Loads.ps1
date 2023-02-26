#Requires -RunAsAdministrator
try { Set-Variable -Name ScriptVersion -Value "230224" ; If (! { $! }) { Write-Section -Text "Script Version has been updated" } ; }catch {throw}
Function Programs() {
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
Function Visuals() {
    $TweakType = "Visual" ; $WindowTitle = "New Loads - Visuals" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '3' -MaxLength $MaxLength -Text "Visuals"
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $osVersion = $os.Caption
    If ($osVersion -like "*10*") {
        # code for Windows 10
        Write-Title -Text "Detected Windows 10"
        $wallpaperPath = ".\Assets\10.jpg"
    }elseif ($osVersion -like "*11*") {
        # code for Windows 11
        Write-Title -Text "Detected Windows 11"
        $wallpaperPath = ".\Assets\11.jpg"
        $StartBinDefault = "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\"
        $StartBinCurrent = "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
        $StartBinFiles = @(
            ".\assets\start.bin"
            ".\assets\start2.bin"
        )
        Foreach ($StartBinFile in $StartBinFiles){
            xcopy $StartBinFile $StartBinDefault /y
            xcopy $StartBinFile $StartBinCurrent /y
        }
        Taskkill /f /im StartMenuExperienceHost.exe
    }else {
        # code for other operating systems
        # Check Windows version
        Throw{"Error:"}
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
Function Branding() {
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
Function StartMenu () {
    $WindowTitle = "New Loads - Start Menu"; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '5' -MaxLength $MaxLength -Text "StartMenuLayout.xml Modification"
    Write-Title -Text "Applying Taskbar Layout"
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
        $layoutFile = "$Env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml"
        If (Test-Path $layoutFile) { Remove-Item $layoutFile -Verbose | Out-Null }
        $StartLayout | Out-File $layoutFile -Encoding ASCII
        Restart-Explorer
        Start-Sleep -Seconds 4
        Remove-Item $layoutFile
}
Function Remove-UWPAppx() {
    [CmdletBinding()]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"
    # Store the original progress preference
    $originalProgressPreference = $ProgressPreference
    # Set the progress preference to 'SilentlyContinue' to suppress all other output
    $ProgressPreference = 'SilentlyContinue'

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
    # Reset the progress preference to the original value
    $ProgressPreference = $originalProgressPreference
}
Function Debloat() {
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


    $Global:Removed = 0
    $Global:Failed = 0
    $Global:NotFound = 0
    Remove-UWPAppx -AppxPackages $Programs

    #ForEach($Program in $Programs){
    #}

    Write-Host "Debloat Results:`nTotal Packages: $TotalItems `nSuccessful: " -NoNewline -ForegroundColor Gray ; Write-Host "$Removed " -ForegroundColor Green
    Write-Host "Not Found: " -NoNewline -ForegroundColor Gray ; Write-Host "$NotFound " -ForegroundColor Yellow -NoNewline
    Write-Host "Failed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Failed " -ForegroundColor Red
    Write-Host ""
    Start-Sleep -Seconds 4
}
Function BitlockerDecryption() {
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
Function CheckForMsStoreUpdates() {
    Write-Status -Types "+" -Status "Checking for updates in Microsoft Store"
    $wmiObj = Get-WmiObject -Namespace "root\cimv2\mdm\dmmap" -Class "MDM_EnterpriseModernAppManagement_AppManagement01"
    $result = $wmiObj.UpdateScanMethod()
    if ($result.ReturnValue -eq 0) {
    Write-Status -Types "+" -Status "Microsoft Store updates check successful"
    } else {
    Write-Status -Types "?" -Status "Error checking for Microsoft Store updates" -Warning
    }
}
Function Cleanup() {
    $WindowTitle = "New Loads - Cleanup"; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n" ; Write-TitleCounter -Counter '12' -MaxLength $MaxLength -Text "Cleaning Up"
    $TweakType = 'Cleanup'
    Restart-Explorer
    Write-Status -Types "+" , $TweakType -Status "Enabling F8 boot menu options"
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    Try{
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
    }Catch{}
}
Function OOS10 {
    param (
        [switch] $Revert
    )

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
Function ADWCleaner() {
    $adwLink = "https://github.com/circlol/newload/raw/main/adwcleaner.exe"
    $adwDestination = ".\bin\adwcleaner.exe"
    If (!(Test-Path ".\bin\adwcleaner.exe")){
        Write-Status -Types "+","ADWCleaner" -Status "Downloading ADWCleaner"
        Start-BitsTransfer -Source $adwLink -Destination $adwDestination
    }

    Write-Status -Types "+","ADWCleaner" -Status "Starting ADWCleaner with ArgumentList /Scan & /Clean"
    Start-Process -FilePath $adwDestination -ArgumentList "/EULA","/PreInstalled","/Clean","/NoReboot" -NoNewWindow -Wait

    #Removes ADWCleaner from the system
    Write-Status -Types "-","ADWCleaner" -Status "Removing traces of ADWCleaner"
    Start-Process -FilePath $adwDestination -ArgumentList "/Uninstall","/NoReboot" -NoNewWindow -Wait
    
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

    Stop-Transcript | Out-Null
    Get-ComputerInfo | Out-File -Append $log -Encoding ascii
    [String]$SystemSpec = Get-SystemSpec
    $SystemSpec | Out-Null

    #If (Test-Path -Path "$Location1") { $chromeyns = "X" }else { $chromeyns = "" }
    #If (Test-Path -Path "$Location2") { $vlcyns = "X" }else { $vlcyns = "" }
    #If (Test-Path -Path "$Location3") { $zoomyns = "X" }else { $zoomyns = "" }
    #If (Test-Path -Path "$Location4") { $adobeyns = "X" }else { $adobeyns = "" }
    If ($CurrentWallpaper -eq $Wallpaper) { $WallpaperApplied = "YES" }Else { $WallpaperApplied = "NO" }
    #Motherboard
    $TempFile = "$Env:Temp\tempmobo.txt" ; $Mobo | Out-File $TempFile -Encoding ASCII
    (Get-Content $TempFile).replace('Product', '') | Set-Content $TempFile
    (Get-Content $TempFile).replace("  ", '') | Set-Content $TempFile
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile

    <#
    $TempFile = "$Env:Temp\tempmobo.txt"
    $Mobo -replace 'Product','' -replace '════════════════════','' -Replace '(','' -replace ')','' -Replace '{','}' | Out-File $TempFile -Encoding ASCII
    $Mobo -replace 'Product','' -replace '  ','' | Out-File $TempFile -Encoding ASCII
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile
    #>
    

    Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "New Loads Log" -Attachments "$Log" -Priority High -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -Verbose -ErrorAction SilentlyContinue -Body "
        ############################
        #==========================#
        #=                        =#
        #=  NEW LOADS SCRIPT LOG  =#
        #=                        =#
        #==========================#
        ############################

New Loads was run on a computer for $ip\$env:computername\$env:USERNAME,


Completing in $ElapsedTime


Program Version: $programversion
Script Version: $ScriptVersion
Date: $CurrentDate
Script Info:
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUA7FK0z9M3CBh1IQ5xmO4DNGc
# uRmgggMQMIIDDDCCAfSgAwIBAgIQKjMkMYkqpItNCiCURmEWWjANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDIxMjIx
# MjA1NloXDTI0MDIxMjIxNDA1NlowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN7IxFLVKnoz9n+b
# QgCpdOt/nLnk3qOSUxBZR/cXmGqqRmNQDV+T8FL7XEjvj4iNAGR/A9F2Rs4QKcdW
# OX4t2cUYHxqeft8+2b5HiZirMGAo+sfeILERHJAo5tGTVp8HlPJlvCWXzcrkZEtx
# ib6faWMGuGYRcRHgtbW4G7cQzbQnpYReq4J+LT/wDWJSYrMhTh89u7gFU5vdXX0R
# aBkYBsid6SVNNaZRRATGWq+SU3l5E+RzLDFF+iiDJSVX7HIUB61aYV6RkmyZsY24
# pklxphf8njEeLu30U6aufZ1lu40xhPWFZo4R6O5XLzgXqEXTGEBl2Tm8JyPQEpyy
# ZAryosECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBQnPYNnFm4VyH3ban7w10sQvJ03ZTANBgkqhkiG9w0BAQsF
# AAOCAQEAsR+0Q3ix62SZGte3F8ItYz4B8sVz6PSVtES/4gIf2Rux4tNlvMnrNSqi
# rGC3ZVd8uEpJkLv2jIjTwJ/LWuf4nk2XUonA2San30l/kBf4JaDMuoQf9QsBemxN
# ftnT+5QGu/mg7jzaiiDaw/gN/ejgtE5VJyYMcvBYyiVMqnclFThAvoTSPoejk53v
# flmIVXp3B5Q/4DjsY0XqfhLg6n61kMfT4mTuDLennv6I7NAFW01jwzyMAX7Fef6T
# dT9OOY7fNN8tB5nH8/bwa1mL0pyg6Ss9I2oNM1AZFYxUBKlNwPLg7ZMGYnbsbNKa
# qe1YlgKIRI++rPnYzPbEvZMh88Eb6jGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQKjMkMYkqpItNCiCURmEWWjAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUJMVJBFMxFe86glaJGO8EytMMaOowDQYJKoZIhvcNAQEBBQAEggEApUf4
# DaXlsHAXA1osEtgS90/kOMTtPeixrBTjTA9mrQHfMdXuxQzcb7ya6SpoXQrWwf67
# xDVth1v7J/XpIbBWJoER8eo9qwN91/d5u+ZrwpFmqld1I2zBdGlC6hjCU/2peuN3
# pjJzChoRsGNPEwgm3Q61r3ovKZ0tmXlBXSjuZrBZm1FIi9OZkgeoWZGLl87Tk5bg
# 2DtAIGHbAu6vhWkpVxs+MI3WztWP59EALmTVXsXMqDXsJmstGQB6AjjncJkxYcR0
# 3k4S2gukJP3X5Oh6Ml86VKh//6mF+Bs0bqkUueg7z5Y10S3gMBt5/ew4YREiojCq
# uqeVM4y/4Rh5ZXR02g==
# SIG # End signature block
