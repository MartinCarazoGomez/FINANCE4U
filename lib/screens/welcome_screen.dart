import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/platform_auth.dart';
import '../utils/tutorial_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    try {
      await auth.signInWithGoogle();
      if (!context.mounted) return;
      _navigateAfterAuth(context, auth);
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, e);
    }
  }

  Future<void> _continueAsGuest(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    try {
      await auth.signInAsGuest();
      if (!context.mounted) return;
      _navigateAfterAuth(context, auth);
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, e);
    }
  }

  void _navigateAfterAuth(BuildContext context, AuthProvider auth) async {
    final uid = auth.firebaseUser?.uid;
    if (auth.onboardingCompleted) {
      if (uid != null) {
        await TutorialService.prepareForUser(uid);
      }
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
  }

  void _showError(BuildContext context, Object e) {
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

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    size: 60,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'FINANCE4U',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tu educación financiera',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Spacer(flex: 2),
                const Text(
                  '¿Cómo quieres empezar?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                _AuthButton(
                  onPressed: auth.busy || !isGoogleSignInSupported
                      ? null
                      : () => _signInWithGoogle(context),
                  icon: Icons.g_mobiledata,
                  label: 'Continuar con Google',
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2E7D32),
                  loading: auth.busy,
                ),
                if (!isGoogleSignInSupported) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Google Sign-In solo funciona en Android/iOS.\n'
                    'En Windows usa invitado o conecta un móvil.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 12),
                _AuthButton(
                  onPressed:
                      auth.busy ? null : () => _continueAsGuest(context),
                  icon: Icons.person_outline,
                  label: 'Continuar como invitado',
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  outlined: true,
                  loading: auth.busy,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Los invitados pueden vincular Google después\n desde su perfil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool outlined;
  final bool loading;

  const _AuthButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.outlined = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 22),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                side: const BorderSide(color: Colors.white70, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon, size: 26),
              label: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
    );
  }
}
