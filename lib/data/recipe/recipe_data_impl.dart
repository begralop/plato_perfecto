import 'package:plato_perfecto/data/recipe/remote/mapper/recipe_remote_mapper.dart';
import 'package:plato_perfecto/data/recipe/remote/recipe_remote_impl.dart';
import 'package:plato_perfecto/domain/recipes_repository.dart';
import 'package:plato_perfecto/model/recipe.dart';

class RecipeDataImpl extends RecipesRepository {

  final RecipeRemoteImpl _remoteImpl;

  RecipeDataImpl({required RecipeRemoteImpl remoteImpl}) : _remoteImpl = remoteImpl;

  @override
  Future<Recipe> getRandomRecipe() async {
    final remoteRecipe =  await _remoteImpl.getRandomRecipe();

    return RecipeRemoteMapper.fromRemote(remoteRecipe);
  }
  
}