Function Main() {
New-Variable -Name "ProgramVersion" -Value "22801.631" -Force
New-Variable -Name "newloads" -Value ".\temp" -Force

New-Variable -Name "Log" -Value "$newloads\New Loads GUI Log.txt" -Force
New-Variable -Name "newlog" -Value "$newloads\New Loads *.txt" -Force

New-Variable -Name "ctemp" -Value "C:\Temp" -Force
New-Variable -Name "temp" -Value "$env:temp" -Force

#PathLocations
#Package/Location1 - Google Chrome 2- VLC 3- Zoom 4- Adobe Acrobat
New-Variable -Name "Package1" -Value "googlechromestandaloneenterprise64.msi" -Force
New-Variable -Name "Package2" -Value "vlc-3.0.17-win64.msi" -Force 
New-Variable -Name "Package3" -Value "ZoomInstallerFull.msi" -Force 
New-Variable -Name "Package4" -Value "AcroRdrDCx642200120085_MUI.exe" -Force 

New-Variable -Name "oi" -Value ".\bin" -Force 

New-Variable -Name "Location1" -Value "$oi\$package1" -Force 
New-Variable -Name "Location2" -Value "$oi\$package2" -Force 
New-Variable -Name "Location3" -Value "$oi\$package3" -Force 
New-Variable -Name "Location4" -Value "$oi\$package4" -Force 
New-Variable -Name "Location5" -Value "C:\Windows\SysWOW64\OneDriveSetup.exe" -Force 

New-Variable -Name "Package1lc" -Value "$oi\$package1" -Force 
New-Variable -Name "Package2lc" -Value "$oi\$package2" -Force 
New-Variable -Name "Package3lc" -Value "$oi\$package3" -Force 
New-Variable -Name "Package4lc" -Value "$oi\$package4" -Force 
New-Variable -Name "OneDriveLocation" -Value "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe" -Force

New-Variable -Name "Package1dl" -Value "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Force 
New-Variable -Name "Package2dl" -Value "https://github.com/circlol/newload/raw/main/Assets/BAF/vlc-3.0.17-win64.msi" -Force 
New-Variable -Name "Package3dl" -Value "https://zoom.us/client/5.10.4.5035/ZoomInstallerFull.msi?archType=x64" -Force 
New-Variable -Name "Package4dl" -Value "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2200120085/AcroRdrDCx642200120085_MUI.exe" -Force 

New-Variable -Name "gcoi" -Value ".\bin\$package1" -Force 
New-Variable -Name "vlcoi" -Value ".\bin\$package2" -Force 
New-Variable -Name "zoomoi" -Value ".\bin\$package3" -Force 
New-Variable -Name "acroi" -Value ".\bin\$package4" -Force 

New-Variable -Name "livesafe" -Value "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe" -Force 
New-Variable -Name "webadvisor" -Value "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe" -Force 
New-Variable -Name "WildGames" -Value "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe" -Force 

New-Variable -Name "EdgeShortcut" -Value "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Force
New-Variable -Name "acrosc" -Value "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk" -Force 
New-Variable -Name "edgescpub" -Value "$Env:PUBLIC\Desktop\Microsoft Edge.lnk" -Force 
New-Variable -Name "vlcsc" -Value "$Env:PUBLIC\Desktop\VLC Media Player.lnk" -Force 
New-Variable -Name "zoomsc" -Value "$Env:PUBLIC\Desktop\Zoom.lnk" -Force 

New-Variable -Name "PathToChromeExtensions" -Value "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Force 
New-Variable -Name "PathToChromeLink" -Value "https://clients2.google.com/service/update2/crx" -Force 

New-Variable -Name "lfsvc" -Value "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Force 
New-Variable -Name "wifisense" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Force 
New-Variable -Name "regcam" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force 
New-Variable -Name "regexlm" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Force 
New-Variable -Name "regsys" -Value "HKLM:\Software\Policies\Microsoft\Windows\System" -Force 
New-Variable -Name "siufrules" -Value "HKCU:\Software\Microsoft\Siuf\Rules" -Force 
New-Variable -Name "reginp" -Value "HKCU:\Software\Microsoft\InputPersonalization" -Force 
New-Variable -Name "regcv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Force 
New-Variable -Name "regcdm" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force 
New-Variable -Name "regex" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Force 
New-Variable -Name "regexadv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Force 
New-Variable -Name "regadvertising" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Force 
New-Variable -Name "regpersonalize" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Force 
New-Variable -Name "regadvertising" -Value "$regcv\AdvertisingInfo" -Force 
New-Variable -Name "regcdm" -Value "$regcv\CntentDeliveryManager" -Force 
New-Variable -Name "regex" -Value "$regcv\Explorer" -Force 
New-Variable -Name "regexadv" -Value "$regcv\Explorer\Advanced" -Force 
New-Variable -Name "regsearch" -Value "$regcv\Search" -Force 

#Branding
New-Variable -Name "PathToOEMInfo" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Force 
New-Variable -Name "website" -Value "https://www.mothercomputers.com" -Force 
New-Variable -Name "hours" -Value "Monday - Saturday 9AM-5PM | Sunday - Closed"  -Force 
New-Variable -Name "phone" -Value "(250) 479-8561" -Force 
New-Variable -Name "store" -Value "Mother Computers" -Force 
New-Variable -Name "model" -Value "Mother Computers - (250) 479-8561" -Force 
New-Variable -Name "page" -Value "Model" -Force 


New-Variable -Name "commonapps" -Value "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Force 

New-Variable -Name "wallpaper" -Value "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Force 
New-Variable -Name "currentwallpaper" -Value (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper -Force 
New-Variable -Name "sysmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme -Force 
New-Variable -Name "appmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme -Force 


New-Variable -Name "path86" -Value "C:\Program Files (x86)\Microsoft Office" -Force 
New-Variable -Name "path64" -Value "C:\Program Files\Microsoft Office 15" -Force 
New-Variable -Name "officecheck" -Value "$false" -Force 
New-Variable -Name "office32" -Value "$false" -Force 
New-Variable -Name "office64" -Value "$false" -Force 


New-Variable -Name "SaRA" -Value "$newloads\SaRA.zip" -Force 
New-Variable -Name "Sexp" -Value "$newloads\SaRA" -Force 

New-Variable -Name "unviewdest" -Value "$newloads\" -Force 
New-Variable -Name "html" -Value "$newloads\unview.exe" -Force 
New-Variable -Name "list" -Value "$newloads\ProgList.html" -Force 
New-Variable -Name "list" -Value "$newloads\ProgList.txt" -Force 
New-Variable -Name "link" -Value "https://github.com/circlol/newload/raw/main/Assets/unview.exe" -Force 
}
Main