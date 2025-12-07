import 'dart:async';
import 'package:flutter/foundation.dart';
import '../voice_service.dart';
import 'ai_voice_router.dart';
import 'ai_intent_service.dart';

enum EntryNavigationEvent { dashboard, profile, teacherContent, none }

class EntryAiMentorService extends ChangeNotifier {
  final AiVoiceRouter _router;
  final VoiceService _voiceService;
  final AiIntentService _intentService; // New dependency

  final StreamController<EntryNavigationEvent> _navigationController =
      StreamController<EntryNavigationEvent>.broadcast();
  Stream<EntryNavigationEvent> get navigationStream =>
      _navigationController.stream;

  EntryAiMentorService(this._router, this._voiceService, this._intentService);

  void startMonitoring() {
    _router.registerHandler(_handleCommand);
    _voiceService.speak(
      "Welcome. I am your Entry Mentor. Say Open Blind Dashboard, Open Profile, or Open Teacher Content.",
    );
  }

  void stopMonitoring() {
    _router.unregisterHandler();
  }

  Future<void> _handleCommand(String command) async {
    if (kDebugMode) {
      debugPrint("EntryAiMentor received: $command");
    }

    // Use LLM to determine intent
    final intent = await _intentService.determineEntryIntent(command);

    switch (intent) {
      case 'DASHBOARD':
        _voiceService.speak("Opening Blind Dashboard");
        _navigationController.add(EntryNavigationEvent.dashboard);
        break;
      case 'PROFILE':
        _voiceService.speak("Opening Profile");
        _navigationController.add(EntryNavigationEvent.profile);
        break;
      case 'TEACHER_CONTENT':
        _voiceService.speak("Opening Teacher Content");
        _navigationController.add(EntryNavigationEvent.teacherContent);
        break;
      default:
        // Optional: Feedback for unknown command
        // _voiceService.speak("I didn't understand. Please say Open Dashboard, Profile, or Teacher Content.");
        break;
    }
  }

  @override
  void dispose() {
    _navigationController.close();
    super.dispose();
  }
}
