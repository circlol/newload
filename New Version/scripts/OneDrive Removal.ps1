Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PsScriptRoot\..\lib\"Variables.psm1"
Function OneDriveRe {
    If (Test-Path $Location5 -ErrorAction SilentlyContinue){
        If (Test-Path $Location5 -ErrorAction SilentlyContinue){
            If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue){
                Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
                Write-Status -Types "-" -Status "Removing OneDrive."
            }
            Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose

        }
        If (Get-Process -Name OneDrive -ErrorAction SilentlyContinue){
            Stop-Process -Name "OneDrive" -Verbose -ErrorAction SilentlyContinue
            Write-Status -Types "-" -Status "Removing OneDrive."
        }
        Start-Process -FilePath $Location5 -ArgumentList /uninstall -Verbose
    }
    If (Test-Path -Path $env:OneDrive){Remove-Item -Path "$env:OneDrive" -Force -Recurse}
    If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive"){Remove-Item -Path "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse}
    If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp"){Remove-Item -Path "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse}
}
OneDriveRe