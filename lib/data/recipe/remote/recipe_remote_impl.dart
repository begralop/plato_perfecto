import 'package:plato_perfecto/data/recipe/remote/model/recipe_remote_model.dart';
import 'package:plato_perfecto/data/remote/error/remote_error_mapper.dart';
import 'package:plato_perfecto/data/remote/network_client.dart';
import 'package:plato_perfecto/data/remote/network_constants.dart';

class RecipeRemoteImpl {
  final NetworkClient _networkClient;

  RecipeRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<RecipeRemoteModel> getRandomRecipe() async {
    try {
      final response =
          await _networkClient.dio.get(NetworkConstants.RECIPES_RANDOM_PATH);

      final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
      final List<dynamic> mealsList = responseData["meals"];

      if (mealsList.isNotEmpty) {
        // Obtén la primera receta de la lista (supongo que solo necesitas una receta aleatoria).
        final Map<String, dynamic> randomRecipeData = mealsList[0];

        // Convierte los datos de la receta a una instancia de RecipeRemoteModel.
        final RecipeRemoteModel randomRecipe = RecipeRemoteModel.fromJson(randomRecipeData);

        return randomRecipe;
      } else {
        // Manejar el caso en que la lista de recetas está vacía.
        throw Exception("La lista de recetas está vacía");
      }
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}
