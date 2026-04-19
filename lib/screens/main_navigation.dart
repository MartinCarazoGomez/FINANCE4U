import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
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

  final List<Widget> _screens = [
    const ContentScreen(),
    const GamesScreen(),
    const NewsScreen(),
    const CommunityScreen(),
    const ClassScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedItemColor: const Color(0xFF2E7D32),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
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
      },
    );
  }
} 