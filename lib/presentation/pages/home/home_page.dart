import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/auth.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String displayName = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }
  Future<void> getUser() async {
    User? currentUser = Auth().currentUser;
    if (currentUser != null) {
      setState(() {
        displayName = currentUser.displayName ?? currentUser.email ?? "User";

      });
    }
  }

  Future<void> signOut() async {
    await Auth().signOut().then((value) => context.go(NavigationRoutes.LOGIN_ROUTE));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1.0),
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
        child: Text(
          "Hola, $displayName",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 110, 8, 211),
          ),
        ),
      ),
              ],
            ),
            const SizedBox(height: 4),
            const Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "¡Qué buen día para cocinar!",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(129, 129, 129, 1.0)),
                ),
              ],
            )
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nombre:',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(90, 90, 90, 1.0)),
                ),
                const SizedBox(width: 16),
                Text(
                  displayName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Email:',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(90, 90, 90, 1.0)),
                ),
                const SizedBox(width: 16),
                Text(
                  displayEmail,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20), // Espaciado antes del botón
            // Botón para desloguearse
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Alineación a la izquierda
              children: [
                TextButton(
                  onPressed: () {
                    signOut();
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 8), // Espaciado entre el icono y el texto
                      Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ), */
          ],
        ),
      ),
            );
  }
}
