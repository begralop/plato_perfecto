import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/auth.dart';
import 'package:plato_perfecto/di/app_modules.dart';
import 'package:plato_perfecto/model/meal_category.dart';
import 'package:plato_perfecto/model/recipe.dart';
import 'package:plato_perfecto/model/recipe_category_model.dart';
import 'package:plato_perfecto/presentation/model/resource_state.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';
import 'package:plato_perfecto/presentation/pages/home/viewmodel/categories_view_model.dart';
import 'package:plato_perfecto/presentation/pages/recipes/viewmodel/recipes_view_model.dart';
import 'package:plato_perfecto/presentation/widget/error/error_view.dart';
import 'package:plato_perfecto/presentation/widget/loading/loading_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String displayName = '';
  final CategoriesViewModel _categoriesViewModel =
      inject<CategoriesViewModel>();
  final RecipeViewModel _recipeViewModel = inject<RecipeViewModel>();
  List<Category> _categoriesList = [];
  List<RecipeCategoryModel> _recipesList = [];

  late TextEditingController _searchController;
  String selectedCategoryName =
      ""; // Variable para almacenar el nombre de la categoría seleccionada
  int selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    getUser();
    _searchController = TextEditingController();

    _categoriesViewModel.getCategoriesState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _categoriesList = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _categoriesViewModel.fetchCategoriesList();
          });
          break;
      }
    });

    _categoriesViewModel.fetchCategoriesList();
  }

  Future<void> getUser() async {
    User? currentUser = Auth().currentUser;
    if (currentUser != null) {
      setState(() {
        displayName = currentUser.displayName ?? currentUser.email ?? "User";
      });
    }
  }

  Future<void> signOut() async {
    await Auth()
        .signOut()
        .then((value) => context.go(NavigationRoutes.LOGIN_ROUTE));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(232, 232, 232, 1.0),
      
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    "Hola, $displayName",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 110, 8, 211),
                    ),
                  ),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "¡Qué buen día para cocinar!",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(129, 129, 129, 1.0)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Buscar receta...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: -8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 110, 8, 211),
                  ),
                  onPressed: () {
                    // Aquí puedes realizar la acción de búsqueda
                    // usando el contenido de _searchController.text
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Categorías",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 110, 8, 211),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categoriesList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final category = entry.value;
                  return Column(
                    children: [
                      Container(
                        width: 120.0,
                        height: 80.0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción al hacer clic en el botón de la categoría
                              setState(() {
                                selectedCategoryIndex = index;
                                selectedCategoryName =
                                    category.strCategory ?? "";

                                _recipeViewModel.getRecipeListState.stream
                                    .listen((state) {
                                  switch (state.status) {
                                    case Status.LOADING:
                                      LoadingView.show(context);
                                      break;
                                    case Status.SUCCESS:
                                      LoadingView.hide();
                                      setState(() {
                                        _recipesList = state.data!;
                                      });
                                      break;
                                    case Status.ERROR:
                                      LoadingView.hide();
                                      ErrorView.show(
                                          context, state.exception!.toString(),
                                          () {
                                        _recipeViewModel.fetchRecipeByCategory(
                                            selectedCategoryName);
                                      });
                                      break;
                                  }
                                });
                                _recipeViewModel.fetchRecipeByCategory(
                                    selectedCategoryName);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              primary: selectedCategoryIndex == index
                                  ? Color.fromARGB(255, 110, 8, 211)
                                      .withOpacity(
                                          0.2) // Morado si está seleccionado
                                  : Colors
                                      .white, // Color normal si no está seleccionado
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      category.strCategoryThumb ?? ""),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2), // Espacio entre el botón y el texto
                      Text(
                        category.strCategory ?? "Sin categoría",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Mostrando: ",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.black, // Color negro para "Mostrando"
                  ),
                ),
                Text(
                  selectedCategoryName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 110, 8,
                        211), // Color morado para la categoría seleccionada
                  ),
                ),
              ],
            ),
            if (_recipesList.isNotEmpty)
              Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      crossAxisCount: 3,
                    ),
                    itemCount: _recipesList.length,
                    itemBuilder: (context, index) {
                      if (index < _recipesList.length) {
                        final recipe = _recipesList[index];
                        return Card(
                          child: InkWell(
                            onTap: () {
                              context.go(
                                NavigationRoutes.DETAIL_RECIPE_ROUTE,
                                extra: {
                                  'name': recipe.strMeal,
                                  'image': recipe.strMealThumb.isNotEmpty
                                      ? NetworkImage(recipe!.strMealThumb)
                                      : 'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/01/plato-cuchillo-tenedor-2577547.jpg',
                                  'people': "undefined",
                                  'time': "time",
                                  'ingredients': [recipe.idMeal],
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
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: recipe
                                                    .strMealThumb.isNotEmpty
                                                ? NetworkImage(
                                                    recipe!.strMealThumb)
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
                                      recipe.strMeal,
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
                      }
                    }),
              )
            else
              Text(
                "Seleccione una categoría para mostrar recetas.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(129, 129, 129,
                      1.0), // Puedes ajustar el color según tu preferencia
                ),
              ),
          ],
        ),
      ),
    );
  }
}
