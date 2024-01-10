import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteRecipePage extends StatefulWidget {
  const FavoriteRecipePage({Key? key});

  @override
  State<FavoriteRecipePage> createState() => _FavoriteRecipePageState();
}

class _FavoriteRecipePageState extends State<FavoriteRecipePage> {
  late List<String> myRecipes = [];
  List<bool> isFavoriteList = [];
  late String userId; 

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      userId = user?.uid ?? ''; 
    });

    _loadMyRecipes();
  }

  Future<void> _loadMyRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedRecipes = prefs.getStringList('$userId-myRecipes');
    if (storedRecipes != null) {
      List<String> favoriteRecipes = [];
      List<bool> favoriteStatusList = [];

      for (String recipe in storedRecipes) {
        bool isFavorite = prefs.getBool('$userId-$recipe') ?? false;
        if (isFavorite) {
          favoriteRecipes.add(recipe);
          favoriteStatusList.add(isFavorite);
        }
      }
      setState(() {
        myRecipes = favoriteRecipes;
        isFavoriteList = favoriteStatusList;
      });
    }
  }

  Future<void> _toggleFavoriteStatus(int index) async {
    if (myRecipes.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isFavoriteList[index] = !isFavoriteList[index];
        prefs.setBool('$userId-${myRecipes[index]}', isFavoriteList[index]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 232, 232, 1.0),
      body: Padding(
        padding: const EdgeInsets.only(top: 36.0, left: 32.0, right: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Recetas favoritas',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 110, 8, 211),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myRecipes.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          myRecipes[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(
                          isFavoriteList[index]
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 40,
                          color: const Color.fromARGB(255, 110, 8, 211),
                        ),
                        onPressed: () => _toggleFavoriteStatus(index),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
