import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudyModeService {
  static const String _keyStudyMode = 'study_mode_enabled';
  static const String _keyBlockedApps = 'blocked_apps';

  Future<bool> isStudyModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_keyStudyMode) ?? false;
    debugPrint('📱 StudyModeService: Reading study mode = $enabled');
    return enabled;
  }

  Future<void> enableStudyMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStudyMode, true);
    debugPrint('✅ StudyModeService: Study mode ENABLED');
    await _logCurrentState();
  }

  Future<void> disableStudyMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStudyMode, false);
    debugPrint('⏸️ StudyModeService: Study mode DISABLED');
    await _logCurrentState();
  }

  Future<void> updateBlockedApps(String blockedAppsString) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBlockedApps, blockedAppsString);
    debugPrint(
      '🚫 StudyModeService: Blocked apps updated = $blockedAppsString',
    );
    await _logCurrentState();
  }

  Future<void> _logCurrentState() async {
    final prefs = await SharedPreferences.getInstance();
    final studyMode = prefs.getBool(_keyStudyMode) ?? false;
    final blockedApps = prefs.getString(_keyBlockedApps) ?? '';
    debugPrint('📋 === SharedPreferences State ===');
    debugPrint('Study Mode: $studyMode');
    debugPrint('Blocked Apps: $blockedApps');
    debugPrint('==================================');
  }
}
