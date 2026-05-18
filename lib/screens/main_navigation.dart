import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/tutorial_service.dart';
import '../widgets/app_tutorial.dart';
import 'content_screen.dart';
import 'games_screen.dart';
import 'news_screen.dart';
import 'community_screen.dart';
import 'class_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  /// Starts as true if the cache already knows we should show the tutorial,
  /// so the very first frame renders with the overlay (no flash).
  bool _showTutorial = TutorialService.cachedShouldShow;

  final List<Widget> _screens = [
    const ContentScreen(),
    const GamesScreen(),
    const NewsScreen(),
    const CommunityScreen(),
    const ClassScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkTutorial();
  }

  Future<void> _checkTutorial() async {
    final show = await TutorialService.shouldShowTutorial();
    if (mounted && show != _showTutorial) {
      setState(() => _showTutorial = show);
    }
  }

  Future<void> _completeTutorial() async {
    await TutorialService.markCompleted();
    if (mounted) {
      setState(() {
        _showTutorial = false;
        _selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final scaffold = Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (!_showTutorial) {
                setState(() => _selectedIndex = index);
              }
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

        if (!_showTutorial) return scaffold;

        return Material(
          child: Stack(
            children: [
              scaffold,
              AppTutorial(
                onComplete: _completeTutorial,
                onTabChange: (index) =>
                    setState(() => _selectedIndex = index),
              ),
            ],
          ),
        );
      },
    );
  }
}
