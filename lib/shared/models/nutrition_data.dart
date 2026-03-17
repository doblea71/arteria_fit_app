class FoodItem {
  final String name;
  final String category;
  final String benefit;
  final String icon;
  final String description;

  const FoodItem({
    required this.name,
    required this.category,
    required this.benefit,
    required this.icon,
    required this.description,
  });
}

class NutritionData {
  static const List<FoodItem> potassiumBoosters = [
    FoodItem(
      name: 'Plátano',
      category: 'Potasio',
      benefit: 'Elimina el exceso de sodio',
      icon: '🍌',
      description: 'El potasio ayuda a relajar las paredes de los vasos sanguíneos y a eliminar el exceso de sodio.',
    ),
    FoodItem(
      name: 'Espinacas',
      category: 'Potasio',
      benefit: 'Relaja los vasos sanguíneos',
      icon: '🥬',
      description: 'Ricas en potasio y folatos, esenciales para la flexibilidad arterial.',
    ),
    FoodItem(
      name: 'Aguacate',
      category: 'Potasio',
      benefit: 'Grasas saludables y potasio',
      icon: '🥑',
      description: 'Combina potasio con grasas monoinsaturadas cardiosaludables.',
    ),
  ];

  static const List<FoodItem> magnesiumSnacks = [
    FoodItem(
      name: 'Almendras',
      category: 'Magnesio',
      benefit: 'Calmante arterial natural',
      icon: '🫘',
      description: 'El magnesio ayuda a que las arterias se mantengan relajadas y expandidas.',
    ),
    FoodItem(
      name: 'Chocolate Negro',
      category: 'Magnesio',
      benefit: 'Antioxidantes y magnesio',
      icon: '🍫',
      description: 'Consumido con moderación, ayuda a mejorar el flujo sanguíneo.',
    ),
  ];

  static const List<FoodItem> nitrateDinners = [
    FoodItem(
      name: 'Remolacha',
      category: 'Nitratos',
      benefit: 'Potente vasodilatador',
      icon: '🥗',
      description: 'Los nitratos se convierten en óxido nítrico, que dilata las arterias rápidamente.',
    ),
    FoodItem(
      name: 'Semillas de Calabaza',
      category: 'Nitratos',
      benefit: 'Mejora el flujo sanguíneo',
      icon: '🎃',
      description: 'Contienen compuestos que ayudan a la síntesis de óxido nítrico.',
    ),
  ];
}
