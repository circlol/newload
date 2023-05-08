function Set-ServiceStartup() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Automatic', 'Boot', 'Disabled', 'Manual', 'System')]
        [String]      $State,
        [Parameter(Mandatory = $true)]
        [String[]]    $Services,
        [String[]]    $Filter
    )

    Begin {
        $Script:SecurityFilterOnEnable = @("RemoteAccess", "RemoteRegistry")
        $Script:TweakType = "Service"
    }

    Process {
    ForEach ($Service in $Services) {
        If (!(Get-Service $Service -ErrorAction SilentlyContinue)) {
            Write-Status -Types "?", $TweakType -Status "The $Service service was not found." -Warning
            Continue
        }

        If (($Service -in $SecurityFilterOnEnable) -and (($State -eq 'Automatic') -or ($State -eq 'Manual'))) {
            Write-Status -Types "?", $TweakType -Status "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..." -Warning
            Continue
        }

        If ($Service -in $Filter) {
            Write-Status -Types "?", $TweakType -Status "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..." -Warning
            Continue
        }

    Try {
        Write-Status -Types "@", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as '$State' on Startup..."
        If ($WhatIf){
            Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State -WhatIf
        } Else {
            Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State
        }
    }catch {
        $errorMessage = $_.Exception.Message
        $lineNumber = $_.InvocationInfo.ScriptLineNumber
        $command = $_.InvocationInfo.Line
        $errorType = $_.CategoryInfo.Reason
        $ErrorLog = ".\ErrorLog.txt"
        
    $errorString = @"
    -
    Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Command run was: $command
    Reason for error was: $errorType
    Offending line number: $lineNumber
    Error Message: $errorMessage
    -
"@
            Add-Content $ErrorLog $errorString
            Write-Output $_
            continue
            }
        }
    }
}

<#
Set-ServiceStartup -State Automatic -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Automatic -Services @("Service1", "Service2", "Service3") -Filter @("Service3")

Set-ServiceStartup -State Disabled -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Disabled -Services @("Service1", "Service2", "Service3") -Filter @("Service3")

Set-ServiceStartup -State Manual -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Manual -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
#>


