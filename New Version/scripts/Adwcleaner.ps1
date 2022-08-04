Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

Function adw(){
    $AdwCleanerDl = "https://downloads.malwarebytes.com/file/adwcleaner"
    $adw = "adwCleaner.exe"
    Start-BitsTransfer -TransferType Download -Source $AdwCleanerDl -Destination ".\$adw"
    Write-Status -Types "+" -Status "Running MalwareBytes AdwCleaner scanner."
    Start-Process -FilePath ".\$adw" -ArgumentList "/eula", "/clean", "/noreboot" -Wait -NoNewWindow
    Remove-Item "$adw" -Force
}

adw