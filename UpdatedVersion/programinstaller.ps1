<# 
.NAME
    Install
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Install                         = New-Object system.Windows.Forms.Form
$Install.ClientSize              = New-Object System.Drawing.Point(938,686)
$Install.text                    = "Install Programs"
$Install.TopMost                 = $false
$Install.Resize                  = $false
$Install.AutoScroll              = $True
$Install.AutoSize                = $True
$Install.MaximizeBox             = $false
$Install.MinimizeBox             = $false
$Install.FormBorderStyle         = 'FixedSingle'
$Install.StartPosition           = "CenterScreen"

$Label_Browsers                  = New-Object system.Windows.Forms.Label
$Label_Browsers.text             = "Browsers"
$Label_Browsers.AutoSize         = $true
$Label_Browsers.width            = 25
$Label_Browsers.height           = 10
$Label_Browsers.location         = New-Object System.Drawing.Point(36,30)
$Label_Browsers.Font             = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_Chrome                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_Chrome.text            = "Chrome"
$CheckBox_Chrome.AutoSize        = $false
$CheckBox_Chrome.Checked         = $True
$CheckBox_Chrome.width           = 95
$CheckBox_Chrome.height          = 20
$CheckBox_Chrome.location        = New-Object System.Drawing.Point(37,54)
$CheckBox_Chrome.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Firefox                = New-Object system.Windows.Forms.CheckBox
$CheckBox_Firefox.text           = "Firefox"
$CheckBox_Firefox.AutoSize       = $false
$CheckBox_Firefox.width          = 95
$CheckBox_Firefox.height         = 20
$CheckBox_Firefox.location       = New-Object System.Drawing.Point(37,122)
$CheckBox_Firefox.Font           = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Opera                  = New-Object system.Windows.Forms.CheckBox
$CheckBox_Opera.text             = "Opera"
$CheckBox_Opera.AutoSize         = $false
$CheckBox_Opera.width            = 95
$CheckBox_Opera.height           = 20
$CheckBox_Opera.location         = New-Object System.Drawing.Point(38,105)
$CheckBox_Opera.Font             = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Brave                  = New-Object system.Windows.Forms.CheckBox
$CheckBox_Brave.text             = "Brave"
$CheckBox_Brave.AutoSize         = $false
$CheckBox_Brave.width            = 95
$CheckBox_Brave.height           = 20
$CheckBox_Brave.location         = New-Object System.Drawing.Point(37,71)
$CheckBox_Brave.Font             = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_PasswordManagers          = New-Object system.Windows.Forms.Label
$Label_PasswordManagers.text     = "Password Managers"
$Label_PasswordManagers.AutoSize  = $true
$Label_PasswordManagers.width    = 25
$Label_PasswordManagers.height   = 10
$Label_PasswordManagers.location  = New-Object System.Drawing.Point(22,156)
$Label_PasswordManagers.Font     = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_Edge                   = New-Object system.Windows.Forms.CheckBox
$CheckBox_Edge.text              = "Edge"
$CheckBox_Edge.AutoSize          = $false
$CheckBox_Edge.width             = 95
$CheckBox_Edge.height            = 20
$CheckBox_Edge.location          = New-Object System.Drawing.Point(38,89)
$CheckBox_Edge.Font              = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Bitwarden              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Bitwarden.text         = "Bitwarden"
$CheckBox_Bitwarden.AutoSize     = $false
$CheckBox_Bitwarden.width        = 95
$CheckBox_Bitwarden.height       = 20
$CheckBox_Bitwarden.location     = New-Object System.Drawing.Point(36,186)
$CheckBox_Bitwarden.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Keeper                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_Keeper.text            = "Keeper"
$CheckBox_Keeper.AutoSize        = $false
$CheckBox_Keeper.width           = 95
$CheckBox_Keeper.height          = 20
$CheckBox_Keeper.location        = New-Object System.Drawing.Point(36,254)
$CheckBox_Keeper.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_1Password              = New-Object system.Windows.Forms.CheckBox
$CheckBox_1Password.text         = "1Password"
$CheckBox_1Password.AutoSize     = $false
$CheckBox_1Password.width        = 95
$CheckBox_1Password.height       = 20
$CheckBox_1Password.location     = New-Object System.Drawing.Point(36,237)
$CheckBox_1Password.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Dashlane               = New-Object system.Windows.Forms.CheckBox
$CheckBox_Dashlane.text          = "Dashlane"
$CheckBox_Dashlane.AutoSize      = $false
$CheckBox_Dashlane.width         = 95
$CheckBox_Dashlane.height        = 20
$CheckBox_Dashlane.location      = New-Object System.Drawing.Point(36,203)
$CheckBox_Dashlane.Font          = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Lastpass               = New-Object system.Windows.Forms.CheckBox
$CheckBox_Lastpass.text          = "LastPass"
$CheckBox_Lastpass.AutoSize      = $false
$CheckBox_Lastpass.width         = 95
$CheckBox_Lastpass.height        = 20
$CheckBox_Lastpass.location      = New-Object System.Drawing.Point(36,221)
$CheckBox_Lastpass.Font          = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_NordPass               = New-Object system.Windows.Forms.CheckBox
$CheckBox_NordPass.text          = "NordPass"
$CheckBox_NordPass.AutoSize      = $false
$CheckBox_NordPass.width         = 95
$CheckBox_NordPass.height        = 20
$CheckBox_NordPass.location      = New-Object System.Drawing.Point(36,269)
$CheckBox_NordPass.Font          = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Roboform               = New-Object system.Windows.Forms.CheckBox
$CheckBox_Roboform.text          = "RoboForm"
$CheckBox_Roboform.AutoSize      = $false
$CheckBox_Roboform.width         = 95
$CheckBox_Roboform.height        = 20
$CheckBox_Roboform.location      = New-Object System.Drawing.Point(36,286)
$CheckBox_Roboform.Font          = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_Messaging                 = New-Object system.Windows.Forms.Label
$Label_Messaging.text            = "Messaging"
$Label_Messaging.AutoSize        = $true
$Label_Messaging.width           = 25
$Label_Messaging.height          = 10
$Label_Messaging.location        = New-Object System.Drawing.Point(31,322)
$Label_Messaging.Font            = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_Messenger              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Messenger.text         = "Messenger"
$CheckBox_Messenger.AutoSize     = $false
$CheckBox_Messenger.width        = 95
$CheckBox_Messenger.height       = 20
$CheckBox_Messenger.location     = New-Object System.Drawing.Point(38,354)
$CheckBox_Messenger.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Signal                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_Signal.text            = "Signal"
$CheckBox_Signal.AutoSize        = $false
$CheckBox_Signal.width           = 95
$CheckBox_Signal.height          = 20
$CheckBox_Signal.location        = New-Object System.Drawing.Point(38,422)
$CheckBox_Signal.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Teams                  = New-Object system.Windows.Forms.CheckBox
$CheckBox_Teams.text             = "Teams"
$CheckBox_Teams.AutoSize         = $false
$CheckBox_Teams.width            = 95
$CheckBox_Teams.height           = 20
$CheckBox_Teams.location         = New-Object System.Drawing.Point(39,405)
$CheckBox_Teams.Font             = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_WeChat                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_WeChat.text            = "WeChat"
$CheckBox_WeChat.AutoSize        = $false
$CheckBox_WeChat.width           = 95
$CheckBox_WeChat.height          = 20
$CheckBox_WeChat.location        = New-Object System.Drawing.Point(38,371)
$CheckBox_WeChat.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Discord                = New-Object system.Windows.Forms.CheckBox
$CheckBox_Discord.text           = "Discord"
$CheckBox_Discord.AutoSize       = $false
$CheckBox_Discord.width          = 95
$CheckBox_Discord.height         = 20
$CheckBox_Discord.location       = New-Object System.Drawing.Point(38,388)
$CheckBox_Discord.Font           = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Skype                  = New-Object system.Windows.Forms.CheckBox
$CheckBox_Skype.text             = "Skype"
$CheckBox_Skype.AutoSize         = $false
$CheckBox_Skype.width            = 95
$CheckBox_Skype.height           = 20
$CheckBox_Skype.location         = New-Object System.Drawing.Point(38,439)
$CheckBox_Skype.Font             = New-Object System.Drawing.Font('Malgun Gothic',10)

$ProgressBar1                    = New-Object system.Windows.Forms.ProgressBar
$ProgressBar1.width              = 845
$ProgressBar1.height             = 22
$ProgressBar1.location           = New-Object System.Drawing.Point(8,653)

$Button_Start                    = New-Object system.Windows.Forms.Button
$Button_Start.text               = "Start"
$Button_Start.width              = 60
$Button_Start.height             = 22
$Button_Start.location           = New-Object System.Drawing.Point(865,653)
$Button_Start.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Button_Start.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml("#61775d")
$Button_Start.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("#b3d4ac")

$Label_Media                     = New-Object system.Windows.Forms.Label
$Label_Media.text                = "Media"
$Label_Media.AutoSize            = $true
$Label_Media.width               = 25
$Label_Media.height              = 10
$Label_Media.location            = New-Object System.Drawing.Point(241,30)
$Label_Media.Font                = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_VLC                    = New-Object system.Windows.Forms.CheckBox
$CheckBox_VLC.text               = "VLC Media Player"
$CheckBox_VLC.AutoSize           = $false
$CheckBox_VLC.width              = 95
$CheckBox_VLC.height             = 20
$CheckBox_VLC.location           = New-Object System.Drawing.Point(223,54)
$CheckBox_VLC.Font               = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Audacity               = New-Object system.Windows.Forms.CheckBox
$CheckBox_Audacity.text          = "Audacity"
$CheckBox_Audacity.AutoSize      = $false
$CheckBox_Audacity.width         = 95
$CheckBox_Audacity.height        = 20
$CheckBox_Audacity.location      = New-Object System.Drawing.Point(223,121)
$CheckBox_Audacity.Font          = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Foobar                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_Foobar.text            = "Foobar2000"
$CheckBox_Foobar.AutoSize        = $false
$CheckBox_Foobar.width           = 95
$CheckBox_Foobar.height          = 20
$CheckBox_Foobar.location        = New-Object System.Drawing.Point(223,105)
$CheckBox_Foobar.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_iTunes                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_iTunes.text            = "iTunes"
$CheckBox_iTunes.AutoSize        = $false
$CheckBox_iTunes.width           = 95
$CheckBox_iTunes.height          = 20
$CheckBox_iTunes.location        = New-Object System.Drawing.Point(223,71)
$CheckBox_iTunes.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_MPC                    = New-Object system.Windows.Forms.CheckBox
$CheckBox_MPC.text               = "Media Player Classic"
$CheckBox_MPC.AutoSize           = $false
$CheckBox_MPC.width              = 95
$CheckBox_MPC.height             = 20
$CheckBox_MPC.location           = New-Object System.Drawing.Point(223,89)
$CheckBox_MPC.Font               = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Voicemeeter            = New-Object system.Windows.Forms.CheckBox
$CheckBox_Voicemeeter.text       = "Voicemeeter"
$CheckBox_Voicemeeter.AutoSize   = $false
$CheckBox_Voicemeeter.width      = 95
$CheckBox_Voicemeeter.height     = 20
$CheckBox_Voicemeeter.location   = New-Object System.Drawing.Point(223,137)
$CheckBox_Voicemeeter.Font       = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_VoicemeeterBanana      = New-Object system.Windows.Forms.CheckBox
$CheckBox_VoicemeeterBanana.text  = "Voicemeeter Banana"
$CheckBox_VoicemeeterBanana.AutoSize  = $false
$CheckBox_VoicemeeterBanana.width  = 95
$CheckBox_VoicemeeterBanana.height  = 20
$CheckBox_VoicemeeterBanana.location  = New-Object System.Drawing.Point(223,154)
$CheckBox_VoicemeeterBanana.Font  = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_VoiceMeeterPotato           = New-Object system.Windows.Forms.CheckBox
$CheckBox_VoiceMeeterPotato.text      = "Voicemeeter Potato"
$CheckBox_VoiceMeeterPotato.AutoSize  = $false
$CheckBox_VoiceMeeterPotato.width     = 95
$CheckBox_VoiceMeeterPotato.height    = 20
$CheckBox_VoiceMeeterPotato.location  = New-Object System.Drawing.Point(223,172)
$CheckBox_VoiceMeeterPotato.Font      = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Handbrake              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Handbrake.text         = "HandBrake"
$CheckBox_Handbrake.AutoSize     = $false
$CheckBox_Handbrake.width        = 95
$CheckBox_Handbrake.height       = 20
$CheckBox_Handbrake.location     = New-Object System.Drawing.Point(222,188)
$CheckBox_Handbrake.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Spotify                = New-Object system.Windows.Forms.CheckBox
$CheckBox_Spotify.text           = "Spotify"
$CheckBox_Spotify.AutoSize       = $false
$CheckBox_Spotify.width          = 95
$CheckBox_Spotify.height         = 20
$CheckBox_Spotify.location       = New-Object System.Drawing.Point(222,205)
$CheckBox_Spotify.Font           = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_Gaming                    = New-Object system.Windows.Forms.Label
$Label_Gaming.text               = "Gaming"
$Label_Gaming.AutoSize           = $true
$Label_Gaming.width              = 25
$Label_Gaming.height             = 10
$Label_Gaming.location           = New-Object System.Drawing.Point(235,247)
$Label_Gaming.Font               = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_Steam                  = New-Object system.Windows.Forms.CheckBox
$CheckBox_Steam.text             = "Steam"
$CheckBox_Steam.AutoSize         = $false
$CheckBox_Steam.width            = 95
$CheckBox_Steam.height           = 20
$CheckBox_Steam.location         = New-Object System.Drawing.Point(227,280)
$CheckBox_Steam.Font             = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Xbox                   = New-Object system.Windows.Forms.CheckBox
$CheckBox_Xbox.text              = "Xbox"
$CheckBox_Xbox.AutoSize          = $false
$CheckBox_Xbox.width             = 95
$CheckBox_Xbox.height            = 20
$CheckBox_Xbox.location          = New-Object System.Drawing.Point(227,348)
$CheckBox_Xbox.Font              = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_GOG                    = New-Object system.Windows.Forms.CheckBox
$CheckBox_GOG.text               = "Gog Galaxy"
$CheckBox_GOG.AutoSize           = $false
$CheckBox_GOG.width              = 95
$CheckBox_GOG.height             = 20
$CheckBox_GOG.location           = New-Object System.Drawing.Point(228,331)
$CheckBox_GOG.Font               = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Battlenet              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Battlenet.text         = "Battle.net"
$CheckBox_Battlenet.AutoSize     = $false
$CheckBox_Battlenet.width        = 95
$CheckBox_Battlenet.height       = 20
$CheckBox_Battlenet.location     = New-Object System.Drawing.Point(227,297)
$CheckBox_Battlenet.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Epic                   = New-Object system.Windows.Forms.CheckBox
$CheckBox_Epic.text              = "Epic Games"
$CheckBox_Epic.AutoSize          = $false
$CheckBox_Epic.width             = 95
$CheckBox_Epic.height            = 20
$CheckBox_Epic.location          = New-Object System.Drawing.Point(227,314)
$CheckBox_Epic.Font              = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_EADesktop              = New-Object system.Windows.Forms.CheckBox
$CheckBox_EADesktop.text         = "EA Desktop"
$CheckBox_EADesktop.AutoSize     = $false
$CheckBox_EADesktop.width        = 95
$CheckBox_EADesktop.height       = 20
$CheckBox_EADesktop.location     = New-Object System.Drawing.Point(228,365)
$CheckBox_EADesktop.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_Cloud                     = New-Object system.Windows.Forms.Label
$Label_Cloud.text                = "Cloud"
$Label_Cloud.AutoSize            = $true
$Label_Cloud.width               = 25
$Label_Cloud.height              = 10
$Label_Cloud.location            = New-Object System.Drawing.Point(444,30)
$Label_Cloud.Font                = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_OneDrive               = New-Object system.Windows.Forms.CheckBox
$CheckBox_OneDrive.text          = "OneDrive"
$CheckBox_OneDrive.AutoSize      = $false
$CheckBox_OneDrive.width         = 95
$CheckBox_OneDrive.height        = 20
$CheckBox_OneDrive.location      = New-Object System.Drawing.Point(436,58)
$CheckBox_OneDrive.Font          = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_iDrive                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_iDrive.text            = "iDrive"
$CheckBox_iDrive.AutoSize        = $false
$CheckBox_iDrive.width           = 95
$CheckBox_iDrive.height          = 20
$CheckBox_iDrive.location        = New-Object System.Drawing.Point(436,127)
$CheckBox_iDrive.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_GoogleDrive            = New-Object system.Windows.Forms.CheckBox
$CheckBox_GoogleDrive.text       = "Google Drive"
$CheckBox_GoogleDrive.AutoSize   = $false
$CheckBox_GoogleDrive.width      = 95
$CheckBox_GoogleDrive.height     = 20
$CheckBox_GoogleDrive.location   = New-Object System.Drawing.Point(436,109)
$CheckBox_GoogleDrive.Font       = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_iCloud                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_iCloud.text            = "iCloud"
$CheckBox_iCloud.AutoSize        = $false
$CheckBox_iCloud.width           = 95
$CheckBox_iCloud.height          = 20
$CheckBox_iCloud.location        = New-Object System.Drawing.Point(436,75)
$CheckBox_iCloud.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Dropbox                = New-Object system.Windows.Forms.CheckBox
$CheckBox_Dropbox.text           = "Dropbox"
$CheckBox_Dropbox.AutoSize       = $false
$CheckBox_Dropbox.width          = 95
$CheckBox_Dropbox.height         = 20
$CheckBox_Dropbox.location       = New-Object System.Drawing.Point(436,93)
$CheckBox_Dropbox.Font           = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Malwarebytes           = New-Object system.Windows.Forms.CheckBox
$CheckBox_Malwarebytes.text      = "Malwarebytes"
$CheckBox_Malwarebytes.AutoSize  = $false
$CheckBox_Malwarebytes.width     = 95
$CheckBox_Malwarebytes.height    = 20
$CheckBox_Malwarebytes.location  = New-Object System.Drawing.Point(421,207)
$CheckBox_Malwarebytes.Font      = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Kaspersky              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Kaspersky.text         = "Kaspersky"
$CheckBox_Kaspersky.AutoSize     = $false
$CheckBox_Kaspersky.width        = 95
$CheckBox_Kaspersky.height       = 20
$CheckBox_Kaspersky.location     = New-Object System.Drawing.Point(422,190)
$CheckBox_Kaspersky.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_SuperAntiSpyware          = New-Object system.Windows.Forms.CheckBox
$CheckBox_SuperAntiSpyware.text     = "SuperAntiSpyware"
$CheckBox_SuperAntiSpyware.AutoSize = $false
$CheckBox_SuperAntiSpyware.width    = 95
$CheckBox_SuperAntiSpyware.height   = 20
$CheckBox_SuperAntiSpyware.location = New-Object System.Drawing.Point(421,222)
$CheckBox_SuperAntiSpyware.Font     = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_SpybotAntiBeacon          = New-Object system.Windows.Forms.CheckBox
$CheckBox_SpybotAntiBeacon.text     = "Spybot AntiMalware"
$CheckBox_SpybotAntiBeacon.AutoSize = $false
$CheckBox_SpybotAntiBeacon.width    = 95
$CheckBox_SpybotAntiBeacon.height   = 20
$CheckBox_SpybotAntiBeacon.location = New-Object System.Drawing.Point(420,238)
$CheckBox_SpybotAntiBeacon.Font     = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_OOShutUp10             = New-Object system.Windows.Forms.CheckBox
$CheckBox_OOShutUp10.text        = "O&O Shutup 10"
$CheckBox_OOShutUp10.AutoSize    = $false
$CheckBox_OOShutUp10.width       = 95
$CheckBox_OOShutUp10.height      = 20
$CheckBox_OOShutUp10.location    = New-Object System.Drawing.Point(420,255)
$CheckBox_OOShutUp10.Font        = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_Security                  = New-Object system.Windows.Forms.Label
$Label_Security.text             = "Security"
$Label_Security.AutoSize         = $true
$Label_Security.width            = 25
$Label_Security.height           = 10
$Label_Security.location         = New-Object System.Drawing.Point(436,166)
$Label_Security.Font             = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_Blackbird              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Blackbird.text         = "Blackbird"
$CheckBox_Blackbird.AutoSize     = $false
$CheckBox_Blackbird.width        = 95
$CheckBox_Blackbird.height       = 20
$CheckBox_Blackbird.location     = New-Object System.Drawing.Point(420,272)
$CheckBox_Blackbird.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_VPN                       = New-Object system.Windows.Forms.Label
$Label_VPN.text                  = "VPN"
$Label_VPN.AutoSize              = $true
$Label_VPN.width                 = 25
$Label_VPN.height                = 10
$Label_VPN.location              = New-Object System.Drawing.Point(444,309)
$Label_VPN.Font                  = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_KasperskyVPN           = New-Object system.Windows.Forms.CheckBox
$CheckBox_KasperskyVPN.text      = "Kaspersky VPN"
$CheckBox_KasperskyVPN.AutoSize  = $false
$CheckBox_KasperskyVPN.width     = 95
$CheckBox_KasperskyVPN.height    = 20
$CheckBox_KasperskyVPN.location  = New-Object System.Drawing.Point(421,330)
$CheckBox_KasperskyVPN.Font      = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Surfshark              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Surfshark.text         = "Surfshark"
$CheckBox_Surfshark.AutoSize     = $false
$CheckBox_Surfshark.width        = 95
$CheckBox_Surfshark.height       = 20
$CheckBox_Surfshark.location     = New-Object System.Drawing.Point(421,399)
$CheckBox_Surfshark.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_PIA                    = New-Object system.Windows.Forms.CheckBox
$CheckBox_PIA.text               = "Private Internet Access"
$CheckBox_PIA.AutoSize           = $false
$CheckBox_PIA.width              = 95
$CheckBox_PIA.height             = 20
$CheckBox_PIA.location           = New-Object System.Drawing.Point(421,381)
$CheckBox_PIA.Font               = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_NordVPN                = New-Object system.Windows.Forms.CheckBox
$CheckBox_NordVPN.text           = "NordVPN"
$CheckBox_NordVPN.AutoSize       = $false
$CheckBox_NordVPN.width          = 95
$CheckBox_NordVPN.height         = 20
$CheckBox_NordVPN.location       = New-Object System.Drawing.Point(421,347)
$CheckBox_NordVPN.Font           = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_ExpressVPN             = New-Object system.Windows.Forms.CheckBox
$CheckBox_ExpressVPN.text        = "ExpressVPN"
$CheckBox_ExpressVPN.AutoSize    = $false
$CheckBox_ExpressVPN.width       = 95
$CheckBox_ExpressVPN.height      = 20
$CheckBox_ExpressVPN.location    = New-Object System.Drawing.Point(421,365)
$CheckBox_ExpressVPN.Font        = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_Compression               = New-Object system.Windows.Forms.Label
$Label_Compression.text          = "Compression"
$Label_Compression.AutoSize      = $true
$Label_Compression.width         = 25
$Label_Compression.height        = 10
$Label_Compression.location      = New-Object System.Drawing.Point(220,393)
$Label_Compression.Font          = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_7zip                   = New-Object system.Windows.Forms.CheckBox
$CheckBox_7zip.text              = "7zip"
$CheckBox_7zip.AutoSize          = $false
$CheckBox_7zip.width             = 95
$CheckBox_7zip.height            = 20
$CheckBox_7zip.location          = New-Object System.Drawing.Point(227,425)
$CheckBox_7zip.Font              = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_WinRAR                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_WinRAR.text            = "WinRAR"
$CheckBox_WinRAR.AutoSize        = $false
$CheckBox_WinRAR.width           = 95
$CheckBox_WinRAR.height          = 20
$CheckBox_WinRAR.location        = New-Object System.Drawing.Point(227,442)
$CheckBox_WinRAR.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_NanaZip                = New-Object system.Windows.Forms.CheckBox
$CheckBox_NanaZip.text           = "NanaZip"
$CheckBox_NanaZip.AutoSize       = $false
$CheckBox_NanaZip.width          = 95
$CheckBox_NanaZip.height         = 20
$CheckBox_NanaZip.location       = New-Object System.Drawing.Point(227,459)
$CheckBox_NanaZip.Font           = New-Object System.Drawing.Font('Malgun Gothic',10)

$Label_Search                    = New-Object system.Windows.Forms.Label
$Label_Search.text               = "Search"
$Label_Search.AutoSize           = $true
$Label_Search.width              = 25
$Label_Search.height             = 10
$Label_Search.location           = New-Object System.Drawing.Point(644,30)
$Label_Search.Font               = New-Object System.Drawing.Font('Malgun Gothic',12)

$CheckBox_FlowLauncher           = New-Object system.Windows.Forms.CheckBox
$CheckBox_FlowLauncher.text      = "Flow Launcher"
$CheckBox_FlowLauncher.AutoSize  = $false
$CheckBox_FlowLauncher.width     = 95
$CheckBox_FlowLauncher.height    = 20
$CheckBox_FlowLauncher.location  = New-Object System.Drawing.Point(628,61)
$CheckBox_FlowLauncher.Font      = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Fluent                 = New-Object system.Windows.Forms.CheckBox
$CheckBox_Fluent.text            = "Fluent Search"
$CheckBox_Fluent.AutoSize        = $false
$CheckBox_Fluent.width           = 95
$CheckBox_Fluent.height          = 20

$CheckBox_Fluent.location        = New-Object System.Drawing.Point(628,112)
$CheckBox_Fluent.Font            = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Powertoys              = New-Object system.Windows.Forms.CheckBox
$CheckBox_Powertoys.text         = "Powertoys"
$CheckBox_Powertoys.AutoSize     = $false
$CheckBox_Powertoys.width        = 95
$CheckBox_Powertoys.clicked      = $true
$CheckBox_Powertoys.height       = 20
$CheckBox_Powertoys.location     = New-Object System.Drawing.Point(628,78)
$CheckBox_Powertoys.Font         = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_Everything             = New-Object system.Windows.Forms.CheckBox
$CheckBox_Everything.text        = "Everything"
$CheckBox_Everything.AutoSize    = $false
$CheckBox_Everything.width       = 95
$CheckBox_Everything.height      = 20
$CheckBox_Everything.location    = New-Object System.Drawing.Point(628,96)
$CheckBox_Everything.Font        = New-Object System.Drawing.Font('Malgun Gothic',10)

$CheckBox_LaunchMenu             = New-Object system.Windows.Forms.CheckBox
$CheckBox_LaunchMenu.text        = "LaunchMenu"
$CheckBox_LaunchMenu.AutoSize    = $false
$CheckBox_LaunchMenu.width       = 95
$CheckBox_LaunchMenu.height      = 20
$CheckBox_LaunchMenu.location    = New-Object System.Drawing.Point(627,129)
$CheckBox_LaunchMenu.Font        = New-Object System.Drawing.Font('Malgun Gothic',10)

$Install.controls.AddRange(@($Label_Browsers,$CheckBox_Chrome,$CheckBox_Firefox,$CheckBox_Opera,$CheckBox_Brave,$Label_PasswordManagers,$CheckBox_Edge,$CheckBox_Bitwarden,$CheckBox_Keeper,$CheckBox_1Password,$CheckBox_Dashlane,$CheckBox_Lastpass,$CheckBox_NordPass,$CheckBox_Roboform,$Label_Messaging,$CheckBox_Messenger,$CheckBox_Signal,$CheckBox_Teams,$CheckBox_WeChat,$CheckBox_Discord,$CheckBox_Skype,$ProgressBar1,$Button_Start,$Label_Media,$CheckBox_VLC,$CheckBox_Audacity,$CheckBox_Foobar,$CheckBox_iTunes,$CheckBox_MPC,$CheckBox_Voicemeeter,$CheckBox_VoicemeeterBanana,$CheckBox_VoiceMeeterPotato,$CheckBox_Handbrake,$CheckBox_Spotify,$Label_Gaming,$CheckBox_Steam,$CheckBox_Xbox,$CheckBox_GOG,$CheckBox_Battlenet,$CheckBox_Epic,$CheckBox_EADesktop,$Label_Cloud,$CheckBox_OneDrive,$CheckBox_iDrive,$CheckBox_GoogleDrive,$CheckBox_iCloud,$CheckBox_Dropbox,$CheckBox_Malwarebytes,$CheckBox_Kaspersky,$CheckBox_SuperAntiSpyware,$CheckBox_SpybotAntiBeacon,$CheckBox_OOShutUp10,$Label_Security,$CheckBox_Blackbird,$Label_VPN,$CheckBox_KasperskyVPN,$CheckBox_Surfshark,$CheckBox_PIA,$CheckBox_NordVPN,$CheckBox_ExpressVPN,$Label_Compression,$CheckBox_7zip,$CheckBox_WinRAR,$CheckBox_NanaZip,$Label_Search,$CheckBox_FlowLauncher,$CheckBox_Fluent,$CheckBox_Powertoys,$CheckBox_Everything,$CheckBox_LaunchMenu))


#region Logic
<#

$ = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$ = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$ = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$ = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$ = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}

#>
filter Add-TimeStamp {"$(Get-Date -Format g)- $_"}

$Powertoys = @{
    Name = "Microsoft Powertoys"
    Enabled = $False
    PackageName = "Microsoft.Powertoys" # winget
    Source = "winget"
    #PackageID = "XP89DCGQ3K6VLD" # msstore
    #Source = "msstore"
}

# Browsers 
$Chrome = @{
    Name = "Google Chrome"
    Enabled = $False
    PackageName = "Google.Chrome"
    Source = "winget"
}
$Brave = @{
    Name = "Brave Browser"
    Enabled = $False
    PackageName = "Brave.Brave"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Edge = @{
    Name = "Microsoft Edge"
    Enabled = $False
    PackageName = "Microsoft.Edge"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Opera = @{
    Name = "Opera"
    Enabled = $False
    PackageName = "Opera.Opera"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Firefox = @{
    Name = "Mozilla Firefox"
    Enabled = $False
    PackageName = "Mozilla.Firefox"
    Source = "winget"
    AcceptsInput = "Yes"
}

Foreach ($Item in $Chrome, $Brave, $Edge, $Opera, $Firefox){
    If ($Item.Enabled -eq $True){
        $InstallQue += $Item
    }
}


# Password Managers
$Bitwarden = @{
    Name = "Bitwarden"
    Enabled = $False
    PackageName = "Bitwarden.Bitwarden"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Dashlane = @{
    Name = "Dashlane"
    Enabled = $False
    PackageName = "Dashlane.Dashlane"
    Source = "winget"
    AcceptsInput = "Yes"
}
$LastPass = @{
    Name = "LastPass"
    Enabled = $True
    PackageName = "Lastpass"
    URL = "https://download.cloud.lastpass.com/windows_installer/LastPassInstaller.exe"
    Source = "bits"
    AcceptsInput = "No"
}
$1Password = @{
    Name = "1Password"
    Enabled = $False
    PackageName = "Agilebits.1Password"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Keeper = @{
    Name = "Keeper Password Manager"
    Enabled = $False
    PackageName = "Keeper.KeeperDesktop"
    Source = "winget"
    AcceptsInput = "Yes"
    #PackageID = "9N040SRQ0S8C"
    #Source = "msstore"
}
$NordPass = @{
    Name = "NordPass"
    Enabled = $False
    PackageName = "NordSecurity.NordPass"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Roboform = @{
    Name = "RoboForm Password Manager"
    Enabled = $False
    PackageName = "SiberSystems.Roboform"
    Source = "winget"
    AcceptsInput = "Yes"
}

# Messenging 
$Messenger = @{
    Name = "Meta Messenger"
    Enabled = $False
    PackageName = "Facebook.Messenger"
    Source = "winget"
    AcceptsInput = "Yes"
}
$WeChat = @{
    Name = "WeChat by Tencent"
    Enabled = $False
    PackageName = "Tencent.WeChat"
    Source = "winget"
    AcceptsInput = "Yes"
}
$WhatsApp = @{
    Name = "WhatsApp"
    Enabled = $False
    PackageName = "WhatsApp.WhatsApp"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Discord = @{
    Name = "Discord"
    Enabled = $False
    PackageName = "Discord.Discord"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Signal = @{
    Name = "Signal"
    Enabled = $False
    PackageName = "OpenWhisperSystems.Signal"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Telegram = @{
    Name = "Telegram"
    Enabled = $False
    PackageName = "Telegram.TelegramDesktop"
    Source = "winget"
}
$Teams = @{
    Name = "Microsoft Teams"
    Enabled = $False
    PackageName = "Microsoft.Teams"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Skype = @{
    Name = "Skype"
    Enabled = $False
    PackageName = "Microsoft.Skype"
    Source = "winget"
    AcceptsInput = "Yes"
}

# Media
$Voicemeeter = @{
    Name = "Voicemeeter"
    Enabled = $False
    PackageName = "VB-Audio.Voicemeeter"
    Source = "winget"
}
$VoicemeeterBanana = @{
    Name = "Voicemeeter Banana"
    Enabled = $False
    PackageName = "VB-Audio.Voicemeeter.Banana"
    Source = "winget"
}
$VoicemeeterPotato = @{
    Name = "Voicemeeter Potato"
    Enabled = $False
    PackageName = "VB-Audio.Voicemeeter.Potato"
    Source = "winget"
}
$Audacity = @{
    Name = "Audacity"
    Enabled = $False
    PackageName = "Audacity.Audacity"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Spotify = @{
    Name = "Spotify"
    Enabled = $False
    PackageName = "Spotify"
    Source = "winget"
    AcceptsInput = "Yes"
}
$MPC = @{
    Name = "Media Player Classic"
    Enabled = $False
    PackageName = "MediaPlayerClassic"
    Source = "winget"
    AcceptsInput = "Yes"
}
$VLC = @{
    Name = "VLC Media Player"
    Enabled = $False
    PackageName = "Videolan.VLC"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Handbrake = @{
    Name = "Handbrake"
    Enabled = $False
    PackageName = "HandBrake.HandBrake"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Foobar2000 = @{
    Name = "Foobar2000"
    Enabled = $False
    PackageName = "PeterPawlowski.foobar2000"
    Source = "winget"
    AcceptsInput = "Yes"
}
$iTunes = @{
    Name = "iTunes"
    Enabled = $False
    PackageName = "Apple.iTunes"
    Source = "winget"
    AcceptsInput = "Yes"
}

# Gaming 
$Steam = @{
    Name = "Steam"
    Enabled = $False
    PackageName = "Valve.Steam"
    Source = "winget"
    AcceptsInput = "Yes"
}
$BattleNet = @{
    Name = "Battle.net"
    Enabled = $False
    Link = "https://us.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
    Source = "bits"
    AcceptsInput = "Yes"
}
$Epic = @{
    Name = "Epic Games"
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$EADesktop = @{
    Name = "EA Desktop"
    Enabled = $False
    PackageName = "ElectronicArts.EADesktop"
    Source = "winget"
    AcceptsInput = "Yes"
}
$GOG = @{
    Enabled = $False
    PackageName = "GOG.Galaxy"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Xbox = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}


# Compression tools
$7Zip = @{
    Enabled = $False
    PackageName = "7zip"
    Source = "winget"
    AcceptsInput = "Yes"
}
$WinRAR = @{
    Enabled = $False
    PackageName = "RARLabs.WinRAR"
    Source = "winget"
    AcceptsInput = "Yes"
}
$NanaZip = @{
    Enabled = $False
    PackageName = "Nanazip"
    Source = "msstore"
    AcceptsInput = "Yes"
}


# Cloud Services
$OneDrive = @{
    Enabled = $False
    PackageName = "Microsoft.OneDrive"
    Source = "winget"
    AcceptsInput = "Yes"
}
$iCloud = @{
    Enabled = $False
    PackageName = "Apple.iCloud"
    Source = "winget"
    AcceptsInput = "Yes"
}
$Dropbox = @{
    Enabled = $False
    PackageName = "Dropbox"
    Source = "winget"
    AcceptsInput = "Yes"
}
$GoogleDrive = @{
    Enabled = $False
    PackageName = "Google.Drive"
    Source = "winget"
    AcceptsInput = "Yes"
}
$iDrive = @{
    Enabled = $False
    PackageName = "iDrive"
    Source = "winget"
    AcceptsInput = "Yes"
}

# Security
$Kaspersky = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$Malwarebytes = @{
    Enabled = $False
    PackageName = "Malwarebytes"
    Source = "winget"
    AcceptsInput = "Yes"
}
$SpybotAntiBeacon = @{
    Enabled = $False
    PackageName = "SaferNetworking.SpybotAntiBeacon"
    Source = "winget"
    AcceptsInput = "Yes"
}
$OOShutUp10 = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$SuperAntiSpyware = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$Blackbird = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
# VPN's
$ExpressVPN = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$NordVPN = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$Surfshark = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$PIA = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$Kaspersky = @{
    Enabled = $False
    PackageName = ""
    Source = "winget"
    AcceptsInput = "Yes"
}
$Install = @()
Foreach ($Item in $Kaspersky, $ExpressVPN, $NordVPN, $Surfshark, $PIA, $Blackbird, $SuperAntiSpyware, $OOShutUp10, $SpybotAntiBeacon, $Malwarebytes, $iDrive, $GoogleDrive, $Dropbox, $iCloud, $OneDrive, $7zip, $Winrar, $NanaZip, $Xbox, $GOG, $EADesktop, $Epic, $BattleNet, $Steam, $iTunes, $Foobar2000, $Handbrake, $VLC, $MPC, $Spotify, $Audacity ,$VoicemeeterPotato, $VoicemeeterBanana, $Voicemeeter, $Skype, $Teams, $Telegram, $Signal, $Discord, $WhatsApp, $WeChat, $Messenger, $Roboform, $NordPass, $Keeper, $1Password, $LastPass, $Dashlane, $Bitwarden, $Powertoys){
    If ($Item.Checked -eq $True){
        $InstallQue += $Item
    }
}

Foreach ($item in $InstallQue){
    If ($Item.Source -eq "bits") {
        try {
            Write-Host "Downloading package: {$($Item.Name)}" | Add-TimeStamp
            Start-Bitstransfer -Source $Item.URL -Destination ".\" -Dynamic -Asynchronous
        }
        catch {
            Write-Error $_ | Add-Timestamp
        }
    }else { 
        try {
            Write-Host "Installing package: {$($Item.Name)}" | Add-TimeStamp
            winget install $Item.PackageName -s $Item.Source
        }
        catch {
            Write-Error $_ | Add-Timestamp
        }
    }
}


    #endregion

[void]$Install.ShowDialog()