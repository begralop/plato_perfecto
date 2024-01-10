import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/di/app_modules.dart';
import 'package:plato_perfecto/model/myrecipe.dart';
import 'package:plato_perfecto/model/recipe.dart';
import 'package:plato_perfecto/presentation/model/resource_state.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';
import 'package:plato_perfecto/presentation/pages/recipes/viewmodel/recipes_view_model.dart';
import 'package:plato_perfecto/presentation/widget/error/error_view.dart';
import 'package:plato_perfecto/presentation/widget/loading/loading_view.dart';

class RandomRecipePage extends StatefulWidget {
  const RandomRecipePage({super.key});

  @override
  State<RandomRecipePage> createState() => _RandomRecipePageState();
}

class _RandomRecipePageState extends State<RandomRecipePage> {
  late List<MyRecipe> myRecipes = [];
  final RecipeViewModel _recipeViewModel = inject<RecipeViewModel>();
  List<String> ingredientesList = [];
  Recipe? _recipe;

  bool showApiRecipes = false;
  bool isApiButtonSelected = true;
  bool isRecipesButtonSelected = false;

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
    // Llamar a la función para cargar las recetas cada vez que las dependencias cambien
    _loadRecipes();
  }

// Función para cargar las recetas desde Firestore
  Future<void> _loadRecipes() async {
    // Obtener el ID del usuario actual
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Referencia a la colección 'users' y documentos asociados al usuario actual
    CollectionReference userRecipesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('recipes');

    // Obtener las recetas del usuario actual
    QuerySnapshot<Map<String, dynamic>> recipesSnapshot =
        await userRecipesCollection.get()
            as QuerySnapshot<Map<String, dynamic>>;

    // Mapear los documentos de Firestore a objetos MyRecipe
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
          padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Receta random',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 110, 8, 211)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
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
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: _recipe?.strSource.isNotEmpty
                                      ? NetworkImage(_recipe!.strMealThumb)
                                      : NetworkImage(
                                          'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/01/plato-cuchillo-tenedor-2577547.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _recipe!.strMeal,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ));
  }
}
