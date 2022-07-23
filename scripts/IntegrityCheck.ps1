Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"Templates.psm1"


$Files = @(
"bin\AcroRdrDCx642200120085_MUI.exe"
"bin\googlechromestandaloneenterprise64.msi"
"bin\vlc-3.0.17-win64.msi"
"bin\ZoomInstallerFull.msi"
"Assets\branding.png"
"Assets\diskette.png"
"Assets\Floppy.png"
"Assets\logo.png"
"Assets\microsoft.png"
"Assets\NoBranding.png"
"Assets\Toolbox.png"
"Assets\wallpapers\win10.deskthemepack"
"Assets\wallpapers\win11.deskthemepack"
"lib\Templates.psm1"
"scripts\AdvRegistry.ps1"
"scripts\AskToReboot.ps1"
"scripts\Branding.ps1"
"scripts\Cleanup.ps1"
"scripts\Debloat.ps1"
"scripts\New Loads Cleanup.ps1"
"scripts\OfficeRemoval.ps1"
"scripts\OneDrive Removal.ps1"
"scripts\ProductConfirmation.ps1"
"scripts\ProgList.ps1"
"scripts\Programs.ps1"
"scripts\Restart-Explorer.ps1"
"scripts\Set-Wallpaper.ps1"
"scripts\Start Menu.ps1"
"scripts\SystemRestore.ps1"
"scripts\UndoScript.ps1"
"scripts\Visuals.ps1"
"scripts\Wallpaper.ps1"
)

$Items = [System.Collections.ArrayList]::new()

#Function CheckFiles($urls, $dest, $items) {
ForEach ($file in $files){
    If(Test-Path ".\$File"){Write-Host "$File Validated" -ForegroundColor Green}else{
        Write-Host "$file failed to validate. Reacquiring" -ForegroundColor Red
        $Items += $file
    } 
}


$ItemsFile = ".\tmp.txt"
$Items | Out-File $ItemsFile -Encoding ASCII 
(Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile

$urls = Get-Content $ItemsFile
<#
$urls = $Items
$urls.replace('\','/')
#>
$dests = $Items

ForEach ($url in $urls){
    ForEach ($dest in $dests){
        Write-Host "Attempting to download $url" -ForegroundColor White
        $link = "https://raw.githubusercontent.com/circlol/newload/main/" + $url.replace('\','/') 
        Start-BitsTransfer -Source $link -Destination ".\$dest" -Verbose -TransferType Download -RetryTimeout 60 -RetryInterval 60
        If($?){Write-Host "Success" -ForegroundColor Green}else{Write-Host "Failure" -ForegroundColor Red}
    }
}





$urls = Get-Content $ItemsFile

ForEach ($url in $urls){
    Foreach ($dest in $dests){
    Write-Host "Attempting redownload on $url" -ForegroundColor White
    #Start-BitsTransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/$url" -Destination ".\$url" -Verbose -TransferType Download -RetryTimeout 60 -RetryInterval 60
    #Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/$url" -Destination ".\$url" -Verbose -TransferType Download -RetryTimeout 60 -RetryInterval 60
    #Invoke-WebRequest -Uri https://raw.githubusercontent.com/circlol/newload/main/$url -OutFile ".\$url" -UseBasicParsing
    If($?){Write-Host "Success" -ForegroundColor Green}else{Write-Host "Failure" -ForegroundColor Red}
    }
}



https://raw.githubusercontent.com/circlol/newload/main/Assets/NoBranding.png


Function GatherMissing() {
    ForEach ($file in $files){
        Select-String -Path ".\assets\acquire.txt" -Pattern "$file"
        $search = (Get-Content ".\assets\acquire.txt" | Select-String -Pattern $file).Matches.Success
        If($search){
            ""
        }
    }


}

#Generates a list of filenames 
$Array = (Get-ChildItem -File -Exclude "New Loads.exe","New Loads UI.exe","IntegrityCheck.ps1","10.png","11.png","11_mGaming.png","10_mGaming.png","EmailLog.ps1","Acquire.txt","GUI Buttons.ps1","GUI Code.ps1" -Recurse).Name



Function LargeCheck() {

If(!(".\assets\branding.png")){
    Write-Host " "
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/Branding.png" -Destination ".\assets\branding.png"}
If(!(".\assets\diskette.png")){
    Start-Bitstransfer -Source "{https://raw.githubusercontent.com/circlol/newload/main/Assets/Diskette.png" -Destination ".\assets\diskette.png"}
If(!(".\assets\microsoft.png")){
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/Branding.png" -Destination ".\assets\branding.png"}
If(!(".\assets\NoBranding.png")){
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/NoBranding.png" -Destination ".\assets\branding.png"}
If(!(".\assets\Toolbox.png")){
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/Toolbox.png" -Destination ".\assets\Toolbox.png"}
If(!(".\assets\wallpaper.ico")){
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/Wallpaper.ico" -Destination ".\assets\wallpaper.ico"}
If(!(".\assets\win10.deskthemepack")){
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/10.deskthemepack" -Destination ".\assets\win10.deskthemepack"}
If(!(".\assets\win11.deskthemepack")){
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/11.deskthemepack" -Destination ".\assets\win11.deskthemepack"}
If(!(".\bin\AcroRdrDCx642200120085_MUI.exe")){
    Start-Bitstransfer -Source "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2200120085/AcroRdrDCx642200120085_MUI.exe" -Destination ".\bin\AcroRdrDCx642200120085_MUI.exe"}
If(!(".\bin\googlechromestandaloneenterprise64.msi")){
    Start-Bitstransfer -Source "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Destination ".\bin\googlechromestandaloneenterprise64.msi"}
If(!(".\bin\vlc-3.0.17-win64.msi")){
    Start-Bitstransfer -Source "https://raw.githubusercontent.com/circlol/newload/main/Assets/BAF/vlc-3.0.17-win64.msi" -Destination ".\bin\vlc-3.0.17-win64.msi"}
If(!(".\bin\ZoomInstallerFull.msi")){
    Start-Bitstransfer -Source "https://zoom.us/client/5.10.4.5035/ZoomInstallerFull.msi?archType=x64" -Destination ".\bin\ZoomInstallerFull.msi"}
}


If(".\lib\Templates.psm1"){}
If(".\scripts\AdvRegistry.ps1"){}
If(".\scripts\AskToReboot.ps1"){}
If(".\scripts\Branding.ps1"){}
If(".\scripts\Cleanup.ps1"){}
If(".\scripts\Debloat.ps1"){}
If(".\scripts\New Loads Cleanup.ps1"){}
If(".\scripts\OfficeRemoval.ps1"){}
If(".\scripts\OneDrive Removal.ps1"){}
If(".\scripts\ProductConfirmation.ps1"){}
If(".\scripts\ProgList.ps1"){}
If(".\scripts\Programs.ps1"){}
If(".\scripts\Restart-Explorer.ps1"){}
If(".\scripts\Set-Wallpaper.ps1"){}
If(".\scripts\Start Menu.ps1"){}
If(".\scripts\SystemRestore.ps1"){}
If(".\scripts\UndoScript.ps1"){}
If(".\scripts\Visuals.ps1"){}
If(".\scripts\Wallpaper.ps1"){}



}