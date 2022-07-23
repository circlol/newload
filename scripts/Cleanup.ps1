Function Cleanup {
    $WindowTitle = "New Loads - Cleanup" ; $host.UI.RawUI.WindowTitle = $WindowTitle ; Write-Host "$frmt Finishing Up$frmt"
    If (!(Get-Process -Name:Explorer -ErrorAction SilentlyContinue)){
        Start-Process Explorer -Verbose
        Write-Host " Explorer Started"
    }
    
    Write-Host ' Changing On AC Sleep Settings'
    powercfg -change -standby-timeout-ac "60"
    powercfg -change -monitor-timeout-ac "45"        
    Write-Host ' Changing On Battery Sleep Settings'
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"
    
    Write-Host ' Enabling F8 boot menu options'
#    bcdedit /set {bootmgr} displaybootmenu yes | Out-Null
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    
    Write-Host " Checking Windows Activation Status.." -ForegroundColor Yellow
    $was = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object PartialProductKey).LicenseStatus
    If ($was -ne 1) {Write-Warning " Windows is not activated" ; Start-Sleep -Milliseconds 125 ; Start-Process slui -ArgumentList '3'} else {Write-Host "Windows is Activated. Proceeding" -ForegroundColor Green}
    try {
        stop-transcript|out-null
        }
        catch [System.InvalidOperationException]{}
    
        
    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq "On"){
        Write-Host "ALERT: Bitlocker seems to be enabled --> " -NoNewLine -ForegroundColor Yellow ; Write-Host "STARTING THE DECRYPTION PROCESS" -ForegroundColor RED
        manage-bde -off "C:"
        Write-Host "                                     --> " -ForegroundColor Yellow -NoNewLine ; Write-Host "TASK CONTINUING IN BACKGROUND." -ForegroundColor Green
    }
    Remove-Item "$env:localappdata\temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL

    If (Test-Path $zoomsc){
        Remove-Item -path $zoomsc -force -verbose
    }
    If (Test-Path $location1){
        Start-Process Chrome
    }    
    If (Test-Path $vlcsc) { 
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $acrosc) { 
        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }

    Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL


    If (Test-Path $EdgeShortcut) { 
        #Write-Host " Removing Edge Icon"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $edgescpub) { 
        Write-Host " Removing Edge Icon in Public"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $ctemp) { 
        Write-Host " Removing temp folder in C Root"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    $WindowTitle = "New Loads"

}

$website = "https://www.mothercomputers.com"
If ((Get-ItemProperty -Path $regoeminfo).SupportURL -eq $website){
    Write-Host " Skipping" -ForegroundColor Red
} else {
Set-ItemProperty -Path $regoeminfo -Name "SupportURL" -Type String -Value $website -Verbose
    
}

$model = "Mother Computers - (250) 479-8561"
If ((Get-ItemProperty -Path $regoeminfo).Model -eq "$model"){
    Write-Host " Skipping" -ForegroundColor Red
} else {
Set-ItemProperty -Path $regoeminfo -Name "Model" -Type String -Value "$Model"
}