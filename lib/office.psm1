$Global:OfficeLastUpdated = '20221014'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"Variables.psm1"
Function OfficeCheck() {
    Write-Host "`n" ; Write-TitleCounter -Counter '7' -MaxLength $MaxLength -Text "Office Removal"
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path "$PathToOffice64") { $office64 = $true }Else { $office64 = $false }
    If (Test-Path "$PathToOffice86") { $Office32 = $true }Else { $office32 = $false }
    If ($office32 -eq $true) { $officecheck = $true }       
    If ($office64 -eq $true) { $officecheck = $true }    
    If ($officecheck -eq $true) { Write-Status -Types "WAITING" -Status "Office Exists" -Warning }Else { Write-Status -Types "?" -Status "Office Doesn't Exist on This Machine" -Warning }
    If ($officecheck -eq $true) { Office_Removal_AskUser }
}
Function Office_Removal_AskUser() {
    $TweakType = "Office"
    $SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_0_9246_0.zip"
    
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('  OFFICE EXISTS ON THIS PC:  SHALL I REMOVE IT?', 'New Loads', 'YesNoCancel', 'Question')
    switch ($msgBoxInput) {
    
        'Yes' {
            CheckNetworkStatus
            Write-Status "+", $TweakType -Status "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
            #Start-BitsTransfer -Source:https://aka.ms/SaRA_CommandLineVersionFiles -Destination:"$SaRA" | Out-Host
            Start-BitsTransfer -Source:$SaRAURL -Destination:$SaRA -TransferType Download -Dynamic | Out-Host
            Expand-Archive -Path $SaRA -DestinationPath $Sexp -Force
            Check
            $SaRAcmdexe = (Get-ChildItem ".\SaRA\" -Include SaRAcmd.exe -Recurse).FullName

            Write-Status "+", $TweakType -Status "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)... "
            Start-Process "$SaRAcmdexe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All" -NoNewWindow | Out-Host
        }
    
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
        'Cancel'{
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
    }    
    
}


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfUzas5OGLJ5iqI+EVkqLEwvq
# 3ymgggMQMIIDDDCCAfSgAwIBAgIQcugDkTMWcphI4F8edmMLrTANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIyMTIwNTA1
# NTgyMFoXDTIzMTIwNTA2MTgyMFowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANLmTQ9JLXGTbz4O
# zrXJeDbJAso5/80NUs/iCJ19a79QHoi5RQZRFrZbJ2uu1+Dx3ui0LOqJeKe0/Or+
# 9L3EqEf2hAlThM3JEZCtx5KRUVqF6zk+dztJ/JqkSZQPzSyZF1KqosBCTb/tAQcH
# c4Bi1JggjX/fhMwxuGfyLBUGNp6WDRMoZby2tfUXe+5grsHFKXcgDHNPNcZo6bZY
# zKQYT3iEEATiLsyXtBt7YzcSrrP5D0l8qrRna8EKCmVCX9wgIGAXHwQKeays50sN
# LIwPIrG5GYwwQVGbjOtVeUo3aneLBArGdmcKPKyHVKZn1t49exN92/no96cPYtWn
# kq15EN0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBR9LgSDHkiaRBLzTyX1lAvCIUlW4DANBgkqhkiG9w0BAQsF
# AAOCAQEAQS8ax4uhVvT8tvhADRQX/oNxwjR7xuZTt4ABOkRMTTQRddwlEOOJiwAc
# MhJlBHtvaCrnNN/0FYtL7df3q/FQvvouIDvfnNZgAZrcrBvEWjZZAd+mXrXb4r/w
# sef73iq341OOSLeZ8sLk6digbNGS6EJjYuzsYUrlAEpG5fP9yW+gpYDmerttKtoY
# xo2V7Wtuhnbx4i5VQEK/7tXgaJKNB2Ue3RJi52g1PQ/ZNkS66tIsnF3iIR5WmxdO
# mNWoJ3ZIa1Bn98WYEiJoWT+yTH/ZfZ1k786Cz2hzSolhV3eur/HWwVZ7NmeH35zT
# X0MABZ2lKEBHit+AOYH/r3SN5aMHjzGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQcugDkTMWcphI4F8edmMLrTAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUo11kfu7UHuFCIKWdZ6DHYItymfQwDQYJKoZIhvcNAQEBBQAEggEAxQmY
# Ay7AMmbscFPmWoSqyGY/6T+RuZP6Krfihu47pYP+bSJBf6dHWXL+jhwB5x+wgPyR
# 7jvSE+HbLSyVCsF1pz/OsNIcFG+OPWguyYwx5M8omGRNM85/IWfQBem4zaTGP/1P
# +ZjSil8Z8G/z882YkgVurOxExxTwkD6IpwsscICLgTIdKuSlx8cf6hr0t1YONgu/
# QoEesGjGpgVLshPJN50oAuWVJytQ25mDMxsUE13QWPncfe1WH1iGBT4TWnmoP4X6
# lCV5QM0dWlYbG3m4SclIpPMDZPfn576nH1ea8wCKTwskBG2nTzlmZNOTCn8RcM7F
# R2lvpMa0czCaoVgmSQ==
# SIG # End signature block
