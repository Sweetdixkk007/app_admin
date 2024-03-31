class Ingredient {
  final String ingredient_name;
  final String ingredient_id;

  Ingredient({
    required this.ingredient_name,
    required this.ingredient_id,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredient_id: json['ingredient_id'],
      ingredient_name: json['ingredient_name'],
    );
  }
}