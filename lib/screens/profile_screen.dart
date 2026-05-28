import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/profile_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _groupCodeController = TextEditingController();
  final _groupPinController = TextEditingController();
  final _picker = ImagePicker();
  bool _editingName = false;

  @override
  void initState() {
    super.initState();
    _syncFromAuth();
  }

  void _syncFromAuth() {
    final auth = context.read<AuthProvider>();
    _nameController.text = auth.profile?.username ?? '';
    _groupCodeController.text = auth.profile?.groupCode ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupCodeController.dispose();
    _groupPinController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    try {
      await context
          .read<AuthProvider>()
          .updateProfilePhoto(File(picked.path));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto actualizada'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) _showError(e);
    }
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();
    if (name.length < 2) {
      _showError('El nombre debe tener al menos 2 caracteres');
      return;
    }
    try {
      await context.read<AuthProvider>().updateUsername(name);
      setState(() => _editingName = false);
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _joinGroup() async {
    final code = _groupCodeController.text.trim();
    final pin = _groupPinController.text.trim();
    if (code.isEmpty) {
      _showError('Introduce un código de clase');
      return;
    }
    if (pin.isEmpty) {
      _showError('Introduce el PIN de la clase');
      return;
    }
    try {
      await context.read<AuthProvider>().joinGroup(code, pin);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Te uniste a la clase'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _leaveGroup() async {
    try {
      await context.read<AuthProvider>().leaveGroup();
      _groupCodeController.clear();
      _groupPinController.clear();
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _linkGoogle() async {
    try {
      await context.read<AuthProvider>().linkGoogleAccount();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta de Google vinculada'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    await context.read<AuthProvider>().signOut();
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/welcome', (route) => false);
  }

  void _showError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profile = auth.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: auth.busy
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Stack(
                    children: [
                      ProfileAvatar(
                        radius: 56,
                        photoUrl: profile?.photoUrl,
                        photoBase64: profile?.photoBase64,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: FloatingActionButton.small(
                          heroTag: 'profile_photo',
                          onPressed: () => _showPhotoOptions(),
                          backgroundColor: const Color(0xFF2E7D32),
                          child: const Icon(Icons.camera_alt, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: auth.isGuest
                          ? Colors.orange.shade100
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      auth.isGuest ? 'Invitado' : 'Cuenta Google',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: auth.isGuest
                            ? Colors.orange.shade900
                            : Colors.green.shade900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _sectionTitle('Información'),
                Card(
                  child: Column(
                    children: [
                      if (_editingName)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Color(0xFF2E7D32)),
                                onPressed: _saveName,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _syncFromAuth();
                                  setState(() => _editingName = false);
                                },
                              ),
                            ],
                          ),
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.person,
                              color: Color(0xFF2E7D32)),
                          title: const Text('Nombre'),
                          subtitle: Text(profile?.username ?? '—'),
                          trailing: const Icon(Icons.edit, size: 20),
                          onTap: () => setState(() => _editingName = true),
                        ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email,
                            color: Color(0xFF2E7D32)),
                        title: const Text('Correo'),
                        subtitle: Text(
                          profile?.email.isNotEmpty == true
                              ? profile!.email
                              : auth.isGuest
                                  ? 'No disponible (invitado)'
                                  : '—',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                _sectionTitle('Clase / Comunidad'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (profile?.groupId != null) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.school,
                                color: Color(0xFF2E7D32)),
                            title: Text(profile?.groupName ?? 'Mi clase'),
                            subtitle: Text(
                                'Código: ${profile?.groupCode ?? '—'}'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _leaveGroup,
                            icon: const Icon(Icons.exit_to_app),
                            label: const Text('Salir de la clase'),
                          ),
                        ] else ...[
                          TextField(
                            controller: _groupCodeController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: const InputDecoration(
                              labelText: 'Código de clase',
                              hintText: 'Ej: 0001',
                              prefixIcon: Icon(Icons.groups),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _groupPinController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              labelText: 'PIN de clase',
                              hintText: '6 dígitos',
                              prefixIcon: Icon(Icons.pin_outlined),
                              border: OutlineInputBorder(),
                              counterText: '',
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _joinGroup,
                            icon: const Icon(Icons.login),
                            label: const Text('Unirse a la clase'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _sectionTitle('Cuenta'),
                Card(
                  child: Column(
                    children: [
                      if (auth.isGuest)
                        ListTile(
                          leading: const Icon(Icons.link,
                              color: Color(0xFF2E7D32)),
                          title: const Text('Vincular Google'),
                          subtitle: const Text(
                              'Guarda tu progreso en la nube'),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16),
                          onTap: _linkGoogle,
                        ),
                      if (auth.isGuest) const Divider(height: 1),
                      ListTile(
                        leading:
                            const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Cerrar sesión',
                            style: TextStyle(color: Colors.red)),
                        onTap: _signOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF388E3C),
        ),
      ),
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
                _pickAndUploadPhoto(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUploadPhoto(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
