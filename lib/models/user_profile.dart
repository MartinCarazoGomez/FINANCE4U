class UserProfile {
  final String uid;
  final String username;
  final String email;
  /// URL externa (p. ej. foto de Google).
  final String? photoUrl;
  /// Foto subida por el usuario, guardada en Firestore como base64.
  final String? photoBase64;
  final String? groupId;
  final String? groupCode;
  final String? groupName;
  final bool isGuest;
  final String authProvider;
  final bool onboardingCompleted;
  /// Franja de edad declarada: '10-13', '14-17', '18-21', '22-25' o '26+'.
  final String? ageRange;
  /// Intereses declarados (claves: ahorro, presupuesto, inversion, deuda,
  /// emprendimiento, fiscalidad).
  final List<String> interests;
  /// Nivel de partida según la prueba de nivel: 1 Básico · 2 Intermedio · 3 Avanzado.
  final int placementLevel;
  final bool personalizationCompleted;

  const UserProfile({
    required this.uid,
    required this.username,
    this.email = '',
    this.photoUrl,
    this.photoBase64,
    this.groupId,
    this.groupCode,
    this.groupName,
    this.isGuest = false,
    this.authProvider = 'guest',
    this.onboardingCompleted = false,
    this.ageRange,
    this.interests = const [],
    this.placementLevel = 1,
    this.personalizationCompleted = false,
  });

  UserProfile copyWith({
    String? uid,
    String? username,
    String? email,
    String? photoUrl,
    String? photoBase64,
    String? groupId,
    String? groupCode,
    String? groupName,
    bool? isGuest,
    String? authProvider,
    bool? onboardingCompleted,
    String? ageRange,
    List<String>? interests,
    int? placementLevel,
    bool? personalizationCompleted,
    bool clearPhotoUrl = false,
    bool clearPhotoBase64 = false,
    bool clearGroup = false,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: clearPhotoUrl ? null : (photoUrl ?? this.photoUrl),
      photoBase64:
          clearPhotoBase64 ? null : (photoBase64 ?? this.photoBase64),
      groupId: clearGroup ? null : (groupId ?? this.groupId),
      groupCode: clearGroup ? null : (groupCode ?? this.groupCode),
      groupName: clearGroup ? null : (groupName ?? this.groupName),
      isGuest: isGuest ?? this.isGuest,
      authProvider: authProvider ?? this.authProvider,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      ageRange: ageRange ?? this.ageRange,
      interests: interests ?? this.interests,
      placementLevel: placementLevel ?? this.placementLevel,
      personalizationCompleted:
          personalizationCompleted ?? this.personalizationCompleted,
    );
  }

  factory UserProfile.fromFirestore(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      username: data['username'] as String? ?? 'Usuario',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      photoBase64: data['photoBase64'] as String?,
      groupId: data['groupId'] as String?,
      groupCode: data['groupCode'] as String?,
      groupName: data['groupName'] as String?,
      isGuest: data['isGuest'] as bool? ?? false,
      authProvider: data['authProvider'] as String? ?? 'guest',
      onboardingCompleted: data['onboardingCompleted'] as bool? ?? false,
      ageRange: data['ageRange'] as String?,
      interests: (data['interests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      placementLevel: (data['placementLevel'] as num?)?.toInt() ?? 1,
      personalizationCompleted:
          data['personalizationCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (photoBase64 != null) 'photoBase64': photoBase64,
      if (groupId != null) 'groupId': groupId,
      if (groupCode != null) 'groupCode': groupCode,
      if (groupName != null) 'groupName': groupName,
      'isGuest': isGuest,
      'authProvider': authProvider,
      'onboardingCompleted': onboardingCompleted,
      if (ageRange != null) 'ageRange': ageRange,
      'interests': interests,
      'placementLevel': placementLevel,
      'personalizationCompleted': personalizationCompleted,
    };
  }
}
