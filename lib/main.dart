import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plato_perfecto/firebase_options.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        fontFamily: "LindenHill"
      ),
    );
  }
}
