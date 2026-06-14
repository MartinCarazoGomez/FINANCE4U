import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/tutorial_service.dart';
import '../utils/currency_helper.dart';
import 'profile_screen.dart';
import '../widgets/profile_avatar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer2<AppProvider, AuthProvider>(
        builder: (context, appProvider, auth, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Perfil completo
              _buildSectionHeader('Cuenta'),
              Card(
                child: ListTile(
                  leading: ProfileAvatar(
                    radius: 22,
                    photoUrl: auth.photoUrl,
                    photoBase64: auth.photoBase64,
                  ),
                  title: Text(auth.profile?.username ?? appProvider.username),
                  subtitle: Text(
                    auth.isGuest
                        ? 'Invitado · Toca para editar perfil'
                        : 'Google · Toca para editar perfil',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Sección de Perfil rápido
              _buildSectionHeader('Perfil'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF2E7D32)),
                      title: const Text('Nombre de Usuario'),
                      subtitle: Text(appProvider.username),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditDialog(context, 'Nombre', appProvider.username, (value) {
                        appProvider.updateUsername(value);
                      }),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email, color: Color(0xFF2E7D32)),
                      title: const Text('Correo Electrónico'),
                      subtitle: Text(appProvider.email),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditDialog(context, 'Correo', appProvider.email, (value) {
                        appProvider.updateEmail(value);
                      }),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sección de Notificaciones
              _buildSectionHeader('Notificaciones'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.notifications, color: Color(0xFF2E7D32)),
                      title: const Text('Notificaciones Push'),
                      subtitle: const Text('Recibir recordatorios diarios'),
                      trailing: Switch(
                        value: appProvider.notificationsEnabled,
                        onChanged: (value) {
                          appProvider.toggleNotifications();
                        },
                        activeColor: const Color(0xFF2E7D32),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.schedule, color: Color(0xFF2E7D32)),
                      title: const Text('Recordatorio Diario'),
                      subtitle: const Text('Hora del recordatorio'),
                      trailing: Text(appProvider.reminderTime),
                      onTap: () => _showTimePicker(context, appProvider),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sección de Moneda
              _buildSectionHeader('Moneda'),
              Card(
                child: ListTile(
                  leading: _currencySymbolAvatar(appProvider.currency),
                  title: const Text('Moneda Local'),
                  subtitle: Text(
                    '${CurrencyHelper.name(appProvider.currency)} · '
                    '${CurrencyHelper.settingsPreview(appProvider.currency)}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showCurrencyPicker(context, appProvider),
                ),
              ),
              
              const SizedBox(height: 24),

              // Sección Desarrollador
              _buildSectionHeader('Desarrollador'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.developer_mode,
                          color: Color(0xFF2E7D32)),
                      title: const Text('Modo desarrollador'),
                      subtitle: Text(
                        appProvider.developerMode
                            ? 'Mapa y decoración experimental de Ahorros'
                            : 'Desactivado · módulos en vista estándar',
                      ),
                      trailing: Switch(
                        value: appProvider.developerMode,
                        onChanged: (_) => appProvider.toggleDeveloperMode(),
                        activeColor: const Color(0xFF2E7D32),
                      ),
                    ),
                    if (appProvider.developerMode) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.science_outlined,
                            color: Color(0xFF558B2F)),
                        title: const Text('Contenido experimental'),
                        subtitle: const Text(
                          'Ahorros: mapa interactivo y decoración especial de píldoras',
                        ),
                        trailing: const Icon(Icons.map_outlined,
                            color: Color(0xFF558B2F)),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección de Datos
              _buildSectionHeader('Datos'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.download, color: Color(0xFF2E7D32)),
                      title: const Text('Exportar Datos'),
                      subtitle: const Text('Descargar tu progreso'),
                      onTap: () {
                        _showSnackBar(context, 'Función en desarrollo');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: const Text('Eliminar Datos'),
                      subtitle: const Text('Borrar todo el progreso'),
                      onTap: () => _showDeleteConfirmation(context, appProvider),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // Sección de Tutorial
              _buildSectionHeader('Tutorial'),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.school_outlined,
                      color: Color(0xFF2E7D32)),
                  title: const Text('Ver tutorial de nuevo'),
                  subtitle: const Text('Repasa el recorrido por la app'),
                  trailing: const Icon(Icons.play_circle_outline,
                      color: Color(0xFF2E7D32)),
                  onTap: () {
                    final uid = context.read<AuthProvider>().firebaseUser?.uid;
                    if (uid == null) {
                      _showSnackBar(context, 'Inicia sesión para ver el tutorial');
                      return;
                    }
                    TutorialService.resetTutorial(userId: uid).then((_) {
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/main', (_) => false);
                      }
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Sección de Acerca de
              _buildSectionHeader('Acerca de'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info, color: Color(0xFF2E7D32)),
                      title: const Text('Versión'),
                      subtitle: const Text('4.0.0'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description, color: Color(0xFF2E7D32)),
                      title: const Text('Términos y Condiciones'),
                      onTap: () {
                        _showSnackBar(context, 'Términos y condiciones');
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip, color: Color(0xFF2E7D32)),
                      title: const Text('Política de Privacidad'),
                      onTap: () {
                        _showSnackBar(context, 'Política de privacidad');
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: field,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
              _showSnackBar(context, '$field actualizado');
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context, AppProvider appProvider) {
    final now = DateTime.now();
    final initialTime = TimeOfDay.fromDateTime(now);
    
    showTimePicker(
      context: context,
      initialTime: initialTime,
    ).then((time) {
      if (time == null || !context.mounted) return;
      appProvider.updateReminderTime('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
      _showSnackBar(context, 'Hora de recordatorio actualizada');
    });
  }

  void _showCurrencyPicker(BuildContext context, AppProvider appProvider) {
    final currencies = CurrencyHelper.supported;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Moneda'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return ListTile(
                leading: _currencySymbolAvatar(currency),
                title: Text(CurrencyHelper.settingsLabel(currency)),
                subtitle: Text(CurrencyHelper.settingsPreview(currency)),
                trailing: appProvider.currency == currency 
                    ? const Icon(Icons.check, color: Color(0xFF2E7D32))
                    : null,
                onTap: () {
                  appProvider.updateCurrency(currency);
                  Navigator.pop(context);
                  _showSnackBar(
                    context,
                    'Moneda actualizada a ${CurrencyHelper.settingsLabel(currency)}',
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Datos'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todos tus datos? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final auth = context.read<AuthProvider>();
              await appProvider.resetData(syncUserId: auth.firebaseUser?.uid);
              if (context.mounted) {
                _showSnackBar(context, 'Datos eliminados');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _currencySymbolAvatar(String currencyCode) {
    final symbol = CurrencyHelper.symbol(currencyCode);
    final fontSize = symbol.length > 1 ? 13.0 : 18.0;

    return CircleAvatar(
      backgroundColor: const Color(0xFFE8F5E9),
      child: Text(
        symbol,
        style: TextStyle(
          color: const Color(0xFF2E7D32),
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 