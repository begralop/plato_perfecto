import 'package:plato_perfecto/data/categories/remote/model/category_remote_model.dart';
import 'package:plato_perfecto/model/recipe_category_model.dart';

class RecipeCategoryRemoteMapper {
  static RecipeCategoryModel fromRemote(RecipeCategoryRemoteModel remoteModel) {
    return RecipeCategoryModel(
        idMeal: remoteModel.idMeal,
        strMeal: remoteModel.strMeal,
        strMealThumb: remoteModel.strMealThumb);
  }
}
