// To parse this JSON data, do
//
//     final mealCategoryResponse = mealCategoryResponseFromMap(jsonString);

class CategoryRemoteModel {
    String idCategory;
    String strCategory;
    String strCategoryThumb;
    String strCategoryDescription;

    CategoryRemoteModel({
        required this.idCategory,
        required this.strCategory,
        required this.strCategoryThumb,
        required this.strCategoryDescription,
    });

    factory CategoryRemoteModel.fromMap(Map<String, dynamic> json) => CategoryRemoteModel(
        idCategory: json["idCategory"],
        strCategory: json["strCategory"],
        strCategoryThumb: json["strCategoryThumb"],
        strCategoryDescription: json["strCategoryDescription"],
    );

    Map<String, dynamic> toMap() => {
        "idCategory": idCategory,
        "strCategory": strCategory,
        "strCategoryThumb": strCategoryThumb,
        "strCategoryDescription": strCategoryDescription,
    };
}

class RecipeCategoryRemoteModel {
    final String strMeal;
  final String strMealThumb;
  final String idMeal;

  RecipeCategoryRemoteModel({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
  });
    factory RecipeCategoryRemoteModel.fromJson(Map<String, dynamic> json) {
    return RecipeCategoryRemoteModel(
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      idMeal: json['idMeal'] ?? '',
    );
  }
}