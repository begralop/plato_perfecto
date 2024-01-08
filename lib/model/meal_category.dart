// To parse this JSON data, do
//
//     final mealCategoryResponse = mealCategoryResponseFromMap(jsonString);

import 'dart:convert';

MealCategoryResponse mealCategoryResponseFromMap(String str) => MealCategoryResponse.fromMap(json.decode(str));

String mealCategoryResponseToMap(MealCategoryResponse data) => json.encode(data.toMap());

class MealCategoryResponse {
    List<Category> categories;

    MealCategoryResponse({
        required this.categories,
    });

    factory MealCategoryResponse.fromMap(Map<String, dynamic> json) => MealCategoryResponse(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toMap())),
    };
}

class Category {
    String idCategory;
    String strCategory;
    String strCategoryThumb;
    String strCategoryDescription;

    Category({
        required this.idCategory,
        required this.strCategory,
        required this.strCategoryThumb,
        required this.strCategoryDescription,
    });

    factory Category.fromMap(Map<String, dynamic> json) => Category(
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
