import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes Page"),
      ),
      body: const SafeArea(
        child: Center(
          child: Text("Welcome to the Third Page!"),
        ),
      ),
    );
  }
}