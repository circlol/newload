function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<===================={ " -NoNewline -ForegroundColor Blue -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "}====================>" -ForegroundColor Blue -BackgroundColor Black
}
function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}

function Write-Status() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Array]  $Types,
        [Parameter(Mandatory)]
        [String] $Status,
        [Switch] $Warning
    )

    ForEach ($Type in $Types) {
        Write-Host "[" -NoNewline -ForegroundColor Blue -BackgroundColor Black
        Write-Host "$Type" -NoNewline -ForegroundColor White -BackgroundColor Black
        Write-Host "] " -NoNewline -ForegroundColor Blue -BackgroundColor Black
    }

    If ($Warning) {
        Write-Host "$Status" -ForegroundColor Yellow -BackgroundColor Black
    } Else {
        Write-Host "$Status" -ForegroundColor Green -BackgroundColor Black
    }
}

function Write-TitleCounter() {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )

    $Counter += 1
    Write-Host "`n<===================={ " -NoNewline -ForegroundColor Blue -BackgroundColor Black
    Write-Host "( $Counter/$MaxLength ) - { $Text } " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "}====================>" -ForegroundColor Blue -BackgroundColor Black

    return $Counter
}
