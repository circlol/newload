Function SystemRestore {
    $desc = "Mother Computers Courtesy Restore Point"
    If ((Get-ComputerRestorePoint).Description -eq $desc){
        Write-Host " $desc found. Skipping." -ForegroundColor Red
        } else {
        Write-Host " Enabling System Restore"
        Enable-ComputerRestore -Drive "C:\"
        
        Write-Host " `n Creating Courtesy Restore Point"
        Checkpoint-Computer -Description "$desc" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        }
}