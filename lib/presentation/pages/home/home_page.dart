import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/auth.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';
import 'package:plato_perfecto/presentation/pages/login/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final User? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> signOut() async {
    await Auth().signOut().then((value) => GoRouter.of(context).push( NavigationRoutes.INITIAL_ROUTE));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                signOut();
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 110, 8, 211),
                  ),
                ),
              ),
              child: Text(widget.user?.displayName ?? widget.user?.email ?? "User"),
            ),
            const SizedBox(height: 16), // Añade espacio entre el TextButton y el nuevo texto
            Text(
              "Haz click en el nombre para desloguearte",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
            );
  }
}
