import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/consent_manager.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);
  }
  await NotificationService().init();
  runApp(const ProviderScope(child: ArteriaFitApp()));
}

class ArteriaFitApp extends ConsumerStatefulWidget {
  const ArteriaFitApp({super.key});

  @override
  ConsumerState<ArteriaFitApp> createState() => _ArteriaFitAppState();
}

class _ArteriaFitAppState extends ConsumerState<ArteriaFitApp> {
  bool _isInitialized = false;
  bool _showOnboarding = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await ref.read(themeModeProvider.notifier).loadTheme();

    final consentManager = ConsentManager();
    final hasCompletedOnboarding = await consentManager
        .hasCompletedOnboarding();

    if (!kIsWeb) {
      FlutterNativeSplash.remove();
    }
    if (mounted) {
      setState(() {
        _isInitialized = true;
        _showOnboarding = !hasCompletedOnboarding;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (_showOnboarding) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const _PrivacyOnboarding(),
        builder: (context, child) {
          return _OnboardingCompleteListener(
            onComplete: () {
              setState(() {
                _showOnboarding = false;
              });
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
      );
    }

    return MaterialApp.router(
      title: 'Arteria Fit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}

class _OnboardingCompleteListener extends StatefulWidget {
  final VoidCallback onComplete;
  final Widget child;

  const _OnboardingCompleteListener({
    required this.onComplete,
    required this.child,
  });

  @override
  State<_OnboardingCompleteListener> createState() =>
      _OnboardingCompleteListenerState();
}

class _OnboardingCompleteListenerState
    extends State<_OnboardingCompleteListener> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OnboardingCompleteNotification>(
      onNotification: (notification) {
        widget.onComplete();
        return true;
      },
      child: widget.child,
    );
  }
}

class OnboardingCompleteNotification extends Notification {
  const OnboardingCompleteNotification();
}

class _PrivacyOnboarding extends StatefulWidget {
  const _PrivacyOnboarding();

  @override
  State<_PrivacyOnboarding> createState() => _PrivacyOnboardingState();
}

class _PrivacyOnboardingState extends State<_PrivacyOnboarding> {
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

  Future<void> _completeOnboarding() async {
    final consentManager = ConsentManager();
    await consentManager.completeOnboarding(
      tipJarConsent: _tipJarConsent,
      passiveMonetizationConsent: _passiveMonetizationConsent,
    );
    if (mounted) {
      const OnboardingCompleteNotification().dispatch(context);
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
                  _buildPage1(theme, colorScheme),
                  _buildPage2(theme, colorScheme),
                  _buildPage3(theme, colorScheme),
                ],
              ),
            ),
            _buildBottomButtons(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 80, color: colorScheme.primary),
          const SizedBox(height: 32),
          Text(
            'Bienvenido a Arteria Fit',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Tu bienestar cardiovascular es nuestra prioridad. Esta aplicación te ayuda a monitorizar tu presión arterial de forma segura y privada.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage2(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee, size: 64, color: Colors.amber.shade700),
          const SizedBox(height: 24),
          Text(
            'Apoya el Desarrollo',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _tipJarConsent,
            onChanged: (value) {
              setState(() {
                _tipJarConsent = value ?? false;
              });
            },
            title: const Text('Tip Jar'),
            subtitle: const Text('Contribución opcional'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: _passiveMonetizationConsent,
            onChanged: (value) {
              setState(() {
                _passiveMonetizationConsent = value ?? false;
              });
            },
            title: const Text('Monetización pasiva'),
            subtitle: const Text('Anuncios no intrusivos'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
    );
  }

  Widget _buildPage3(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.shield, size: 64, color: colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Tus Derechos',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.visibility),
            title: Text('Acceso'),
            subtitle: Text('Consulta tus datos'),
          ),
          const ListTile(
            leading: Icon(Icons.edit),
            title: Text('Rectificación'),
            subtitle: Text('Corrige datos'),
          ),
          const ListTile(
            leading: Icon(Icons.delete),
            title: Text('Supresión'),
            subtitle: Text('Elimina tus datos'),
          ),
          const ListTile(
            leading: Icon(Icons.download),
            title: Text('Portabilidad'),
            subtitle: Text('Exporta tus datos'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (_currentPage == 1)
            TextButton(onPressed: _nextPage, child: const Text('Más tarde')),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _currentPage == 2 ? _completeOnboarding : _nextPage,
              child: Text(_currentPage == 2 ? 'Entendido' : 'Continuar'),
            ),
          ),
        ],
      ),
    );
  }
}
