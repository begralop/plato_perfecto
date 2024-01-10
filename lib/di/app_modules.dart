import 'package:get_it/get_it.dart';
import 'package:plato_perfecto/data/categories/category_data_impl.dart';
import 'package:plato_perfecto/data/categories/remote/category_remote_impl.dart';
import 'package:plato_perfecto/data/recipe/recipe_data_impl.dart';
import 'package:plato_perfecto/data/recipe/remote/recipe_remote_impl.dart';
import 'package:plato_perfecto/data/remote/network_client.dart';
import 'package:plato_perfecto/domain/categories_repository.dart';
import 'package:plato_perfecto/domain/recipes_repository.dart';
import 'package:plato_perfecto/presentation/pages/home/viewmodel/categories_view_model.dart';
import 'package:plato_perfecto/presentation/pages/recipes/viewmodel/recipes_view_model.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupRecipeModule();
    _setupCategoriesModule();
  }

  _setupMainModule() {
    inject.registerSingleton(NetworkClient());
  }

  _setupRecipeModule() {
    inject.registerFactory(() => RecipeRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<RecipesRepository>(
        () => RecipeDataImpl(remoteImpl: inject.get()));
    inject.registerFactory(
        () => RecipeViewModel(recipesRepository: inject.get()));
  }

  _setupCategoriesModule() {
    inject
        .registerFactory(() => CategoryRemoteImpl(networkClient: inject.get()));
    inject.registerFactory<CategoryRepository>(
        () => CategoryDataImpl(remoteImpl: inject.get()));
    inject.registerFactory(
        () => CategoriesViewModel(categoriesRepository: inject.get()));
  }
}
