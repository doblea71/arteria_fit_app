import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/bp_protocol_model.dart';
import '../services/bp_protocol_service.dart';
import '../core/providers/theme_provider.dart';
import '../core/services/donation_service.dart';
import '../core/services/database_service.dart';
import '../widgets/donation_sheet.dart';

final bpProtocolServiceProvider = Provider((ref) => BpProtocolService());

class BpHistoryScreen extends ConsumerStatefulWidget {
  const BpHistoryScreen({super.key});

  @override
  ConsumerState<BpHistoryScreen> createState() => _BpHistoryScreenState();
}

class _BpHistoryScreenState extends ConsumerState<BpHistoryScreen> {
  List<ProtocolSummary>? _protocols;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final service = ref.read(bpProtocolServiceProvider);
    final protocols = await service.getProtocolHistory();
    if (!mounted) return;
    setState(() {
      _protocols = protocols;
      _isLoading = false;
    });
    _checkAndShowDonation();
  }

  Future<void> _checkAndShowDonation() async {
    final db = DatabaseService();
    final readings = await db.getBloodPressureReadings();
    if (!mounted) return;

    if (readings.length >= 20) {
      final donationService = DonationService();
      final shouldShow = await donationService.shouldShowDonationPrompt();
      if (shouldShow && mounted) {
        await donationService.markDonationPromptShown();
        if (mounted) {
          showDonationSheet(context);
        }
      }
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
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: theme.colorScheme.onSurface,
                ),
                onPressed: () =>
                    ref.read(themeModeProvider.notifier).toggleTheme(),
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
                    'Historial',
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
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _protocols == null || _protocols!.isEmpty
                ? _buildEmptyState(theme)
                : _buildProtocolList(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(LucideIcons.history, size: 80, color: theme.colorScheme.outline),
          const SizedBox(height: 24),
          Text('Sin historial', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(
            'No hay protocolos registrados',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolList(ThemeData theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: _protocols!.length,
      itemBuilder: (context, index) {
        return _buildProtocolCard(theme, _protocols![index]);
      },
    );
  }

  Widget _buildProtocolCard(ThemeData theme, ProtocolSummary summary) {
    final statusColor = switch (summary.protocol.status) {
      BpProtocolStatus.active => theme.colorScheme.primary,
      BpProtocolStatus.completed => Colors.green,
      BpProtocolStatus.cancelled => Colors.orange,
    };

    final statusIcon = switch (summary.protocol.status) {
      BpProtocolStatus.active => LucideIcons.clock,
      BpProtocolStatus.completed => LucideIcons.checkCircle,
      BpProtocolStatus.cancelled => LucideIcons.xCircle,
    };

    final dateStr =
        '${summary.protocol.startDate.day}/${summary.protocol.startDate.month}/${summary.protocol.startDate.year}';

    return GestureDetector(
      onTap: () => context.push('/bp-dashboard/${summary.protocol.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.calendarDays,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Protocolo #${summary.protocol.id}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        summary.statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(theme, LucideIcons.calendar, 'Iniciado', dateStr),
            const SizedBox(height: 8),
            _buildInfoRow(
              theme,
              LucideIcons.activity,
              'Sesiones',
              '${summary.completedSessions}/${summary.totalSessions}',
            ),
            if (summary.hasResults) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                theme,
                LucideIcons.heart,
                'Promedio',
                '${summary.avgSystolic!.round()}/${summary.avgDiastolic!.round()} mmHg',
                valueColor: statusColor,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Ver detalles',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  LucideIcons.arrowRight,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
