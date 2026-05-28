import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/tutorial_service.dart';
import '../widgets/app_tutorial.dart';
import 'class_screen.dart';
import 'community_screen.dart';
import 'content_screen.dart';
import 'games_screen.dart';
import 'news_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  bool _tutorialPending = false;
  bool _tutorialShowing = false;

  final List<Widget> _screens = const [
    ContentScreen(),
    GamesScreen(),
    NewsScreen(),
    CommunityScreen(),
    ClassScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowTutorial());
  }

  Future<void> _maybeShowTutorial() async {
    if (!mounted || _tutorialShowing) return;

    final uid = context.read<AuthProvider>().firebaseUser?.uid;
    if (uid == null) return;

    final show = await TutorialService.shouldShowTutorial(userId: uid);
    if (!mounted || !show || _tutorialShowing) return;

    _tutorialShowing = true;
    _tutorialPending = true;

    await showAppTutorial(
      context,
      onTabChange: (index) {
        if (mounted) setState(() => _selectedIndex = index);
      },
    );

    if (!mounted) return;

    await TutorialService.markCompleted(userId: uid);

    if (!mounted) return;

    setState(() {
      _tutorialShowing = false;
      _tutorialPending = false;
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (_tutorialPending) return;
          setState(() => _selectedIndex = index);
        },
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Contenido',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            label: 'Juegos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Comunidad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Clase',
          ),
        ],
      ),
    );
  }
}
