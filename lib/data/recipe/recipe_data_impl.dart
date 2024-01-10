import 'package:plato_perfecto/data/recipe/remote/mapper/recipe_category_remote_mapper.dart';
import 'package:plato_perfecto/data/recipe/remote/mapper/recipe_remote_mapper.dart';
import 'package:plato_perfecto/data/recipe/remote/recipe_remote_impl.dart';
import 'package:plato_perfecto/domain/recipes_repository.dart';
import 'package:plato_perfecto/model/recipe.dart';
import 'package:plato_perfecto/model/recipe_category_model.dart';

class RecipeDataImpl extends RecipesRepository {
  final RecipeRemoteImpl _remoteImpl;

  RecipeDataImpl({required RecipeRemoteImpl remoteImpl})
      : _remoteImpl = remoteImpl;

  @override
  Future<Recipe> getRandomRecipe() async {
    final remoteRecipe = await _remoteImpl.getRandomRecipe();
    return RecipeRemoteMapper.fromRemote(remoteRecipe);
  }

  @override
  Future<List<RecipeCategoryModel>> getRecipeByCategory(String category) async {
    final remoteRecipeList = await _remoteImpl.getRecipeByCategory(category);
    return remoteRecipeList
        .map((e) => RecipeCategoryRemoteMapper.fromRemote(e))
        .toList();
  }

  @override
  Future<Recipe> getRecipeByName(String name) async {
    final remoteRecipe = await _remoteImpl.getRecipeByName(name);
    return RecipeRemoteMapper.fromRemote(remoteRecipe);
  }
}
