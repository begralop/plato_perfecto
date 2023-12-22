import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageNavbar extends StatefulWidget {
  const HomePageNavbar({Key? key, required this.navigationShell})
      : super(key: key);
  final StatefulNavigationShell navigationShell;

  @override
  State<HomePageNavbar> createState() => _HomePageNavbarState();
}

class _HomePageNavbarState extends State<HomePageNavbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 10),
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 110, 8, 211),
          elevation: 0,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {},
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(width: 10, color: Colors.white)),
          child: const Icon(
            Icons.add, // Cambia a tu icono deseado
            size: 32,
            color: Colors
                .white, // Ajusta el tamaño del icono según tus necesidades
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45.0),
                topRight: Radius.circular(45.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              selectedIndex: widget.navigationShell.currentIndex,
              onDestinationSelected: (value) {
                widget.navigationShell.goBranch(value,
                    initialLocation:
                        value == widget.navigationShell.currentIndex);
              },
              indicatorColor: Colors.transparent,
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.list),
                  selectedIcon: Icon(Icons.list_outlined),
                  label: "Recetas",
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
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
          ),
        ],
      ),
    );
  }
}
