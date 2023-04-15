$Global:BackgroundColor = "Black"
$Global:ForegroundColor = "DarkCyan"

function Use-Command {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    
    try {
        Invoke-Expression $Command
    }
catch {
    $errorMessage = $_.Exception.Message
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $command = $_.InvocationInfo.Line
    $errorType = $_.CategoryInfo.Reason
    $ErrorLog = ".\ErrorLog.txt"

$errorString = @"
-
Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Command run was: $command
Reason for error was: $errorType
Offending line number: $lineNumber
Error Message: $errorMessage
-

"@
    Add-Content $ErrorLog $errorString
    Write-Output $_
    continue
    }
}
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
#        "assets\10.jpg",
#        "assets\10_mGaming.png",
#        "assets\11.png",
#        "assets\11_mGaming.png",
$Files = @(        
    "assets\Mother_Computers.png"
    "assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx",
    "assets\start.bin",
    "assets\start2.bin",
    "bin\vlc-3.0.18-win64.exe"
    "bin\googlechromestandaloneenterprise64.msi"
    "bin\ZoomInstallerFull.msi"
    "lib\Set-ItemPropertyVerified.psm1",
    "lib\Set-Scheduled-Task-State.psm1",
    "lib\Set-ServiceStartup.psm1",
    "lib\Set-Windows-Feature-State.psm1",
    "lib\Optimize-GeneralTweaks.psm1",
    "lib\Optimize-Performance.psm1",
    "lib\Optimize-Privacy.psm1",
    "lib\Optimize-Security.psm1",
    "lib\Optimize-Services.psm1",
    "lib\Optimize-TaskScheduler.psm1",
    "lib\Optimize-WindowsOptionalFeatures.psm1",
    "lib\Remove-Office.psm1"
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
        Get-ChildItem ".\*.psm1" -Recurse -Exclude "assets.psm1" | ForEach-Object {
            Write-Status -Types "+","Modules" -Status "Attempting to Import Module: $($_.Name)"
            Import-Module $_.FullName
            Check
        }
    }
    <#
    ForEach ($url in $URLs){
        If (Test-Path ".\$url" -Include "*.psm1" -ErrorAction SilentlyContinue) {
            Write-Status -Types "+","Modules" -Status "Attempting to Import Module: $url"
            Import-Module -DisableNameChecking ".\$url"
            Check
        }
    }
    #>
Function Set-ScriptCategory() {
    param(
        [String]$Category
    )
    If (!$TweakType){
        New-Variable -Name "TweakType" -Value "$Category" -Scope Global
    } else{
        Set-Variable -Name 'TweakType' -Value $Category -Scope Global
    }
    $WindowTitle = "New Loads - $Category"
    $host.UI.RawUI.WindowTitle = $WindowTitle
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
    #New-Variable -Name "HVECCodec" -Value ".\assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx" -Scope Global    
    New-Variable -Name "HVECCodec" -Value  "Assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx" -Scope Global -Force
    New-Variable -Name "Programs" -Value @(
        # Microsoft Applications
        "Microsoft.549981C3F5F10"                   # Cortana
        "Microsoft.3DBuilder"                       # 3D Builder
        "Microsoft.Appconnector"                    # App Connector
        "Microsoft.BingFinance"                     # Finance
        "Microsoft.BingFoodAndDrink"                # Food And Drink
        "Microsoft.BingHealthAndFitness"            # Health And Fitness
        "Microsoft.BingNews"                        # News
        "Microsoft.BingSports"                      # Sports
        "Microsoft.BingTranslator"                  # Translator
        "Microsoft.BingTravel"                      # Travel
        "Microsoft.BingWeather"                     # Weather
        "Microsoft.CommsPhone"                      # Your Phone
        "Microsoft.ConnectivityStore"               # Connectivity Store
        "Microsoft.Messaging"                       # Messaging
        "Microsoft.Microsoft3DViewer"               # 3D Viewer
        "Microsoft.MicrosoftOfficeHub"              # Office
        "Microsoft.MicrosoftPowerBIForWindows"      # Power Automate
        "Microsoft.MicrosoftSolitaireCollection"    # MS Solitaire
        "Microsoft.MinecraftEducationEdition"       # Minecraft Education Edition for Windows 10
        "Microsoft.MinecraftUWP"                    # Minecraft
        "Microsoft.MixedReality.Portal"             # Mixed Reality Portal
        "Microsoft.Office.Hub"                      # Office Hub
        "Microsoft.Office.Lens"                     # Office Lens
        "Microsoft.Office.OneNote"                  # Office One Note
        "Microsoft.Office.Sway"                     # Office Sway
        "Microsoft.OneConnect"                      # OneConnect
        "Microsoft.People"                          # People
        "Microsoft.SkypeApp"                        # Skype (Who still uses Skype? Use Discord)
        "MicrosoftTeams"                            # Teams / Preview
        "Microsoft.Todos"                           # To Do
        "Microsoft.Wallet"                          # Wallet
        "Microsoft.Whiteboard"                      # Microsoft Whiteboard
        "Microsoft.WindowsPhone"                    # Your Phone Alternate
        "Microsoft.WindowsReadingList"              # Reading List
        #"Microsoft.WindowsSoundRecorder"            # Sound Recorder
        "Microsoft.ZuneMusic"                       # Groove Music / (New) Windows Media Player
        "Microsoft.ZuneVideo"                       # Movies & TV
        # 3rd party Apps
        "*AdobePhotoshopExpress*"                   # Adobe Photoshop Express
        "AdobeSystemsIncorporated.AdobeLightroom"   # Adobe Lightroom
        "AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    # Adobe Creative Cloud Express
        "AdobeSystemsIncorporated.AdobeExpress"    # Adobe Creative Cloud Express
        "*Amazon.com.Amazon*"                       # Amazon
        "AmazonVideo.PrimeVideo"                    # Amazon Prime Video
        "57540AMZNMobileLLC.AmazonAlexa"            # Amazon Alexa
        "*BubbleWitch3Saga*"                        # Bubble Witch 3 Saga
        "*CandyCrush*"                              # Candy Crush
        "Clipchamp.Clipchamp"                       # Clip Champ
        "*DisneyMagicKingdoms*"                     # Disney Magic Kingdom
        "Disney.37853FC22B2CE"                      # Disney Plus
        "*Disney*"                                  # Disney Plus
        "*Dolby*"                                   # Dolby Products (Like Atmos)
        "*DropboxOEM*"                              # Dropbox
        "Evernote.Evernote"                         # Evernote
        "*ExpressVPN*"                              # ExpressVPN
        "*Facebook*"                                # Facebook
        "*Flipboard*"                               # Flipboard
        "*Hulu*"                                    # Hulu
        "*Instagram*"                               # Instagram
        "*McAfee*"                                  # McAfee
        "5A894077.McAfeeSecurity"                   # McAfee Security
        "4DF9E0F8.Netflix"                          # Netflix
        "*PicsArt-PhotoStudio*"                     # PhotoStudio
        "*Pinterest*"                               # Pinterest
        "142F4566A.147190D3DE79"                    # Pinterest
        "1424566A.147190DF3DE79"                    # Pinterest
        "SpotifyAB.SpotifyMusic"                    # Spotify
        "*Twitter*"                                 # Twitter
        "*TikTok*"                                  # TikTok
        "5319275A.WhatsAppDesktop"                  # WhatsApp
        # Acer OEM Bloat
        "AcerIncorporated.AcerRegistration"         # Acer Registration
        "AcerIncorporated.QuickAccess"              # Acer Quick Access
        "AcerIncorporated.UserExperienceImprovementProgram"              # Acer User Experience Improvement Program
        #"AcerIncorporated.AcerCareCenterS"         # Acer Care Center
        "AcerIncorporated.AcerCollectionS"          # Acer Collections 
        # HP Bloat
        "AD2F1837.HPPrivacySettings"                # HP Privacy Settings
        "AD2F1837.HPInc.EnergyStar"                 # Energy Star
        "AD2F1837.HPAudioCenter"                    # HP Audio Center
        # Common HP & Acer Bloat
        "CyberLinkCorp.ac.PowerDirectorforacerDesktop"          # CyberLink Power Director for Acer
        "CorelCorporation.PaintShopPro"                         # Coral Paint Shop Pro
        "26720RandomSaladGamesLLC.HeartsDeluxe"                 # Hearts Deluxe
        "26720RandomSaladGamesLLC.SimpleSolitaire"              # Simple Solitaire
        "26720RandomSaladGamesLLC.SimpleMahjong"                # Simple Mahjong
        "26720RandomSaladGamesLLC.Spades"                       # Spades
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
    New-Variable -Name "WallpaperDestination" -Value "$Env:Appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Scope Global -Force
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
Variables
<#
Write-Break ; Write-Caption -Text "This is a Test Message" ; Write-CaptionFailed -Text "This is a Test Message" ; Write-CaptionSucceed -Text "This is a Test Message" ; Write-CaptionWarning -Text "This is a Test Message" ; Write-Section -Text "This is a Test Message" ; Write-Status -Types "+" , "Test" -Status "This is a Test Message" ; Write-Title -Text "This is a Test Message" ; Write-TitleCounter -Counter "4" -MaxLength "15" -Text "This is a Test Message"
#>

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/pioNkjxr5cW9SGJpr0GNo/M
# uHigggMQMIIDDDCCAfSgAwIBAgIQGopRfa9vUaBNYHxjP9CRADANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDQxMzAx
# MzgyOVoXDTI0MDQxMzAxNTgyOVowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMeESaCCI/aIc/XE
# UOPfQdPyPZudTPoqikHcv7qQyiSa1dwOldn+UlP72iCb1SdNOrQ1pS9PW9fVpaOG
# hhQU48deC9WgUykyg+Z5mUt23bb+ni8bb48cvP2DdOGtmCRQYm5ok/8aEMsi35/t
# cXl7Odmiro8xd+SBgXf7bg8qgxyOqNSqO0kbOAroYlOLMQ5UDmmw6wv2YuPQhddv
# Uzg+pI+J0c+/mJEFdhGORuTnOLABgOZHRD7DDGNV5f91pglS9qHkNiXm857PHq4s
# l4DKUmfAdlDhTFcHOv6eSI1o1IUtjeLGD8d6lG5Hp3qwfZ/j14FoSodmsKfUdOqY
# HBCYWxECAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBTb52Tr21VDXgO3IsUAvCDBP16w7DANBgkqhkiG9w0BAQsF
# AAOCAQEAXsHUgL7wW600L+6M+AZHyHwsKhoCaVztMHMPsx/H/4rF8EuQYyTS5/s2
# Ov8a4DlRLjYlsJ6VqrLjqLyTf84U9EV8IVB7N94F3u9A0O647y0PTmZ4wMqPtW6P
# mZGLQ0G6r7digzaHb/IaiUhj30MnWY7ZZwZlwlMlOGdR/2yiyv4vmNNa/3xQXipR
# LdjshlF8Jjj399OxppKOgKDaTv4ebzIZlUv2qdQYsiQkg6f9w2vFdPAdAddW5573
# dWc4o1HPgGiuwMJuulS9cP0W5iXMwQGgIM8v6FkpcHSLoLgSJ3ngsVNn4BCEyFU9
# NQq7c3E4f66ssnXlSSwTCT7RQEZJSzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQGopRfa9vUaBNYHxjP9CRADAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQU55Qs9ZRcdsBPskVVD6TPbHpL1B8wDQYJKoZIhvcNAQEBBQAEggEAfOgA
# Otavk5I2PUGnR57Zo15PabkCNlhX3EAoeei6XMokFMmqDptDFKs5XS9381bf8LjT
# +3OXrx/83Nuld8ekEI1a2XUoNS5+0zSruqzE7yubGP0XVNyYUm2qcqUQ2I45oA0G
# umpF/oofRKXXn1B2nxggxMNqCI8TmH+99NNggdU2ZpEF858KJlFTO52//z2pmqIo
# bZaTOBoy2+sfbUfUEKof4+qP9Pk7d93VK6nmTnS2uywcJr4UjHsm2VA4FjLWZLfg
# n7zNyNgyx0KnLTiXTJQCGz1bn/mD/RpsPequSnbhwbCL6T+VCiiYBbUrjPmRw2wd
# BwleTG5hC/0PmG6ONQ==
# SIG # End signature block
