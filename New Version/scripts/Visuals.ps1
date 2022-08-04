Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"restart-explorer.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"get-hardware-info.psm1"
Import-Module -DisableNameChecking $PsScriptRoot\..\lib\"Variables.psm1"
Function Wallpaper {
    Taskkill /f /im explorer.exe
    $code = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 

public class Wallpaper{ 
    [DllImport("user32.dll", CharSet=CharSet.Auto)] 
    static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
    
    public static void SetWallpaper(string thePath){ 
        SystemParametersInfo(20,0,thePath,3); 
    }
}
} 
'@

    add-type $code 
    [Win32.Wallpaper]::SetWallpaper($Wallpaper)
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value '2' -Force
}
Function Visuals() {

    If (!(Test-Path -Path "$Wallpaper")) {
        If ($BuildNumber -ge $Win11) {
            #Write-Section -Text "You are on Windows 11."
            Write-Status -Types "+" -Status "Downloading Wallpaper for Windows 11"
            Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/11.jpg" -Destination "$wallpaper" -Verbose | Out-Host
            Check
        }
        else {
            If ($BuildNumber -lt $Win11) {
                Write-Status -Types "+" -Status "Downloading Wallpaper for Windows 11"
                Start-BitsTransfer -Source "https://github.com/circlol/newload/raw/main/Assets/wallpaper/10.jpg" -Destination "$wallpaper" -Verbose | Out-Host
                Check
            }
        }
    }
    else {
        Write-Status -Types "=" -Text "Wallpaper already exists on this system. Checking if its set." -Warning
    }

    If (!($currentwallpaper -eq "$wallpaper")) {
        Write-Status -Types "+", "Apply" -Status "Setting Wallpaper"
        Wallpaper
        #Set-WallPaper -Image "$wallpaper" -Style Stretch
    }
    else {
        Write-Status -Types "+" -Status "Wallpaper already seems to be applied" -Warning
    }

    If (!($sysmode -eq 0)) {
        Write-Status -Types "+" -Status "Setting System Theme to Dark Mode"
        Set-ItemProperty -Path $regpersonalize -Name "SystemUsesLightTheme" -Value 0
    }
    else {
        Write-Status -Types "=" -Status "New Loads detected System Mode is already set to Dark Theme" -warning
    }
    If (!($appmode -eq 0)) {
        Write-Status -Types "+" -Status "Setting App Theme to Dark Mode"
        Set-ItemProperty -Path $regpersonalize -Name "AppsUseLightTheme" -Value 0
    }
    else {
        Write-Status -Types "=" -Status "New Loads detected App Mode is already set to Dark Theme" -warning
    }
}
Visuals
Restart-Explorer