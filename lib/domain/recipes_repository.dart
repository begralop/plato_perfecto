import 'package:plato_perfecto/model/recipe.dart';

abstract class RecipesRepository {
  Future<Recipe> getRandomRecipe();
  //Future<Recipe> getRecipeByName(String name);
 // Future<Recipe> getRecipeByCategory(String category);

}