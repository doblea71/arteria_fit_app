import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/recipe_model.dart';

class RecipeService {
  static final RecipeService _instance = RecipeService._internal();

  factory RecipeService() => _instance;

  RecipeService._internal();

  Future<List<Recipe>> loadRecipes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/recipes.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> recetas = data['recetas'] as List<dynamic>;
      return recetas.map((r) => Recipe.fromJson(r as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error loading recipes: $e');
    }
  }

  Map<String, List<Recipe>> groupByCategory(List<Recipe> recipes) {
    final Map<String, List<Recipe>> grouped = {};
    for (final r in recipes) {
      final normalizedCategory = _normalizeCategory(r.foodCategory);
      grouped.putIfAbsent(normalizedCategory, () => []).add(r);
    }
    return grouped;
  }

  String _normalizeCategory(String category) {
    final normalized = category.toLowerCase().trim();
    final categoryMap = {
      'platano': 'Plátano',
      'banana': 'Plátano',
      'espinacas': 'Espinacas',
      'aguacate': 'Aguacate',
      'avocado': 'Aguacate',
      'almendras': 'Almendras',
      'almonds': 'Almendras',
      'chocolate_negro': 'Chocolate Negro',
      'chocolate': 'Chocolate Negro',
      'remolacha': 'Remolacha',
      'beetroot': 'Remolacha',
      'semillas_calabaza': 'Semillas de Calabaza',
      'semillas de calabaza': 'Semillas de Calabaza',
      'pumpkin seeds': 'Semillas de Calabaza',
    };
    return categoryMap[normalized] ?? _capitalizeFirst(normalized);
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  List<String> getAvailableCategories() {
    return ['Plátano', 'Espinacas', 'Aguacate', 'Almendras', 'Chocolate Negro', 'Remolacha', 'Semillas de Calabaza'];
  }
}
