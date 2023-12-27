import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/auth.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String displayName = '';
  late String displayEmail = '';
  late ImageProvider<Object> displayImage;

  Future<void> signOut() async {
    await Auth()
        .signOut()
        .then((value) => context.go(NavigationRoutes.LOGIN_ROUTE));
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    User? currentUser = Auth().currentUser;
    if (currentUser != null) {
      setState(() {
        displayName = currentUser.displayName ??  "User";
        displayEmail = currentUser.email ?? "Email";
        displayImage = currentUser.photoURL != null
            ? NetworkImage(currentUser.photoURL!)
            : const AssetImage("assets/images/blanck_picture_profile.png")
                as ImageProvider<Object>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1.0),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mi Perfil',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 110, 8, 211)),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: displayImage, // Reemplaza con tu imagen
                  ),
                ),
              ],
            ),
            const SizedBox(height: 38),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nombre:',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(90, 90, 90, 1.0)),
                ),
                const SizedBox(width: 16),
                Flexible(
        child: Text(
                  displayName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                Flexible(
        child: Text(
                  displayEmail,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
