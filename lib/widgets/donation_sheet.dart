import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/constants/donation_constants.dart';
import '../core/services/donation_service.dart';

void showDonationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _DonationSheetContent(),
  );
}

class _DonationSheetContent extends StatefulWidget {
  const _DonationSheetContent();

  @override
  State<_DonationSheetContent> createState() => _DonationSheetContentState();
}

class _DonationSheetContentState extends State<_DonationSheetContent> {
  final _donationService = DonationService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.coffee,
              size: 48,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            DonationConstants.donationTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DonationConstants.donationMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _DonationOptionButton(
            icon: LucideIcons.heart,
            title: 'Ko-fi (Recomendado)',
            subtitle: 'Sin comisiones, apoyo directo',
            color: Colors.pink,
            onTap: () => _openDonation(DonationPlatform.kofi),
          ),
          const SizedBox(height: 12),
          _DonationOptionButton(
            icon: LucideIcons.creditCard,
            title: 'PayPal',
            subtitle: 'Pago directo',
            color: Colors.blue,
            onTap: () => _openDonation(DonationPlatform.paypal),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              _donationService.markDonationDismissed();
              Navigator.pop(context);
            },
            child: Text(
              'Quizás más tarde',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _donationService.markAsDonor();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Gracias por tu apoyo!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'Ya doné',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Future<void> _openDonation(DonationPlatform platform) async {
    await _donationService.openDonationUrl(platform);
    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _DonationOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DonationOptionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.externalLink,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
