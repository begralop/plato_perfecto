class MyRecipe {
  late String name;
  late String time;
  late String people;
  late String ingredient;

  MyRecipe({required this.name, required this.time, required this.people, required this.ingredient});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'people': people,
      'ingredient': ingredient,
    };
  }
}
