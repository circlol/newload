

#############################################
#                                           #
#                                           #
#       This portion asks the user if       #
#           they'd like to reboot           #
#                                           #
#                                           #
#############################################

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | out-null
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null
$TimeStart = Get-Date
$TimeEnd = $timeStart.addminutes(20)
Do
{
    $TimeNow = Get-Date
    if ($TimeNow -ge $TimeEnd)
    {
        
        Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue
        Remove-Event click_event -ErrorAction SilentlyContinue
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
        Exit
    }
    else
    #$path = Get-Process -id $pid | Select-Object -ExpandProperty Path
    #$Balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    #$balloonToolTip.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    {
        $Balloon = new-object System.Windows.Forms.NotifyIcon
        #$balloonToolTip.Icon = [System.Drawing.SystemIcons]::Information
        $Balloon.Icon = [System.Drawing.SystemIcons]::Information
        $Balloon.BalloonTipIcon = "Warning"
        $Balloon.BalloonTipTitle = "New Loads Completed"
        $Balloon.BalloonTipText = "Please reboot for all changes to take effect."
        $Balloon.Visible = $true;
        $Balloon.ShowBalloonTip(20000);
        $Balloon_MouseOver = [System.Windows.Forms.MouseEventHandler]{ $Balloon.ShowBalloonTip(20000) }
        $Balloon.add_MouseClick($Balloon_MouseOver)
        Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue
        Register-ObjectEvent $Balloon BalloonTipClicked -sourceIdentifier click_event -Action {
            Add-Type -AssemblyName Microsoft.VisualBasic
            
            If ([Microsoft.VisualBasic.Interaction]::MsgBox('Would you like to reboot your machine now?', 'YesNo,MsgBoxSetForeground,Question', 'NewLoads') -eq "NO")
            { }
            else
            {
                shutdown -r -t 0
            }
            
        } | Out-Null
        
        Wait-Event -timeout 7200 -sourceIdentifier click_event > $null
        Unregister-Event -SourceIdentifier click_event -ErrorAction SilentlyContinue
        $Balloon.Dispose()
    }

}
Until ($TimeNow -ge $TimeEnd)