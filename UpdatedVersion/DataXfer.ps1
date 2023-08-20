[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
[System.Windows.Forms.Application]::EnableVisualStyles()
#/ZB /J /XD $APPDATA /copy:DAT /NDL /NJH /NJS /BYTES /LOG+:output.log

$Form = New-Object system.Windows.Forms.Form
$Form.ClientSize = New-Object System.Drawing.Point(659, 470)
$Form.text = "DataXfer"
$Form.TopMost = $false
$Form.AutoSize = $True
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$Form.MinimizeBox = $False
$Form.MaximizeBox = $False
$Form.WindowState = "Normal"
$Form.SizeGripStyle = "Hide"
$iconBase64 = "AAABAAEAQEAAAAEAIAAoQgAAFgAAACgAAABAAAAAgAAAAAEAIAAAAAAAAEIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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//9Fvf//Rb3//0W8//9FvP//RLz//0S8//9Du///Qrr//0K6//9Buf//QLj//z+4//8+t///PbX//zy0/v87s/7/O7L9/zqx/f85r/z/OK78/zet+/83rPr/Nqn5/zKc8/8sg+b/KnLW/ytv0f8rbtD/K27Q/yttz/8rbc7/K2zN/ytszf8ra8z/KmvL/y1syYEAAAAAAAAAAAAAAAAAAAAAQ674TEG0/PhGuv//Rrr//0e7//9Hu///R7v//0e7//9HvP//R7z//0e8//9Hvf//SL3//0i+//9Ivv//SL7//0i+//9Ivv//SL7//0i+//9Hvv//R77//0e+//9Hvv//Rr7//0a+//9Gvv//Rb3//0W9//9Fvf//RLz//0S8//9Du///Q7r//0K6//9Buf//QLj//z62//89tf//PLT+/zyz/v87sv3/OrH9/zmw/P85r/z/OK37/zeq+v8znvT/LITm/ypz1/8scNL/K2/R/ytu0P8rbtD/K23P/yttzv8rbM3/K2zN/ytrzP8tbMuBAAAAAAAAAAAAAAAAAAAAAEau+ExCt/34Rrv//0i7//9IvP//SLz//0i9//9Ivf//SL3//0i9//9Ivv//SL7//0m+//9Jv///ScD//0nA//9JwP//ScD//0nA//9JwP//SMD//0i///9Iv///SL///0i///9Hv///R7///0e///9Gvv//Rr7//0W+//9Fvf//Rb3//0S8//9Du///Qrr//0G5//8/uP//P7f//z22//89tf7/PLT+/zuz/f87sf3/OrD8/zmv/P84rPv/NJ/1/y2F5/8rc9j/LHDS/yxw0v8sb9H/LG7Q/yxu0P8rbc//K23O/ytszf8rbM3/LWzLgQAAAAAAAAAAAAAAAAAAAABGrvhMQ7j9+Ee8//9Jvf//Sb3//0m+//9Jvv//Sb7//0m+//9Jv///Sb///0m///9Jv///SsD//0rB//9Lwf//SsH//0rB//9Kwf//SsH//0nB//9Jwf//ScH//0nB//9JwP//SMD//0jA//9IwP//R7///0e///9Gv///Rr7//0W+//9Fvf//Rb3//0O8//9Cu///Qbn//0C4//8/t///Prb//z21//88tP7/O7P+/zuy/f86sP3/Oa77/zWg9v8thuf/K3TY/yxx0/8scNL/LHDR/yxv0f8sbtD/LG7P/yxtz/8rbc7/K2zN/y1sy4EAAAAAAAAAAAAAAAAAAAAARrH4TES5/fhIvf//Sr7//0q+//9Kv///Sr///0q///9KwP//SsD//0rA//9LwP//SsD//0vB//9Lwv//TML//0zC//9Lwv//S8L//0vC//9Lwv//S8L//0vC//9Kwv//SsL//0rB//9Jwf//ScH//0jB//9IwP//SMD//0fA//9Hv///Rr///0W+//9Fvf//Q7z//0K7//9Buv//QLn//z+4//8/t///Prb//z20/v88s/7/PLL9/zqv/P81ovb/Lobo/yt02f8tcdT/LXHT/yxw0v8sb9H/LG/R/yxu0P8sbs//LG3P/yttzv8vbs2BAAAAAAAAAAAAAAAAAAAAAEax+ExFuv34Sr///0u///9LwP//S8D//0vA//9LwP//S8H//0zB//9Mwf//S8L//0zC//9Mwv//TcP//03E//9NxP//TMT//03E//9MxP//TMP//0zD//9Mw///TMP//0vD//9Lw///SsP//0rC//9Kwv//ScL//0nB//9Iwf//SMD//0fA//9Gv///Rb7//0S9//9DvP//Q7v//0K6//9Buf//QLj//z+3//8+tv//PbX+/z20/v87sP3/NqP3/y6H6f8sddn/LXLU/y1x1P8tcdP/LXDS/yxv0f8sb9H/LG7Q/yxuz/8sbc//L27NgQAAAAAAAAAAAAAAAAAAAABJsfhMRrv9+EvA//9Mwf//TMH//0zB//9Nwv//TcL//0zC//9Nwv//TcP//03D//9Nw///TcP//07E//9Oxf//TsX//07F//9Oxf//TcX//03F//9Nxf//TcX//03E//9MxP//TMT//0zE//9LxP//S8P//0rD//9Kwv//ScL//0nB//9Iwf//R8D//0W///9Fvv//Rb3//0S9//9DvP//Qrv//0G6//9BuP//P7f//z62//8+tf7/PLL9/zek9/8viOn/LHba/y1y1f8tctT/LXHT/y1x0/8tcNL/LG/R/yxv0f8sbtD/LG7P/y9uzYEAAAAAAAAAAAAAAAAAAAAASbX4TEe8/fhMwf//TcL//03C//9Ow///TsP//07D//9OxP//TsT//07E//9OxP//TsT//07E//9Pxf//T8b//0/G//9Pxv//T8b//07G//9Pxv//Tsb//07G//9Oxv//Tcb//03F//9Nxf//TMX//0zE//9MxP//S8T//0rD//9Kw///ScL//0fB//9GwP//Rr///0W+//9Fvv//RL3//0S8//9Du///Qrr//0C5//9AuP//P7b//z20/v85pvj/MInq/y122/8uc9X/LnLV/y1x1P8tcdP/LXHT/y1w0v8sb9H/LG/R/yxu0P8vcM+BAAAAAAAAAAAAAAAAAAAAAEm1+ExJvv34TcL//07D//9Ow///T8T//0/E//9Pxf//T8X//0/F//9Pxf//UMX//0/G//9Pxv//UMb//1DH//9Qx///Ucj//1HI//9QyP//UMf//1DH//9Px///T8f//0/H//9Oxv//Tcb//03G//9Nxv//TMX//0zF//9MxP//S8T//0rD//9Iwv//SMH//0fA//9GwP//Rr///0W+//9Evf//RLz//0O7//9Cuv//Qbn//0C4//8/tf7/Oaf5/zCK6v8td9v/LnPW/y5z1f8uctX/LXLU/y1x0/8tcdP/LXDS/y1v0f8tb9H/L3DPgQAAAAAAAAAAAAAAAAAAAABJtfhMSr/9+E7E//9QxP//UMX//1DF//9Qxv//UMb//1DG//9Qxv//Ucf//1HH//9Qx///UMf//1DH//9RyP//Usn//1LJ//9Syf//Ucn//1HJ//9Ryf//Ucn//1HI//9QyP//UMj//0/I//9Px///Tsf//07G//9Oxv//Tcb//0zF//9LxP//ScP//0jC//9Iwf//R8H//0fA//9Gv///Rb7//0S+//9Evf//Q7z//0O7//9Buf//QLb//zuo+f8xi+v/LXfc/y501/8uc9b/LnPV/y5y1f8tctT/LnHT/y1x0/8tcNL/LW/R/y9wz4EAAAAAAAAAAAAAAAAAAAAATbj4TEzA/fhPxf//Ucb//1HG//9Rxv//Usf//1LH//9Sx///Usj//1HI//9SyP//Usj//1LI//9Syf//Usn//1PK//9Tyv//U8r//1PK//9Syv//Usr//1LK//9Syv//Usn//1HJ//9Ryf//UMj//1DI//9PyP//T8f//07H//9Nxv//S8X//0rE//9Kw///ScP//0jC//9Iwf//R8D//0bA//9Gv///Rb7//0S9//9EvP//Q7v//0G4//87qvr/Mozr/y543P8vdNf/L3TW/y5z1v8uc9X/LnLU/y5y1P8tcdP/LXHT/y1w0v8vcNGBAAAAAAAAAAAAAAAAAAAAAE24+0xMwf34Ucb//1LH//9Sx///U8j//1PI//9TyP//U8n//1PJ//9Tyf//U8n//1PK//9Tyv//U8r//1PK//9Uy///VMv//1XM//9Vy///VMz//1TL//9Uy///U8v//1PL//9Syv//Usr//1HK//9Ryf//Ucn//1DI//9PyP//Tsf//0zG//9Mxf//S8T//0rE//9Jw///ScL//0jB//9Hwf//R8D//0a///9Fvv//Rb3//0S8//9Cuf//Pav6/zKM7P8ued3/L3XY/y901/8vdNb/L3PW/y5z1f8uctT/LnLU/y5x0/8ucdL/MXLRgQAAAAAAAAAAAAAAAAAAAABNuPtMTcL++FLI//9TyP//VMn//1TJ//9Uyv//VMr//1XK//9Vyv//VMv//1TL//9Uy///Vcv//1TL//9Vy///Vsz//1jO//9d0f//X9P//1/T//9f0v//XtL//17S//9e0v//XdH//13R//9c0f//W9D//1vQ//9Xzv//Ucr//0/I//9Nx///Tcb//0zF//9Lxf//SsT//0rD//9Jw///SML//0jB//9HwP//Rr///0W+//9Fvf//Q7v//z2t+/8zjez/L3nd/zB12P8vddj/L3TX/y901v8uc9b/LnPV/y5y1P8uctT/LnHT/zFy0YEAAAAAAAAAAAAAAAAAAAAATbj7TE7E/vhUyf//Vcr//1XK//9Vy///Vsv//1bL//9Wy///Vsz//1bM//9WzP//Vsz//1bM//9Wzf//Vs3//1jO//9l1P//Ycz8/1Ow7/9Rq+v/Uazt/1Gt7f9Rre7/Ua3u/1Gt7v9Rre7/Ua3u/1Ct7f9Qrez/V7jx/1nO/f9Qyv//Tsj//07H//9Nx///TMb//0zF//9LxP//SsT//0nD//9Jwv//SMH//0fA//9Gv///Rb7//0W7//8+rfv/M47t/y963v8wdtn/L3bY/y912P8vdNf/L3TW/y9z1v8uc9X/LnLU/y5y1P8xctOBAAAAAAAAAAAAAAAAAAAAAFC7+0xQxf74Vcr//1fL//9Xy///V8z//1fM//9Xzf//V83//1fN//9Xzf//V87//1fO//9Yzv//V87//1fO//9Zz///Vb/9/x9a3P8JH67/Cx6r/wser/8LILL/DCC0/wwhtf8MIbT/CyG0/wsgs/8LH7D/Cx6s/xAprv9Anuf/Ucv//0/J//9PyP//Tsj//03H//9Nxv//TMb//0vF//9LxP//SsP//0jC//9Iwf//R8D//0a///9FvP//P677/zSO7f8vet7/MHfZ/zB22f8wddj/MHXY/y911/8vdNb/L3PW/y9z1f8vctT/MXLTgQAAAAAAAAAAAAAAAAAAAABQu/tMUcb++FbL//9YzP//WM3//1jN//9Yzf//Wc7//1nO//9Zzv//WM///1nP//9Zz///Wc///1jP//9Yz///V87//zqd+P8JJ8n/AQ+h/wYTov8HE6f/BxWr/wgWrf8IFq7/CBau/wgWrf8IFqz/CBWq/wcUp/8HFKP/LHvZ/1DL//9Qyv//T8n//0/J//9OyP//Tsf//03G//9Mxv//TMX//0rE//9Jw///SML//0jB//9HwP//Rr3//z+v/P80j+3/MHre/zB32f8wdtn/MHbZ/zB12P8wddf/L3XX/y901v8vc9b/L3PV/zF004EAAAAAAAAAAAAAAAAAAAAAULv7TFLH/vhYzf//Wc7//1rO//9az///Ws///1rP//9az///WtD//1rQ//9a0P//WtD//1rQ//9a0P//WdD//1fO//87pvr/EETd/wUhu/8GILX/BiG6/wYivf8GIr//BiPA/wYjwP8GIr//BiK+/wYhvP8GILn/Ci6+/zab7/9Qy///Ucv//1DK//9Qyv//T8n//07I//9Nx///Tcf//0zG//9Lxf//SsT//0rD//9Jwv//SMH//0e+//9AsPz/NI/t/zB63v8xd9n/MHfZ/zB22f8wdtn/MHbY/zB12P8wddf/L3TW/y9z1v8xdNOBAAAAAAAAAAAAAAAAAAAAAFO/+0xUyf74Ws///1vP//9c0P//XND//1zQ//9c0f//XNH//1zR//9c0v//XNL//1zS//9b0f//W9H//1rR//9Z0f//Ucj//zup+v8zmPb/Mpf2/zKX9v8xl/b/MZb2/zCW9v8wlfb/MJT2/y+U9v8vk/X/LpL1/zej+P9Mxv//Usz//1HM//9Ry///Ucv//1HK//9Qyv//T8n//0/I//9Ox///Tcb//0zF//9MxP//S8P//0rC//9IwP//QrL8/zWQ7f8wet7/MXfZ/zF32f8xdtn/MXbZ/zB22f8wddj/MHXY/zB11/8vdNb/MXTVgQAAAAAAAAAAAAAAAAAAAABTv/tMVsv++FzR//9e0f//XtH//17S//9e0v//XtP//17T//9d0///XtP//17T//9d0///XdP//1zT//9c0///XNP//1vS//9a0v//WdH//1nR//9Y0P//WND//1fQ//9Wz///Vs///1XP//9Uzv//VM7//1TN//9Uzf//VM7//1PN//9Tzf//Usz//1LM//9Sy///Ucr//1DK//9Qyf//T8n//0/I//9Ox///Tcb//0zF//9LxP//SsH//0S0/f83ku7/MXve/zF32f8xd9n/MXfZ/zF22f8xdtn/MXbZ/zB22P8wddj/MHTX/zN01YEAAAAAAAAAAAAAAAAAAAAAXcf7Sl3Q/vdh1P//YtT//2PV//9j1f//Y9X//2PW//9j1v//Y9b//2LW//9j1///Y9f//2PX//9j1///Ytf//2LX//9h1///Ydf//2HX//9g1///YNb//1/W//9f1v//XtX//17V//9d1P//XNT//1zT//9b0///WtL//1nS//9Z0f//WND//1fQ//9Wz///Vs7//1XN//9UzP//U8z//1LL//9Syv//Ucn//1DI//9Px///Tsb//07E//9JuP3/OpXv/zJ93/8yeNr/Mnja/zN52v8zeNr/NHna/zR52v81etr/Nnra/zd62v85fdp4AAAAAAAAAAAAAAAAAAAAAI7g/jKI4v7qfuH//33h//994f//feL//3zi//994v//feL//33j//994///feP//3zj//984///fOP//3zj//974///e+P//3rj//964v//eeL//3ji//944v//d+H//3fh//924f//deD//3Xg//903///c9///3Le//9x3v//cd3//3Dc//9v3P//btv//23a//9s2v//a9n//2vY//9p1///aNb//2jV//9n1P//ZtP//2XS//9k0f//X8f//1Oq9v9Ulef/V5Tj/1uX5P9gmuX/ZZ3m/2qg5/9wpOj/dqfp/3ur6v9+rOrxc6TmSQAAAAAAAAAAAAAAAAAAAADM//8KwPT+j6zw/uyh7v75ou/++aHu/vqh7/76oe/++qHv/vqh7/77ou/9/qLw/v+i8P7/ofD+/6Hw/v+g8P7/n/D+/5/w/v+e7/7/ne/+/5zv/v+c7/7/m+/+/5ru/v+a7v7/me7+/5jt/v+Y7f7/l+3+/5bs/v+V7P7/lOv+/5Pr/v+S6v7/ker//5Dp//+P6f//juj//43n//+M5v//iub//4nl//+I5P//h+P//4bj//+E4v//guD//3vY//+IzPz/qcz2/LLQ9/i20/j0utX5773X+erA2Pnkw9v73Mbc+9TG2/vDw9r6cLLM/woAAAAAAAAAAAAAAAAAAAAAAAAAANDn/gvP9f42x/X+Tsb1/lHH9ftSyvj+Usf4/lPF9f5Uyfb5WuP6z7Ps/Lf77Pyx/+z8r//r+63/6/qq/+r4p//q96T/6fWi/+nzov/o8qL/5/Ci/+fuov/n7KL/5+mg/+bllv/l3Yf/4tWJ/9/Uov/d16f/3dmd/9zZjf/e4If/4/Ge/+PzqP/i8qv/4fCr/+DvrP/g7az/3+qs/93npv/b4Zr/2dqP/9fUj//T0Jr/0NCq/8/Ur//R1az/29aq6dni23TT6v5M1+v+QdXn/jfY6P4u3Or+Jd3u/x7d6P4X2uz+Dv///wIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD+/qMZ/v6Snf39g/n//nr///12///7cf//+Wz///dn///1Yv//82D///Be///tXv//6lz//+db///iUv/+2jn//c4n//jFQP/0xmP/88pj//TNWP/10UHx++xU+v/3X///9WD///Ng///wX///7V///+pg//7nXP/94Ez/+9Yz//nLIv/1wSj/77s//+u9WP/sw17/7chh5e7NaF3MzGYFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//lhH+/o6K/v5+9P/+dP///G////pq///4Zf//9mD///Rc///xW///71r//+xZ///pVf//40L//tko//zPLv/2y1j/9c5m//XSZP721mHO+N5iTv79gof/+3Lw//hk///1X///8l3//+9c///sXP//6VX//uI///vYKP/5zh//9MUt/+/BSv/txVr/7spg3O7OZ0+/v38EAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA////Af//fwb//38CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA///////////////////////////////////////////wAAAAAAAD/8AAAAAAAAAHwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA8AAAAAAAAADwAAAAAAAAAPAAAAAAAAAA+AAAAAAAAAH//AAAAAAD///+AAAAAAf///8AAAAAD////4AAOAAf////wAB+AD/////gAP8A//////AB/4H//////AP////////+B/////////8f/////8="
$iconBytes = [Convert]::FromBase64String($iconBase64)
# initialize a Memory stream holding the bytes
$stream = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$Form.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))


Function Backup-ProgramDataForCustomer {
    $Brave = @{
        Name        = "Brave"
        Location    = "$SourceFolder\AppData\Local\BraveSoftware"
        Destination = "$DestinationFolder\Browsers\Local"
    }
    $Chrome = @{
        Name        = "Google Chrome"
        Location    = "$SourceFolder\AppData\Local\Google\Chrome"
        Destination = "$DestinationFolder\Browsers\Local"
    }
    $ChromeBeta = @{
        Name        = "Google Chrome Beta"
        Location    = "$SourceFolder\AppData\Local\Google\Chrome Beta"
        Destination = "$DestinationFolder\Browsers\Local"
    }
    $Chromium = @{
        Name        = "Chromium"
        Location    = "$SourceFolder\AppData\Local\Chromium"
        Destination = "$DestinationFolder\Browsers\Local"
    }
    $Edge = @{
        Name        = "Microsoft Edge"
        Location    = "$SourceFolder\AppData\Local\Microsoft\Edge"
        Destination = "$DestinationFolder\Browsers\Local"
    }
    $EMClient = @{
        Name        = "EMClient"
        Location    = "$SourceFolder\AppData\Roaming\eM Client"
        Destination = "$DestinationFolder\Mail\eM Client"
    }
    $Firefox = @{
        Name        = "Mozilla Firefox"
        Location    = "$SourceFolder\AppData\Roaming\Mozilla"
        Destination = "$DestinationFolder\Browsers\Roaming"
    }
    $Outlook = @{
        Name        = "Microsoft Outlook"
        Location    = "$SourceFolder\Documents\Outlook Files"
        Location1   = "$SourceFolder\AppData\Microsoft\Outlook"
        Destination = "$DestinationFolder\Mail\Outlook"
    }
    $Opera = @{
        Name        = "Opera & GX"
        Location    = "$SourceFolder\AppData\Roaming\Opera Software"
        Destination = "$DestinationFolder\Browsers\Roaming"
    }
    $Thunderbird = @{
        Name        = "Thunderbird"
        Location    = "$SourceFolder\AppData\Roaming\Thunderbird"
        Destination = "$DestinationFolder\Mail\Thunderbird"
    }
    $WLM = @{
        Name         = "Windows Live Mail"
        Location     = "$SourceFolder\AppData\Local\Windows Live"
        Location1    = "$SourceFolder\AppData\Local\Microsoft\Windows Live Mail"
        Destination  = "$DestinationFolder\Mail\Local\"
        Destination1 = "$DestinationFolder\Mail\Local\Microsoft\"
    }

    # Function to check existence and add to the array if exists
    $Global:programsToBackup = [System.Collections.ArrayList]::new()

    # Check existence and add to the array if true
    CheckAndAdd $Brave.Location $Brave.Destination
    CheckAndAdd $Chrome.Location $Chrome.Destination
    CheckAndAdd $ChromeBeta.Location $ChromeBeta.Destination
    CheckAndAdd $Chromium.Location $Chromium.Destination
    CheckAndAdd $Edge.Location $Edge.Destination
    CheckAndAdd $EMClient.Location $eMClient.Destination
    CheckAndAdd $Firefox.Location $Firefox.Destination
    CheckAndAdd $Outlook.Location $Outlook.Destination
    CheckAndAdd $Outlook.Location1 $Outlook.Destination
    CheckAndAdd $Opera.Location $Opera.Destination
    CheckAndAdd $Thunderbird.Location $Thunderbird.Destination
    CheckAndAdd $WLM.Location $WLM.Destination
    CheckAndAdd $WLM.Location1 $WLM.Destination


    $TransferText = " Preparing to transfer Browser Data data. Please wait...
    
        Detected Programs: $Proggies
    "

    If ($Programs) {
        #count the source files
        $outputBox.AppendText($TransferText)
        if ($Textbox_Source.text -notlike $Null) {
            $sourcefiles = robocopy.exe $EdgePath $EdgePath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
            If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
        }
    }
}

function CheckAndAdd($location, $dest) {
    if (Test-Path $location) {
        If ($programsToBackup -like $null) { $programsToBackup = $location } else {
            $programsToBackup = "$programsToBackup $location"
        }
    }
}
# region brave backup
Function Backup-BraveData {
    begin {
        $progressbar.Value = 0
        $BravePath = "$SourceFolder\AppData\Local\BraveSoftware"
        $BraveExists = Test-Path $BravePath
    } process {
        If ($BraveExists) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Brave data. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                # counts amount of files to transfer
                $sourcefiles = robocopy.exe $BravePath $BravePath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            # creates backup brave folder
            New-Item "$DestinationFolder\Browsers\Brave" -ItemType Directory -Force
            # initiates robocopy
            $run = robocopy.exe $BravePath "$DestinationFolder\Browsers\Brave" /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
    } end {
        $progressbar.Value = 100
    }
}
# end region

# region chrome backup
Function Backup-ChromeData {
    begin {
        $progressbar.Value = 0
            $ChromePath = "$SourceFolder\AppData\Local\Google"
            $ChromeExists = Test-Path $ChromePath
    } process {
        If ($ChromeExists) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Chrome data. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                # counts files
                $sourcefiles = robocopy.exe $ChromePath $ChromePath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            # creates google backup folder
            New-Item "$DestinationFolder\Browsers\Google" -ItemType Directory -Force
            # initiates robocopy
            $run = robocopy.exe $ChromePath "$DestinationFolder\Browsers\Google" /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
    } end {
        $progressbar.Value = 100
    }
}
# end region

# region edge
Function Backup-EdgeData {
    begin {
        $progressbar.Value = 0
        $EdgePath = "$SourceFolder\AppData\Local\Microsoft\Edge"
        $EdgeExists = Test-Path $EdgePath
    } process {
        If ($EdgeExists) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Microsoft Edge data. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                $sourcefiles = robocopy.exe $EdgePath $EdgePath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            # creates edge folder
            New-Item "$DestinationFolder\Browsers\Edge" -ItemType Directory -Force
            # initiates robocopy
            $run = robocopy.exe $EdgePath "$DestinationFolder\Browsers\Edge" /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
    } end {
        $progressbar.Value = 100
    }
}
# end region

# region firefox backup
Function Backup-FirefoxData {
    begin {
        $progressbar.Value = 0
        $FirefoxPath = "$SourceFolder\AppData\Roaming\Mozilla"
        $FirefoxExists = Test-Path $FirefoxPath
        $LocalFirefoxPath = "$SourceFolder\AppData\Local\Mozilla"
        $LocalFirefoxExists = Test-Path $LocalFirefoxPath
    } process {
        If ($FirefoxExists) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Firefox data. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                $sourcefiles = robocopy.exe $FirefoxPath $FirefoxPath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            New-Item "$DestinationFolder\Browsers\Mozilla\Roaming" -ItemType Directory -Force
            $run = robocopy.exe $FirefoxPath "$DestinationFolder\Browsers\Mozilla\Roaming" /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
        If ($LocalFirefoxExists) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Firefox data. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                $sourcefiles = robocopy.exe $LocalFirefoxPath $LocalFirefoxPath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            New-Item "$DestinationFolder\Browsers\Mozilla\Local" -ItemType Directory -Force
            $run = robocopy.exe $LocalFirefoxPath "$DestinationFolder\Browsers\Mozilla\Local" /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
    } end {
        $progressbar.Value = 100
    }
}
# end region


# region opera backup
Function Backup-OperaData {
    begin {
        # sets progress to 0
        $progressbar.Value = 0
        $OperaPath = "$SourceFolder\AppData\Roaming\Opera Software"
        # checks if opera exists
        $OperaExists = Test-Path $OperaPath
    } process {
        If ($OperaExists) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Chrome data. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                # scans files with robocopy for progress bar
                $sourcefiles = robocopy.exe $OperaPath $OperaPath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            # creates the browser folder
            $browsersFolder = "$DestinationFolder\Browsers"
            If (!$browsersFolder) { New-Item $browsersFolder -ItemType Directory -Force }
            # backs up opera
            $run = robocopy.exe $OperaPath $browsersFolder /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
    } end {
        $progressbar.Value = 100
    }
}
# end region



# region windows live mail backup

Function Backup-CustomersWindowsLiveMailData {
    begin {
        $run = $null ; $run | Out-Null
        $progressbar.Value = 0
        $LiveMailPath = "$SourceFolder\AppData\Local\Microsoft\Windows Live Mail"
        $LiveMailContactsPath = "$SourceFolder\AppData\Local\Windows Live"
        $LiveMail = Test-Path $LiveMailPath
        $LiveMailContacts = Test-Path $LiveMailContactsPath
    } process {
        If ($LiveMail) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Windows Live Mail data. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                # counts amount of files to transfer
                $sourcefiles = robocopy.exe $LiveMailPath $LiveMailPath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            # creates mail folder
            New-Item "$DestinationFolder\Mail" -ItemType Directory -Force
            # initiates robocopy outputting to winform
            $run = robocopy.exe $LiveMailPath "$DestinationFolder\Mail" /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
        If ($LiveMailContacts) {
            #count the source files
            $outputBox.AppendText(" Preparing to transfer Windows Live Mail contacts. Please wait...")
            if ($Textbox_Source.text -notlike $Null) {
                # counts amount of files to transfer
                $sourcefiles = robocopy.exe $LiveMailContactsPath $LiveMailContactsPath /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
                If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
            }
            $outputBox.Focus()
            # initiates robocopy outputting to winform
            $run = robocopy.exe $LiveMailContactsPath "$DestinationFolder\Mail" /E /ZB /J /R:3 /W:1 /NP | ForEach-Object {
                $ErrorActionPreference = "silentlycontinue"
                #calculate percentage
                $i++
                [int]$pct = ($i / $filecount) * 100
                #update the progress bar
                $progressbar.Value = ($pct)
                $outputBox.AppendText($_ + "`r`n")
                [void] [System.Windows.Forms.Application]::DoEvents()
            }
        }
    }
    end {
        $progressbar.Value = 100
    }
}# end region


# region folder selector

Function Get-Folder($initialDirectory) {
    # loads winform
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    # loads folder dialog
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    # default view to MyComputer
    $FolderBrowserDialog.RootFolder = 'MyComputer'
    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    # shows the dialog
    [void] $FolderBrowserDialog.ShowDialog()
    # returns the value
    return $FolderBrowserDialog.SelectedPath
}
# end region


# region robocopy

function Invoke-RoboCopy {
    begin {
        $run = $null ; $run | Out-Null
        $Button_Start.Enabled = $false
        $Button_Source.Enabled = $false
        $Textbox_Source.Enabled = $false
        $Button_Destination.Enabled = $false
        $Textbox_Destination.Enabled = $false
    

        If ( $Textbox_Source.text -like $null ) {
            # asks user where they'd like to backup from
            $Global:SourceFolder = Get-Folder
            $Textbox_Source.Text = $SourceFolder
        }
        
        #$CheckTextBox1 = Test-Path $Textbox_Destination.Text -ErrorAction SilentlyContinue
        If ( $Textbox_Destination.text -like $null ) {
            # asks user where they'd like to backup to
            $Global:DestinationFolder = Get-Folder
            $Textbox_Destination.Text = $DestinationFolder
        }
    }
    process {
        #count the source files
        $outputBox.text = " Preparing to Robocopy. Please wait..."
        if ($Textbox_Source.text -notlike $Null) {
            # counts the files
            $sourcefiles = robocopy.exe $Textbox_Source.text $Textbox_Source.text /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
            If ($sourcefiles[-5] -match '^\s{3}Files\s:\s+(?<Count>\d+).*') { $filecount = $matches.Count }
        }
        $outputBox.Focus()
        # initiates robocopy
        $run = robocopy.exe $Textbox_Source.text $Textbox_Destination.Text /E /ZB /J /R:3 /W:1 /NP /XD "Application Data",
        "Appdata" "Cookies" "Local Settings" "My Documents" "SendTo" "NetHood" "PrintHood" "Recent" "SendTo", 
        "Start Menu" "Templates" /XF "Desktop.ini" "*ntuser*" | ForEach-Object {
            $ErrorActionPreference = "silentlycontinue"
            #calculate percentage
            $i++
            [int]$pct = ($i / $filecount) * 100
            #update the progress bar
            $progressbar.Value = ($pct)
            $outputBox.AppendText($_ + "`r`n")
            [void] [System.Windows.Forms.Application]::DoEvents()
        }
    }end {
        $progressbar.Value = 100
    }
}
# end region

# region scanforpst

Function ScanForPST {
    # Scan user's documents folder for .pst files
    $UserProfilePSTs = Get-ChildItem -Path $Env:userprofile\documents -Include "*.pst" , "*.ost" -Recurse -ErrorAction SilentlyContinue
    # Scan local AppData for .pst files
    $LocalAppDataPSTs = Get-ChildItem -Path $Env:localappdata -Include "*.pst" , "*.ost" -Recurse -ErrorAction SilentlyContinue
    # Scan roaming AppData for .pst files (note: you are using "*.ps1" as the filter here)
    $RoamingAppDataPSTs = Get-ChildItem -Path $Env:appdata -Include "*.pst" , "*.ost" -Recurse -ErrorAction SilentlyContinue
    # Check if any .pst files were found in either local or roaming AppData
    if ($LocalAppDataPSTs -or $RoamingAppDataPSTs) {
        Write-Host "Found .pst files in local or roaming AppData."
    }
    else {
        Write-Host "No .pst files found."
    }
    # Return the list of .pst files in the user's documents folder
    return $UserProfilePSTs
    <#
    ScanForPST | ForEach-Object {
    Copy-Item $_ "$DestinationFolder\PST"
    }
    #>
}
# end region


# region question
Function Show-Question() {
    [CmdletBinding()]
    param (
        [String] $Title = "DataXfer",
        [String] $Message = "pRoBlEm?",
        [Switch] $YesNo,
        [Switch] $YesNoCancel,
        [ValidateSet("None", "Information", "Question", "Warning", "Error")]
        [String] $Icon = "None"
    )

    $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Question

    switch ($Icon) {
        "None" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::None }
        "Information" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Information }
        "Question" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Question }
        "Warning" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Warning }
        "Error" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Error }
    }

    if ($YesNoCancel) {
        # plays a chime to grab users attention
        Start-Chime
        # dispays the question
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNoCancel, $iconFlag)
    }
    elseif ($YesNo) {
        # plays a chime to grab users attention
        Start-Chime
        # dispays the question
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNo, $iconFlag)
    }

    return $result
}
# end region

# region chime

function Start-Chime {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        $File = "C:\Windows\Media\Alarm06.wav"
    )

    # Check if the file exists before attempting to play the sound
    if (Test-Path $File) {
        try {
            # Create a SoundPlayer object and load the sound file
            $soundPlayer = New-Object System.Media.SoundPlayer
            # locates and loads sound files
            $soundPlayer.SoundLocation = $File
            if ($PSCmdlet.ShouldProcess("Play the sound", "Play sound from $File")) {
                # Play the sound
                $soundPlayer.Play()
                # Dispose the SoundPlayer object to release resources
                $soundPlayer.Dispose()
            }
        }
        catch {
            Write-Error "An error occurred while playing the sound: $_.Exception.Message"
        }
    }
    else {
        Write-Error "The sound file doesn't exist at the specified path."
    }
}
# end region

# region robocopy manual cancel

function Stop-RoboCopy {
    # checks if robocopy is running
    if (get-process -Name robocopy -ErrorAction SilentlyContinue) {
        # stops robocopy
        Stop-Process -Name robocopy -Force
        $timestamp = (Get-Date).ToString('yyyy/MM/dd hh:mm:ss')
        $outputBox.AppendText("`n`r$timestamp Robocopy process has been terminated.")
    }
}
# end region

$Button_Cancel = New-Object system.Windows.Forms.Button
$Button_Cancel.text = "Cancel"
$Button_Cancel.width = 68
$Button_Cancel.height = 20
$Button_Cancel.location = New-Object System.Drawing.Point(576, 19)
$Button_Cancel.Font = New-Object System.Drawing.Font('Microsoft JhengHei UI', 9)
$Form.Controls.Add($Button_Cancel)

$Button_Destination = New-Object system.Windows.Forms.Button
$Button_Destination.text = "Browse"
$Button_Destination.width = 68
$Button_Destination.height = 20
$Button_Destination.location = New-Object System.Drawing.Point(482, 175)
$Button_Destination.Font = [System.Drawing.Font]::new('Microsoft JhengHei UI', 9 )
$Form.Controls.Add($Button_Destination)

$Button_Source = New-Object system.Windows.Forms.Button
$Button_Source.text = "Browse"
$Button_Source.width = 68
$Button_Source.height = 20
$Button_Source.location = New-Object System.Drawing.Point(482, 67)
$Button_Source.Font = [System.Drawing.Font]::new('Microsoft JhengHei UI', 9)
$Form.Controls.Add($Button_Source)

$Button_Start = New-Object system.Windows.Forms.Button
$Button_Start.text = "Start"
$Button_Start.width = 60
$Button_Start.height = 30
$Button_Start.location = New-Object System.Drawing.Point(587, 428)
#$Button_Start.Font               = New-Object System.Drawing.Font('Microsoft JhengHei UI',9)
$Button_Start.Font = [System.Drawing.Font]::new('Microsoft JhengHei UI', 9)
$Form.Controls.Add($Button_Start)

$Label_Destination = New-Object system.Windows.Forms.Label
$Label_Destination.text = "Destination:"
$Label_Destination.AutoSize = $true
$Label_Destination.width = 25
$Label_Destination.height = 10
$Label_Destination.location = New-Object System.Drawing.Point(52, 178)
$Label_Destination.Font = [System.Drawing.Font]::new('Microsoft JhengHei UI', 10)
$Form.Controls.Add($Label_Destination)

$Label_Source = New-Object system.Windows.Forms.Label
$Label_Source.text = "Source:"
$Label_Source.AutoSize = $true
$Label_Source.width = 25
$Label_Source.height = 10
$Label_Source.location = New-Object System.Drawing.Point(90, 70)
$Label_Source.Font = [System.Drawing.Font]::new('Microsoft JhengHei UI', 10)
$Form.Controls.Add($Label_Source)

#Output box
$outputBox = New-Object System.Windows.Forms.RichTextBox 
$OutputBox.location = New-Object System.Drawing.Point(45, 222)
$outputBox.Size = New-Object System.Drawing.Size(570, 180)
$outputBox.MultiLine = $True
$outputBox.ReadOnly = $True
#$outputBox.WordWrap             = $False
$outputBox.ScrollBars = "Both"
$outputBox.Font = "Microsoft JhengHei UI"
$Form.Controls.Add($outputBox)

$Textbox_Destination = New-Object system.Windows.Forms.TextBox
$Textbox_Destination.multiline = $false
$Textbox_Destination.width = 327
$Textbox_Destination.height = 20
$Textbox_Destination.location = New-Object System.Drawing.Point(152, 175)
$Textbox_Destination.Font = [System.Drawing.Font]::new('Microsoft JhengHei UI', 10)
$Form.Controls.Add($Textbox_Destination)

$Textbox_Source = New-Object system.Windows.Forms.TextBox
$Textbox_Source.multiline = $false
$Textbox_Source.width = 327
$Textbox_Source.height = 20
$Textbox_Source.location = New-Object System.Drawing.Point(152, 67)
$Textbox_Source.Font = [System.Drawing.Font]::new('Microsoft JhengHei UI', 10)
$Form.Controls.Add($Textbox_Source)



$Button_Source.Add_Click({
        # asks user what folder they want to backup from
        $Global:SourceFolder = Get-Folder
        if ($SourceFolder -ne $null) {
            $TextBox_Source.text = $SourceFolder
        }
    })

$Button_Destination.Add_Click({
        # asks user what folder they want to backup to
        $Global:DestinationFolder = Get-Folder
        if ($DestinationFolder -ne $null) {
            $TextBox_Destination.text = $DestinationFolder
        }
    })

$Button_Start.Add_Click({
        # Runs robocopy
        Invoke-RoboCopy
        # Runs brave backup
        Backup-BraveData
        # Runs edge backup
        Backup-EdgeData
        # Runs chrome backup
        Backup-ChromeData
        # Runs firefox backup
        Backup-FirefoxData
        # Runs opera backup
        Backup-OperaData
        # Runs WLM backup
        Backup-WindowsLiveMailData
        $outputBox.AppendText("Transfer Completed")
        $Button_Start.Enabled = $true
        $Button_Source.Enabled = $true
        $Textbox_Source.Enabled = $true
        $Button_Destination.Enabled = $true
        $Textbox_Destination.Enabled = $true
        $OpenExplorer = Show-Question -Title "DataXfer" -Message "Transfer Completed. Would you like to open explorer?" -YesNo -Icon Question
        If ($OpenExplorer -eq $true) { explorer $DestinationFolder }
    })
$Button_Cancel.Add_Click({ Stop-RoboCopy })

$ProgressBar = New-Object system.Windows.Forms.ProgressBar
$ProgressBar.Visible = $true
$progressBar.Style = "Continuous"
$ProgressBar.width = 563
$ProgressBar.height = 21
$ProgressBar.location = New-Object System.Drawing.Point(11, 433)

#initialize a counter
$i = 0


$Form.Controls.Add($progressBar)
$Form.Add_Shown({ $Form.Activate() })
[void]$Form.ShowDialog()