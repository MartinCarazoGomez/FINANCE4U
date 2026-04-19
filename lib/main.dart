import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- NUEVAS IMPORTACIONES DE FIREBASE ---
import 'package:firebase_core/firebase_core.dart';
import 'package:finance4u/firebase_options.dart'; 

import 'screens/main_navigation.dart';
import 'screens/welcome_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/progress_service.dart';
import 'providers/app_provider.dart';
import 'services/firebase_service.dart';

// Variable global para controlar el desbloqueo de juegos
// 0: todos los juegos habilitados
// 1: desbloqueo progresivo
int unlockGames = 0;

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
  
  // Configurar orientación de pantalla preferida
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Inicializar datos de demo para mostrar progreso
  ProgressService().initDemoData();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: const Finance4UApp(),
    ),
  );
}

class Finance4UApp extends StatelessWidget {
  const Finance4UApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        // Configurar barra de estado según el tema
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: appProvider.isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: appProvider.isDarkMode ? Colors.black : Colors.white,
          systemNavigationBarIconBrightness: appProvider.isDarkMode ? Brightness.light : Brightness.dark,
        ));
        
        return MaterialApp(
          title: 'FINANCE4U - Educación Financiera',
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          routes: {
            '/main': (context) => const MainNavigation(),
            '/welcome': (context) => const WelcomeScreen(),
            '/splash': (context) => const SplashScreen(),
          },
        );
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
  
  ThemeData _buildDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: const Color(0xFF4CAF50),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4CAF50),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF66BB6A),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF4CAF50),
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