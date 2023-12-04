$File = "https://raw.githubusercontent.com/pbatard/Fido/master/Fido.ps1"
$Dest = "$Env:Temp\Fido.ps1"

# Downloads Fido.ps1
try {
    Start-BitsTransfer -Source $File -Destination $Dest
} catch {
    Write-Host "Failed to Download FIDO.ps1 from $File"
}

# Executes Fido.ps1
try {
    Invoke-Expression $Dest
} catch {
    Write-Host "Failed to Invoke-Expression from file $Dest"
}


Write-Host "Script Completed"
Exit 0