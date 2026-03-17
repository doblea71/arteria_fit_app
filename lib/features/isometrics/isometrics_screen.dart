import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/exercise_provider.dart';
import '../../core/services/database_service.dart';
import '../../core/services/haptic_service.dart';

class IsometricsScreen extends ConsumerStatefulWidget {
  const IsometricsScreen({super.key});

  @override
  ConsumerState<IsometricsScreen> createState() => _IsometricsScreenState();
}

class _IsometricsScreenState extends ConsumerState<IsometricsScreen> {
  int _currentSet = 1;
  static const int _totalSets = 4;
  static const int _exerciseTime = 120;
  static const int _restTime = 60;

  int _secondsLeft = _exerciseTime;
  bool _isResting = false;
  bool _isActive = false;
  Timer? _timer;

  void _startExercise() {
    setState(() {
      _isActive = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _onTimeFinished();
      }
    });
  }

  void _onTimeFinished() {
    _timer?.cancel();
    if (!_isResting) {
      if (_currentSet < _totalSets) {
        HapticService().phaseChange();
        setState(() {
          _isResting = true;
          _secondsLeft = _restTime;
        });
        _startExercise();
      } else {
        _registerExercise();
        _showCompletionDialog();
      }
    } else {
      HapticService().phaseChange();
      setState(() {
        _isResting = false;
        _currentSet++;
        _secondsLeft = _exerciseTime;
      });
      _startExercise();
    }
  }

  void _pauseExercise() {
    _timer?.cancel();
    setState(() => _isActive = false);
  }

  Future<void> _registerExercise() async {
    final db = DatabaseService();
    await db.insertExerciseLog(
      exerciseType: 'isometric',
      durationSeconds: 480,
    );
    ref.read(exerciseCompletedProvider.notifier).increment();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Sesión Completada!'),
        content: const Text(
          'Has terminado tus 4 sets de ejercicios isométricos. ¡Buen trabajo!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              context.pop();
            },
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final totalDuration = _isResting ? _restTime : _exerciseTime;
    final progress = 1 - (_secondsLeft / totalDuration);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isométricos'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Set $_currentSet de $_totalSets',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isResting ? 'Tiempo de Descanso' : 'Mantén la Presión',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (!_isResting)
                  Text(
                    'Aprieta suavemente al 30% de tu fuerza',
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                const SizedBox(height: 60),
                CircularPercentIndicator(
                  radius: 140.0,
                  lineWidth: 15.0,
                  percent: progress,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_secondsLeft),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _isResting ? 'Relájate' : 'Segundos',
                        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  progressColor: _isResting
                      ? Colors.orangeAccent
                      : colorScheme.primary,
                  animateFromLastPercent: true,
                  animation: true,
                  curve: Curves.easeInOut,
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _controlButton(
                      onPressed: _isActive ? _pauseExercise : _startExercise,
                      icon: _isActive ? LucideIcons.pause : LucideIcons.play,
                      label: _isActive ? 'Pausar' : 'Iniciar',
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 24),
                    _controlButton(
                      onPressed: () => context.pop(),
                      icon: LucideIcons.stopCircle,
                      label: 'Detener',
                      color: Colors.redAccent,
                      isOutlined: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    bool isOutlined = false,
  }) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    );
  }
}
