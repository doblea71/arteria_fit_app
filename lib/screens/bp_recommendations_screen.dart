import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BpRecommendationsScreen extends StatefulWidget {
  final int sessionId;

  const BpRecommendationsScreen({super.key, required this.sessionId});

  @override
  State<BpRecommendationsScreen> createState() => _BpRecommendationsScreenState();
}

class _BpRecommendationsScreenState extends State<BpRecommendationsScreen> {
  final List<bool> _confirmed = List.filled(7, false);

  final List<Map<String, String>> _recommendations = [
    {
      'title': 'Ambiente adecuado',
      'description': 'Estar en una habitación tranquila y sin ruido.',
    },
    {
      'title': 'Evitar estimulantes',
      'description': '30 minutos antes: evitar café, tabaco, alcohol, comida y ejercicio.',
    },
    {
      'title': 'Vaciar la vejiga',
      'description': 'Orinar antes de tomarse la tensión.',
    },
    {
      'title': 'Posición correcta',
      'description': 'Apoyar la espalda en una silla, sin cruzar las piernas.',
    },
    {
      'title': 'Reposo previo',
      'description': 'Permanecer 5 minutos en reposo y en silencio.',
    },
    {
      'title': 'Colocación del manguito',
      'description': 'Desnudar el brazo de referencia y colocar el manguito con el sensor en posición branquial.',
    },
    {
      'title': 'Posición del brazo',
      'description': 'Apoyar el brazo sobre una superficie estable al nivel del corazón, con la palma hacia arriba.',
    },
  ];

  bool get _allConfirmed => _confirmed.every((c) => c);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Antes de medir'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(LucideIcons.info, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Confirma cada condición antes de continuar',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                return _buildRecommendationItem(theme, index);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _allConfirmed
                      ? () => context.pushReplacement('/bp-session/${widget.sessionId}/record')
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(_allConfirmed ? 'Continuar' : 'Confirma todas las condiciones'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(ThemeData theme, int index) {
    final item = _recommendations[index];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _confirmed[index]
              ? Colors.green
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _confirmed[index] = !_confirmed[index];
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _confirmed[index]
                      ? Colors.green
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
                child: Icon(
                  _confirmed[index] ? Icons.check : null,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title']!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['description']!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
