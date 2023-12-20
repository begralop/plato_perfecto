import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/auth.dart';
import 'package:plato_perfecto/presentation/pages/home/home_page.dart';
import 'package:plato_perfecto/presentation/pages/login/login_page.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';

class InitialTree extends StatefulWidget {
  const InitialTree({super.key});

  @override
  State<InitialTree> createState() => _InitialTreeState();
}

class _InitialTreeState extends State<InitialTree> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User? currentUser = snapshot.data;
          if (currentUser?.emailVerified == true) {
            return MaterialApp.router(
              routerConfig: router,
            );
          } else {
            return MaterialApp.router(
              routerConfig: router,
            );
          }
        } else {
          return MaterialApp.router(
      routerConfig: router,
    );
        }
      },
    );
  }
}
