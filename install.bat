@echo off
title Tobii Hub Reset - Talon Installer
echo =======================================
echo   Tobii Hub Reset - Talon Installer
echo =======================================
echo.

:: 1. Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Administrator privileges required.
    echo Please close this window, right-click the install.bat file, 
    echo and select "Run as administrator".
    echo.
    pause
    exit /b 1
)

:: 2. Define target paths and URLs
:: CHANGE THIS URL to your repository's zip download link. 
:: Typically: https://github.com/USERNAME/REPONAME/archive/refs/heads/main.zip
set "ZIP_URL=https://github.com/USERNAME/REPONAME/archive/refs/heads/main.zip"
set "TALON_DIR=%APPDATA%\talon\user\tobii-reset"
set "PS1_SCRIPT=%TALON_DIR%\Reset-TobiiHub.ps1"

:: 3. Download and Extract the Repository via PowerShell
echo [INFO] Downloading and installing the latest scripts...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ProgressPreference = 'SilentlyContinue'; " ^
    "$zipUrl = '%ZIP_URL%'; " ^
    "$dest = '%TALON_DIR%'; " ^
    "$tempZip = Join-Path $env:TEMP 'tobii-repo.zip'; " ^
    "$tempExtract = Join-Path $env:TEMP 'tobii-extract'; " ^
    "try { " ^
    "    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip; " ^
    "    if (Test-Path $tempExtract) { Remove-Item -Recurse -Force $tempExtract }; " ^
    "    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force; " ^
    "    $extractedFolder = Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1; " ^
    "    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }; " ^
    "    Move-Item -Path $extractedFolder.FullName -Destination $dest -Force; " ^
    "    Remove-Item -Force $tempZip; " ^
    "    Remove-Item -Recurse -Force $tempExtract; " ^
    "} catch { " ^
    "    Write-Error 'Failed to download or extract the repository.'; " ^
    "    exit 1; " ^
    "}"

if %errorLevel% neq 0 (
    echo [ERROR] Installation failed during download/extraction.
    pause
    exit /b 1
)

:: 4. Create the Elevated Scheduled Task
echo.
echo [INFO] Registering elevated Scheduled Task...

schtasks /create /f /tn "ResetTobii" ^
    /tr "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File \"%PS1_SCRIPT%\"" ^
    /sc once /sd 01/01/2000 /st 00:00 /ru SYSTEM /rl HIGHEST

if %errorLevel% equ 0 (
    echo.
    echo =======================================
    echo [SUCCESS] Installation complete!
    echo =======================================
    echo Your Talon voice command is now ready to use.
) else (
    echo.
    echo [ERROR] Failed to create Scheduled Task.
)

echo.
pause
