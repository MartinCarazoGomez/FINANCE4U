@echo off
echo Creando keystore para FINANCE4U...

"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass finance4u123 -keypass finance4u123 -dname "CN=Finance4U, OU=Education, O=Finance4U App, L=Madrid, S=Madrid, C=ES"

echo Keystore creado exitosamente!
pause 