# Guía de configuración Firebase — FINANCE4U

Guía completa para vincular la app con Firebase **sin Firebase Storage** (plan Spark gratuito).

---

## Qué usa la app de Firebase

| Servicio | ¿Necesario? | Plan |
|----------|-------------|------|
| **Authentication** (Google + Anónimo) | ✅ Sí | Spark gratis |
| **Firestore** (perfiles, progreso, clases, foro) | ✅ Sí | Spark gratis |
| **Storage** (archivos/fotos) | ❌ No | — |
| Analytics / Crashlytics | Opcional | Spark / Blaze |

### Fotos de perfil (sin Storage)

| Origen | Campo en Firestore |
|--------|-------------------|
| Usuario sube foto (cámara/galería) | `photoBase64` (imagen comprimida en base64) |
| Login con Google | `photoUrl` (URL de la cuenta Google) |

No hace falta activar Storage ni el plan Blaze.

---

## Paso 1 — Dependencias

```bash
cd c:\Users\marti\duolingo_finanzas
flutter pub get
```

Paquetes Firebase en `pubspec.yaml`:
- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `google_sign_in`, `image_picker`
- **No** incluye `firebase_storage`

---

## Paso 2 — FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```

### Si CMD dice «flutterfire no es un comando»

Opción A — ruta completa (Windows):

```cmd
C:\Users\marti\AppData\Local\Pub\Cache\bin\flutterfire.bat configure
```

Opción B — añadir al PATH de usuario:

```
C:\Users\marti\AppData\Local\Pub\Cache\bin
```

Opción C:

```cmd
dart pub global run flutterfire_cli:flutterfire configure
```

### Archivos generados

| Archivo | Ubicación |
|---------|-----------|
| `firebase_options.dart` | `lib/` |
| `google-services.json` | `android/app/` |
| `GoogleService-Info.plist` | `ios/Runner/` (si configuras iOS) |

Están en `.gitignore`: cada desarrollador ejecuta `flutterfire configure` en su máquina.

---

## Paso 3 — Android (ya configurado en el repo)

- `applicationId`: `com.finance4u.education`
- Plugins Google Services y Crashlytics en Gradle
- Permisos cámara en `AndroidManifest.xml` (fotos de perfil)

Solo falta el `google-services.json` del paso 2.

### Huellas SHA para Google Sign-In

```cmd
cd android
gradlew signingReport
```

Copia SHA-1 y SHA-256 (debug) en Firebase Console → Project settings → Android app.

---

## Paso 4 — Authentication

Firebase Console → **Authentication → Sign-in method**

1. **Google** → Activar → email de soporte del proyecto
2. **Anónimo** → Activar (modo invitado)
3. **Email/Password** → Opcional (código legacy en `AuthService`)

---

## Paso 5 — Firestore Database

Firebase Console → **Firestore Database → Create database**

- Región cercana a tus usuarios
- Modo Production recomendado (con reglas abajo)

### Reglas de seguridad

Firestore → **Rules**:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /user_progress/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    match /game_data/{docId} {
      allow read, write: if request.auth != null
        && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null
        && request.resource.data.userId == request.auth.uid;
    }

    match /achievements/{docId} {
      allow read, write: if request.auth != null
        && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null
        && request.resource.data.userId == request.auth.uid;
    }

    match /community_posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null
        && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null
        && resource.data.userId == request.auth.uid;
    }

    match /groups/{groupId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }

    match /lessons/{lessonId} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

### Documento de usuario (`users/{uid}`)

```json
{
  "username": "María",
  "email": "maria@gmail.com",
  "photoUrl": "https://lh3.googleusercontent.com/...",
  "photoBase64": "/9j/4AAQSkZJRg...",
  "groupId": "abc123",
  "groupCode": "FIN2024",
  "groupName": "Clase 5A",
  "isGuest": false,
  "authProvider": "google",
  "onboardingCompleted": true,
  "createdAt": "...",
  "updatedAt": "..."
}
```

> `photoBase64` puede ocupar ~50–150 KB. Firestore limita ~1 MB por documento; la app comprime a 512×512 antes de guardar.

### Crear una clase de prueba

Colección `groups` → nuevo documento:

```json
{
  "code": "FIN2024",
  "name": "Clase 5A",
  "memberIds": []
}
```

Los alumnos usan el código en onboarding o en **Ajustes → Mi perfil**.

---

## Paso 6 — Storage

**No activar.** Esta app no usa Firebase Storage.

Si activas Storage por error, no afecta al código actual, pero no es necesario ni recomendado en plan Spark para este proyecto.

---

## Paso 7 — Verificar

```bash
flutter clean
flutter pub get
flutter run
```

### Checklist funcional

| Prueba | Resultado esperado |
|--------|-------------------|
| Arranque | Sin `Firebase initialization error` |
| Welcome | Botones Google e Invitado |
| Google login | Entra a onboarding o main |
| Invitado | Entra a onboarding |
| Onboarding | Guarda nombre en `users` |
| Foto de perfil | Campo `photoBase64` en Firestore |
| Google sin foto propia | `photoUrl` de Google |
| Código clase `FIN2024` | `groupId` en perfil |
| Comunidad | Post en `community_posts` |
| Cerrar sesión | Vuelve a Welcome |

---

## Arquitectura en el código

```
lib/
  main.dart                    # Firebase.initializeApp + providers
  providers/
    auth_provider.dart         # Sesión, perfil, onboarding, grupos
    app_provider.dart          # Progreso local (pendiente sync Firestore)
  services/
    firebase_service.dart      # Auth, Firestore, Analytics, Crashlytics
    auth_service.dart          # Google, invitado, perfil
    firestore_helper.dart      # CRUD tipado
    group_service.dart         # Códigos de clase
  models/
    user_profile.dart          # photoUrl + photoBase64
  screens/
    welcome_screen.dart        # Login Google / invitado
    onboarding_screen.dart     # Nombre, foto, código clase
    profile_screen.dart        # Perfil completo
  utils/
    profile_photo_helper.dart  # Compresión → base64
  widgets/
    profile_avatar.dart        # Muestra foto base64 / URL / icono
```

---

## Troubleshooting

### `flutterfire` no reconocido
Ver Paso 2 — usar ruta completa o añadir Pub al PATH.

### `firebase_options.dart` no existe
Ejecutar `flutterfire configure` en la raíz del proyecto.

### Google Sign-In falla (Android)
- SHA-1/SHA-256 en Firebase Console
- Package name: `com.finance4u.education`
- Google activado en Authentication

### `PERMISSION_DENIED` en Firestore
- Usuario autenticado (Google o anónimo)
- Reglas publicadas correctamente
- UID del documento = UID del usuario

### Foto no se guarda
- Firestore activo (no Storage)
- Imagen no demasiado grande (máx. ~700 KB antes de base64)
- Reglas de `users/{userId}` correctas

### Error LNK1127 (Windows, Firebase libs)
```bash
flutter clean
flutter pub get
flutter run
```

---

## Próximos pasos (opcional)

1. Sincronizar `AppProvider` con `user_progress` en Firestore al completar lecciones
2. Ranking real en pestaña **Clase** usando `groups` + miembros
3. Analytics y Crashlytics en producción
4. Firebase App Check anti-abuso

---

## Enlaces

- [FlutterFire](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Precios Firebase (Spark)](https://firebase.google.com/pricing)
