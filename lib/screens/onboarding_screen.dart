import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/tutorial_service.dart';
import '../widgets/profile_avatar.dart';

/// First-time setup after Google or guest sign-in.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _groupCodeController = TextEditingController();
  final _groupPinController = TextEditingController();
  final _picker = ImagePicker();
  File? _photoFile;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final suggested = auth.profile?.username;
    if (suggested != null &&
        suggested.isNotEmpty &&
        suggested != 'Invitado' &&
        suggested != 'Usuario') {
      _nameController.text = suggested;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupCodeController.dispose();
    _groupPinController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _photoFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.length < 2) {
      _showError('Elige un nombre de al menos 2 caracteres');
      return;
    }

    final groupCode = _groupCodeController.text.trim();
    final groupPin = _groupPinController.text.trim();
    if (groupCode.isNotEmpty && groupPin.isEmpty) {
      _showError('Introduce el PIN de la clase');
      return;
    }

    setState(() => _submitting = true);
    try {
      await context.read<AuthProvider>().completeOnboarding(
            username: name,
            groupCode: groupCode.isEmpty ? null : groupCode,
            groupPin: groupPin.isEmpty ? null : groupPin,
            photoFile: _photoFile,
          );
      if (!mounted) return;
      final uid = context.read<AuthProvider>().firebaseUser?.uid;
      if (uid != null) {
        await TutorialService.prepareForUser(uid);
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/main');
    } catch (e) {
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Text(
                  '¡Bienvenido!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  auth.isGuest
                      ? 'Configura tu perfil de invitado'
                      : 'Completa tu perfil',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Stack(
                    children: [
                      ProfileAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        localFile: _photoFile,
                        photoBase64: auth.photoBase64,
                        photoUrl: auth.photoUrl,
                        iconColor: const Color(0xFF2E7D32),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => _showPhotoOptions(),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.camera_alt,
                                  size: 20, color: Color(0xFF2E7D32)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Foto de perfil (opcional, se guarda en tu cuenta)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 28),
                _fieldCard(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Tu nombre',
                          hintText: '¿Cómo te llamamos?',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _groupCodeController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Código de clase (opcional)',
                          hintText: 'Ej: 0001',
                          prefixIcon: Icon(Icons.groups_outlined),
                          border: OutlineInputBorder(),
                          helperText:
                              'Úsalo para unirte a las estadísticas de tu clase',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _groupPinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        decoration: const InputDecoration(
                          labelText: 'PIN de clase (si tienes código)',
                          hintText: '6 dígitos',
                          prefixIcon: Icon(Icons.pin_outlined),
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Empezar aventura',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
