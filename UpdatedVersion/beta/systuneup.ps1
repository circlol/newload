<#BEGIN#>
<#  |  #>
<#  |  #>
<#  |  #>
<#  V  #>
Clear-Host
$WindowTitle = "SysTuneUp"
$host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.ForegroundColor = 'White'
$host.UI.RawUI.BackgroundColor = 'Black'
$ErrorActionPreference = "SilentlyContinue"
Clear-Host
# Define your logo
$MainMenuLogoText = "


     ____           _____                 _   _       
    / ___| _   _ __|_   _|   _ _ __   ___| | | |_ __  
    \___ \| | | / __|| || | | | '_ \ / _ \ | | | '_ \ 
     ___) | |_| \__ \| || |_| | | | |  __/ |_| | |_) |
    |____/ \__, |___/|_| \__,_|_| |_|\___|\___/| .__/ 
           |___/                               |_|    


             Repair and Maintenance Toolkit

"

function Show-MainMenu {
    param (
        [string]$logo,
        [array]$menuOptions
    )

    $divider = "-" * 40

    while ($true) {
        Clear-Host
        Write-Host $logo
        Write-Host $divider

        for ($i = 0; $i -lt $menuOptions.Count; $i++) {
            Write-Host "$($i + 1). $($menuOptions[$i])"
        }

        Write-Host "`n0. Exit`n"
        Write-Host $divider

        $choice = Read-Host "Enter your choice"

        switch ($choice) {
            {$_ -in 1..$menuOptions.Count} {
                Clear-Host
                $selectedOption = $menuOptions[$choice - 1]
                # Perform action based on the selected option
                Return $selectedOption
            }
            "0" {
                Write-Host "Exiting..."
                Exit
            }
            default {
                Write-Host "Invalid choice. Press any key to continue..."
                $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            }
        }
    }
}


function Show-DriveMenu {
    # Retrieve a list of available drives
    $drives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, VolumeName

    # Display available drives
    Write-Host "Available Drives:"
    $index = 1
    foreach ($drive in $drives) {
        Write-Host "$index. $($drive.DeviceID) - $($drive.VolumeName)"
        $index++
    }

    $choice = Read-Host "Select a drive by number or type 'all' for all drives"

    if ($choice -eq 'all') {
        # Run chkdsk on all drives
        foreach ($drive in $drives) {
            chkdsk $($drive.DeviceID):\ /x
        }
    } elseif ($choice -match '^\d+$') {
        $selectedDrive = $drives[[int]$choice - 1]
        # Run chkdsk on the selected drive
        chkdsk $($selectedDrive.DeviceID):\ /x
    } else {
        Write-Host "Invalid selection. Please choose a drive number or 'all'."
    }
}
# Function to perform chkdsk
Function Start-CheckDsk {
    $logo = "
     ____ _     _    ____      _    
    / ___| |__ | | _|  _ \ ___| | __
    | |   | '_ \| |/ / | | / __| |/ /
    | |___| | | |   <| |_| \__ \   < 
    \____|_| |_|_|\_\____/|___/_|\_\
"
    
    # Retrieve available drives
    $drives = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, VolumeName

    # Display available drives
    Write-Host "Available Drives:"
    $index = 1
    foreach ($drive in $drives) {
        Write-Host "$index. $($drive.DeviceID) - $($drive.VolumeName)"
        $index++
    }

    $options = @("Check a specific drive", "Check all drives")
    $selected = Show-MainMenu -logo $logo -menuOptions $options

    if ($selected -eq "Check a specific drive") {
        Show-DriveMenu
    } elseif ($selected -eq "Check all drives") {
        Show-DriveMenu -all
    }
}


# Function to perform system tune-up
function Start-SystemTuneUp {
    Write-Host "Performing system tune-up..."
    dism /online /cleanup-image /restorehealth
    sfc /scannow
    Start-Process -FilePath CleanMgr.exe -ArgumentList '/AUTOCLEAN' -Wait
}



# Function to perform DISM
function Start-DISM {
    Write-Host "Performing DISM..."
    dism /online /cleanup-image /restorehealth
}

# Function to perform SFC
function Start-SFC {
    Write-Host "Performing SFC..."
    sfc /scannow
}

# Function to perform disk cleanup
function Start-DiskCleanup {
    Write-Host "Performing disk cleanup..."
    Start-Process -FilePath CleanMgr.exe -ArgumentList '/AUTOCLEAN' -Wait #'/sagerun:1'
}

# Function to perform network troubleshooter
function Start-NetworkTroubleshooter {
    Write-Host "Performing network troubleshooter..."

}

# Function to perform Windows Update reset
function Start-WindowsUpdateReset {
    Write-Host "Performing Windows Update reset..."
    # Download the batch file using Invoke-WebRequest
    $url = "https://raw.githubusercontent.com/wureset-tools/script-wureset/main/wureset.bat"
    $outputPath = "$env:TEMP\wureset.bat"
    Invoke-WebRequest -Uri $url -OutFile $outputPath
    # Run the downloaded batch file using Start-Process
    Start-Process -FilePath $outputPath -Wait
}

# Function to perform Windows Update cleanup
function Start-WindowsUpdateCleanup {
    Write-Host "Performing Windows Update cleanup..."
}

# Function to perform Windows Update cleanup (advanced)
function Start-WindowsUpdateCleanupAdvanced {
    Write-Host "Performing Windows Update cleanup (advanced)..."
}


do {
    # Define your menu options
    #, "Windows Update Cleanup", "Windows Update Cleanup (Advanced)")
    $menuOptions = @("System Tune-Up", "DISM", "SFC", "Chkdsk", "Disk Cleanup", "Network Troubleshooter", "Windows Update Reset")
    # Call the main menu function
    $perform = Show-MainMenu -logo $MainMenuLogoText -menuOptions $menuOptions
    Start-Sleep -Milliseconds 350
    If ($perform -eq "System Tune-Up"){ Start-SystemTuneUp }
    If ($perform -eq "Chkdsk"){ Start-CheckDsk }
    If ($perform -eq "DISM"){ Start-DISM }
    If ($perform -eq "SFC"){ Start-SFC }
    If ($perform -eq "Disk Cleanup"){ Start-DiskCleanup }
    If ($perform -eq "Network Troubleshooter"){ Start-NetworkTroubleshooter }
    If ($perform -eq "Windows Update Reset"){ Start-WindowsUpdateReset }
    If ($perform -eq "Windows Update Cleanup"){ Start-WindowsUpdateCleanup }
    If ($perform -eq "Windows Update Cleanup (Advanced)"){ Start-WindowsUpdateCleanupAdvanced }

} until ( $perform -eq "0" )