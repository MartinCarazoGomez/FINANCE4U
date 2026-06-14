@echo off
setlocal
echo.
echo FINANCE4U - Huellas SHA para Firebase / Google Sign-In
echo Package: com.finance4u.education
echo.

set "KEYTOOL=C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"
if not exist "%KEYTOOL%" (
  echo No se encontro keytool en Android Studio. Usa: gradlew signingReport
  exit /b 1
)

echo === Release (upload-keystore.jks) - YA registrado en Firebase ===
"%KEYTOOL%" -list -v -keystore "%~dp0upload-keystore.jks" -alias upload -storepass finance4u123 -keypass finance4u123 2>nul | findstr /i "SHA1 SHA256"

echo.
echo === Debug (%%USERPROFILE%%\.android\debug.keystore) ===
if exist "%USERPROFILE%\.android\debug.keystore" (
  "%KEYTOOL%" -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android 2>nul | findstr /i "SHA1 SHA256"
) else (
  echo debug.keystore no encontrado
)

echo.
echo Anade ambos SHA-1 en Firebase Console:
echo   Project settings ^> Your apps ^> Android ^> Add fingerprint
echo.
echo O ejecuta desde android: gradlew signingReport
echo.
pause
