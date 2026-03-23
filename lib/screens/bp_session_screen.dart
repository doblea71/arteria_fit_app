import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/bp_session_model.dart';
import '../core/services/donation_service.dart';
import '../core/services/database_service.dart';
import '../widgets/donation_sheet.dart';
import 'bp_protocol_screen.dart';

class BpSessionScreen extends ConsumerStatefulWidget {
  final int sessionId;

  const BpSessionScreen({super.key, required this.sessionId});

  @override
  ConsumerState<BpSessionScreen> createState() => _BpSessionScreenState();
}

class _BpSessionScreenState extends ConsumerState<BpSessionScreen> {
  BpSession? _session;
  bool _isLoading = true;
  bool _showRestTimer = false;
  int _restSeconds = 0;
  bool _restTimerActive = false;

  final List<Map<String, dynamic>> _readings = [
    {'systolic': null, 'diastolic': null, 'pulse': null, 'completed': false},
    {'systolic': null, 'diastolic': null, 'pulse': null, 'completed': false},
    {'systolic': null, 'diastolic': null, 'pulse': null, 'completed': false},
  ];

  int _currentReading = 0;
  int _timerSeconds = 0;
  bool _timerActive = false;
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _pulseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadSession() async {
    final service = ref.read(bpProtocolServiceProvider);
    final session = await service.getSession(widget.sessionId);

    if (session != null && session.readings.isNotEmpty) {
      for (int i = 0; i < session.readings.length && i < 3; i++) {
        _readings[i] = {
          'systolic': session.readings[i].systolic,
          'diastolic': session.readings[i].diastolic,
          'pulse': session.readings[i].pulse,
          'completed': true,
        };
      }
      _currentReading = session.readings.length;
      if (_currentReading >= 3) {
        if (mounted) context.pop();
        return;
      }
    }

    setState(() {
      _session = session;
      _isLoading = false;
    });
  }

  void _startRestTimer() {
    setState(() {
      _showRestTimer = true;
      _restSeconds = 5 * 60;
      _restTimerActive = true;
    });
    _runTimer(isRest: true);
  }

  void _runTimer({bool isRest = false}) {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        if (isRest) {
          _restSeconds--;
          if (_restSeconds <= 0) _restTimerActive = false;
        } else {
          _timerSeconds--;
          if (_timerSeconds <= 0) _timerActive = false;
        }
      });

      return (isRest ? _restSeconds : _timerSeconds) > 0;
    });
  }

  Future<void> _saveReading() async {
    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);
    final pulse = int.tryParse(_pulseController.text);

    if (systolic == null || diastolic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa valores de sistólica y diastólica'),
        ),
      );
      return;
    }

    final warnings = _getWarnings(systolic, diastolic, pulse);
    if (warnings.isNotEmpty) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Valores fuera de rango'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Se detectaron los siguientes avisos:'),
              const SizedBox(height: 12),
              ...warnings.map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(w, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('¿Deseas guardar los valores de todos modos?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Corregir'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    final service = ref.read(bpProtocolServiceProvider);
    await service.saveReading(
      sessionId: widget.sessionId,
      readingIndex: _currentReading + 1,
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
    );

    setState(() {
      _readings[_currentReading] = {
        'systolic': systolic,
        'diastolic': diastolic,
        'pulse': pulse,
        'completed': true,
      };
      _systolicController.clear();
      _diastolicController.clear();
      _pulseController.clear();
      _currentReading++;
    });

    if (_currentReading >= 3) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sesión completada'),
            backgroundColor: Colors.green,
          ),
        );
        _checkAndShowDonation();
        context.pop();
      }
    } else {
      setState(() {
        _timerSeconds = 60;
        _timerActive = true;
      });
      _runTimer();
    }
  }

  Future<void> _checkAndShowDonation() async {
    final db = DatabaseService();
    final readings = await db.getBloodPressureReadings();

    if (readings.length == 7) {
      final donationService = DonationService();
      final shouldShow = await donationService.shouldShowDonationPrompt();
      if (shouldShow && mounted) {
        await donationService.markDonationPromptShown();
        showDonationSheet(context);
      }
    }
  }

  List<String> _getWarnings(int? systolic, int? diastolic, int? pulse) {
    final warnings = <String>[];
    if (systolic != null && (systolic < 70 || systolic > 250)) {
      warnings.add('Sistólica fuera del rango 70-250 mmHg');
    }
    if (diastolic != null && (diastolic < 40 || diastolic > 150)) {
      warnings.add('Diastólica fuera del rango 40-150 mmHg');
    }
    if (pulse != null && (pulse < 30 || pulse > 200)) {
      warnings.add('Pulso fuera del rango 30-200 lpm');
    }
    return warnings;
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isMorning = _session?.sessionType == BpSessionType.morning;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(isMorning ? LucideIcons.sunrise : LucideIcons.sunset),
            const SizedBox(width: 8),
            Text('Sesión ${isMorning ? "Matutina" : "Nocturna"}'),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_restTimerActive) {
      return _buildRestTimer(theme);
    }

    if (_timerActive) {
      return _buildCountdownTimer(theme);
    }

    return _buildReadingInput(theme);
  }

  Widget _buildRestTimer(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.bed, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Tiempo de reposo',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _formatTime(_restSeconds),
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Permanece en reposo y en silencio',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          OutlinedButton(
            onPressed: () {
              setState(() => _restTimerActive = false);
            },
            child: const Text('Saltar reposo'),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.timer, size: 80, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Espera antes de la siguiente lectura',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _formatTime(_timerSeconds),
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hables ni te muevas',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReadingInput(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_showRestTimer && _currentReading == 0) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.bed, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '¿Deseas hacer 5 minutos de reposo antes de medir?',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonal(
                    onPressed: _startRestTimer,
                    child: const Text('Iniciar reposo de 5 minutos'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          _buildProgressIndicator(theme),
          const SizedBox(height: 24),
          Text(
            'Lectura ${_currentReading + 1} de 3',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        theme,
                        label: 'Sistólica',
                        hint: 'mmHg',
                        controller: _systolicController,
                        icon: LucideIcons.arrowUp,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        theme,
                        label: 'Diastólica',
                        hint: 'mmHg',
                        controller: _diastolicController,
                        icon: LucideIcons.arrowDown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  theme,
                  label: 'Pulso (opcional)',
                  hint: 'lpm',
                  controller: _pulseController,
                  icon: LucideIcons.heart,
                  isOptional: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saveReading,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Guardar lectura'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Row(
      children: List.generate(3, (index) {
        final completed = _readings[index]['completed'] as bool;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: completed
                  ? Colors.green
                  : index == _currentReading
                  ? theme.colorScheme.primary.withValues(alpha: 0.2)
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: completed
                    ? Colors.green
                    : index == _currentReading
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  completed ? Icons.check : LucideIcons.circle,
                  size: 20,
                  color: completed
                      ? Colors.white
                      : index == _currentReading
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                const SizedBox(height: 4),
                Text(
                  completed
                      ? '${_readings[index]['systolic']}/${_readings[index]['diastolic']}'
                      : 'Lectura ${index + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: completed
                        ? Colors.white
                        : index == _currentReading
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInputField(
    ThemeData theme, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isOptional = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        suffixText: isOptional ? 'Opcional' : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
