import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _auth.authStateChanges().listen((User? user) {
      if (!mounted) return;

      setState(() {
        _user = user;
      });

      if (_user == null) {
        Future.delayed(const Duration(seconds: 3), () {
          context.go(NavigationRoutes.LOGIN_ROUTE);
        });
      } else {
        if (_user!.emailVerified == true) {
          Future.delayed(const Duration(seconds: 3), () {
            context.go(
              NavigationRoutes.HOME_ROUTE,
            );
          });
        } else {
          _user!.sendEmailVerification();
          Future.delayed(const Duration(seconds: 3), () {
            context.go(NavigationRoutes.LOGIN_ROUTE);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/plato_perfecto_logo.png',
            width: 200,
            height: 200,
          ),
        ),
        Positioned(
          bottom: 0,
          width: 600,
          height: 200,
          child: Lottie.asset('assets/lottie/loading_animation.json'),
        ),
      ],
    ));
  }
}
