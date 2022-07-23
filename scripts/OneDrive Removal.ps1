Function OneDriveRe {
    If ($perform_onedrive.checked -eq $true){
    $WindowTitle = "New Loads - Removing OneDrive" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    If (Test-Path "C:\Windows\SysWOW64\OneDriveSetup.exe" -ErrorAction SilentlyContinue){
        If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue){
            Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
            Write-Host " Found OneDrive in its dirty house, Stopping & Uninstalling."
        }
        Start-Process -FilePath:C:\Windows\SysWOW64\OneDriveSetup.exe -ArgumentList /uninstall -Verbose
    }
    If (Test-Path -Path $env:OneDrive){Remove-Item -Path "$env:OneDrive" -Force -Recurse}
    If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive"){Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse}
    If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp"){Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse}
    } Else {
        Write-Host " OneDrive removal has been disabled by technician.`n Moving on."
    }
}
