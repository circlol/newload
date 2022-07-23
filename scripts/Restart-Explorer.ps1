Function restartExplorer {
    $app = 'Explorer'
    If (!(Get-Process -Name $app -ErrorAction SilentlyContinue)){
        Write-Host " $app is not running. Starting."
        Start-Process $app -Verbose
    } else {
        Write-Host " Restarting $app"
        taskkill /f /im "$app.exe"
        Start-Sleep -Seconds 2000
        Start-Process $app -Verbose
    }

}