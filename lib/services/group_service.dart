import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_service.dart';

/// Manages class/group codes for community stats.
///
/// Firestore structure:
///   groups/{groupId}
///     code       : String   (uppercase, unique)
///     name       : String
///     pin        : String   (6 digits)
///     memberIds  : List<String>
///     createdAt  : Timestamp
class GroupService {
  static FirebaseFirestore get _db => FirebaseService.instance.firestore;

  static CollectionReference<Map<String, dynamic>> get _groups =>
      _db.collection('groups');

  static const int pinLength = 6;

  static String normalizeCode(String code) => code.trim().toUpperCase();

  static String normalizePin(String pin) =>
      pin.trim().replaceAll(RegExp(r'\s'), '');

  /// Join a group by its invite code and PIN. Returns group metadata.
  static Future<({String groupId, String code, String name})> joinByCode({
    required String userId,
    required String code,
    required String pin,
  }) async {
    final normalized = normalizeCode(code);
    if (normalized.length < 4) {
      throw Exception('El código debe tener al menos 4 caracteres');
    }

    final normalizedPin = normalizePin(pin);
    if (normalizedPin.length != pinLength) {
      throw Exception('El PIN debe tener $pinLength dígitos');
    }

    final snapshot = await _groups
        .where('code', isEqualTo: normalized)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Código de clase no encontrado');
    }

    final doc = snapshot.docs.first;
    final data = doc.data();
    final storedPin = normalizePin(data['pin'] as String? ?? '');
    if (storedPin.isEmpty) {
      throw Exception('Esta clase aún no tiene PIN configurado');
    }
    if (storedPin != normalizedPin) {
      throw Exception('PIN incorrecto');
    }
    await doc.reference.update({
      'memberIds': FieldValue.arrayUnion([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return (
      groupId: doc.id,
      code: data['code'] as String? ?? normalized,
      name: data['name'] as String? ?? 'Mi clase',
    );
  }

  /// Leave the current group.
  static Future<void> leaveGroup({
    required String userId,
    required String groupId,
  }) async {
    await _groups.doc(groupId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream member count for a group (for class stats UI).
  static Stream<int> memberCountStream(String groupId) {
    return _groups.doc(groupId).snapshots().map((snap) {
      final ids = snap.data()?['memberIds'];
      if (ids is List) return ids.length;
      return 0;
    });
  }
}
