import 'dart:async';
import 'package:plato_perfecto/domain/categories_repository.dart';
import 'package:plato_perfecto/model/meal_category.dart';
import 'package:plato_perfecto/presentation/base/base_view_model.dart';
import 'package:plato_perfecto/presentation/model/resource_state.dart';

class CategoriesViewModel extends BaseViewModel {
  final CategoryRepository _categoriesRepository;

  final StreamController<ResourceState<List<Category>>> getCategoriesState = StreamController();
  
  CategoriesViewModel({required CategoryRepository categoriesRepository}) : _categoriesRepository = categoriesRepository;

  fetchCategoriesList() {
    getCategoriesState.add(ResourceState.loading());

    _categoriesRepository
      .getCategories()
      .then(
        (value) => getCategoriesState.add(ResourceState.success(value)))
      .catchError(
        (error) => getCategoriesState.add(ResourceState.error(error)));
  }

  @override
  void dispose() {
    getCategoriesState.close();
  }
}