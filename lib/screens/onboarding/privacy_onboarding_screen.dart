import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/legal_constants.dart';
import '../../core/services/consent_manager.dart';

class PrivacyOnboardingScreen extends StatefulWidget {
  const PrivacyOnboardingScreen({super.key});

  @override
  State<PrivacyOnboardingScreen> createState() =>
      _PrivacyOnboardingScreenState();
}

class _PrivacyOnboardingScreenState extends State<PrivacyOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _tipJarConsent = false;
  bool _passiveMonetizationConsent = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final consentManager = ConsentManager();
    await consentManager.completeOnboarding(
      tipJarConsent: _tipJarConsent,
      passiveMonetizationConsent: _passiveMonetizationConsent,
    );
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentPage
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(theme, colorScheme),
                  _buildSupportPage(theme, colorScheme),
                  _buildRightsPage(theme, colorScheme),
                ],
              ),
            ),
            _buildBottomButtons(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.heartPulse,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Bienvenido a Arteria Fit',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Tu bienestar cardiovascular es nuestra prioridad. Esta aplicación te ayuda a monitorizar tu presión arterial de forma segura y privada.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.shieldCheck,
                  color: Colors.green.shade700,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tus datos se almacenan exclusivamente en tu dispositivo. No compartimos ni vendemos tu información.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green.shade700,
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

  Widget _buildSupportPage(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.coffee,
              size: 64,
              color: Colors.amber.shade700,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Apoya el Desarrollo',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Puedes apoyar el desarrollo de Arteria Fit de las siguientes formas:',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildConsentCheckbox(
            title: 'Tip Jar',
            description:
                'Deja una pequeña contribución cuando lo desees. Es completamente opcional.',
            icon: LucideIcons.coins,
            value: _tipJarConsent,
            onChanged: (value) {
              setState(() {
                _tipJarConsent = value ?? false;
              });
            },
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          _buildConsentCheckbox(
            title: 'Monetización pasiva',
            description:
                'Permite anuncios no intrusivos para apoyar el desarrollo. Puedes desactivarlo en cualquier momento.',
            icon: LucideIcons.batteryCharging,
            value: _passiveMonetizationConsent,
            onChanged: (value) {
              setState(() {
                _passiveMonetizationConsent = value ?? false;
              });
            },
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCheckbox({
    required String title,
    required String description,
    required IconData icon,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: value ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: value
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.outline.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: value ? colorScheme.primary : colorScheme.outline,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightsPage(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.userCheck,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Tus Derechos',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildRightItem(
            icon: LucideIcons.eye,
            title: 'Acceso',
            description: 'Consulta los datos que hemos tratado sobre ti.',
            colorScheme: colorScheme,
          ),
          _buildRightItem(
            icon: LucideIcons.pencil,
            title: 'Rectificación',
            description: 'Corrige datos inexactos o incompletos.',
            colorScheme: colorScheme,
          ),
          _buildRightItem(
            icon: LucideIcons.trash2,
            title: 'Supresión',
            description: 'Elimina tus datos cuando lo desees.',
            colorScheme: colorScheme,
          ),
          _buildRightItem(
            icon: LucideIcons.download,
            title: 'Portabilidad',
            description: 'Exporta tus datos en formato legible.',
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openUrl(LegalConstants.privacyPolicyUrl),
                  icon: const Icon(LucideIcons.fileText, size: 18),
                  label: const Text('Política de Privacidad'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openUrl(LegalConstants.termsOfUseUrl),
                  icon: const Icon(LucideIcons.fileText, size: 18),
                  label: const Text('Términos de Uso'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightItem({
    required IconData icon,
    required String title,
    required String description,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (_currentPage == 1) ...[
            TextButton(
              onPressed: _nextPage,
              child: Text(
                'Más tarde',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _currentPage == 2 ? _completeOnboarding : _nextPage,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _currentPage == 2 ? 'Entendido' : 'Continuar',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
