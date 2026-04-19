@echo off
setlocal
echo Installing NDK 27 via command line...
echo.

REM Use default Android SDK path if ANDROID_HOME not set
if "%ANDROID_HOME%"=="" set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
if "%ANDROID_ROOT%"=="" set "ANDROID_ROOT=%ANDROID_HOME%"

set "SDKMAN=%ANDROID_HOME%\cmdline-tools\latest\bin\sdkmanager.bat"
if not exist "%SDKMAN%" (
    set "SDKMAN=%ANDROID_HOME%\tools\bin\sdkmanager.bat"
)
if not exist "%SDKMAN%" (
    echo sdkmanager not found. Install "Android SDK Command-line Tools" first:
    echo   Android Studio -^> Settings -^> Android SDK -^> SDK Tools -^> check "Android SDK Command-line Tools" -^> Apply
    echo.
    echo Then run this script again.
    pause
    exit /b 1
)

REM Remove broken/incomplete NDK folder so we get a clean install
set "NDK_OLD=%ANDROID_HOME%\ndk\27.0.12077973"
if exist "%NDK_OLD%" (
    echo Removing incomplete NDK folder: %NDK_OLD%
    rmdir /s /q "%NDK_OLD%" 2>nul
    if exist "%NDK_OLD%" (
        echo Could not remove. Close any program using it, then run this script again.
        pause
        exit /b 1
    )
    echo.
)

echo Accepting SDK licenses (if prompted)...
call "%SDKMAN%" --licenses
echo.

REM Try preferred version first; fallback to 27.0.1
echo Installing NDK 27.0.12077973...
call "%SDKMAN%" --install "ndk;27.0.12077973"
if errorlevel 1 (
    echo.
    echo 27.0.12077973 not available, trying 27.0.1...
    call "%SDKMAN%" --install "ndk;27.0.1"
    if errorlevel 1 (
        echo.
        echo To see available NDK versions run:
        echo   "%SDKMAN%" --list ^| findstr ndk
        echo Then install with: "%SDKMAN%" --install "ndk;VERSION"
        pause
        exit /b 1
    )
    set "NDK_VER=27.0.1"
) else (
    set "NDK_VER=27.0.12077973"
)

echo.
echo NDK installed. Check that this file exists:
echo   %ANDROID_HOME%\ndk\%NDK_VER%\build\cmake\android.toolchain.cmake
echo.
echo In android\app\build.gradle.kts set: ndkVersion = "%NDK_VER%"
echo Then run: flutter build appbundle --release
pause
