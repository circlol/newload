Function Restart-Explorer (){
    $exp = "explorer.exe"
    $Run = Get-Process -Name Explorer -EA SilentlyContinue -WarningAction SilentlyContinue
    If (!($Run)){Explorer}else{
        taskkill /f /im $exp
        Start-Sleep -Milliseconds 1500
        Explorer
    }
}
