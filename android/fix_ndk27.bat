@echo off
REM Creates the missing source.properties so the build recognizes NDK 27.
REM Run this from the project root or from android folder.

set "NDK_DIR=%LOCALAPPDATA%\Android\Sdk\ndk\27.0.12077973"
set "PROPS=%NDK_DIR%\source.properties"

if not exist "%NDK_DIR%" (
    echo NDK folder not found: %NDK_DIR%
    echo.
    echo Install NDK 27.0.12077973 first:
    echo   Android Studio -^> Settings -^> Android SDK -^> SDK Tools -^> Show Package Details -^> NDK 27.0.12077973 -^> Apply
    echo.
    pause
    exit /b 1
)

(
echo Pkg.Desc=Android NDK
echo Pkg.Revision=27.0.12077973
) > "%PROPS%"

echo Created: %PROPS%
echo.
echo You can now run: flutter build appbundle --release
pause
