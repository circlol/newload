Function CheckFiles() {
    Try{
        If (Test-Path ".\tmp.txt") { Write-Status -Types "-" -Status "Removing a previously runs tmp.txt." ; Remove-Item ".\tmp.txt" -Force}
        If (!(Test-Path ".\bin")) { Write-Status -Types "+" -Status "Creating Bin Folder." ; mkdir ".\bin" }
        If (!(Test-Path ".\assets")) { Write-Status -Types "+" -Status "Creating Assets Folder." ; mkdir ".\assets" }
        If (!(Test-Path ".\lib")) { Write-Status -Types "+" -Status "Creating Lib Folder." ; mkdir ".\lib" }
        If (Test-Path .\ErrorLog.txt) { Write-Status -Types "-" -Status "Removing a previous runs ErrorLog.txt." ; Remove-Item -Path ".\ErrorLog.txt"}
        "$(Get-Date) - New Loads Error Log:" | Out-File ".\newloads-errorlog.txt"
        #ForEach ($CurrentLibFile in $CurrentLibFiles){Remove-Item -Path .\lib\"$CurrentLibFile" -Force}
    }Catch{}
    
    Write-Section -Text "Scanning Exisitng Files"
    $Files = @(
        "lib\get-hardware-info.psm1"
        "lib\gui.psm1"
        "lib\office.psm1"
        "lib\optimizeWindows.psm1"
        "lib\remove-uwp-appx.psm1"
        "lib\restart-explorer.psm1"
        "lib\set-scheduled-task-state.psm1"
        "lib\set-service-startup.psm1"
        "lib\set-windows-feature-state.psm1"
        "lib\Templates.psm1"
        "lib\Variables.psm1"
        "Assets\10.jpg"
        "Assets\10_mGaming.png"
        "Assets\11.jpg"
        "Assets\11_mGaming.png"
        "Assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx"
        "Assets\start.bin"
        "Assets\start2.bin"
    )
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) {
        If (Test-Path ".\$File") {
            Write-CaptionSucceed -Text "$File Validated"
        }
        else {
            Write-CaptionFailed -Text "$file Failed to validate."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }
    else {

        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        CheckNetworkStatus
        Write-Section -Text "Downloading Missing Files"
        Try {
            ForEach ($url in $urls) {
                Write-Caption "Attempting to Download $url"
                $link = $NewLoadsURLMain + $url.replace('\', '/')
                Start-BitsTransfer -Source "$link" -Destination ".\$url" -TransferType Download -Confirm:$False | Out-Host
                Check ; ""
            }
        }
        Catch { Continue }
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile
    }
}

