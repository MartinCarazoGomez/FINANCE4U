# Quick Start - Firebase Setup

## 🚀 3-Step Setup

### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase
```bash
firebase login
flutterfire configure
```

### 3. Install Dependencies
```bash
flutter pub get
```

## ✅ Done!

Your app is now ready to use Firebase. See `FIREBASE_SETUP_GUIDE.md` for detailed instructions.

## 📝 Quick Usage Examples

### Authentication
```dart
import 'package:finance4u/services/auth_service.dart';

// Sign up
await AuthService.instance.createUserWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password123',
  username: 'John Doe',
);

// Sign in
await AuthService.instance.signInWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password123',
);
```

### Firestore
```dart
import 'package:finance4u/services/firestore_helper.dart';

// Save progress
await FirestoreHelper.saveProgress(
  userId: 'user123',
  level: 5,
  totalXP: 450,
  streakDays: 7,
  completedLessons: ['lesson1'],
  unlockedGames: ['budget_master'],
);
```

## 📚 Full Documentation
- `FIREBASE_SETUP_GUIDE.md` - Complete setup guide
- `FIREBASE_INTEGRATION_SUMMARY.md` - Architecture overview

