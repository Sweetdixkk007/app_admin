class Food {
  final String food_name;
  final String food_id;
  final String description;
  final String food_img;
  final String instructions;

  const Food({
    required this.food_name,
    required this.food_id,
    required this.description,
    required this.food_img,
    required this.instructions,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      food_id: json['food_id'] as String,
      food_name: json['food_name'] as String,
      description: json['description'] as String,
      food_img: json['food_img'] as String,
      instructions: json['instructions'] as String,
    );
  }
}