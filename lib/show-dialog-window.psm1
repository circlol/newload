# Reference: https://michlstechblog.info/blog/powershell-show-a-messagebox/#:~:text=Sometimes%20while%20a%20powershell%20script,NET%20Windows.
function Use-WindowsForm() {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null # Load assembly
}

function Show-Message() {
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DialogResult])]
    param (
        [String] $Title = "New Loads",
        [Array]  $Message = "Donkey`nKong",
        [String] $BoxButtons = "OK", # AbortRetryIgnore, OK, OKCancel, RetryCancel, YesNo, YesNoCancel
        [String] $BoxIcon = "Information" # Information, Question, Warning, Error or None
    )

    Use-WindowsForm
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)
}

function Show-Question() {
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DialogResult])]
    param (
        [String] $Title = "New Loads",
        [Array]  $Message = "Donkey`nKong",
        [String] $BoxButtons = "YesNoCancel", # With Yes, No and Cancel, the user can press Esc to exit
        [String] $BoxIcon = "Question"
    )

    Use-WindowsForm
    $Answer = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)

    return $Answer
}

function Request-PcRestart() {
    $Ask = "Reboot?"

    switch (Show-Question -Title "New Loads" -Message $Ask) {
        'Yes' {
            Write-Host "You choose to Restart now"
            Restart-Computer
        }
        'No' {
            Write-Host "You choose to Restart later"
        }
        'Cancel' {
            # With Yes, No and Cancel, the user can press Esc to exit
            Write-Host "You choose to Restart later"
        }
    }
}

<#
Example:
Show-Message -Title "Title" -Message "Message"
$Question = Show-Question -Title "Title" -Message "Message"
Request-PcRestart
Returns Yes or No or Cancel
#>