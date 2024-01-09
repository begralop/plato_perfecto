import 'package:plato_perfecto/model/meal_category.dart';
import 'package:plato_perfecto/model/recipe.dart';

abstract class CategoryRepository {
    Future<List<Category>> getCategories();
}