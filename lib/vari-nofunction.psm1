#Function Main(){
New-Variable -Name "ProgramVersion" -Value "22801.631" -Force -Option Constant
New-Variable -Name "newloads" -Value ".\temp" -Force -Option Constant

New-Variable -Name "Log" -Value "$newloads\New Loads GUI Log.txt" -Force -Option Constant
New-Variable -Name "newlog" -Value "$newloads\New Loads *.txt" -Force -Option Constant

New-Variable -Name "ctemp" -Value "C:\Temp" -Force -Option Constant
New-Variable -Name "temp" -Value "$env:temp" -Force -Option Constant

#PathLocations
#Package/Location1 - Google Chrome 2- VLC 3- Zoom 4- Adobe Acrobat
New-Variable -Name "Package1" -Value "googlechromestandaloneenterprise64.msi" -Force -Option Constant
New-Variable -Name "Package2" -Value "vlc-3.0.17-win64.msi" -Force  -Option Constant 
New-Variable -Name "Package3" -Value "ZoomInstallerFull.msi" -Force  -Option Constant
New-Variable -Name "Package4" -Value "AcroRdrDCx642200120085_MUI.exe" -Force  -Option Constant

New-Variable -Name "oi" -Value ".\bin" -Force  -Option Constant

New-Variable -Name "Location1" -Value "$oi\$package1" -Force  -Option Constant
New-Variable -Name "Location2" -Value "$oi\$package2" -Force  -Option Constant
New-Variable -Name "Location3" -Value "$oi\$package3" -Force  -Option Constant
New-Variable -Name "Location4" -Value "$oi\$package4" -Force  -Option Constant
New-Variable -Name "Location5" -Value "C:\Windows\SysWOW64\OneDriveSetup.exe" -Force  -Option Constant

New-Variable -Name "Package1lc" -Value "$oi\$package1" -Force  -Option Constant
New-Variable -Name "Package2lc" -Value "$oi\$package2" -Force  -Option Constant
New-Variable -Name "Package3lc" -Value "$oi\$package3" -Force  -Option Constant
New-Variable -Name "Package4lc" -Value "$oi\$package4" -Force  -Option Constant
New-Variable -Name "OneDriveLocation" -Value "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe" -Force -Option Constant

New-Variable -Name "Package1dl" -Value "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Force  -Option Constant
New-Variable -Name "Package2dl" -Value "https://github.com/circlol/newload/raw/main/Assets/BAF/vlc-3.0.17-win64.msi" -Force  -Option Constant
New-Variable -Name "Package3dl" -Value "https://zoom.us/client/5.10.4.5035/ZoomInstallerFull.msi?archType=x64" -Force  -Option Constant
New-Variable -Name "Package4dl" -Value "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2200120085/AcroRdrDCx642200120085_MUI.exe" -Force  -Option Constant

New-Variable -Name "gcoi" -Value ".\bin\$package1" -Force  -Option Constant
New-Variable -Name "vlcoi" -Value ".\bin\$package2" -Force  -Option Constant
New-Variable -Name "zoomoi" -Value ".\bin\$package3" -Force  -Option Constant
New-Variable -Name "acroi" -Value ".\bin\$package4" -Force  -Option Constant

New-Variable -Name "livesafe" -Value "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe" -Force  -Option Constant
New-Variable -Name "webadvisor" -Value "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe" -Force  -Option Constant
New-Variable -Name "WildGames" -Value "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe" -Force  -Option Constant

New-Variable -Name "EdgeShortcut" -Value "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Force -Option Constant
New-Variable -Name "acrosc" -Value "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk" -Force  -Option Constant
New-Variable -Name "edgescpub" -Value "$Env:PUBLIC\Desktop\Microsoft Edge.lnk" -Force  -Option Constant
New-Variable -Name "vlcsc" -Value "$Env:PUBLIC\Desktop\VLC Media Player.lnk" -Force  -Option Constant
New-Variable -Name "zoomsc" -Value "$Env:PUBLIC\Desktop\Zoom.lnk" -Force  -Option Constant

New-Variable -Name "PathToChromeExtensions" -Value "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Force  -Option Constant
New-Variable -Name "PathToChromeLink" -Value "https://clients2.google.com/service/update2/crx" -Force  -Option Constant

New-Variable -Name "lfsvc" -Value "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Force  -Option Constant
New-Variable -Name "wifisense" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Force  -Option Constant
New-Variable -Name "regcam" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force  -Option Constant
New-Variable -Name "regexlm" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Force  -Option Constant
New-Variable -Name "regsys" -Value "HKLM:\Software\Policies\Microsoft\Windows\System" -Force  -Option Constant
New-Variable -Name "siufrules" -Value "HKCU:\Software\Microsoft\Siuf\Rules" -Force  -Option Constant
New-Variable -Name "reginp" -Value "HKCU:\Software\Microsoft\InputPersonalization" -Force  -Option Constant
New-Variable -Name "regcv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Force  -Option Constant
New-Variable -Name "regcdm" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Force  -Option Constant
New-Variable -Name "regex" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Force  -Option Constant
New-Variable -Name "regexadv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Force  -Option Constant
New-Variable -Name "regadvertising" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Force  -Option Constant
New-Variable -Name "regpersonalize" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Force  -Option Constant
New-Variable -Name "regadvertising" -Value "$regcv\AdvertisingInfo" -Force  -Option Constant
New-Variable -Name "regcdm" -Value "$regcv\CntentDeliveryManager" -Force  -Option Constant
New-Variable -Name "regex" -Value "$regcv\Explorer" -Force  -Option Constant
New-Variable -Name "regexadv" -Value "$regcv\Explorer\Advanced" -Force  -Option Constant
New-Variable -Name "regsearch" -Value "$regcv\Search" -Force  -Option Constant

#Branding
New-Variable -Name "PathToOEMInfo" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Force  -Option Constant
New-Variable -Name "website" -Value "https://www.mothercomputers.com" -Force  -Option Constant
New-Variable -Name "hours" -Value "Monday - Saturday 9AM-5PM | Sunday - Closed"  -Force  -Option Constant
New-Variable -Name "phone" -Value "(250) 479-8561" -Force  -Option Constant
New-Variable -Name "store" -Value "Mother Computers" -Force  -Option Constant
New-Variable -Name "model" -Value "Mother Computers - (250) 479-8561" -Force  -Option Constant
New-Variable -Name "page" -Value "Model" -Force  -Option Constant


New-Variable -Name "commonapps" -Value "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Force  -Option Constant

New-Variable -Name "wallpaper" -Value "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Force  -Option Constant
New-Variable -Name "currentwallpaper" -Value (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper -Force  -Option Constant
New-Variable -Name "sysmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme -Force  -Option Constant
New-Variable -Name "appmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme -Force  -Option Constant


New-Variable -Name "path86" -Value "C:\Program Files (x86)\Microsoft Office" -Force  -Option Constant
New-Variable -Name "path64" -Value "C:\Program Files\Microsoft Office 15" -Force  -Option Constant
New-Variable -Name "officecheck" -Value "$false" -Force  -Option Constant
New-Variable -Name "office32" -Value "$false" -Force  -Option Constant
New-Variable -Name "office64" -Value "$false" -Force  -Option Constant


New-Variable -Name "SaRA" -Value "$newloads\SaRA.zip" -Force  -Option Constant
New-Variable -Name "Sexp" -Value "$newloads\SaRA" -Force  -Option Constant

New-Variable -Name "unviewdest" -Value "$newloads\" -Force  -Option Constant
New-Variable -Name "html" -Value "$newloads\unview.exe" -Force  -Option Constant
New-Variable -Name "list" -Value "$newloads\ProgList.html" -Force  -Option Constant
New-Variable -Name "list" -Value "$newloads\ProgList.txt" -Force  -Option Constant
New-Variable -Name "link" -Value "https://github.com/circlol/newload/raw/main/Assets/unview.exe" -Force  -Option Constant
#}
#Main