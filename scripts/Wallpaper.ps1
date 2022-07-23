Function Wallpaper {
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
