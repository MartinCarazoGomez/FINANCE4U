# Quick Start — Firebase para FINANCE4U

Guía rápida actualizada. **No necesitas Firebase Storage ni plan Blaze** para las fotos de perfil (van en Firestore como base64).

---

## Requisitos

- Cuenta en [Firebase Console](https://console.firebase.google.com/)
- Flutter instalado (`flutter doctor`)
- Plan **Spark (gratis)** — suficiente para esta app

---

## Paso 1 — Dependencias y CLI

```bash
cd c:\Users\marti\duolingo_finanzas
flutter pub get
dart pub global activate flutterfire_cli
```

**Si `flutterfire` no se reconoce en CMD**, usa la ruta completa:

```cmd
C:\Users\marti\AppData\Local\Pub\Cache\bin\flutterfire.bat configure
```

O añade `C:\Users\marti\AppData\Local\Pub\Cache\bin` al PATH de Windows.

---

## Paso 2 — Vincular el proyecto

```bash
firebase login
flutterfire configure
```

Selecciona tu proyecto Firebase y las plataformas (Android como mínimo).

Genera:
- `lib/firebase_options.dart`
- `android/app/google-services.json`

> Android Gradle ya está configurado en este repo. No hace falta tocar `build.gradle.kts`.

---

## Paso 3 — Authentication

Firebase Console → **Build → Authentication → Sign-in method**

| Método | Obligatorio |
|--------|-------------|
| **Google** | ✅ Sí |
| **Anónimo** | ✅ Sí (modo invitado) |
| Email/Password | Opcional |

**Android + Google:** Project settings → app Android (`com.finance4u.education`) → añade SHA-1 y SHA-256:

```cmd
cd android
gradlew signingReport
```

---

## Paso 4 — Firestore (base de datos)

Firebase Console → **Build → Firestore Database → Create database**

Modo **Production** (o Test solo para pruebas). Pega las reglas de `FIREBASE_SETUP_GUIDE.md` (sección Firestore).

### Colecciones que usa la app

| Colección | Uso |
|-----------|-----|
| `users` | Perfil, nombre, `photoBase64`, grupo |
| `user_progress` | XP, nivel, lecciones |
| `game_data` | Saves de juegos |
| `achievements` | Logros |
| `community_posts` | Foro |
| `groups` | Códigos de clase |

### Clase de prueba (opcional)

Colección `groups` → documento nuevo:

```json
{
  "code": "FIN2024",
  "name": "Clase 5A",
  "memberIds": []
}
```

---

## Paso 5 — Storage

**⏭️ NO ACTIVAR.** La app no usa Firebase Storage.

- Fotos subidas → `photoBase64` en Firestore (`users/{uid}`)
- Fotos de Google → `photoUrl` (URL de Google, gratis)

---

## Paso 6 — Probar la app

```bash
flutter clean
flutter pub get
flutter run
```

### Checklist

- [ ] Sin error `Firebase initialization error` en consola
- [ ] Welcome → **Google** o **Invitado** funciona
- [ ] Onboarding → nombre + código de clase opcional
- [ ] Perfil → cambiar nombre y subir foto
- [ ] Firestore → aparece documento en `users/{uid}` con `photoBase64` si subiste foto
- [ ] Comunidad → crear un post

---

## Flujo de la app

```
Splash → ¿sesión? → Welcome (primera vez)
                    → Onboarding (nombre, foto, código clase)
                    → App principal
```

Perfil completo: **Ajustes → Mi perfil**

---

## Documentación completa

Ver `FIREBASE_SETUP_GUIDE.md` para reglas de seguridad, troubleshooting y detalles técnicos.
