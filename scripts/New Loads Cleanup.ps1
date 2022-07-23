Function NewLoadsCleanup {
    If (!(Test-Path $Newloads)){
        Write-Host " New Loads temp folder does not exist.`n Skipping"
    }
    Write-Warning " Cleaning up temporary files used by New Loads."
    Remove-Item "$newloads\*.*" -Recurse -Force -Verbose 

    If (Test-Path "C:\ProgList.html"){
        Remove-Item C:\ProgList.html -Force -Confirm:$false -ErrorAction SilentlyContinue -Verbose 2>$NULL
    }
}
