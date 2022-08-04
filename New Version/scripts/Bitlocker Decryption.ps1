Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

Function main() { 
    If ((Get-BitLockerVolume -MountPoint "C:").ProtectionStatus -eq "On"){
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        manage-bde -off "C:"
    }else{
        Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" -Warning
    }
}

Main