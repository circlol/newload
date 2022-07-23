Function OfficeCheck {
    Write-Host "`n`n Checking for Office "
    If (Test-Path "$path64")    {    $office64 = $true}             Else {    $office64 = $false}
    If (Test-Path "$path86")    {    $Office32 = $true}             Else {    $office32 = $false}
    If ($office32 -eq $true)    {    $officecheck = $true}       
    If ($office64 -eq $true)    {    $officecheck = $true}    
    If ($officecheck -eq $true) {    Write-Host " Office Exists"}   Else {    Write-Host " Office does not exist"}
    If ($officecheck -eq $true) {    Office_Removal_AskUser}
}
Function Office_Removal_AskUser{
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('Office Detected on this computer, Would you like to remove it?','New Loads','YesNo','Question')

    switch  ($msgBoxInput) {
    
        'Yes' {
            Start-BitsTransfer -Source:https://aka.ms/SaRA_CommandLineVersionFiles -Destination:"$SaRA" | Out-Host
            Expand-Archive -Path "$SaRA" -DestinationPath "$Sexp" -Force -Verbose 
            Check
            Write-Warning " This program will nuke all version of Office 2013 and up off of this computer."
            Start-Process "$Env:temp\New Loads\SaRA\SaRAcmd.exe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -Officeversion All -CloseOffice" -Wait -Verbose -NoNewWindow | Out-Host
            }
    
        'No' {
            Write-Host " Leaving Office Alone"
        }
    
    }
    
}