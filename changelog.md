# New Loads Changelog

------

## Version 1.06 - Expected ~~August 8th, 2023~~ September 14th

------

#### Highlighted Changes

> - Essentially entire script has been rewritten every function of the script has been rewritten or modified
> - `irm run.newloads.ca | iex` added as a quick way to run from any Win10 20H2+ system 
> - Custom Progress bar added during Debloat
> - Start-Chime added
> - Logging rewritten to be more clear and concise - Improved from `Start-Transcript`
> - Consolidated `.\lib`, `.\assets`, `assets.psm1` `Online: New Loads.ps1`, `Local: New Loads.ps1`
> - Error Handling improved and added into Get-Status

#### Formatting Changes

> - Write-Status modified now including multiple new parameters including `-NoNewLine` , `-ForegroundColorText` , `-BackgroundColorText` , `-WhatIf` , `-Confirm` 
> - Write-Status handles log formatting
> - Get-Status grabs log formatting from Write-Status, also adds if last command was successful or not
> - All Variables moved into a hash-table
> - Timestamp Filter added
> - All Functions renamed to use approved verbs
> - Redundant params for Set-ScriptStatus removed
> - Send-Email log $EmailBody rewritten
> - Show-ScriptStatus tweaked to include TweakType, WindowTitle, Write-TitleCounter, Write-Section
>

#### Script Improvements

> - Scripts performance has been increased
> - Redundant code has been significant reduced
> - Removed Programs from CheckFiles function
> - Removed Local bin files
> - Check will run without breaking the line. 
> - Get-SystemSpecs created to gather all info about system
> - Modified Update-Time function to be more robust
> - Added Get-DriveModels
> - Admin check code shrunk and faster
> - Script can attempt to self elevate using `irm run.newloads.ca | iex`
>

Security Improvements

> - Script no longer changes Execution Policy
>
> - Added Security Vulnerability Patch [CVE-2023-36884](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2023-36884)
>
>   [^]: Office and Windows HTML Remote Code Execution Vulnerability
