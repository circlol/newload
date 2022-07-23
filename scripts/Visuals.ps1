Function Visuals {
    $WindowTitle = "New Loads - Applying Wallpaper" ; $host.UI.RawUI.WindowTitle = $WindowTitle
	If (!(Get-Process -Name:Explorer)){
		Start-Process Explorer -Verbose
		Write-Host " Explorer Started"
    }
    Write-Host "$frmt Applying Visuals $frmt"
    
    If (!(Test-Path -Path "$Wallpaper")){
    If ($BuildNumber -gt $Win11) {
        Write-Host " Downloading Wallpaper"
        Write-Host " I have detected that you are on Windows 11"
        Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/11.jpg" -Destination "$wallpaper" -Verbose | Out-Host
        If($? -eq $True){
            Write-Host " Successful"
        }
    } else {
        If ($BuildNumber -lt $Win11) {
            Write-Host " I have detected that you are on Windows 10"
            Write-Host " Downloading Wallpaper"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/10.jpg" -Destination "$wallpaper" -Verbose | Out-Host
            If($? -eq $True){
                Write-Host " Successful"            
            }
        }
    }
    } else {
        Write-Host " Wallpaper already exists on this system. Checking if its set."
    }
    Write-Host " Checking if wallpaper is applied"
    If (!($currentwallpaper -eq "$wallpaper")){
        Write-Host " It is not. Applying."
        Wallpaper
        #Set-WallPaper -Image "$wallpaper" -Style Stretch
    } else {
        Write-Host " Detected wallpaper is set to New Loads"
    }

    If (!($sysmode -eq 0)){
        Write-Host " Setting System Theme to Dark Mode"
        Set-ItemProperty -Path $regpersonalize -Name "SystemUsesLightTheme" -Value 0 -Verbose
    } else {
        Write-Host " New Loads detected System Mode is set to Dark Theme"
    }
    If (!($appmode -eq 0)){
        Write-Host " Setting App Theme to Dark Mode"
        Set-ItemProperty -Path $regpersonalize -Name "AppsUseLightTheme" -Value 0 -Verbose
    } else {
        Write-Host " New Loads detected App Mode is set to Dark Theme"
    }


}
