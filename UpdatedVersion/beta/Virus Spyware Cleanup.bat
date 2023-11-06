@echo off
setlocal enabledelayedexpansion

set "params=%*"
set "scriptPath=%~dpnx0"
set "desktopPath=%USERPROFILE%\Desktop\Common Spyware Tools"
set "UserDesktop=%USERPROFILE%\Desktop\Virus Spyware Cleanup.bat"
set "successMessage=no"
set "tempPath=%TEMP%"
set "tempBAT=%tempPath%\temp.bat"

:: Check for admin rights and elevate if necessary
cd /d "%~dp0" && (
    if not exist "%tempPath%\getadmin.vbs" (
        echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd /d ""%~dp0"" && %~s0 %params%", "", "runas", 1 >> "%tempPath%\getadmin.vbs"
    )
) && (
    fsutil dirty query %systemdrive% >nul 2>nul || (
        "%tempPath%\getadmin.vbs" && exit /B
    )
)

title Virus Spyware Cleanup


:continue
if exist C:\temp (
    rmdir "C:\temp" /Q /S 2>nul
) else (
    echo.
    echo "      |\      _,,,---,,_"
    echo "ZZZzz /,`.-'`'    -.  ;-;;,_"
    echo "     |,4-  ) )-,_. ,\ (  `'-'"
    echo "    '---''(_/--'  `-'\_)"
    echo.
    echo C:\Temp does not exist... Skipping
)

echo.
echo Removing traces of ADWCleaner Logs
if exist "C:\ADWCleaner\" (
    rmdir "C:\ADWCleaner" /Q /S 2>nul
) else (
    echo C:\ADWCleaner folder does not exist... Skipping
)


echo.
echo Removing traces of KVRT Logs
if exist "C:\KVRT2020_Data\" (
    rmdir "C:\KVRT2020_Data\" /Q /S
) else (
    echo C:\KVRT2020_Data folder does not exist... Skipping
)

echo.
echo Removing TDSSKiller Log
if exist "C:\TDSSKiller.3.1.0.28_*_*_log.txt" (
    del /F "C:\TDSSKiller.3.1.0.28_*_*_log.txt" /Q 2>nul
) else (
    echo TDSSKiller log in C:\ does not exist... Skipping
)

echo.
echo Removing RKill log file
if exist "%USERPROFILE%\Desktop\Rkill.txt" (
    del /F "%USERPROFILE%\Desktop\Rkill.txt" /Q 2>nul
    echo Rkill.txt removed
) else (
    echo Rkill log file not found.. Skipping
)
if exist "%APPDATA%\Microsoft\Windows\Recent\Rkill.lnk" (
    del /F "%APPDATA%\Microsoft\Windows\Recent\Rkill.lnk" /Q
)





echo.
echo Uninstalling Malwarebytes
if exist "C:\Program Files\Malwarebytes\Anti-Malware\mbuns.exe" (
    "C:\Program Files\Malwarebytes\Anti-Malware\mbuns.exe"
) else (
    echo Malwarebytes is not installed... Skipping
)
if exist "%LocalAppDATA%\mbam" (
    rmdir "%LocalAppDATA%\mbam" /Q /S 2>nul
) else (
    echo %LocalAppDATA%\mbam does not exist... Skipping
)
    if exist "%temp%\mbam" (
    rmdir "%temp%\mbam" /Q /S 2>nul
) else (
    echo %temp%\mbam does not exist... Skipping
)


echo.
echo Finished
timeout 3 > NUL
rmdir "%desktopPath%" /Q /S 2>nul
del "%tempPath%\*.*" /Q /S 2>nul
set successMessage=yes
goto post

:post
    Echo                       Script has Completed. Ready to Close
if %successMessage%==yes (
    echo.
    echo    WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG
    echo.
    echo       DO NOT FORGET TO REMOVE COMMON SPYWARE TOOLS FOLDER FROM THE DESKTOP
    echo.
    echo    WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG:::WaRnInG
    echo.
)
GOTO END


:end
pause
exit
