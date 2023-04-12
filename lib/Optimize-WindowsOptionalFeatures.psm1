Function Optimize-WindowsOptionalFeatures{
# Code from: https://github.com/LeDragoX/Win-Debloat-Tools/blob/main/src/scripts/optimize-windows-features.ps1
$DisableFeatures = @(
    "FaxServicesClientPackage"             # Windows Fax and Scan
    "IIS-*"                                # Internet Information Services
    "Internet-Explorer-Optional-*"         # Internet Explorer
    "LegacyComponents"                     # Legacy Components
    "MediaPlayback"                        # Media Features (Windows Media Player)
    "MicrosoftWindowsPowerShellV2"         # PowerShell 2.0
    "MicrosoftWindowsPowershellV2Root"     # PowerShell 2.0
    #"Printing-PrintToPDFServices-Features" # Microsoft Print to PDF
    "Printing-XPSServices-Features"        # Microsoft XPS Document Writer
    "WorkFolders-Client"                   # Work Folders Client
    )

$EnableFeatures = @(
    "NetFx3"                            # NET Framework 3.5
    "NetFx4-AdvSrvs"                    # NET Framework 4
    "NetFx4Extended-ASPNET45"           # NET Framework 4.x + ASPNET 4.x
    )

    Write-Title -Text "Optional Features Tweaks"
    Write-Section -Text "Uninstall Optional Features from Windows"

    If ($Revert) {
        Write-Status -Types "*", "OptionalFeature" -Status "Reverting the tweaks is set to '$Revert'." -Warning
        $CustomMessage = { "Re-Installing the $OptionalFeature optional feature..." }
        Set-OptionalFeatureState -Enabled -OptionalFeatures $DisableFeatures -CustomMessage $CustomMessage
    } Else {
        Set-OptionalFeatureState -Disabled -OptionalFeatures $DisableFeatures
    }

    Write-Section -Text "Install Optional Features from Windows"
    Set-OptionalFeatureState -Enabled -OptionalFeatures $EnableFeatures


    Write-Section -Text "Removing Unnecessary Printers"
    $printers = "Microsoft XPS Document Writer", "Fax", "OneNote"
    foreach ($printer in $printers) {
        try {
            Remove-Printer -Name $printer -ErrorAction Stop
            Write-Status -Types "-", "Printer" -Status "Removed $printer..."
        } catch {
            Write-Status -Types "?", "Printer" -Status "Failed to remove $printer : $_" -Warning
        }
    }


}