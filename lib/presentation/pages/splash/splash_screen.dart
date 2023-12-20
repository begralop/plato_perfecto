import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:plato_perfecto/presentation/navigation/initial_tree.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => const InitialTree()
        ));
    });
  }

@override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
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
    )
    );
  }
}