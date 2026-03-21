import 'package:go_router/go_router.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/breathing/breathing_screen.dart';
import '../../features/isometrics/isometrics_screen.dart';
import '../../features/nutrition/nutrition_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/activity/activity_screen.dart';
import '../../features/activity/blood_pressure_entry_screen.dart';
import '../../screens/recipes_screen.dart';
import '../../screens/bp_protocol_screen.dart';
import '../../screens/bp_session_screen.dart';
import '../../screens/bp_recommendations_screen.dart';
import '../../screens/bp_dashboard_screen.dart';
import '../../screens/bp_history_screen.dart';

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
    GoRoute(
      path: '/activity',
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      path: '/blood-pressure',
      builder: (context, state) => const BloodPressureEntryScreen(),
    ),
    GoRoute(
      path: '/recipes',
      builder: (context, state) => const RecipesScreen(),
    ),
    GoRoute(
      path: '/bp-protocol',
      builder: (context, state) => const BpProtocolScreen(),
    ),
    GoRoute(
      path: '/bp-session/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BpSessionScreen(sessionId: id);
      },
    ),
    GoRoute(
      path: '/bp-session/:id/recommendations',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BpRecommendationsScreen(sessionId: id);
      },
    ),
    GoRoute(
      path: '/bp-session/:id/record',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BpSessionScreen(sessionId: id);
      },
    ),
    GoRoute(
      path: '/bp-dashboard/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BpDashboardScreen(protocolId: id);
      },
    ),
    GoRoute(
      path: '/bp-history',
      builder: (context, state) => const BpHistoryScreen(),
    ),
  ],
);
