$Global:OfficeLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Function OfficeCheck() {
    Write-Host "`n" ; Write-TitleCounter -Counter '7' -MaxLength $MaxLength -Text "Office Removal"
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path "$PathToOffice64") { $office64 = $true }Else { $office64 = $false }
    If (Test-Path "$PathToOffice86") { $Office32 = $true }Else { $office32 = $false }
    If ($office32 -eq $true) { $officecheck = $true }       
    If ($office64 -eq $true) { $officecheck = $true }    
    If ($officecheck -eq $true) { Write-Status -Types "WAITING" -Status "Office Exists" -Warning }Else { Write-Status -Types "?" -Status "Office Doesn't Exist on This Machine" -Warning }
    If ($officecheck -eq $true) { Office_Removal_AskUser }
}
Function Office_Removal_AskUser() {
    $TweakType = "Office"
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('  OFFICE EXISTS ON THIS PC:  SHALL I REMOVE IT?', 'New Loads', 'YesNoCancel', 'Question')
    switch ($msgBoxInput) {
    
        'Yes' {
            CheckNetworkStatus
            Write-Status "+", $TweakType -Status "Downloading Microsoft Support and Recovery Assistant (SaRA)"
            Start-BitsTransfer -Source:https://aka.ms/SaRA_CommandLineVersionFiles -Destination:"$SaRA" | Out-Host
            Expand-Archive -Path "$SaRA" -DestinationPath "$Sexp" -Force
            Check
            Start-Process ".\SaRA\SaRAcmd.exe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All" -NoNewWindow | Out-Host
        }
    
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
        'Cancel'{
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
    }    
    
}

