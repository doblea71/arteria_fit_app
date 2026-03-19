class Recipe {
  final String id;
  final String foodCategory;
  final String name;
  final String description;
  final String icon;
  final List<String> ingredientes;
  final List<String> modoPreparacion;

  const Recipe({
    required this.id,
    required this.foodCategory,
    required this.name,
    required this.description,
    required this.icon,
    required this.ingredientes,
    required this.modoPreparacion,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String,
      foodCategory: json['food_category'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '🍽️',
      ingredientes: List<String>.from(json['ingredientes'] as List),
      modoPreparacion: List<String>.from(json['modo_preparacion'] as List),
    );
  }
}
