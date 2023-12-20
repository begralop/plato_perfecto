import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageNavbar extends StatefulWidget {
  const HomePageNavbar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<HomePageNavbar> createState() => _HomePageNavbarState();
}

class _HomePageNavbarState extends State<HomePageNavbar> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (value) {
          widget.navigationShell.goBranch(value,
              initialLocation: value == widget.navigationShell.currentIndex);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",  
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.list),
            label: "Recetas",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.favorite),
            label: "Favoritos",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Perfil",
          ),
          
        ],
      ),
    );
  }
}