import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:finance4u/firebase_options.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }

  final db = FirebaseFirestore.instance;
  const groups = [
    ('class-0001', '0001', 'Clase 0001', '000000'),
    ('class-0002', '0002', 'Clase 0002', '000000'),
    ('class-0003', '0003', 'Clase 0003', '000000'),
  ];

  for (final (id, code, name, pin) in groups) {
    await db.collection('groups').doc(id).set({
      'code': code,
      'name': name,
      'pin': pin,
      'memberIds': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    debugPrint('Created $code -> $name (PIN set)');
  }

  debugPrint('All class codes created.');
}
