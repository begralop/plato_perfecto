import 'package:plato_perfecto/data/categories/remote/category_remote_impl.dart';
import 'package:plato_perfecto/data/categories/remote/mapper/category_remote_mapper.dart';
import 'package:plato_perfecto/domain/categories_repository.dart';
import 'package:plato_perfecto/model/meal_category.dart';

class CategoryDataImpl extends CategoryRepository {
  final CategoryRemoteImpl _remoteImpl;

  CategoryDataImpl({required CategoryRemoteImpl remoteImpl})
      : _remoteImpl = remoteImpl;

  @override
  Future<List<Category>> getCategories() async {
    final remoteCateoriesList = await _remoteImpl.getCategories();
    return remoteCateoriesList
        .map((e) => CategoryRemoteMapper.fromRemote(e))
        .toList();
  }
}
