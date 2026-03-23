import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class ConsentManager {
  static const String _keyOnboardingCompleted = 'onboarding_privacy_completed';
  static const String _keyTipJarConsent = 'tip_jar_consent';
  static const String _keyPassiveMonetizationConsentGiven =
      'passive_monetization_consent_given';
  static const String _keyPassiveMonetizationEnabled =
      'passive_monetization_enabled';
  static const String _keyConsentTimestamp = 'consent_timestamp';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> completeOnboarding({
    required bool tipJarConsent,
    required bool passiveMonetizationConsent,
  }) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyOnboardingCompleted, true);
    await prefs.setBool(_keyTipJarConsent, tipJarConsent);
    await prefs.setBool(
      _keyPassiveMonetizationConsentGiven,
      passiveMonetizationConsent,
    );
    if (passiveMonetizationConsent) {
      await prefs.setBool(_keyPassiveMonetizationEnabled, false);
    }
    await prefs.setString(
      _keyConsentTimestamp,
      DateTime.now().toIso8601String(),
    );
  }

  Future<Map<String, dynamic>> getAllConsents() async {
    final prefs = await _prefs;
    return {
      'onboarding_privacy_completed':
          prefs.getBool(_keyOnboardingCompleted) ?? false,
      'tip_jar_consent': prefs.getBool(_keyTipJarConsent) ?? false,
      'passive_monetization_consent_given':
          prefs.getBool(_keyPassiveMonetizationConsentGiven) ?? false,
      'passive_monetization_enabled':
          prefs.getBool(_keyPassiveMonetizationEnabled) ?? false,
      'consent_timestamp': prefs.getString(_keyConsentTimestamp),
    };
  }

  Future<void> updateConsent(String key, bool value) async {
    final prefs = await _prefs;
    String? prefsKey;
    switch (key) {
      case 'tip_jar_consent':
        prefsKey = _keyTipJarConsent;
        break;
      case 'passive_monetization_consent_given':
        prefsKey = _keyPassiveMonetizationConsentGiven;
        break;
      case 'passive_monetization_enabled':
        prefsKey = _keyPassiveMonetizationEnabled;
        break;
      default:
        return;
    }
    await prefs.setBool(prefsKey, value);
  }

  Future<void> deleteAllUserData() async {
    await _clearSharedPreferences();
    await _clearDatabase();
    await _clearLocalFiles();
  }

  Future<void> _clearSharedPreferences() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  Future<void> _clearDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbFilePath = path.join(dbPath, 'arteria_fit.db');
    final dbFile = File(dbFilePath);
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
  }

  Future<void> _clearLocalFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync();
      for (final file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error clearing local files: $e');
    }
  }

  Future<Map<String, dynamic>> exportUserData() async {
    final consents = await getAllConsents();
    final bloodPressureReadings = await _getBloodPressureData();
    final exerciseLogs = await _getExerciseData();
    final protocolData = await _getProtocolData();

    return {
      'export_timestamp': DateTime.now().toIso8601String(),
      'consents': consents,
      'blood_pressure_readings': bloodPressureReadings,
      'exercise_logs': exerciseLogs,
      'protocol_data': protocolData,
    };
  }

  Future<List<Map<String, dynamic>>> _getBloodPressureData() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFilePath = path.join(dbPath, 'arteria_fit.db');
      if (!await File(dbFilePath).exists()) {
        return [];
      }
      final db = await openDatabase(dbFilePath);
      return await db.query('blood_pressure_log', orderBy: 'created_at DESC');
    } catch (e) {
      debugPrint('Error getting blood pressure data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getExerciseData() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFilePath = path.join(dbPath, 'arteria_fit.db');
      if (!await File(dbFilePath).exists()) {
        return [];
      }
      final db = await openDatabase(dbFilePath);
      return await db.query('exercise_log', orderBy: 'completed_at DESC');
    } catch (e) {
      debugPrint('Error getting exercise data: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> _getProtocolData() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFilePath = path.join(dbPath, 'arteria_fit.db');
      if (!await File(dbFilePath).exists()) {
        return {'protocols': [], 'sessions': [], 'readings': []};
      }
      final db = await openDatabase(dbFilePath);
      final protocols = await db.query(
        'bp_protocol',
        orderBy: 'start_date DESC',
      );
      final sessions = await db.query(
        'bp_session',
        orderBy: 'scheduled_at DESC',
      );
      final readings = await db.query(
        'bp_reading',
        orderBy: 'recorded_at DESC',
      );
      return {
        'protocols': protocols,
        'sessions': sessions,
        'readings': readings,
      };
    } catch (e) {
      debugPrint('Error getting protocol data: $e');
      return {'protocols': [], 'sessions': [], 'readings': []};
    }
  }

  String exportToJson(Map<String, dynamic> data) {
    return const JsonEncoder.withIndent('  ').convert(data);
  }
}
