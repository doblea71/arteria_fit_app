import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  static const String _channelId = 'bp_protocol_channel';
  static const String _channelName = 'Control de Tensión';
  static const String _channelDescription = 'Notificaciones para el protocolo de tensión arterial';

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  void _onNotificationResponse(NotificationResponse response) {
    // Handle notification tap
  }

  Future<bool> requestPermission() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        try {
          final granted = await android.requestNotificationsPermission();
          return granted ?? false;
        } catch (e) {
          return false;
        }
      }

      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        try {
          final granted = await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          return granted ?? false;
        } catch (e) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> scheduleSessionNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleAdvanceNotification({
    required int id,
    required DateTime sessionTime,
    required bool isMorning,
  }) async {
    final advanceTime = sessionTime.subtract(const Duration(minutes: 10));
    
    if (advanceTime.isBefore(DateTime.now())) return;

    final sessionType = isMorning ? 'matutina' : 'nocturna';
    final timeStr = '${sessionTime.hour.toString().padLeft(2, '0')}:${sessionTime.minute.toString().padLeft(2, '0')}';

    await scheduleSessionNotification(
      id: id,
      title: 'Recordatorio de tensión arterial',
      body: 'Sesión $sessionType en 10 minutos ($timeStr). Recuerda las condiciones previas a la medición.',
      scheduledTime: advanceTime,
    );
  }

  Future<void> scheduleStartNotification({
    required int id,
    required DateTime sessionTime,
    required bool isMorning,
  }) async {
    if (sessionTime.isBefore(DateTime.now())) return;

    final sessionType = isMorning ? 'matutina' : 'nocturna';

    await scheduleSessionNotification(
      id: id,
      title: 'Es hora de medir tu tensión',
      body: 'Inicia tu sesión $sessionType de tensión arterial.',
      scheduledTime: sessionTime,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> cancelByIds(List<int> ids) async {
    for (final id in ids) {
      await _plugin.cancel(id);
    }
  }

  int generateNotificationId(int protocolId, int dayNumber, bool isMorning, bool isAdvance) {
    final base = protocolId * 1000;
    final day = dayNumber * 10;
    final type = isMorning ? 0 : 5;
    final notifType = isAdvance ? 0 : 1;
    return base + day + type + notifType;
  }
}
