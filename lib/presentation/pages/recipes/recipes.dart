import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plato_perfecto/presentation/navigation/navigation_routes.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 232, 232, 1.0),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Recetas',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 110, 8, 211)),
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
                itemCount:
                    30, // Cambia esto por la cantidad de recetas que tengas
                itemBuilder: (context, index) {
                  // Aquí deberías obtener la información de cada receta
                  // Puedes crear una lista de objetos Recipe y obtener la información desde allí
                  // Ejemplo: final recipe = recipes[index];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        /* context.go(Uri(
                                path: NavigationRoutes.JOKE_DETAIL_ROUTE,
                                queryParameters: {'category': category})
                            .toString()); */
                            context.go(NavigationRoutes.DETAIL_RECIPE_ROUTE);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Puedes agregar la imagen de la receta aquí
                          Image.asset("assets/images/pizza-carbonara.jpg"),
                          const SizedBox(height: 8),
                          Text('Carbonara',
                              style: TextStyle(fontSize: 14)),
                          // Puedes agregar más detalles aquí, como tiempo de preparación, etc.
                        ],
                      ),
                    ),
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
