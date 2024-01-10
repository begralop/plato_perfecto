import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/di/app_modules.dart';
import 'package:plato_perfecto/model/myrecipe.dart';
import 'package:plato_perfecto/model/recipe.dart';
import 'package:plato_perfecto/presentation/model/resource_state.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plato_perfecto/presentation/pages/recipes/viewmodel/recipes_view_model.dart';
import 'package:plato_perfecto/presentation/widget/error/error_view.dart';
import 'package:plato_perfecto/presentation/widget/loading/loading_view.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late List<MyRecipe> myRecipes = [];
  final RecipeViewModel _recipeViewModel = inject<RecipeViewModel>();
  List<String> ingredientesList = [];
  Recipe? _recipe;

  bool showApiRecipes = false;
  bool isApiButtonSelected = true;
  bool isRecipesButtonSelected = false;
  bool recipesLoad = false;

  @override
  void initState() {
    super.initState();

    _recipeViewModel.getRandomRecipeState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          ingredientesList.clear();

          setState(() {
            _recipe = state.data!;
          });
          ingredientesList.add(_recipe!.strIngredient1);
          ingredientesList.add(_recipe!.strIngredient2);
          ingredientesList.add(_recipe!.strIngredient3);
          ingredientesList.add(_recipe!.strInstructions);
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _recipeViewModel.fetchRandomRecipe();
          });
          break;
      }
    });
    _recipeViewModel.fetchRandomRecipe();
    _loadRecipes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference userRecipesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('recipes');

    QuerySnapshot<Map<String, dynamic>> recipesSnapshot =
        await userRecipesCollection.get()
            as QuerySnapshot<Map<String, dynamic>>;

    List<MyRecipe> recipes = recipesSnapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      Map<String, dynamic> data = doc.data();
      return MyRecipe(
        name: data['name'] ?? 'Nombre receta',
        people: data['people'] ?? 'Comensales',
        time: data['time'] ?? 'Tiempo',
        ingredients: (data['ingredients'] as List<dynamic>?)
                ?.map((ingredient) => ingredient.toString())
                .toList() ??
            ['Ingrediente 1', 'Ingrediente 2', 'Ingrediente 3'],
        image: data['image'] ?? 'assets/images/pizza-carbonara.jpg',
      );
    }).toList();

    setState(() {
      myRecipes = recipes;
    });
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
                    'Recetas',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 110, 8, 211)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showApiRecipes = false;
                        isApiButtonSelected = true;
                        isRecipesButtonSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isApiButtonSelected
                          ? Colors.deepPurple
                          : const Color.fromARGB(255, 245, 245, 245),
                    ),
                    child: Text(
                      'Mis recetas',
                      style: TextStyle(
                        fontSize: 18,
                        color: isApiButtonSelected
                            ? Colors.white
                            : const Color.fromARGB(255, 110, 8, 211),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showApiRecipes = true;
                        isApiButtonSelected = false;
                        isRecipesButtonSelected = true;
                      });
                      _loadRecipes();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecipesButtonSelected
                          ? Colors.deepPurple
                          : const Color.fromARGB(255, 245, 245, 245),
                    ),
                    child: Text('Receta random',
                        style: TextStyle(
                          fontSize: 18,
                          color: isRecipesButtonSelected
                              ? Colors.white
                              : const Color.fromARGB(255, 110, 8, 211),
                        )),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    crossAxisCount: 3,
                  ),
                  itemCount: showApiRecipes ? 1 : myRecipes.length,
                  itemBuilder: (context, index) {
                    if (showApiRecipes) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            context.go(
                              NavigationRoutes.DETAIL_RECIPE_ROUTE,
                              extra: {
                                'name': _recipe?.strMeal,
                                'image': _recipe?.strMealThumb.isNotEmpty
                                    ? NetworkImage(_recipe!.strMealThumb)
                                    : 'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/01/plato-cuchillo-tenedor-2577547.jpg',
                                'people': "undefined",
                                'time': "time",
                                'ingredients': ingredientesList,
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: 0.9,
                                    child: Container(
                                      width: 80,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: _recipe?.strSource.isNotEmpty
                                              ? NetworkImage(
                                                  _recipe!.strMealThumb)
                                              : NetworkImage(
                                                  'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/01/plato-cuchillo-tenedor-2577547.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(_recipe!.strMeal,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final MyRecipe recipe = myRecipes[index];
                      final img = Image.network(recipe.image);

                      return Card(
                        child: InkWell(
                          onTap: () {
                            context.go(
                              NavigationRoutes.DETAIL_RECIPE_ROUTE,
                              extra: {
                                'name': recipe.name,
                                'image': recipe.image.isNotEmpty
                                    ? img.image
                                    : NetworkImage(
                                        'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/01/plato-cuchillo-tenedor-2577547.jpg'),
                                'people': recipe.people,
                                'time': recipe.time,
                                'ingredients': recipe.ingredients,
                              },
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity: 0.9,
                                    child: Container(
                                      width: 80,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: recipe.image.isNotEmpty
                                              ? img.image
                                              : NetworkImage(
                                                  'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/01/plato-cuchillo-tenedor-2577547.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(recipe.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
