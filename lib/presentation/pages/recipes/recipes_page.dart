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
          padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 26),
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
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: 3,
                    ),
                    itemCount: showApiRecipes ? 1 : myRecipes.length,
                    itemBuilder: (context, index) {
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
                                      height: 59,
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
                                child: Text(
                                    // Puedes personalizar el texto según tus necesidades
                                    recipe.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
