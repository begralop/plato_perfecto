import 'package:plato_perfecto/data/recipe/remote/model/recipe_remote_model.dart';
import 'package:plato_perfecto/model/recipe.dart';

class RecipeRemoteMapper {
  static Recipe fromRemote(RecipeRemoteModel remoteModel) {
    return Recipe(
        idMeal: remoteModel.idMeal,
        strMeal: remoteModel.strMeal,
        strCategory: remoteModel.strCategory,
        strInstructions: remoteModel.strInstructions,
        strIngredient1: remoteModel.strIngredient1,
        strIngredient2: remoteModel.strIngredient2,
        strIngredient3: remoteModel.strIngredient3,
        strIngredient4: remoteModel.strIngredient4,
        strIngredient5: remoteModel.strIngredient5,
        strIngredient6: remoteModel.strIngredient6,
        strIngredient7: remoteModel.strIngredient7,
        strIngredient8: remoteModel.strIngredient8,
        strIngredient9: remoteModel.strIngredient8,
        strIngredient10: remoteModel.strIngredient10,
        strIngredient11: remoteModel.strIngredient11,
        strIngredient12: remoteModel.strIngredient12,
        strIngredient13: remoteModel.strIngredient13,
        strIngredient14: remoteModel.strIngredient14,
        strIngredient15: remoteModel.strIngredient15,
        strIngredient16: remoteModel.strIngredient16,
        strIngredient17: remoteModel.strIngredient17,
        strIngredient18: remoteModel.strIngredient18,
        strIngredient19: remoteModel.strIngredient19,
        strIngredient20: remoteModel.strIngredient20,
        strMeasure1: remoteModel.strMeasure1,
        strMeasure2: remoteModel.strMeasure2,
        strMeasure3: remoteModel.strMeasure3,
        strMeasure4: remoteModel.strMeasure4,
        strMeasure5: remoteModel.strMeasure5,
        strMeasure6: remoteModel.strMeasure6,
        strMeasure7: remoteModel.strMeasure7,
        strMeasure8: remoteModel.strMeasure8,
        strMeasure9: remoteModel.strMeasure9,
        strMeasure10: remoteModel.strMeasure10,
        strMeasure11: remoteModel.strMeasure11,
        strMeasure12: remoteModel.strMeasure12,
        strMeasure13: remoteModel.strMeasure13,
        strMeasure14: remoteModel.strMeasure14,
        strMeasure15: remoteModel.strMeasure15,
        strMeasure16: remoteModel.strMeasure16,
        strMeasure17: remoteModel.strMeasure17,
        strMeasure18: remoteModel.strMeasure18,
        strMeasure19: remoteModel.strMeasure19,
        strMeasure20: remoteModel.strMeasure20,
        strSource: remoteModel.strSource,
        strMealThumb: remoteModel.strMealThumb);
  }
}
