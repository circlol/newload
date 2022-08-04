Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"restart-explorer.psm1"
Import-Module -DisableNameChecking $PsScriptRoot\..\lib\"Variables.psm1"

Function Cleanup {
    Restart-Explorer
    
    Write-Status -Types "+" , "Modify" -Status "Changing On AC Sleep Settings"
    powercfg -change -standby-timeout-ac "60"
    powercfg -change -monitor-timeout-ac "45"        
    Write-Status -Types "+" , "Modify" -Status "Changing On Battery Sleep Settings"
    powercfg -change -standby-timeout-dc "15"
    powercfg -change -monitor-timeout-dc "10"
    
    Write-Status -Types "+" , "Modify" -Status "Enabling F8 boot menu options"
#    bcdedit /set {bootmgr} displaybootmenu yes | Out-Null
    bcdedit /set "{CURRENT}" bootmenupolicy legacy
    


    Write-Status -Types "?" , "Parse" -Status "Checking Windows Activation Status.." -Warning
    $ActiStat = (Get-CimInstance -ClassName SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object PartialProductKey).LicenseStatus
    If ($ActiStat -ne 1) {Write-CaptionFailed -Text "Windows is not activated. Launching slui" ; Start-Process slui -ArgumentList '3'}else{Write-CaptionSucceed -Text "Windows is Activated. Proceeding"}
        
    
    Write-Status -Types "-","Remove" -Status "Cleaning Temp Folder"
        
    Remove-Item "$env:localappdata\temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL

    If (Test-Path $location1){
        Write-Status -Types "+","Launching" -Status "Google Chrome"
        Start-Process Chrome
    }    
    If (Test-Path $vlcsc) { 
        Write-Status -Types "-","Remove" -Status "Removing VLC Media Player Desktop Icon"
        Remove-Item $vlcsc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $acrosc) { 
        Write-Status -Types "-" , "Remove" -Status "Removing Acrobat Desktop Icon"

        Remove-Item $acrosc -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $zoomsc){
        Write-Status -Types "-","Remove" -Status "Removing Zoom Desktop Icon"
        Remove-Item -path $zoomsc -force -verbose
    }
    Remove-Item "$env:Userprofile\AppData\Local\Temp\*.*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose -Exclude "New Loads" 2>$NULL


    If (Test-Path $EdgeShortcut) { 
        #Write-Host " Removing Edge Icon"
        Write-Status -Types "-" , "Remove" -Status "Removing Edge Desktop Shortcut"
        Remove-Item $EdgeShortcut -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $edgescpub) { 
        Write-Status -Types "-" , "Remove" -Status "Removing Edge Shortcut in Public Desktop"
        Remove-Item $edgescpub -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
    If (Test-Path $ctemp) { 
        Write-Status -Types "-" , "Remove" -Status "Removing C:\Temp"
        Remove-Item $ctemp -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }

}
Cleanup