import 'package:plato_perfecto/model/recipe.dart';
import 'package:plato_perfecto/model/recipe_category_model.dart';

abstract class RecipesRepository {
  Future<Recipe> getRandomRecipe();
  Future<List<RecipeCategoryModel>> getRecipeByCategory(String category);
}
