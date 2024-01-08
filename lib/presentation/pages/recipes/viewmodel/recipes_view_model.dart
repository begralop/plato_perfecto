import 'dart:async';
import 'package:plato_perfecto/domain/recipes_repository.dart';
import 'package:plato_perfecto/model/recipe.dart';
import 'package:plato_perfecto/presentation/base/base_view_model.dart';
import 'package:plato_perfecto/presentation/model/resource_state.dart';

class RecipeViewModel extends BaseViewModel {
  final RecipesRepository _recipesRepository;

  final StreamController<ResourceState<Recipe>> getRandomRecipeState = StreamController();
  
  RecipeViewModel({required RecipesRepository recipesRepository}) : _recipesRepository = recipesRepository;

  fetchRandomRecipe() {
    getRandomRecipeState.add(ResourceState.loading());
    _recipesRepository
      .getRandomRecipe()
      .then(
        (value) => getRandomRecipeState.add(ResourceState.success(value)))
      .catchError(
        (error) => getRandomRecipeState.add(ResourceState.error(error)));
  }

  @override
  void dispose() {
    getRandomRecipeState.close();
  }
}