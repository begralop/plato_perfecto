import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(children: [
          /// -- IMAGE
          Stack(
            children: [
              Text("Mi perfil"),
              Container(
                margin: EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                ),
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    color: Colors.yellow, //PARA PROBAR CONTAINER
                    borderRadius: new BorderRadius.circular(50.0),
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/plato_perfecto_logo.png",
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      new BoxShadow(
                        //SOMBRA
                        color: Color(0xffA4A4A4),
                        offset: Offset(1.0, 5.0),
                        blurRadius: 3.0,
                      ),
                    ]),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
