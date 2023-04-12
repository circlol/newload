function Find-OptionalFeature {
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $OptionalFeature
    )

    $feature = Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature -ErrorAction SilentlyContinue
    if ($feature) {
        return $true
    } else {
        Write-Status -Types "?", $TweakType -Status "The $OptionalFeature optional feature was not found." -Warning
        return $false
    }
}

function Set-OptionalFeatureState {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch] $Disabled,
        [Parameter(Mandatory = $false)]
        [Switch] $Enabled,
        [Parameter(Mandatory = $true)]
        [Array] $OptionalFeatures,
        [Parameter(Mandatory = $false)]
        [Array] $Filter,
        [Parameter(Mandatory = $false)]
        [ScriptBlock] $CustomMessage
    )

    $SecurityFilterOnEnable = @("IIS-*")
    $TweakType = "OptionalFeature"

    $OptionalFeatures | ForEach-Object {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $_ -ErrorAction SilentlyContinue
        if ($feature) {
            if ($_.DisplayName -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..." -Warning
                return
            }

            if (($_.DisplayName -in $SecurityFilterOnEnable) -and $Enabled) {
                Write-Status -Types "?", $TweakType -Status "Skipping $_ ($($feature.DisplayName)) to avoid a security vulnerability..." -Warning
                return
            }

            if (!$CustomMessage) {
                if ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Uninstalling the $_ ($($feature.DisplayName)) optional feature..."
                } elseif ($Enabled) {
                    Write-Status -Types "+", $TweakType -Status "Installing the $_ ($($feature.DisplayName)) optional feature..."
                } else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Enabled)" -Warning
                }
            } else {
                Write-Status -Types "@", $TweakType -Status (& $CustomMessage)
            }

            if ($Disabled) {
                $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart
            } elseif ($Enabled) {
                $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart
            }
        } else {
            Write-Status -Types "?", $TweakType -Status "The $_ optional feature was not found." -Warning
        }
    }
}


<#
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3")
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3")
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3") -CustomMessage { "Uninstalling $OptionalFeature feature!"}

Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3")
Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3")
Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3") -CustomMessage { "Installing $OptionalFeature feature!"}
#>
