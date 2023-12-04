Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Clear-Host
Set-ExecutionPolicy RemoteSigned -Scope Process -Force


Function Get-Status {
    # Similar function to gs, instead it stores all the information in a variable and outputs to a log at the end of the script. the function has a passhrough to start a new log entry. and end the log entry.
    <#
.SYNOPSIS
This function is used to get the status of a log entry and perform actions based on the status.

.DESCRIPTION
This function takes in a log entry and performs actions based on the status of the log entry. It can start or stop a transcript, and write to the log file.

.PARAMETER LogEntry
The log entry to be processed.

.PARAMETER EndLogEntry
A switch parameter that indicates whether the log entry is the last entry in the log.

.PARAMETER StartTranscript
A switch parameter that indicates whether to start a transcript.

.PARAMETER StopTranscript
A switch parameter that indicates whether to stop a transcript.

.NOTES
    Author: Circlol
    Version: 1.0
    Release Notes:
        1.0:
            - Started logging changes.
#>
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [String] $LogEntry,
        [Switch] $EndLogEntry,
        [Switch] $StartTranscript,
        [Switch] $StopTranscript
    )
    process {
        If ($StartTranscript) {
            Start-Transcript -Path $Variables.Log -Append | wms -Types "STARTING" -Status "Starting Transcript"
        }

        If ($StopTranscript) {
            Stop-Transcript | wms -Types "STOPPING" -Status "Stopping Transcript"
        }

        If (!$EndLogEntry) {
            If ($? -eq $True) {
                # If no error message is provided, assume success
                #$Global:LogEntry.Successful = $true
                wc -Type Success
                #$GlobalLogEntry += $logEntry
            }
            else {
                # Set the global LogEntry.Successful to false
                #$Global:LogEntry.Successful = $false
                #$Global:LogEntry.ErrorMessage = $Error[0]
                # Log a failure message
                wc -Type Failed
                #$Global:LogEntry += $logEntry
                #        # Handle the error message
                #        Get-Error
            }
        }
        else {
            write $LogEntry | of -FilePath $Variables.Log -Append
        }
    }
}
Function Show-Question {
    <#
.SYNOPSIS
    This script defines the Show-Question function which displays a message box with a specified message, title, buttons, and icon.

.DESCRIPTION
    The Show-Question function is used to display a message box with a specified message, title, buttons, and icon. It also has an optional Chime parameter which, when specified, plays a chime sound before displaying the message box.

.PARAMETER Message
    The message to display in the message box.

.PARAMETER Title
    The title of the message box. Default value is "New Loads".

.PARAMETER Buttons
    The buttons to display in the message box. Valid values are OK, OKCancel, YesNo, YesNoCancel, RetryCancel, and AbortRetryIgnore. Default value is OK.

.PARAMETER Icon
    The icon to display in the message box. Valid values are None, Hand, Question, Exclamation, Asterisk, Stop, and Warning. Default value is Information.

.PARAMETER Chime
    Specifies whether to play a chime sound before displaying the message box. Default value is $false.

.EXAMPLE
    Show-Question -Message "Are you sure you want to delete this file?" -Title "Delete File" -Buttons YesNo -Icon Warning -Chime

.NOTES
    Author: Circlol
    Version: 1.0
    History:
        1.0:
            - Started logging changes.
#>
    param (
        [string]$Message,
        [string]$Title = "New Loads",
        [System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::Information,
        [switch]$Chime = $false
    )
    #If ($Chime) { Start-Chime }
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $Icon)
}
Function Start-Update {
    <#
.SYNOPSIS
    This function is used to update the system if the user accepts a prompt.

.DESCRIPTION
    This function uses PSWindowsUpdate to update the system, once finished the function will remove itself

.EXAMPLE
    Start-Update

.NOTES
    Author: Circlol
    Date Created: Nov 5, 2023
    Version: 1.0.1
    History:
        1.0.1:
            - Added execution policy check and change
        1.0:
            - Created function
#>
    #$lastUpdateCheckTime = Get-LastCheckForUpdate
    #$currentTime = gd
    ## Calculate time difference in hours
    #$timeDifference = ($currentTime - $lastUpdateCheckTime).TotalHours
    $TimeDifference = $True

    if ($timeDifference -eq $True) {
        $Message = "Run Windows Updates?"
        ws -Status "Press ALT + TAB if you dont see the form`n$Message"
        switch (sq -Buttons YesNo -Title "Windows Updates Notification" -Icon Information -Message $Message) {
            'Yes' {
                ## INSTALLATION
                ws -Types "+" -Status "Installing Assets"

                # Installs NuGet
                ws -Types "+" -Status "NuGet" -NoNewLine
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false | Out-Null
                gs

                # Installs PSWindowsUpdate
                ws -Types "+" -Status "PSWindowsUpdate" -NoNewLine
                Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
                gs

                $Policy = Get-ExecutionPolicy
                If ($Policy -ne "RemoteSigned") {
                    ws -Status "Changing Execution Policy"
                    Set-ExecutionPolicy RemoteSigned -Confirm:$False -Scope Process -Force
                }

                # Small sleep to assure PSWindowsUpdate can be loaded
                sleep -Seconds 3
                try {

                    # Imports PSWindowsUpdate
                    ws -Types "+" -Status "Importing PSWindowsUpdate" -NoNewLine
                    ipmo -Name PSWindowsUpdate -Force
                    gs
                    ws -Types "+" -Status "Starting Windows Updates - Download, Install, IgnoreReboot, AcceptAll"
                    Get-WindowsUpdate -AcceptAll -Install -Download -IgnoreReboot
                    
                    # CLEANUP & REMOVAL OF START-UPDATE ASSETS
                    ws -Types "-" -Status "Removing Start-Update Assets"
                    ws -Types "-" -Status "PSWindowsUpdate" -NoNewLine
                    Remove-Module -Name PSWindowsUpdate -Force -Confirm:$false
                    gs
                    ws -Types "-" -Status "NuGet" -NoNewLine
                    Uninstall-PackageProvider -Name NuGet -Force -Confirm:$false | Out-Null
                    gs
                }catch {
                    saps ms-settings:windowsupdate
                    ws -Status "Failed to Update through the script. Please manually do it."
                    Read-Host
                    Exit
                }

                ws -Status "Updates finished"
            }
            'No' {
                ws -Types "D:" "You choose to skip Windows Updates. Naughty Naughty"
            }
        }
    }
    else {
        ws -Types "" -Status "The last update check was within the 6 hours."
    }
}
Function Write-Caption {
    <#
.SYNOPSIS
Writes a caption to the console.

.DESCRIPTION
This function writes a caption to the console.

.EXAMPLE
Write-Caption -Type Success -Text "Operation completed successfully."

.NOTES
    Author: Circlol
    Version: 1.0
    History:
        1.0:
            - Started logging changes.
#>
    [CmdletBinding()]
    param (
        [ValidateSet("Failed", "Success", "Warning", "none")]
        [String] $Type = "none",
        [String] $Text = "No Text"
    )
    If ($Text -ne "No Text") { $OverrideText = $Text }

    switch ($Type) {
        "Failed" {
            $foreg = "DarkRed"
            $foreg1 = "Red"
            $symbol = "X"
            $text = "Failed"
        }
        "Success" {
            $foreg = "DarkGreen"
            $foreg1 = "Green"
            $symbol = "√"
            $text = "Success"
        }
        "Warning" {
            $foreg = "DarkYellow"
            $foreg1 = "Yellow"
            $symbol = "!"
            $text = "Warning"
        }"None" {
            $foreg = "white"
            $foreg1 = "Gray"
            $symbol = ""
            $text = ""
        }
    }
    If ($OverrideText) { $Text = $OverrideText }
    wh "  " -NoNewline #-ForegroundColor $foreg
    wh $Symbol -NoNewline -ForegroundColor $foreg1
    wh "$Text" -ForegroundColor $foreg
}
Function Write-Status {
    <#
.SYNOPSIS
Writes a status to the console.

.DESCRIPTION
This function writes a status to the console.

.EXAMPLE
Write-Status -Types "Info", "Verbose" -Status "Operation in progress."

.NOTES
    Author: Circlol
    Version: 1.0.1
    Date: Nov 5 23
    History:
        1.0.1
        (Nov 5, 2023)
            - Removed mandatory param on types for simple status
        1.0:
            - Started logging changes.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $Status,
        [Array]  $Types,
        [Switch] $WriteWarning,
        [Switch] $NoNewLine,
        [ValidateSet("Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray", "DarkGray",
            "Blue", "Green", "Cyan", "Red", "Magenta", "Yellow", "White")]
        [String] $ForegroundColorText = "White"
    )

    If ($WriteWarning -eq $True -And $ForegroundColorText -eq "White") {
        $ForegroundColorText = "Yellow"
    }
    $time = (gd).ToString("h:mm:ss tt")
    <#
    # Prints date in line, converts to Month Day Year Hour Minute Period
    $LogEntry = [PSCustomObject]@{
        Time       = $time
        Successful = $False
        Types      = $Types -join ', '
        Status     = $Status
    }
    $Global:LogEntry = $LogEntry
    #>
    # Output the log entry to the console
    wh "$time " -NoNewline -ForegroundColor DarkGray -BackgroundColor Black

    ForEach ($Type in $Types) {
        wh "$Type " -NoNewline -ForegroundColor Green -BackgroundColor Black
    }

    If ($WriteWarning) {
        wh "::Warning:: -> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor Black -NoNewline:$NoNewLine
    }
    Else {
        wh "-> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor Black -NoNewline:$NoNewLine
    }
}

If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
    cls ; wh "Please open powershell/command prompt as administrator." ; rh
    Exit 1
}


nal -name gd    -Value Get-Date
nal -name gs    -Value Get-Status
nal -name rh    -Value Read-Host
nal -Name sq    -Value Show-Question
nal -Name wc    -Value Write-Caption
nal -Name wh    -Value Write-Host
nal -Name wse   -Value Write-Section
nal -Name ws    -Value Write-Status

Start-Update
Set-ExecutionPolicy Restricted