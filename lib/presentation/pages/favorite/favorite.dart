import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
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