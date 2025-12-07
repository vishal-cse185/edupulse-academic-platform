import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../voice_service.dart';

class PostureDetectorService extends ChangeNotifier {
  final VoiceService _voiceService;
  bool _isMonitoring = false;
  Timer? _monitoringTimer;

  // Dummy status
  String _currentStatus = "Good";

  PostureDetectorService(this._voiceService);

  bool get isMonitoring => _isMonitoring;
  String get currentStatus => _currentStatus;

  void startMonitoring() {
    if (_isMonitoring) return;
    _isMonitoring = true;
    _voiceService.speak("Posture monitoring started. Please sit upright.");
    notifyListeners();

    // Simulate periodic checks
    _monitoringTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _checkPosture();
    });
  }

  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _isMonitoring = false;
    _voiceService.speak("Posture monitoring stopped.");
    notifyListeners();
  }

  void _checkPosture() {
    // Dummy logic: Randomly detect bad posture
    final random = Random();
    final chance = random.nextInt(10); // 0-9

    if (chance < 3) {
      _currentStatus = "Leaning Left";
      _voiceService.speak("You are leaning to the left. Please sit straight.");
    } else if (chance < 6) {
      _currentStatus = "Too Close";
      _voiceService.speak(
        "You are too close to the screen. Move back slightly.",
      );
    } else {
      _currentStatus = "Good";
      // Optionally give positive reinforcement rarely
      if (chance == 9) {
        _voiceService.speak("Your posture is good. Keep it up.");
      }
    }
    notifyListeners();
  }

  // Method to be called when a camera frame is available (Placeholder)
  void processFrame(dynamic cameraImage) {
    // In a real implementation, this would run ML Kit Pose Detection
    // For now, the timer handles the simulation
  }
}
