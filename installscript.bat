@echo off
setlocal EnableDelayedExpansion

:: Check for winget and install/update if needed
:checkWinget
where winget >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing winget...
    powershell -Command "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe" >nul 2>&1
    if !errorlevel! neq 0 (
        echo Failed to install winget. Please install it manually from the Microsoft Store.
        pause
        exit /b 1
    )
) else (
    echo Checking for winget updates...
    winget upgrade --id Microsoft.DesktopAppInstaller >nul 2>&1
)

:: Start the script by going to the main menu
goto main

:: Add these functions at the start of the file
:showProgress
set /a "progress=%~1"
set "bar="
for /l %%i in (1,1,50) do (
    if %%i leq !progress! (
        set "bar=!bar!█"
    ) else (
        set "bar=!bar!░"
    )
)
echo [!bar!] !progress!%%
exit /b

:installProgram
echo Installing %~1...
for /l %%i in (0,2,100) do (
    call :showProgress %%i
    timeout /t 1 /nobreak >nul
    cls
    if %%i equ 100 (
        echo %~1 installed successfully!
        timeout /t 2 /nobreak >nul
    )
)
exit /b

:main
cls
echo Welcome to New PC Setup
echo Press any key to continue...
pause >nul
goto menu

:menu
cls
echo ================================
echo         New PC Setup
echo ================================
echo.
echo [1] Debloat Windows
echo [2] Install Programs
echo [3] Exit
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" goto debloat
if "%choice%"=="2" goto install
if "%choice%"=="3" (
    cls
    echo Thank you for using New PC Setup
    echo Press any key to exit...
    pause >nul
    goto :eof
)
goto menu

:debloat
cls
echo Checking for unnecessary apps...
echo.
echo The following apps can be removed:
echo [1] Cortana
echo [2] Xbox Apps
echo [3] Skype
echo [4] Microsoft News
echo [5] Return to main menu
echo.
set /p debloat_choice="Enter numbers to remove (separate with spaces) or 5 to return: "
if "%debloat_choice%"=="5" goto menu

echo %debloat_choice% | find "1" >nul && (
    powershell -command "Get-AppxPackage *Microsoft.549981C3F5F10* | Remove-AppxPackage"
    echo Removed Cortana
)
echo %debloat_choice% | find "2" >nul && (
    powershell -command "Get-AppxPackage *Xbox* | Remove-AppxPackage"
    echo Removed Xbox Apps
)
echo %debloat_choice% | find "3" >nul && (
    powershell -command "Get-AppxPackage *Skype* | Remove-AppxPackage"
    echo Removed Skype
)
echo %debloat_choice% | find "4" >nul && (
    powershell -command "Get-AppxPackage *Microsoft.News* | Remove-AppxPackage"
    echo Removed Microsoft News
)
timeout /t 3
goto debloat

:install
cls
echo ================================
echo        Install Programs
echo ================================
echo.
echo [A] Browsers
echo [B] Games
echo [C] Streaming
echo [D] Misc
echo [E] Office
echo [F] Mouse Software
echo [G] Return to main menu
echo.
set /p install_choice="Enter your choice: "

if /i "%install_choice%"=="A" goto browsers
if /i "%install_choice%"=="B" goto games
if /i "%install_choice%"=="C" goto streaming
if /i "%install_choice%"=="D" goto misc
if /i "%install_choice%"=="E" goto office
if /i "%install_choice%"=="F" goto mouse
if /i "%install_choice%"=="G" goto menu
goto install

:browsers
cls
echo ================================
echo           Browsers
echo ================================
echo.
echo [1] Vivaldi
echo [2] Firefox
echo [3] Google Chrome
echo [4] Brave
echo [5] Chromium
echo [6] Return to install menu
echo.
set /p browser_choice="Enter numbers to install (separate with spaces) or 6 to return: "
if "%browser_choice%"=="6" goto install

echo %browser_choice% | find "1" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Vivaldi.Vivaldi >nul 2>&1
    call :installProgram "Vivaldi"
)
echo %browser_choice% | find "2" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Mozilla.Firefox >nul 2>&1
    call :installProgram "Firefox"
)
echo %browser_choice% | find "3" >nul && (
    winget install Google.Chrome
    echo Installing Chrome...
)
echo %browser_choice% | find "4" >nul && (
    winget install Brave.Brave
    echo Installing Brave...
)
echo %browser_choice% | find "5" >nul && (
    winget install Hibbiki.Chromium
    echo Installing Chromium...
)
timeout /t 3
goto browsers

:games
cls
echo ================================
echo            Games
echo ================================
echo.
echo [1] Minecraft Clients
echo [2] Steam
echo [3] Epic Games
echo [4] Heroic Games Launcher
echo [5] Roblox
echo [6] Return to install menu
echo.
set /p game_choice="Enter your choice: "
if "%game_choice%"=="1" goto minecraft
if "%game_choice%"=="6" goto install

if "%game_choice%"=="2" (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Valve.Steam >nul 2>&1
    call :installProgram "Steam"
)
if "%game_choice%"=="3" (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements EpicGames.EpicGamesLauncher >nul 2>&1
    call :installProgram "Epic Games Launcher"
)
if "%game_choice%"=="4" (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements HeroicGamesLauncher.HeroicGamesLauncher >nul 2>&1
    call :installProgram "Heroic Games Launcher"
)
if "%game_choice%"=="5" (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Roblox.Roblox >nul 2>&1
    call :installProgram "Roblox"
)
timeout /t 3
goto games

:minecraft
cls
echo ================================
echo       Minecraft Clients
echo ================================
echo.
echo [1] Lunar Client
echo [2] Badlion Client
echo [3] Minecraft Launcher
echo [4] Return to games menu
echo.
set /p mc_choice="Enter numbers to install (separate with spaces) or 4 to return: "
if "%mc_choice%"=="4" goto games

echo %mc_choice% | find "1" >nul && (
    winget install "Moonsworth.LunarClient"
    echo Installing Lunar Client...
)
echo %mc_choice% | find "2" >nul && (
    winget install "Badlion.BadlionClient"
    echo Installing Badlion Client...
)
echo %mc_choice% | find "3" >nul && (
    winget install "Mojang.MinecraftLauncher"
    echo Installing Minecraft Launcher...
)
timeout /t 3
goto minecraft

:streaming
cls
echo ================================
echo          Streaming
echo ================================
echo.
echo [1] Spotify
echo [2] SpotX (Requires Spotify)
echo [3] Return to install menu
echo.
set /p stream_choice="Enter your choice: "
if "%stream_choice%"=="3" goto install

if "%stream_choice%"=="1" (
    winget install Spotify.Spotify
    echo Installing Spotify...
)
if "%stream_choice%"=="2" (
    powershell -command "iex ""& { $(iwr -useb 'https://spotx-official.github.io/run.ps1') } -m -new_theme"""
    echo Installing SpotX...
)
timeout /t 3
goto streaming

:misc
cls
echo ================================
echo            Misc
echo ================================
echo.
echo [1] Discord
echo [2] Microsoft Teams
echo [3] Bitwarden
echo [4] Cloudflare WARP
echo [5] 7-Zip
echo [6] OBS Studio
echo [7] CRU (Custom Resolution Utility)
echo [8] Return to install menu
echo.
set /p misc_choice="Enter numbers to install (separate with spaces) or 8 to return: "
if "%misc_choice%"=="8" goto install

echo %misc_choice% | find "1" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Discord.Discord >nul 2>&1
    call :installProgram "Discord"
)
echo %misc_choice% | find "2" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Microsoft.Teams >nul 2>&1
    call :installProgram "Microsoft Teams"
)
echo %misc_choice% | find "3" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Bitwarden.Bitwarden >nul 2>&1
    call :installProgram "Bitwarden"
)
echo %misc_choice% | find "4" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements Cloudflare.Warp >nul 2>&1
    call :installProgram "Cloudflare WARP"
)
echo %misc_choice% | find "5" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements 7zip.7zip >nul 2>&1
    call :installProgram "7-Zip"
)
echo %misc_choice% | find "6" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements OBSProject.OBSStudio >nul 2>&1
    call :installProgram "OBS Studio"
)
echo %misc_choice% | find "7" >nul && (
    echo Downloading Custom Resolution Utility...
    powershell -command "Invoke-WebRequest -Uri 'https://customresolutionutility.b-cdn.net/cru-1.5.2.zip' -OutFile '%temp%\CRU.zip'" >nul 2>&1
    echo Extracting files...
    powershell -command "Expand-Archive -Path '%temp%\CRU.zip' -DestinationPath '%userprofile%\Documents\CRU' -Force" >nul 2>&1
    del /f /q "%temp%\CRU.zip" >nul 2>&1
    call :installProgram "Custom Resolution Utility"
)
timeout /t 3
goto misc

:office
cls
echo ================================
echo           Office
echo ================================
echo.
echo [1] Microsoft Office (Word, Excel, PowerPoint)
echo [2] Microsoft OneNote
echo [3] Microsoft Outlook
echo [4] Windows Activator
echo [5] Return to install menu
echo.
set /p office_choice="Enter numbers to install (separate with spaces) or 5 to return: "
if "%office_choice%"=="5" goto install

echo %office_choice% | find "1" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements "Microsoft.Office" >nul 2>&1
    call :installProgram "Microsoft Office"
)
echo %office_choice% | find "2" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements "Microsoft.OneNote" >nul 2>&1
    call :installProgram "Microsoft OneNote"
)
echo %office_choice% | find "3" >nul && (
    start /b /wait "" winget install -h --accept-source-agreements --accept-package-agreements "Microsoft.Outlook" >nul 2>&1
    call :installProgram "Microsoft Outlook"
)
echo %office_choice% | find "4" >nul && (
    powershell -command "irm https://get.activated.win | iex"
    echo Running Windows Activator...
    timeout /t 5 >nul
)
timeout /t 3
goto office

:mouse
cls
echo ================================
echo        Mouse Software
echo ================================
echo.
echo [1] Glorious Model O/O- Firmware v1.0.9
echo [2] Return to install menu
echo.
set /p mouse_choice="Enter your choice: "
if "%mouse_choice%"=="2" goto install

if "%mouse_choice%"=="1" (
    echo Downloading Glorious Model O/O- Firmware...
    powershell -command "Invoke-WebRequest -Uri 'https://downloads.gloriousgamingservices.com/download/ModelO_1-0-9.zip' -OutFile '%temp%\ModelO.zip'" >nul 2>&1
    echo Extracting files...
    powershell -command "Expand-Archive -Path '%temp%\ModelO.zip' -DestinationPath '%userprofile%\Desktop\Glorious_Model_O' -Force" >nul 2>&1
    del /f /q "%temp%\ModelO.zip" >nul 2>&1
    call :installProgram "Glorious Model O/O- Firmware"
)
timeout /t 3
goto mouse

:: Add error handling at the end of the file
:error
echo An error occurred
echo Press any key to exit...
pause >nul
exit /b 1

:exit
echo Press any key to exit...
pause >nul
goto :eof
