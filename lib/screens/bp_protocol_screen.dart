import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/bp_protocol_model.dart';
import '../models/bp_session_model.dart';
import '../services/bp_protocol_service.dart';
import '../services/notification_service.dart';
import '../core/providers/theme_provider.dart';

final bpProtocolServiceProvider = Provider((ref) => BpProtocolService());

class BpProtocolScreen extends ConsumerStatefulWidget {
  const BpProtocolScreen({super.key});

  @override
  ConsumerState<BpProtocolScreen> createState() => _BpProtocolScreenState();
}

class _BpProtocolScreenState extends ConsumerState<BpProtocolScreen> {
  BpProtocol? _protocol;
  List<BpSession>? _sessions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final service = ref.read(bpProtocolServiceProvider);
    final protocol = await service.getActiveProtocol();
    
    if (protocol != null) {
      final sessions = await service.getProtocolSessions(protocol.id!);
      setState(() {
        _protocol = protocol;
        _sessions = sessions;
      });
    } else {
      setState(() {
        _protocol = null;
        _sessions = null;
      });
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _startProtocol() async {
    final morningTime = await _showTimePicker(isMorning: true);
    if (morningTime == null) return;

    final eveningTime = await _showTimePicker(isMorning: false);
    if (eveningTime == null) return;

    final morningMinutes = morningTime.hour * 60 + morningTime.minute;
    final eveningMinutes = eveningTime.hour * 60 + eveningTime.minute;
    var diff = eveningMinutes - morningMinutes;
    if (diff < 0) diff += 24 * 60;
    
    if (diff < 6 * 60) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La diferencia mínima entre sesiones debe ser de 6 horas'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final permissionGranted = await NotificationService().requestPermission();
    if (!permissionGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No recibirás recordatorios. Puedes continuar con el protocolo manualmente.'),
        ),
      );
    }

    try {
      final service = ref.read(bpProtocolServiceProvider);
      final protocol = await service.startProtocol(
        morningTime: '${morningTime.hour.toString().padLeft(2, '0')}:${morningTime.minute.toString().padLeft(2, '0')}',
        eveningTime: '${eveningTime.hour.toString().padLeft(2, '0')}:${eveningTime.minute.toString().padLeft(2, '0')}',
      );
      
      await service.scheduleNotificationsForProtocol(protocol);
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<TimeOfDay?> _showTimePicker({required bool isMorning}) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: isMorning ? 7 : 20, minute: 30),
      helpText: isMorning ? 'Hora de sesión matutina' : 'Hora de sesión nocturna',
    );
  }

  Future<void> _cancelProtocol() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar protocolo'),
        content: const Text('¿Estás seguro de que deseas cancelar el protocolo activo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(bpProtocolServiceProvider);
      await service.cancelProtocol();
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: theme.colorScheme.onSurface),
                onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo/arteria-fit.png', height: 28, width: 28),
                  const SizedBox(width: 8),
                  Text(
                    'Control 7 Días',
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
            child: _isLoading
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ))
                : _protocol == null
                    ? _buildNotStarted()
                    : _buildProtocolContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotStarted() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            LucideIcons.heartPulse,
            size: 80,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Protocolo de Control de Tensión',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Sigue tu presión arterial durante 7 días con 3 mediciones por sesión.',
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _startProtocol,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Iniciar Protocolo'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => context.push('/bp-history'),
            icon: Icon(
              LucideIcons.history,
              size: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            label: Text(
              'Ver historial de protocolos',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolContent() {
    final theme = Theme.of(context);
    final completedSessions = _sessions?.where((s) => s.isCompleted).length ?? 0;
    final totalSessions = _sessions?.length ?? 0;
    final completedDays = _sessions
        ?.where((s) => s.isCompleted)
        .map((s) => s.dayNumber)
        .toSet()
        .length ?? 0;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(theme, completedSessions, totalSessions),
          if (completedDays >= 1) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/bp-dashboard/${_protocol!.id}'),
                icon: const Icon(LucideIcons.barChart3),
                label: Text(
                  completedDays >= 2 
                      ? 'Ver Resultados' 
                      : 'Ver Resultados (parciales)',
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          if (_sessions != null && _sessions!.isNotEmpty) ...[
            Text(
              'Calendario de Sesiones',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._buildDaySections(),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _cancelProtocol,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancelar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(ThemeData theme, int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(LucideIcons.clock, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Protocolo Activo',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completed de $total sesiones completadas',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDaySections() {
    final theme = Theme.of(context);
    final dayGroups = <int, List<BpSession>>{};
    
    for (final session in _sessions!) {
      dayGroups.putIfAbsent(session.dayNumber, () => []).add(session);
    }

    return dayGroups.entries.map((entry) {
      return _buildDayCard(theme, entry.key, entry.value);
    }).toList();
  }

  Widget _buildDayCard(ThemeData theme, int day, List<BpSession> sessions) {
    final isToday = DateTime.now().day == sessions.first.scheduledAt.day &&
        DateTime.now().month == sessions.first.scheduledAt.month;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday 
              ? theme.colorScheme.primary 
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isToday ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isToday 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Día $day',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isToday 
                        ? theme.colorScheme.onPrimary 
                        : theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                sessions.first.displayDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              if (isToday) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'HOY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: sessions.map((session) {
              return Expanded(
                child: _buildSessionButton(theme, session),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionButton(ThemeData theme, BpSession session) {
    final isMorning = session.sessionType == BpSessionType.morning;
    final icon = isMorning ? LucideIcons.sunrise : LucideIcons.sunset;
    final statusColor = switch (session.status) {
      BpSessionStatus.completed => Colors.green,
      BpSessionStatus.inProgress => theme.colorScheme.primary,
      BpSessionStatus.pending => theme.colorScheme.outline,
      BpSessionStatus.skipped => Colors.orange,
    };

    return Padding(
      padding: EdgeInsets.only(
        right: isMorning ? 8 : 0,
        left: isMorning ? 0 : 8,
      ),
      child: FilledButton.tonal(
        onPressed: session.isPending
            ? () => context.push('/bp-session/${session.id}')
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: session.isCompleted 
              ? Colors.green.withValues(alpha: 0.1) 
              : null,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: statusColor),
            const SizedBox(height: 4),
            Text(
              session.displayTime,
              style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
            ),
            Text(
              session.isCompleted ? 'Completada' : session.sessionType.displayName,
              style: TextStyle(fontSize: 10, color: statusColor),
            ),
          ],
        ),
      ),
    );
  }
}
