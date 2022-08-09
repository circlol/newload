Function Logo(){
    Write-Host " _   _                 _                     _     " -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "| \ | |               | |                   | |    " -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "|  \| | _____      __ | |     ___   __ _  __| |___ " -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "| . `` |/ _ \ \ /\ / / | |    / _ \ / _`` |/ _``  / __|" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "| |\  |  __/\ V  V /  | |___| (_) | (_| | (_| \__ \" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "\_| \_/\___| \_/\_/   \_____/\___/ \__,_|\__,_|___/" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "`n                 Created by " -NoNewLine -ForegroundColor white -BackgroundColor Black
    Write-Host "circ" -ForegroundColor Cyan -BackgroundColor Black
}

function Write-Title() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<====================] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[====================>" -ForegroundColor Cyan -BackgroundColor Black
}
function Write-Section() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "`n<==========] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[==========>`n" -ForegroundColor Cyan -BackgroundColor Black
}
function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}

function Write-CaptionFailed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Red -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}
function Write-CaptionSucceed() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Green -BackgroundColor Black
    Write-Host "$Text" -ForegroundColor White -BackgroundColor Black
}

function Write-CaptionWarning() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==> " -NoNewline -ForegroundColor Yellow -BackgroundColor Black
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
        Write-Host "[" -NoNewline -ForegroundColor Cyan -BackgroundColor Black
        Write-Host "$Type" -NoNewline -ForegroundColor White -BackgroundColor Black
        Write-Host "] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    }

    If ($Warning) {
        Write-Host "$Status" -ForegroundColor Yellow -BackgroundColor Black
    } Else {
        Write-Host "$Status" -ForegroundColor White -BackgroundColor Black
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

    #$Counter += 1
    Write-Host "`n<====================] " -NoNewline -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "( $Counter/$MaxLength ) - { $Text } " -NoNewline -ForegroundColor White -BackgroundColor Black
    Write-Host "[====================>" -ForegroundColor Cyan -BackgroundColor Black

}

Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor Cyan -Backgroundcolor Black
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "]`n" -ForegroundColor Cyan -BackgroundColor Black
}

Function ScriptInfo(){
    Write-Break
    Write-Host ""
    Write-Host " New Loads`n"
    Write-Host " New Loads Version : $programversion"
    #Write-Host " Script Intregity: $Health%`n`n"
    Write-Host " Ideally run updates before continuing with this program." -ForegroundColor Red
    Write-Break
}

Function Check() {
    If ($?) {
        Write-CaptionSucceed -Text "Succcessful"
    }else{
        Write-CaptionFailed -Text "Unsuccessful"
    }
}


#Write-Break ; Logo ; Write-Break
#
#Write-Break
#Write-CaptionSucceed
#Write-CaptionFailed
#Write-Caption
#Write-Title
#Write-TitleCounter
#Write-Section
#Check
