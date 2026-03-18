import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/services/database_service.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _exerciseLogs = [];
  List<Map<String, dynamic>> _bpLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final db = DatabaseService();
    final exerciseLogs = await db.getAllLogs();
    final bpLogs = await db.getBloodPressureReadings();
    
    if (mounted) {
      setState(() {
        _exerciseLogs = exerciseLogs;
        _bpLogs = bpLogs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Historial',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'Ejercicios'),
            Tab(text: 'Tensión'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLogsList(_exerciseLogs, isExercise: true),
                _buildLogsList(_bpLogs, isExercise: false),
              ],
            ),
      floatingActionButton: _tabController.index == 1 ? FloatingActionButton.extended(
        onPressed: () => context.push('/blood-pressure').then((_) => _loadData()),
        label: const Text('Registrar'),
        icon: const Icon(LucideIcons.plus),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) context.go('/');
          if (index == 2) context.push('/nutrition');
          if (index == 3) context.push('/settings');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layoutDashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.clipboardList),
            label: 'Actividad',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.apple),
            label: 'Nutrición',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(List<Map<String, dynamic>> logs, {required bool isExercise}) {
    if (logs.isEmpty) {
      return _buildEmptyState(context, isExercise);
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          return isExercise 
            ? _buildExerciseItem(context, logs[index])
            : _buildBPItem(context, logs[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isExercise) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isExercise ? LucideIcons.clipboardList : LucideIcons.heartPulse,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            isExercise ? 'No hay ejercicios registrados' : 'No hay tomas de tensión',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(BuildContext context, Map<String, dynamic> log) {
    final exerciseType = log['exercise_type'] as String;
    final isBreathing = exerciseType == 'breathing';
    final completedAt = DateTime.parse(log['completed_at'] as String);
    final durationSeconds = log['duration_seconds'] as int;

    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    final durationText = minutes > 0
        ? '$minutes min ${seconds > 0 ? '$seconds seg' : ''}'
        : '$seconds seg';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isBreathing ? Colors.blueAccent : Colors.teal).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isBreathing ? LucideIcons.wind : LucideIcons.activity,
            color: isBreathing ? Colors.blueAccent : Colors.teal,
            size: 20,
          ),
        ),
        title: Text(
          isBreathing ? 'Respiración' : 'Isométricos',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_formatDateTime(completedAt)),
        trailing: Text(
          durationText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isBreathing ? Colors.blueAccent : Colors.teal,
          ),
        ),
      ),
    );
  }

  Widget _buildBPItem(BuildContext context, Map<String, dynamic> log) {
    final createdAt = DateTime.parse(log['created_at'] as String);
    final sys = log['systolic'] as int;
    final dia = log['diastolic'] as int;
    final pulse = log['pulse'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.heartPulse, color: Colors.redAccent, size: 20),
        ),
        title: Row(
          children: [
            Text('$sys', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text(' / ', style: TextStyle(color: Colors.grey)),
            Text('$dia', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(width: 8),
            const Text('mmHg', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatDateTime(createdAt)),
            if (log['note'] != null)
              Text(
                log['note'] as String,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$pulse',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
            const Text('ppm', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String datePrefix = '';
    if (dateToCheck == today) {
      datePrefix = 'Hoy, ';
    } else if (dateToCheck == yesterday) {
      datePrefix = 'Ayer, ';
    } else {
      datePrefix = '${dateTime.day}/${dateTime.month}, ';
    }

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$datePrefix$hour:$minute';
  }
}
