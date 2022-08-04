Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"restart-explorer.psm1"
Import-Module -DisableNameChecking $PsScriptRoot\..\lib\"Variables.psm1"

Function OEMInfo() {
    $TweakType = "OEM"
    If ((Get-ItemProperty -Path $PathToOEMInfo).Manufacturer -eq "$store"){
        Write-Status -Types "?" -Status "Skipping" -Warning
    } else {
        Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "Manufacturer" -Type String -Value "$store"
        Check
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportPhone -eq $phone){
        Write-Status -Types "?" -Status "Skipping" -Warning
    } else {
        Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportPhone" -Type String -Value "$phone"
        Check
        
    }

    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportHours -eq "$hours"){
        Write-Status -Types "?" -Status "Skipping" -Warning
    } else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportHours" -Type String -Value "$hours"
        Check
    }
    
    If ((Get-ItemProperty -Path $PathToOEMInfo).SupportURL -eq $website){
        Write-Status -Types "?" -Status "Skipping" -Warning
    } else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name "SupportURL" -Type String -Value $website
        Check
    }
    If ((Get-ItemProperty -Path $PathToOEMInfo).Model -eq "$model"){
        Write-Status -Types "?" -Status "Skipping" -Warning
    } else {
        Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
        Set-ItemProperty -Path $PathToOEMInfo -Name $page -Type String -Value "$Model"
        Check
    }
}

OEMInfo