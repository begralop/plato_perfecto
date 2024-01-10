import 'package:plato_perfecto/model/meal_category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}
