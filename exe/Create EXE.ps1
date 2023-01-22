#$iconfile = "E:\CONSOLIDATED DATA\Pictures\.ico\Blackvariant-Button-Ui-System-Apps-Finder-1.ico"
#$iconfile = "C:\Users\owner\Downloads\Blackvariant-Button-Ui-System-Apps-Finder-1.ico"
#$iconfile = "E:\CONSOLIDATED DATA\Pictures\.ico\Blackvariant-Button-Ui-System-Apps-Finder-1.ico"
#$IconFile = "E:\CONSOLIDATED DATA\Pictures\.ico\Blackvariant-Button-Ui-System-Apps-Finder-1-1-gigapixel-standard-scale-2_00x.ico"
#$IconFile = "C:\Users\Circlol\Downloads\curved-monitor_result.ico"
$IconFile = "C:\Users\Circlol\Downloads\curved-monitor_result.ico"
#$Source = ".\Program.ps1"
$Source = ".\New Loads.ps1"
$Output = "..\Current\newloads.exe"
$Title = "New Loads"
$Description = "Automated Windows Setup and Debloat Script"
$Version = "23.0113"
$Company = "Mother Computers"
$Copyright = "Mike Ivison"
#ps2exe -inputFile $Source -outputFile $Output -iconFile $iconfile #-requireAdmin -x64 -Mta



Write-host "Creating New Loads.exe"
Invoke-PS2EXE -inputFile $Source -outputFile $Output -x64 -STA -iconFile $iconfile -title $title -description $Description -version $Version -copyright $Copyright -supportOS -Company $Company
Write-Host "Finished. Opening Explorer"
Explorer ..\Current\
Start-Sleep -Seconds 3