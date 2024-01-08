class MyRecipe {
  late String name;
  late String image;
  late String time;
  late String people;
  late List<String> ingredients;

  MyRecipe({required this.name, required this.image, required this.time, required this.people, required this.ingredients});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image' : image,
      'time': time,
      'people': people,
      'ingredients': ingredients,
    };
  }
}
