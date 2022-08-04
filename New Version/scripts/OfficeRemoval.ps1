Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"show-dialog-window.psm1"
Import-Module -DisableNameChecking $PsScriptRoot\..\lib\"Variables.psm1"
Function OfficeCheck {

    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path "$path64") { $office64 = $true }Else { $office64 = $false }
    If (Test-Path "$path86") { $Office32 = $true }Else { $office32 = $false }
    If ($office32 -eq $true) { $officecheck = $true }       
    If ($office64 -eq $true) { $officecheck = $true }    
    If ($officecheck -eq $true) { Write-Status -Types "/" -Status "Office Exists" -Warning }Else { Write-Status -Types "?" -Status "Office Doesn't Exist on This Machine" -Warning }
    If ($officecheck -eq $true) { Office_Removal_AskUser }
}
Function Office_Removal_AskUser {
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('Office exists. Would you like to remove off this PC?', 'New Loads', 'YesNo', 'Question')
    switch ($msgBoxInput) {
    
        'Yes' {
            Start-BitsTransfer -Source:https://aka.ms/SaRA_CommandLineVersionFiles -Destination:"$SaRA" | Out-Host
            Expand-Archive -Path "$SaRA" -DestinationPath "$Sexp" -Force
            Check
            Start-Process "$Env:temp\New Loads\SaRA\SaRAcmd.exe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -Officeversion All -CloseOffice" -Wait -Verbose -NoNewWindow | Out-Host
        }
    
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
    }    
    
}

OfficeCheck