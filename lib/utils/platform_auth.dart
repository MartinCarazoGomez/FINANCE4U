import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Google Sign-In is only implemented on mobile, macOS and web — not Windows/Linux.
bool get isGoogleSignInSupported {
  if (kIsWeb) return true;
  return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
}

const kGoogleSignInUnsupportedMessage =
    'Iniciar sesión con Google no está disponible en Windows. '
    'Conecta un móvil Android, usa un emulador, o continúa como invitado.';
