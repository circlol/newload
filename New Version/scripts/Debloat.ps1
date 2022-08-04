Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"restart-explorer.psm1"
Import-Module -DisableNameChecking $PsScriptRoot\..\lib\"Variables.psm1"

Function Debloat {

    Write-Section -Text "Checking for Win32 Pre-Installed Bloat"
    $TweakType = "Win32"
    #McAfee Live Safe Removal
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue) {
        Write-Status -Types "-","$TweakType" -Status "Attemping Removal of McAfee Live Safe."
        Start-Process "$livesafe"
    }
    #WebAdvisor Removal
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue) {
        Write-Status -Types "-","$TweakType" -Status "Attemping Removal of McAfee WebAdvisor Uninstall."
        Start-Process "$webadvisor"
    }
    #Preinsatlled on Acer machines primarily WildTangent Games
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue) {
        Write-Status -Types "-","$TweakType" -Status "Attemping Removal WildTangent Games."
        Start-Process $WildGames 
    }

    $apps = @(
        "Amazon"
        "Booking"
        "Booking.com"
        "Forge of Empires"
        "Planet9 Link"
    )
    $TweakType = "Shortcuts"
    ForEach ($app in $apps) {
        If (Test-Path -Path "$commonapps\$app.url") {
            Write-Status -Types "-","$TweakType" -Status "Removing $app.url"
            Remove-Item -Path "$commonapps\$app.url" -Force -Verbose
        }
        else {
            Write-Status -Types "?","$TweakType" -Status "$app.url was not found." -Warning
        }
        If (Test-Path -Path "$commonapps\$app.lnk") {
            Write-Status -Types "-","$TweakType" -Status "Removing $app.lnk"
            Remove-Item -Path "$commonapps\$app.lnk" -Force -Verbose
        }
        else {
            Write-Status -Types "?","$TweakType" -Status "$app.lnk was not found." -Warning
        }
    }
    Write-Host "" ; Write-Section -Text "Removing UWP Apps"
    $TweakType = "UWP"
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
        #"Microsoft.WindowsMaps"
    )
    Foreach ($Program in $Programs) {
        If (Get-AppxPackage -Name $program) {
            Write-Status -Types "-","$TweakType" -Status "Removing $Program from this account"
            Get-AppxPackage -Name $Program | Remove-AppxPackage | Out-Host
            If ($?) { Write-CaptionSucceed -Text "$Program was successfully removed for $env:COMPUTERNAME\$env:USERNAME." }else {
                Write-Status -Types "?","$TweakType" -Status "$Program was not removed" -Warning
            }
        }
        If (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like $Program) {
            Write-Status -Types "-","$TweakType" -Status "Removing $Program from this PC"
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Program | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Host
            If ($?) { Write-CaptionSucceed -Text "$Program was successfully debloated from future accounts." }else {
                Write-Status -Types "?","$TweakType" -Status "$Program was not removed" -Warning
            }
            
        }
        else {
            Write-Status -Types "?","$TweakType" -Status "$Program was not found on this PC" -Warning
        }


    }
}
Debloat