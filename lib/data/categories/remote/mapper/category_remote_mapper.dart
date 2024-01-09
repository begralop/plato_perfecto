import 'package:plato_perfecto/data/categories/remote/model/category_remote_model.dart';
import 'package:plato_perfecto/model/meal_category.dart';

class CategoryRemoteMapper {
  static Category fromRemote(CategoryRemoteModel remoteModel) {
    return Category(
        idCategory: remoteModel.idCategory,
        strCategory: remoteModel.strCategory,
        strCategoryThumb: remoteModel.strCategoryThumb,
        strCategoryDescription: remoteModel.strCategoryDescription);
  }
}
