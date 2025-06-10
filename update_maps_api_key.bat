@echo off
REM Windows script to update Google Maps API key in AndroidManifest.xml

setlocal enabledelayedexpansion

REM Determine the manifest file path relative to the script location
set "SCRIPT_DIR=%~dp0"
set "MANIFEST_PATH=%SCRIPT_DIR%android\app\src\main\AndroidManifest.xml"

REM Check if the manifest file exists
if not exist "%MANIFEST_PATH%" (
    echo Error: AndroidManifest.xml not found at %MANIFEST_PATH%
    exit /b 1
)

REM Prompt for the API key
echo Please enter your Google Maps API key:
set /p API_KEY=

REM Exit if no key was provided
if "%API_KEY%"=="" (
    echo No API key provided. Exiting without making changes.
    exit /b 1
)

REM Create a backup of the original file
copy "%MANIFEST_PATH%" "%MANIFEST_PATH%.bak" > nul
echo Created backup at %MANIFEST_PATH%.bak

REM Replace the placeholder with the provided API key using PowerShell
powershell -Command "(Get-Content '%MANIFEST_PATH%') -replace 'android:value=\"YOUR_API_KEY\"', 'android:value=\"%API_KEY%\"' | Set-Content '%MANIFEST_PATH%'"

REM Verify the change (using PowerShell for grep-like functionality)
powershell -Command "if ((Get-Content '%MANIFEST_PATH%' | Select-String 'android:value=\"%API_KEY%\"').Count -gt 0) { exit 0 } else { exit 1 }"
if %errorlevel% equ 0 (
    echo Success! Google Maps API key has been updated in AndroidManifest.xml
) else (
    echo Error: Failed to update the API key. Please check the file manually.
    echo The original file has been backed up to %MANIFEST_PATH%.bak
)

exit /b 0
