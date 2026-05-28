import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- NUEVAS IMPORTACIONES DE FIREBASE ---

import 'package:firebase_core/firebase_core.dart';
import 'package:finance4u/firebase_options.dart'; 

import 'screens/main_navigation.dart';
import 'screens/welcome_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'services/firebase_service.dart';

// Variable global para controlar el desbloqueo de juegos
// 0: todos los juegos habilitados
// 1: desbloqueo progresivo
int unlockGames = 1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- INICIALIZACIÓN DE FIREBASE ACTUALIZADA ---
  try {
    // 1. Inicializa el núcleo de Firebase con el archivo generado
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // 2. Inicializa tu servicio personalizado (auth, base de datos, etc.)
    await FirebaseService.instance.initialize();
  } catch (e) {
    // Handle Firebase initialization error
    // In production, you might want to show an error screen
    debugPrint('Firebase initialization error: $e');
  }
  
  // Activar edge-to-edge: el app ocupa toda la pantalla y Flutter
  // reporta correctamente MediaQuery.padding (altura de la barra del sistema).
  // Esto permite que el BottomNavigationBar coloque sus iconos ENCIMA de los
  // botones del sistema y extienda su fondo detrás de ellos.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Configurar orientación de pantalla preferida
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProxyProvider<AppProvider, AuthProvider>(
          create: (_) => AuthProvider(),
          update: (_, appProvider, auth) =>
              auth!..attachAppProvider(appProvider),
        ),
      ],
      child: const Finance4UApp(),
    ),
  );
}

class Finance4UApp extends StatelessWidget {
  const Finance4UApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'FINANCE4U - Educación Financiera',
      theme: _buildLightTheme(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainNavigation(),
        '/welcome': (context) => const WelcomeScreen(),
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
  
  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: const Color(0xFF2E7D32), // Verde del logo
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E7D32),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E7D32),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF388E3C),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Color(0xFF212121),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF2E7D32),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
  
}