import 'package:plato_perfecto/data/categories/remote/model/category_remote_model.dart';
import 'package:plato_perfecto/data/remote/error/remote_error_mapper.dart';
import 'package:plato_perfecto/data/remote/network_client.dart';
import 'package:plato_perfecto/data/remote/network_constants.dart';

class CategoryRemoteImpl {
  final NetworkClient _networkClient;

  CategoryRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<List<CategoryRemoteModel>> getCategories() async {
    try {
      final response =
          await _networkClient.dio.get(NetworkConstants.CATEGORIES_PATH);

      final Map<String, dynamic> responseData =
          response.data as Map<String, dynamic>;
      final List<dynamic> categoriesList = responseData["categories"];

      return categoriesList.map((e) => CategoryRemoteModel.fromMap(e)).toList();
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}
