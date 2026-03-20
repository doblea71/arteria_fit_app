import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/theme_provider.dart';
import '../../shared/models/nutrition_data.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/recipes'),
        icon: const Icon(LucideIcons.bookOpen),
        label: const Text('Recetas'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(LucideIcons.chevronLeft, color: theme.colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logo/arteria-fit.png',
                    height: 28,
                    width: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Nutrición Cardíaca',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    context,
                    title: 'Impulsores de Potasio',
                    subtitle: 'Los "Fontaneros" (Eliminan Sodio)',
                    items: NutritionData.potassiumBoosters,
                    accentColor: Colors.blueAccent,
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    context,
                    title: 'Snacks de Magnesio',
                    subtitle: 'Los "Calmantes" (Relajan Arterias)',
                    items: NutritionData.magnesiumSnacks,
                    accentColor: Colors.deepPurpleAccent,
                  ),
                  const SizedBox(height: 32),
                  _buildSection(
                    context,
                    title: 'Cenas de Nitratos',
                    subtitle: 'Los "Dilatadores" (Óxido Nítrico)',
                    items: NutritionData.nitrateDinners,
                    accentColor: Colors.redAccent,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<FoodItem> items,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
        Text(subtitle, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildFoodCard(context, item, accentColor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCard(
    BuildContext context,
    FoodItem item,
    Color accentColor,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(item.icon, style: const TextStyle(fontSize: 24)),
          ),
          const Spacer(),
          Text(
            item.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            item.benefit,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
