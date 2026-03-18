import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/exercise_provider.dart';
import '../../core/services/database_service.dart';
import '../../core/services/haptic_service.dart';

enum BreathingPhase { inhale, hold, exhale, resting }

class BreathingScreen extends ConsumerStatefulWidget {
  const BreathingScreen({super.key});

  @override
  ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends ConsumerState<BreathingScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  BreathingPhase _currentPhase = BreathingPhase.resting;
  int _secondsLeft = 300;
  Timer? _timer;
  Timer? _phaseCountdownTimer;
  int _phaseCountdown = 0;
  bool _isActive = false;
  bool _isFinalCycle = false;

  final int _inhaleSec = 4;
  final int _holdSec = 7;
  final int _exhaleSec = 8;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _inhaleSec),
    );
  }

  void _startSession() {
    setState(() {
      _isActive = true;
      _secondsLeft = 300;
      _isFinalCycle = false;
    });
    _runBreathingCycle();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _isFinalCycle = true;
        _stopSession();
      }
    });
  }

  void _startPhaseCountdown(int seconds) {
    _phaseCountdownTimer?.cancel();
    setState(() {
      _phaseCountdown = seconds;
    });
    _phaseCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_phaseCountdown > 0) {
          _phaseCountdown--;
        }
      });
    });
  }

  void _cancelPhaseCountdown() {
    _phaseCountdownTimer?.cancel();
  }

  void _runBreathingCycle() async {
    if (!_isActive || !mounted) return;

    _cancelPhaseCountdown();
    setState(() => _currentPhase = BreathingPhase.inhale);
    _startPhaseCountdown(_inhaleSec);
    HapticService().phaseChange();
    _breathingController.duration = Duration(seconds: _inhaleSec);
    await _breathingController.forward();

    if (!_isActive || !mounted) return;

    _cancelPhaseCountdown();
    setState(() => _currentPhase = BreathingPhase.hold);
    _startPhaseCountdown(_holdSec);
    HapticService().phaseChange();
    await Future.delayed(Duration(seconds: _holdSec));

    if (!_isActive || !mounted) return;

    _cancelPhaseCountdown();
    setState(() => _currentPhase = BreathingPhase.exhale);
    _startPhaseCountdown(_exhaleSec);
    HapticService().phaseChange();
    _breathingController.duration = Duration(seconds: _exhaleSec);
    await _breathingController.reverse();

    if (_isActive && mounted) _runBreathingCycle();
  }

  void _runFinalExhale() async {
    if (!_isFinalCycle || !mounted) return;
    
    _cancelPhaseCountdown();
    setState(() => _currentPhase = BreathingPhase.exhale);
    _startPhaseCountdown(_exhaleSec);
    _breathingController.duration = Duration(seconds: _exhaleSec);
    _breathingController.value = 1.0;
    
    await Future.delayed(Duration(seconds: _exhaleSec));
    
    if (!mounted) return;

    _timer?.cancel();
    _cancelPhaseCountdown();
    _breathingController.stop();
    setState(() {
      _isActive = false;
      _currentPhase = BreathingPhase.resting;
    });
    _registerExercise();
  }

  void _stopSession() {
    _timer?.cancel();
    _breathingController.stop();
    
    if (_isFinalCycle) {
      _runFinalExhale();
    } else {
      if (mounted) {
        setState(() {
          _isActive = false;
          _currentPhase = BreathingPhase.resting;
        });
      }
    }
  }

  Future<void> _registerExercise() async {
    final db = DatabaseService();
    await db.insertExerciseLog(
      exerciseType: 'breathing',
      durationSeconds: 300,
    );
    ref.read(exerciseCompletedProvider.notifier).increment();
  }

  String get _phaseText {
    switch (_currentPhase) {
      case BreathingPhase.inhale:
        return "Inhala";
      case BreathingPhase.hold:
        return "Mantén";
      case BreathingPhase.exhale:
        return "Exhala";
      case BreathingPhase.resting:
        return "Listo?";
    }
  }

  String _formatTime(int seconds) {
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phaseCountdownTimer?.cancel();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Respiración Consciente',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_secondsLeft),
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 24,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.20,
                      child: Text(
                        _phaseCountdown > 0 ? '$_phaseCountdown' : '',
                        style: TextStyle(
                          fontSize: 200,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      width: 200 + (100 * _breathingController.value),
                      height: 200 + (100 * _breathingController.value),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.8),
                            colorScheme.primary.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(
                              alpha: 0.4 * _breathingController.value,
                            ),
                            blurRadius: 50,
                            spreadRadius: 20 * _breathingController.value,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _phaseText,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate(target: _isActive ? 1 : 0).fadeIn(),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 100),
            if (!_isActive)
              ElevatedButton(
                onPressed: _startSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 40,
                    icon: Icon(LucideIcons.pause, color: colorScheme.onSurface),
                    onPressed: _stopSession,
                  ),
                  const SizedBox(width: 40),
                  IconButton(
                    iconSize: 40,
                    icon: Icon(LucideIcons.x, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
