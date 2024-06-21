<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2023 v5.8.221
	 Created on:   	2024-06-20 9:55 PM
	 Created by:   	circl
	 Organization: 	
	 Filename:     	BitlockerDecryptor
	===========================================================================
	.DESCRIPTION
		Decrypts bitlocker on a selected drive
#>
Clear-Host

#Region Import Required Modules
# Ensure BitLocker module is imported for cmdlets
Import-Module BitLocker -WarningAction SilentlyContinue
#endregion


#region Check for admin
If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
	Write-Warning "`n`n$('*' * 115)`n`nAdministrative privileges are required to run this script. Due to the functionality of this script it is neccessary.`n`n$('*' * 115)`n`n"
	do {
		$SelfElevate = Read-Host -Prompt "Automatically relaunch the script? (Y/N)"
		switch ($SelfElevate.ToUpper()) {
			"Y" {
				$wtExists = Get-Command wt
				If ($wtExists) { Start-Process wt -verb runas -ArgumentList "new-tab powershell -c ""irm bitlocker.newloads.ca | iex""" }
				else {
					Start-Process powershell -verb runas -ArgumentList "-command ""irm bitlocker.newloads.ca | iex"""
				}
				Stop-Process $pid
			}
			"N" { exit 1 }
			default { Write-Host "Invalid input. Please enter Y or N." }
		}
	}
	while ($true)
}
#endregion

#region Bitlocker Functions
function Decrypt-BitLocker {
	param (
		[Parameter(Mandatory = $true)]
		[string]$MountPoint
	)
	
	try {
		$Q = Read-Host -Prompt "`n`n`n$('*' * 40) `n`n How do you want to unlock the drive?`n`n1) 48 Digit Recovery Key`n`n2) Recovery Password`n`n$('*' * 40)`n`n`nWhich option would you like to select? "
		switch ($Q.ToUpper()) {
			"1" {
				Unlock-BitLocker -MountPoint $MountPoint -RecoveryPassword (Read-Host "Enter the BitLocker Recovery Key")
			}
			"2" {
				Unlock-BitLocker -MountPoint $MountPoint -Password (Read-Host "Enter the Bitlocker Password" -AsSecureString)
			}
			default {
				Write-Host "Invalid input. Please enter Y or N."
			}
		}
		Write-Output "Decrypting drive at $MountPoint..."
		Disable-BitLocker -MountPoint $MountPoint
		# loops until percentage equals 0 
		do {
			$percentage = (Get-BitLockerVolume -MountPoint $MountPoint).EncryptionPercentage
			If ($percentage -ne 0) {
				Write-Output "Encryption Percentage: $percentage %"
				Start-SleepCountdown -Seconds 15
			}
		}
		while ((Get-BitLockerVolume -MountPoint $MountPoint).EncryptionPercentage -ne 0)
		
		If ((Get-BitLockerVolume -MountPoint $MountPoint).EncryptionPercentage -eq 0) {
			Write-Output "$MountPoint is at 0% encryption."
			exit 0
		}
		
	}
	catch {
		Write-Output "Error decrypting drive: $($_.Exception.Message)"
	}
}
function Get-BitLockerDrives {
	$bitlockerDrives = Get-BitLockerVolume | Where-Object { $_.VolumeStatus -eq 'FullyEncrypted' -or $_.VolumeStatus -eq 'EncryptionInProgress' } | Select-Object -Property VolumeType, DriveLetter, MountPoint, ProtectionStatus
	if ($bitlockerDrives) {
		return $bitlockerDrives
	}
	else {
		Write-Output "No BitLocker-encrypted drives found."
	}
}
function Show-BitLockerDriveMenu {
	$bitlockerDrives = Get-BitLockerDrives
	if ($bitlockerDrives) {
		Write-Output "BitLocker Encrypted Drives:"
		$index = 1
		foreach ($drive in $bitlockerDrives) {
			Write-Output "$index. $($drive.DriveLetter) - $($drive.MountPoint)"
			$index++
		}
		
		$selection = Read-Host "Enter the number of the drive to decrypt (1-$($Index - 1))"
		If ($selection -igt 1 -and $selection -lt $($index + 1)) {
			$selectedDrive = $bitlockerDrives[$($selection - 1)]
			Decrypt-BitLocker -MountPoint $selectedDrive.MountPoint
		}
		

		}
	else {
		Write-Output "Invalid selection. Please enter a valid number."
	}
}

#endregion

function Start-SleepCountdown {
	param (
		[int]$Seconds
	)
	
	$endTime = (Get-Date).AddSeconds($Seconds)
	while ($endTime -gt (Get-Date)) {
		$remainingSeconds = $endTime.Subtract((Get-Date)).Seconds
		Write-Host -NoNewline "Sleeping: $remainingSeconds sec`r"
		Start-Sleep -Milliseconds 500 # Adjust the update frequency (in milliseconds)
	}
	Write-Host "Sleeping: 0 sec"
}


#region Main Script

# Display menu for BitLocker drives and decrypt selected drive
Show-BitLockerDriveMenu

#endregion
