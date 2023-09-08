#Requires -RunAsAdministrator
try { Set-Variable -Name ScriptVersion -Value "2023.r1.06" ; If (! { $! }) { Write-Section -Text "Script Version has been updated" } ; }catch {throw}
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$global:osVersion = $os.Caption

Function Programs() {
    # Set Window Title
    #Set-ScriptCategory -Category "Apps"
    #"" ; Write-TitleCounter -Counter '2' -MaxLength $MaxLength -Text "Program Installation"
    Set-ScriptStatus -TweakType "Apps" -Counter 2 -Text "Program Installation"

    Write-Section -Text "Application Installation"
    $chrome = @{
        Name = "Google Chrome"
        Location = "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
        DownloadURL = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        Installer = ".\bin\googlechromestandaloneenterprise64.msi"
        ArgumentList = "/passive"}
    $vlc = @{
        Name = "VLC Media Player"
        Location = "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
        #DownloadURL = "https://get.videolan.org/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
        DownloadURL = "https://ftp.osuosl.org/pub/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
        Installer = ".\bin\vlc-3.0.18-win64.exe"
        ArgumentList = "/S /L=1033"}
    $zoom = @{
        Name = "Zoom"
        Location = "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe"
        DownloadURL = "https://zoom.us/client/5.13.5.12053/ZoomInstallerFull.msi?archType=x64"
        Installer = ".\bin\ZoomInstallerFull.msi"
        ArgumentList = "/quiet"}
    $acrobat = @{
        Name = "Adobe Acrobat Reader"
        Location = "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
        DownloadURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe"
        Installer = ".\bin\AcroRdrDCx642200120085_MUI.exe"
        ArgumentList = "/sPB"}
    foreach ($program in $chrome, $vlc, $zoom, $acrobat) {
        Write-Section -Text $program.Name
        If (!(Test-Path -Path:$program.Location)) {
            If (!(Test-Path -Path:$program.Installer)) {
                CheckNetworkStatus
                Write-Status -Types "+", $TweakType -Status "Downloading $($program.Name)"
                Start-BitsTransfer -Source $program.DownloadURL -Destination $program.Installer -TransferType Download -Dynamic
            }
            Write-Status -Types "+", $TweakType -Status "Installing $($program.Name)"
            If ($($program.Name) -eq "Google Chrome"){
                Start-Process -FilePath $program.Installer -ArgumentList $program.ArgumentList -Wait
                Write-Status "+", $TweakType -Status "Adding UBlock Origin to Google Chrome"
                Set-ItemPropertyVerified -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Name "update_url" -value "https://clients2.google.com/service/update2/crx" -Type STRING 
            }Else {
                Start-Process -FilePath $program.Installer -ArgumentList $program.ArgumentList
            }
        If ($($Program.Name) -eq "$VLC.Name"){
            Write-Status -Types "+", $TweakType -Status "Adding support to HEVC/H.265 video codec (MUST HAVE)..."
            Add-AppPackage -Path $HVECCodec -ErrorAction SilentlyContinue
        }
        } else {
            Write-Status -Types "@", $TweakType -Status "$($program.Name) already seems to be installed on this system.. Skipping Installation"
        }
    }
}
Function Get-DisplayResolution {
    $screen = Get-WmiObject -Class Win32_VideoController | Select-Object CurrentHorizontalResolution, CurrentVerticalResolution
    $width = $screen.CurrentHorizontalResolution
    $height = $screen.CurrentVerticalResolution
    $ratio = "{0}:{1}" -f $width, $height

    $aspectRatios = @{
        '3840:2560' = '16:9 (UHD)'
        '3840:2160' = '16:9 (UHD)'
        '2560:1600' = '16:10 (WQXGA)'
        '2560:1440' = '16:9 (WQHD)'
        '2048:1152' = '16:9 (QWXGA)'
        '1920:1200' = '16:10 (WUXGA)'
        '1920:1080' = '16:9 (FHD)'
        '1680:1050' = '16:10 (WSXGA+)'
        '1600:900'  = '16:9 (HD+)'
        '1440:900'  = '16:10 (WXGA+)'
        '1366:768'  = '16:9 (WXGA)'
        '1280:800'  = '16:10 (WXGA)'
        '1280:720'  = '16:9 (HD)'
        '1024:768'  = '4:3 (XGA)'
        '2880:1800' = '8:5 (Retina)'
        '2256:1504' = '3:2'
        '2160:1440' = '3:2 (2160p)'
        '1920:1280' = '3:2 (Surface Pro 3)'
        '1440:960'  = '3:2 (Surface Laptop 3)'
        '2736:1824' = '3:2 (Surface Pro 4)'
    }

    if ($aspectRatios.ContainsKey($ratio)) {
        $aspectRatio = $aspectRatios[$ratio]
    }
    else {
        $aspectRatio = $ratio
    }

    return @{
        Resolution = "$width x $height"
        AspectRatio = $aspectRatio
    }
}
Function Branding() {
    #Set-ScriptCategory -Category "Branding"
    #Write-TitleCounter -Counter '4' -MaxLength $MaxLength -Text "Mothers Branding"
    Set-ScriptStatus -TweakType "Branding" -Counter 10 -Text "Mother Computers Branding"

    Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
    Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "Manufacturer" -Type String -Value "$store" -Verbose
    Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
    Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportPhone" -Type String -Value "$phone" -Verbose
    Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
    Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportHours" -Type String -Value "$hours" -Verbose
    Write-Status -Types "+", $TweakType -Status "Adding Store URL to Support Page"
    Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportURL" -Type String -Value "$website" -Verbose
    Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
    Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "$page" -Type String -Value "$Model" -Verbose
}
Function Visuals() {
    Set-ScriptStatus -TweakType "Visuals" -Counter 3 -Text "Visuals"
    Write-Status -Types "+", $TweakType -Status "Applying Wallpaper"
    Write-HostReminder "Wallpaper may not apply until computer is Restarted"
    New-Variable -Name "WallpaperPath" -Value ".\assets\mother.jpg" -Scope Global -Force
    Use-Command "Copy-Item -Path `"$WallpaperPath`" -Destination `"$wallpaperDestination`" -Force"
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value '2' -Type String
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaperDestination -Type String
    Set-ItemPropertyVerified -Path $PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 1 -Type DWord
    Set-ItemPropertyVerified -Path $PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1 -Type DWord
    Use-Command 'Start-Process "RUNDLL32.EXE" "user32.dll, UpdatePerUserSystemParameters"'
    #$Status = ($?)
    If ($?) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set`n" } 
    elseif (!$?) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper`n" -Warning}else { }
}
Function StartMenu () {
    #Set-ScriptCategory -Category "Start Menu"
    Set-ScriptStatus -TweakType "Start Menu" -Counter 5 -Text "Start Menu Layout"
    #Write-TitleCounter -Counter '5' -MaxLength $MaxLength -Text "StartMenuLayout.xml Modification"
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
        <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
        </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@
        Write-Status -Types "+", $TweakType -Status "Applying Taskbar Layout"
        $layoutFile = "$Env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml"
        If (Test-Path $layoutFile) { Remove-Item $layoutFile | Out-Null }
        $StartLayout | Out-File $layoutFile -Encoding ASCII
        Check
        Restart-Explorer
        Start-Sleep -Seconds 4
        Remove-Item $layoutFile
        If ($osVersion -like "*11*"){
        Write-Section -Text "Applying Start Menu Layout"
        Write-Status -Types "+", $TweakType -Status "Generating Layout File"
        $StartBinDefault = "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\"
        $StartBinCurrent = "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
        $StartBinFiles = Get-ChildItem -Path ".\assets" -Filter "*.bin" -File
        $TotalBinFiles = $StartBinFiles.Count * 2
        for ($i = 0; $i -lt $StartBinFiles.Count; $i++) {
            $StartBinFile = $StartBinFiles[$i]
            $progress = ($i * 2) + 1
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) for new users ($progress/$TotalBinFiles)"
            xcopy $StartBinFile.FullName $StartBinDefault /y
            Check
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) to current user ($($progress+1)/$TotalBinFiles)"
            xcopy $StartBinFile.FullName $StartBinCurrent /y
            Check
        }
        Taskkill /f /im StartMenuExperienceHost.exe
        }elseif ($osVersion -like "*10*"){
            Write-Status -Types "-", $TweakType -Status "Clearing Windows 10 Start Menu Pins"
            ClearStartMenuPinned
        }
}
Function ClearStartMenuPinned() {
    #Requires -RunAsAdministrator
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
    $Global:layoutFile="C:\Windows\StartMenuLayout.xml"
    If(Test-Path $layoutFile){Remove-Item $layoutFile}
    $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
    $regAliases = @("HKLM", "HKCU")
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value 1 -Type DWord
        Set-ItemPropertyVerified -Path "$keyPath" -Name "StartLayoutFile" -Value "$layoutFile" -Type ExpandString
    }
    Restart-Explorer
    Start-Sleep -Seconds 5
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -Seconds 5
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value 0 -Type DWord
    }
    Restart-Explorer
    Remove-Item $layoutFile
}
Function Find-InstalledPrograms {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Keyword
    )
    # Construct the registry path for the installed programs list
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    # Retrieve all subkeys under the installed programs registry path
    $installedPrograms = Get-ChildItem -Path $registryPath
    # Filter the installed programs by their display names and descriptions, searching for the specified keyword
    $matchingPrograms = $installedPrograms | Where-Object { 
        ($_.GetValue("DisplayName") -like "*$Keyword*") -or 
        ($_.GetValue("DisplayVersion") -like "*$Keyword*") -or 
        ($_.GetValue("Publisher") -like "*$Keyword*") -or 
        ($_.GetValue("Comments") -like "*$Keyword*") 
    }
    # Output the matching programs as a list of objects with Name, Version, and Publisher properties
    $matchingPrograms | ForEach-Object {
        [PSCustomObject]@{
            Name = $_.GetValue("DisplayName")
            Version = $_.GetValue("DisplayVersion")
            Publisher = $_.GetValue("Publisher")
        }
    }
}
Function Remove-UWPAppx() {
    [CmdletBinding()]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"
    $Global:PackagesRemoved = [System.Collections.ArrayList]::new()
    ForEach ($AppxPackage in $AppxPackages) {
        $appxPackageToRemove = Get-AppxPackage -AllUsers -Name $AppxPackage -ErrorAction SilentlyContinue
        if ($appxPackageToRemove) {
            $appxPackageToRemove | ForEach-Object {
                Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage from ALL users..."
                Remove-AppxPackage $_.PackageFullName -EA SilentlyContinue -WA SilentlyContinue >$NULL | Out-Null #4>&1 | Out-Null
                If ($?){ $Global:Removed++ ; $PackagesRemoved += $appxPackageToRemove.PackageFullName  } elseif (!($?)) { $Global:Failed++ }
            }
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
            If ($?){ $Global:Removed++ ; $PackagesRemoved += "Provisioned Appx $($appxPackageToRemove.PackageFullName)" } elseif (!($?)) { $Global:Failed++ }
        } else {
            $Global:NotFound++
        }
    }
}
Function Debloat() {
    #Set-ScriptCategory -Category "Debloat"
    #Write-TitleCounter -Counter '6' -MaxLength $MaxLength -Text "Debloat"
    Set-ScriptStatus -TweakType "Debloat" -Counter 6 -Text "Debloat"

    
    Write-Section -Text "Checking for Win32 Pre-Installed Bloat"
    Write-Caption -Text "McAfee"
    #McAfee Live Safe Removal
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee Live Safe..."
        Use-Command 'Start-Process "$livesafe"'
    }    #WebAdvisor Removal
    Write-Caption -Text "McAfee WebAdvisor"
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee WebAdvisor Uninstall."
        Use-Command 'Start-Process "$webadvisor"'
    }
    Write-Caption -Text "WildTangent Games"
    #Preinsatlled on Acer machines primarily WildTangent Games
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal WildTangent Games."
        Use-Command 'Start-Process "$WildGames"'
    }
    Write-Caption -Text "Norton x86"
    #Norton cuz LUL Norton
    $NortonPath = "C:\Program Files (x86)\NortonInstaller"
    $CheckNorton = Get-ChildItem -Path $NortonPath -Name "InstStub.exe" -Recurse -ErrorAction SilentlyContinue | Out-Null
    If ($CheckNorton) {
        New-Variable -Name "Norton" -Value "$NortonPath\$CheckNorton" -Scope Global -Force
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of Norton..."
        Use-Command 'Start-Process "$Norton" -ArgumentList "/X /ARP"'
    }
    Write-Caption -Text "Avast Cleanup"
    #Avast Cleanup Premium
    $AvastCleanupLocation = "C:\Program Files\Common Files\Avast Software\Icarus\avast-tu\icarus.exe"
    If (Test-Path $AvastCleanupLocation) {
        Use-Command 'Start-Process "$AvastCleanupLocation" -ArgumentList "/manual_update /uninstall:avast-tu"'
    }
    Write-Caption -Text "Avast AV"
    #Avast Antivirus
    $AvastLocation = "C:\Program Files\Avast Software\Avast\setup\Instup.exe"
    If (Test-Path $AvastLocation) {
        Start-Process "$AvastLocation" -ArgumentList "/control_panel"
    }
    Write-Section -Text "Checking for Start Menu Ads"
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
    ForEach ($app in $apps) {
        If (Test-Path -Path "$commonapps\$app.url") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.url"
            Use-Command 'Remove-Item -Path "$commonapps\$app.url" -Force'
        }
        If (Test-Path -Path "$commonapps\$app.lnk") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.lnk"
            Use-Command 'Remove-Item -Path "$commonapps\$app.lnk" -Force'
        }
    }
    Write-Section -Text "Checking for UWP Apps"
    $TotalItems = $Programs.Count
    $CurrentItem = 0
    $PercentComplete = 0
    ForEach($Program in $Programs){
    Write-Progress -Activity "Debloating System" -Status " $PercentComplete% Complete:" -PercentComplete $PercentComplete | Out-Host
    Remove-UWPAppx -AppxPackages $Program
    $CurrentItem++
    $PercentComplete = [int](($CurrentItem / $TotalItems) * 100)
    }
    Write-Host "Debloat Completed!`n" -Foregroundcolor Green
    Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Removed" -ForegroundColor Green
    If ($Failed){ Write-Host "Failed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Failed" -ForegroundColor Red }
    Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray ; Write-Host "$NotFound`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 4
}
Function BitlockerDecryption() {
    #Set-ScriptCategory -Category "Bitlocker"
    #Write-TitleCounter -Counter '10' -MaxLength $MaxLength -Text "Bitlocker Decryption"
    Set-ScriptStatus -TweakType "Bitlocker" -Counter 10 -Text "Bitlocker Decryption"

    If ((Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).ProtectionStatus -eq "On") {
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        Use-Command 'Disable-Bitlocker -MountPoint C:\'
    } else { Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" -Warning }
}
Function CheckForMsStoreUpdates() {
    Write-Section -Text "Updating UWP Applications"
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
    Write-Section -Text "Cleanup"
    Set-ScriptStatus -TweakType "Cleanup" -Counter 12 -Text "Cleaning Up"
    If (!(Get-Process -Name Explorer)){ Restart-Explorer }
    Write-Status -Types "+" , $TweakType -Status "Enabling F8 boot menu options"
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
    Use-Command 'Start-Process Chrome -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null'
    Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"
    Use-Command 'Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -Exclude "New Loads" -ErrorAction SilentlyContinue | Out-Null'
    Write-Status -Types "-", $TweakType -Status "Removing VLC Media Player Desktop Icon"
    Use-Command 'Remove-Item "$vlcsc" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null'
    Write-Status -Types "-" , $TweakType -Status "Removing Acrobat Desktop Icon"
    Use-Command 'Remove-Item "$acrosc" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null'
    Write-Status -Types "-", $TweakType -Status "Removing Zoom Desktop Icon"
    Use-Command 'Remove-Item "$zoomsc" -force -ErrorAction SilentlyContinue | Out-Null'
    Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in User Folder"
    Use-Command 'Remove-Item "$EdgeShortcut" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null'
    Write-Status -Types "-" , $TweakType -Status "Removing Edge Shortcut in Public Desktop"
    Use-Command 'Remove-Item "$edgescpub" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue | Out-Null'
}
Function ADWCleaner() {
    Write-Section -Text "ADWCleaner"
    $adwLink = "https://github.com/circlol/newload/raw/main/adwcleaner.exe"
    $adwDestination = ".\bin\adwcleaner.exe"
    If (!(Test-Path ".\bin\adwcleaner.exe")){
        Write-Status -Types "+","ADWCleaner" -Status "Downloading ADWCleaner"
        Start-BitsTransfer -Source "$adwLink" -Destination $adwDestination
    }
    Write-Status -Types "+","ADWCleaner" -Status "Starting ADWCleaner with ArgumentList /Scan & /Clean"
    Start-Process -FilePath "$adwDestination" -ArgumentList "/EULA","/PreInstalled","/Clean","/NoReboot" -Wait -NoNewWindow
    Write-Status -Types "-","ADWCleaner" -Status "Removing traces of ADWCleaner"
    Start-Process -FilePath "$adwDestination" -ArgumentList "/Uninstall","/NoReboot" -WindowStyle Minimized
}
Function CreateRestorePoint() {
    $TweakType = "Backup"
    Write-TitleCounter -Counter '11' -MaxLength $MaxLength -Text "Creating Restore Point"
    Write-Status -Types "+", $TweakType -Status "Enabling system drive Restore Point..."
    Use-Command 'Enable-ComputerRestore -Drive "$env:SystemDrive\"'
    Use-Command 'Checkpoint-Computer -Description "Mother Computers Courtesy Restore Point" -RestorePointType "MODIFY_SETTINGS"'
}
Function EmailLog() {
    Write-TitleCounter -Counter 12 -MaxLength $MaxLength -Text "Email Log"
    Write-Caption -Text "Ending Transcript"
    Stop-Transcript
    Write-Caption -Text "System Statistics"
    $EndTime = Get-Date -DisplayHint Time
    $ElapsedTime = $EndTime - $StartTime
    $CurrentDate = Get-Date
    #$IP = (New-Object System.Net.WebClient).DownloadString("http://ifconfig.me/ip")
    $IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
    $Mobo = (Get-CimInstance -ClassName Win32_BaseBoard).Product
    $CPU = Get-CPU
    $RAM = Get-RAM
    $GPU = Get-GPU
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    $SSD = Get-OSDriveType
    $DriveSpace = Get-DriveSpace
    Get-ComputerInfo | Out-File -Append $log -Encoding ascii
    [String]$SystemSpec = Get-SystemSpec
    $SystemSpec | Out-Null
    <#
    Here's how this script works:
    The first -replace operation removes the unwanted characters from the $logFile variable.
    The second line removes any empty lines from the $newLogFile variable. It does this by using the Where-Object cmdlet to filter out any lines that don't contain non-whitespace characters (\S), and then joins the remaining lines back together using the line break character ("n"`).
    Write-Caption -Text "Cleaning $Log"
    # Read the contents of the log file into a variable
    $logFile = Get-Content $Log
    # Define a regular expression pattern to match the unwanted characters
    $pattern = "[\[\]><\+@]"
    # Replace the unwanted characters with nothing
    $newLogFile = $logFile -replace $pattern
    # Remove empty lines
    $newLogFile = ($newLogFile | Where-Object { $_ -match '\S' }) -join "`n"
    # Overwrite the log file with the new contents
    Set-Content -Path $Log -Value $newLogFile
    #>

<#  
Here's how this script works:
The first -replace operation removes the unwanted characters from the $logFile variable.
The second line removes any empty lines from the $newLogFile variable. It does this by using the Where-Object cmdlet to filter out any lines that don't contain non-whitespace characters (\S), and then joins the remaining lines back together using the line break character ("n"`).
#>
    Write-Caption -Text "Cleaning $Log"
    # Read the contents of the log file into a variable
    $logFile = Get-Content $Log
    # Define a regular expression pattern to match the unwanted characters
    $pattern = "[\[\]><\+@),|=]"
    # Replace the unwanted characters with nothing
    $newLogFile = $logFile -replace $pattern
    # Remove empty lines
    $newLogFile = ($newLogFile | Where-Object { $_ -match '\S' }) -join "`n"
    # Overwrite the log file with the new contents
    Set-Content -Path $Log -Value $newLogFile

    Write-Caption -Text "Generating New Loads Summary"
    If ($CurrentWallpaper -eq $Wallpaper) { $WallpaperApplied = "YES" }Else { $WallpaperApplied = "NO" }
    $TempFile = "$Env:Temp\tempmobo.txt" ; $Mobo | Out-File $TempFile -Encoding ASCII
    (Get-Content $TempFile).replace('Product', '') | Set-Content $TempFile
    (Get-Content $TempFile).replace("  ", '') | Set-Content $TempFile
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile

    $CheckChrome = Find-InstalledPrograms -Keyword "Google Chrome"
    If (!$CheckChrome){ $ChromeYN = "NO" } Else { $ChromeYN = "YES" }
    $CheckVLC = Find-InstalledPrograms -Keyword "VLC"
    If (!$CheckVLC){ $VLCYN = "NO" } Else { $VLCYN = "YES" }
    $CheckZoom = Find-InstalledPrograms -Keyword "Zoom"
    If (!$CheckZoom){ $ZoomYN = "NO" } Else { $ZoomYN = "YES" }
    $CheckAcrobat = Test-Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
    If (!$CheckAcrobat){ $AdobeYN = "NO"} Else { $AdobeYN = "YES"}

    $LogFiles = @()
    if (Test-Path -Path ".\Log.txt") {
    $LogFiles += ".\Log.txt"
    }
    if (Test-Path -Path ".\ErrorLog.txt") {
    $LogFiles += ".\ErrorLog.txt"
    }

    # Converts the array into a neat string 
    $packagesRemovedString = $packagesRemoved -join "`n - "

    Write-Caption -Text "Sending log + hardware info home"
Send-MailMessage -From 'New Loads Log <newloadslogs@shaw.ca>' -To '<newloadslogs@shaw.ca> , <newloads@shaw.ca>' -Subject "New Loads Log" -Attachments $LogFiles -DeliveryNotification OnSuccess, OnFailure -SmtpServer 'smtp.shaw.ca' -ErrorAction SilentlyContinue -Body "
    ############################
    #   NEW LOADS SCRIPT LOG   #
    ############################

New Loads was run on a computer for $ip\$env:computername\$env:USERNAME

On this computer for $Env:Username, New Loads completed in $elapsedtime. This system is equipped with a $cpu, $ram, $gpu

- Script Information:
    - Date: $CurrentDate
    - Elapsed Time: $ElapsedTime
    - Start Time: $StartTime
    - End Time: $EndTime
    - Program Version: $ProgramVersion
    - Script Version: $ScriptVersion

- Computer Information:
    - CPU: $CPU
    - Motherboard: $Mobo
    - RAM: $RAM
    - GPU: $GPU
    - SSD: $SSD
    - Drive Space: $DriveSpace free
    - OS: $WindowsVersion ($DisplayVersion)

- Script Run Information:
    - Applications Installed: $appsyns
    - Chrome: $ChromeYN
    - VLC: $VLCYN
    - Adobe: $AdobeYN
    - Zoom: $ZoomYN
    - Wallpaper Applied: $WallpaperApplied
    - Windows 11 Start Layout Applied: $StartMenuLayout
    - Packages Removed During Debloat: $Removed
    $PackagesRemovedstring
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
AdwCleaner
OfficeCheck
Optimize-GeneralTweaks
#CheckForMsStoreUpdates - Disabled Temporarily
Optimize-Performance
Optimize-Privacy
Optimize-Security
Optimize-Services
Optimize-TaskScheduler
Optimize-WindowsOptionalFeatures
BitlockerDecryption
CreateRestorePoint
EmailLog
Cleanup
Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB "
Request-PCRestart
}
else {
Clear-Host
Write-Host "GUI is currently disabled, try running without -GUI"
EXIT
#
#CheckNetworkStatus
#GUI
}


