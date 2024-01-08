import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/presentation/model/myrecipe.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late List<MyRecipe> myRecipes = [];

  bool showApiRecipes = false;
  bool isHelloButtonSelected = false;
  bool isRecipesButtonSelected = false;

  @override
  void initState() {
    super.initState();
    // Llamar a la función para cargar las recetas al inicializar la página
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
      showApiRecipes = false;
      isHelloButtonSelected = false;
      isRecipesButtonSelected = true;
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
                      // Acción para el primer botón
                      setState(() {
                        showApiRecipes = true;
                        isHelloButtonSelected = true;
                        isRecipesButtonSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: isHelloButtonSelected
                          ? Colors.deepPurple
                          : Color.fromARGB(255, 245, 245, 245),
                    ),
                    child: Text(
                      'Recetas API',
                      style: TextStyle(
                        fontSize: 18,
                        color: isHelloButtonSelected
                            ? Colors.white
                            : Color.fromARGB(255, 110, 8, 211),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para el segundo botón
                      _loadRecipes(); // Cargar las recetas existentes
                    },
                    style: ElevatedButton.styleFrom(
                      primary: isRecipesButtonSelected
                          ? Colors.deepPurple
                          : Color.fromARGB(255, 245, 245, 245),
                    ),
                    child: Text('Mis recetas',
                        style: TextStyle(
                          fontSize: 18,
                          color: isRecipesButtonSelected
                              ? Colors.white
                              : Color.fromARGB(255, 110, 8, 211),
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
                        child: Center(
                          child: Text(
                            'Hola Mundo',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                                              :
                                                  'https://cdn.computerhoy.com/sites/navi.axelspringer.es/public/media/image/2022/01/plato-cuchillo-tenedor-2577547.jpg',
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
                                      height: 80,
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
                                  Text(
                                    recipe.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      backgroundColor:
                                          Color.fromARGB(255, 110, 8, 211)
                                              .withOpacity(0.6),
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
