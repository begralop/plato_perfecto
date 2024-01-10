import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/presentation/pages/recipes/create_recipe.dart';

class HomePageNavbar extends StatefulWidget {
  const HomePageNavbar({Key? key, required this.navigationShell})
      : super(key: key);
  final StatefulNavigationShell navigationShell;

  @override
  State<HomePageNavbar> createState() => _HomePageNavbarState();
}

class _HomePageNavbarState extends State<HomePageNavbar> {

PageRouteBuilder _customPageRouteBuilder() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CreateRecipe();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); 
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widget.navigationShell,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
          onPressed: () {
            Navigator.push(
              context,
              _customPageRouteBuilder(),
            );
          },
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
                  color: Colors.black.withOpacity(0.2),
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
                  icon: Icon(Icons.list_outlined),
                  selectedIcon: Icon(Icons.list),
                  label: "Mis recetas",
                ),
                NavigationDestination(
                  icon: Icon(Icons.question_mark_outlined),
                  selectedIcon: Icon(Icons.question_mark),
                  label: "Receta random",
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
