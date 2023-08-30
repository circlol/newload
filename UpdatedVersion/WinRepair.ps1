
Write-Output "Starting System File Checker"
try { sfc -scannow | out-host }catch { Write-Output "SFC Error: $($_)" }
Write-Output "Starting Deployment Image Servicing and Management"
try { dism /online /cleanup-image /restorehealth | out-host }catch { Write-Output "DISM Error: $($_)"}
Function Chec {
    $SystemRestoreYN = Read-Host -Prompt "Do you want to run System Restore? (Y/N) "
    switch ($SystemRestoreYN.ToUpper()){
        "Y"{ Write-Output "Starting System Restore" ; start-process rstrui }
        "N"{ Write-Output "Skipping" }
        default{ Chec }
    }
}
Chec

Read-Host -Prompt "Press any key to Exit"
Exit