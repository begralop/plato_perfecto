import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(      backgroundColor: Color.fromRGBO(232, 232, 232, 1.0),

      appBar: AppBar(
        title: const Text("Second Page"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) => ListTile(title: Text("Item $index")),
        ),
      ),
    );
  }
}