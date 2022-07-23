Function ProgList {
    $Title = "New Loads - ProgList Extractor" ; $host.UI.RawUI.WindowTitle = $Title
    
        Write-Host " Generating Program List $frmt"
        If (!(Test-Path -Path "$newloads")){
            New-Item -Path "$Env:Temp" -Name:"New Loads" -ItemType:Directory -Force
        }
    
        If (Test-Path -Path "$html"){
            Remove-Item -Path $html -Force -Verbose
        }
        If (Test-Path -Path "$list"){
            Remove-Item -Path "$list" -Force -Verbose
        }
        
        If (!(Test-Path -Path "$unviewdest")){
            Write-Host " Unview not found, Downloading." >> $list
            Start-BitsTransfer -Source "$link" -Destination "$unviewdest" | Out-Host
            Start-Process "$unviewdest" -ArgumentList "/shtml $html"
            } Else {
            Write-Host " Running Uninstall View by NirSoft"
            Start-Process "$unviewdest" -ArgumentList "/shtml $html"
        }
        
        #Generating a win32 product list 
        Write-Host " Generating an alphabetical list of all win32 applications`n" >> $list
        (Get-WmiObject win32_product).Name | Sort-Object >> $list
        
        Write-Host " Adding list of installed Windows Apps to $list`n" ; Write-Output "`n`n Generating list of installed Windows Apps`n Executing Command Get-AppxPackage." >> $list
        (Get-AppxPackage -AllUsers).PackageFamilyName >> $list
        
        If (Test-Path "~\AppData\Local\Microsoft\WindowsApps\winget.exe"){
            Write-Host " Adding list of Winget Packages to $list" ; Write-Output "`n`n Generating List of Winget Packages" >> $list
            winget list -s winget --accept-source-agreements >> $list
        } else {
            Write-Host " Winget does not exist on this PC."
    }
    }
