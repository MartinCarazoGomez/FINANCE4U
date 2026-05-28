import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

/// Avatar de perfil: foto local, base64 (Firestore) o URL (Google).
class ProfileAvatar extends StatelessWidget {
  final double radius;
  final String? photoUrl;
  final String? photoBase64;
  final File? localFile;
  final Color backgroundColor;
  final Color iconColor;

  const ProfileAvatar({
    super.key,
    required this.radius,
    this.photoUrl,
    this.photoBase64,
    this.localFile,
    this.backgroundColor = const Color(0xFFE8F5E9),
    this.iconColor = const Color(0xFF2E7D32),
  });

  ImageProvider? get _imageProvider {
    if (localFile != null) return FileImage(localFile!);
    if (photoBase64 != null && photoBase64!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(photoBase64!));
      } catch (_) {
        return null;
      }
    }
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return NetworkImage(photoUrl!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final image = _imageProvider;
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: image,
      child: image == null
          ? Icon(Icons.person, size: radius, color: iconColor)
          : null,
    );
  }
}
