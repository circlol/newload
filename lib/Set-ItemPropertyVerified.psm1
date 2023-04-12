Function Set-ItemPropertyVerified {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Value,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $Type,
        [Parameter(Mandatory = $true)]
        $Path,
        [Parameter(Mandatory = $False)]
        [Switch]$Force,
        [Parameter(Mandatory = $False)]
        [Switch]$UseVerbose,
        [Parameter(Mandatory = $False)]
        [Switch]$Passthru
    )

    $keyExists = Test-Path -Path $Path

    if (!$keyExists) {
        Write-Status -Types "+", "Path Not Found" -Status "Creating key at $Path"
        New-Item -Path $Path -Force | Out-Null
    }

    $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue

    if ($null -eq $currentValue -or $currentValue.$Name -ne $Value) {
        Try {
            Write-Status -Types "+" -Status "$Name set to $Value in $Path"
            $warningPreference = Get-Variable -Name WarningPreference -ValueOnly -ErrorAction SilentlyContinue
            If (!$Force) {
                Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Verbose:$UseVerbose
            }
            else {
                Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Force -Verbose:$UseVerbose
            }
        }
        Catch {
            Write-Error "=> Error: $_.Exception.Message" | Out-File -FilePath $ErrorLog -Append
        }
    }
    else {
        Write-Status -Types "@" -Status "Key already set to desired value. Skipping"
    }
}