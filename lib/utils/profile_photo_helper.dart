import 'dart:convert';
import 'dart:io';

/// Convierte fotos de perfil a base64 para guardarlas en Firestore
/// (sin necesidad de Firebase Storage / plan Blaze).
class ProfilePhotoHelper {
  /// Límite ~700 KB en binario (~930 KB en base64), dentro del límite de Firestore.
  static const maxBytes = 700 * 1024;

  static Future<String> encodeFile(File file) async {
    final bytes = await file.readAsBytes();
    if (bytes.length > maxBytes) {
      throw Exception(
        'La imagen es demasiado grande. Elige una foto más pequeña.',
      );
    }
    return base64Encode(bytes);
  }
}
