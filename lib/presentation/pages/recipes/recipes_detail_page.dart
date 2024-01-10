import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipesDetail extends StatefulWidget {
  final String recipeName;
  final NetworkImage image;
  final String time;
  final String people;
  final List<String?> ingredients;

  const RecipesDetail({
    Key? key,
    required this.recipeName,
    required this.image,
    required this.people,
    required this.time,
    required this.ingredients,
  }) : super(key: key);

  @override
  State<RecipesDetail> createState() => _RecipesDetailState();
}

class _RecipesDetailState extends State<RecipesDetail> {
  bool isFavorite = false;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    checkFavoriteStatus();
  }

  Future<void> _loadUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      userId = user?.uid ?? '';
    });
  }

  Future<void> checkFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('$userId-${widget.recipeName}') ?? false;
    });
  }

  Future<void> toggleFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isFavorite = !isFavorite;
      prefs.setBool('$userId-${widget.recipeName}', isFavorite);
      List<String> storedRecipes = prefs.getStringList('$userId-myRecipes') ?? [];

      if (isFavorite) {
        storedRecipes.add(widget.recipeName);
      } else {
        storedRecipes.remove(widget.recipeName);
      }

      prefs.setStringList('$userId-myRecipes', storedRecipes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 232, 232, 1.0),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.60,
              child: Container(
                padding: const EdgeInsets.all(28.0),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(232, 232, 232, 1.0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.recipeName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 110, 8, 211),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 40,
                              color: const Color.fromARGB(255, 110, 8, 211),
                            ),
                            onPressed: toggleFavoriteStatus,
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.timer,
                              color: Color.fromRGBO(0, 0, 0, 0.667)),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.time} min",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.667)),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.person,
                              color: Color.fromRGBO(0, 0, 0, 0.667)),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.people} comensales",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.667)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ingredientes y descripción',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 110, 8, 211)),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.ingredients.map((ingredient) {
                          return Text(
                            ingredient!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
