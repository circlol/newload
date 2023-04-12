Function OfficeCheck() {
    Write-Host "`n" ; Write-TitleCounter -Counter '7' -MaxLength $MaxLength -Text "Office Removal"
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path "$PathToOffice64") { $office64 = $true }Else { $office64 = $false }
    If (Test-Path "$PathToOffice86") { $Office32 = $true }Else { $office32 = $false }
    If ($office32 -eq $true) { $officecheck = $true }
    If ($office64 -eq $true) { $officecheck = $true }
    If ($officecheck -eq $true) { Write-Status -Types "WAITING" -Status "Office Exists" -Warning }Else { Write-Status -Types "?" -Status "Office Doesn't Exist on This Machine" -Warning }
    If ($officecheck -eq $true) { Remove-Office }
}
Function Remove-Office() {
    $TweakType = "Office"
    <# Old Link
    $SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_0_9246_0.zip" 
    #>
    $SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_0_9941_9.zip"
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('  Microsoft Office was found on this system: REMOVE IT?', 'New Loads', 'YesNo', 'Question')
    switch ($msgBoxInput) {
        'Yes' {
            Write-Status "+", $TweakType -Status "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
            CheckNetworkStatus
            Start-BitsTransfer -Source:$SaRAURL -Destination:$SaRA -TransferType Download -Dynamic | Out-Host
            Expand-Archive -Path $SaRA -DestinationPath $Sexp -Force
            Check
            $SaRAcmdexe = (Get-ChildItem ".\SaRA\" -Include SaRAcmd.exe -Recurse).FullName
            Write-Status "+", $TweakType -Status "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)... "
            Start-Process "$SaRAcmdexe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All"
        }
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
    }
}