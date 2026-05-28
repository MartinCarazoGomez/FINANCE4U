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

  final snap = await FirebaseFirestore.instance
      .collection('groups')
      .where('code', whereIn: ['0001', '0002', '0003'])
      .get();

  for (final doc in snap.docs) {
    final data = doc.data();
    debugPrint('${data['code']} | ${data['name']} | members: ${(data['memberIds'] as List?)?.length ?? 0}');
  }
}
