import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../services/voice_service.dart';

class DesktopPostureService extends ChangeNotifier {
  final VoiceService _voiceService;
  bool _isMonitoring = false;
  Timer? _monitoringTimer;
  String _currentFeedback = "Posture Good";

  DesktopPostureService(this._voiceService);

  bool get isMonitoring => _isMonitoring;
  String get currentFeedback => _currentFeedback;

  void startMonitoring() {
    if (_isMonitoring) return;
    _isMonitoring = true;
    _voiceService.speak(
      "Desktop posture monitoring active. I am watching your position.",
    );
    notifyListeners();

    // Simulate analysis loop (In real app, analyze frames from DesktopCameraService)
    _monitoringTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _analyzePosture();
    });
  }

  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _isMonitoring = false;
    _voiceService.speak("Posture monitoring paused.");
    notifyListeners();
  }

  void _analyzePosture() {
    // Mock Logic for Prototype
    // In production, this would consume frames from the secondary camera
    final random = Random();
    final event = random.nextInt(10);

    if (event < 2) {
      _currentFeedback = "Leaning too far forward";
      _voiceService.speak(
        "You are leaning too close to the screen. Please sit back.",
      );
    } else if (event < 4) {
      _currentFeedback = "Head tilted left";
      _voiceService.speak("Your head is tilted to the left. Adjust to center.");
    } else {
      _currentFeedback = "Posture Good";
      // Occasional positive reinforcement
      if (event == 9) {
        _voiceService.speak("Perfect posture. Keep it up.");
      }
    }
    notifyListeners();
  }
}
