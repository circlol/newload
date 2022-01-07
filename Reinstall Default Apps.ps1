## Reinstalling default applications ##
Get-AppxPackage -AllUsers | For each app: Add-AppxPackage -DisableDevelopmentMode -Register "$($_InstallLocation)\AppXManifest.xml