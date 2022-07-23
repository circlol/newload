Function Debloat {
    If ($perform_debloat.checked -eq $true){
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
        #"Microsoft.WindowsMaps"
        )
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
}
