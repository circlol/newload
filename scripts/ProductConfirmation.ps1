Function ProductConfirmation {
    $processor = (Get-ComputerInfo).CsProcessors.Name
    $product = (Get-WmiObject win32_baseboard).Product
    $gpuname = (Get-WmiObject win32_videocontroller).Name
    $gpudesc = (Get-WmiObject win32_videocontroller).Description
    Write-Host "`n CPU: $processor"
    Write-Host " Motherboard: $product"
    Write-Host " GPU Name: $gpuname"
    Write-Host " GPU Description: $gpudesc"    
    Write-Host " RAM INFORMATION"
    Get-CimInstance -Class CIM_PhysicalMemory -ErrorAction Stop | Select-Object 'Manufacturer', 'DeviceLocator', 'PartNumber', 'ConfiguredClockSpeed' | Out-Host
    Write-Host "`n Generating Hard Drive Report`n"
    Write-Host " Double check all drives that should be with this computer are connected." -ForegroundColor RED
    $size = 60GB
    Get-Volume | Where-Object {$_.Size -gt $Size} | Sort-Object {$_.DriveLetter} | Out-Host
}
