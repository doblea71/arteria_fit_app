import 'package:go_router/go_router.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/breathing/breathing_screen.dart';
import '../../features/isometrics/isometrics_screen.dart';
import '../../features/nutrition/nutrition_screen.dart';
import '../../features/settings/settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/breathing',
      builder: (context, state) => const BreathingScreen(),
    ),
    GoRoute(
      path: '/isometrics',
      builder: (context, state) => const IsometricsScreen(),
    ),
    GoRoute(
      path: '/nutrition',
      builder: (context, state) => const NutritionScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
