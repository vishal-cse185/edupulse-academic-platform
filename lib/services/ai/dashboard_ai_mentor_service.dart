import 'dart:async';
import 'package:flutter/foundation.dart';
import '../voice_service.dart';
import 'ai_voice_router.dart';
import 'ai_intent_service.dart';
import '../content/teacher_work_service.dart';
import '../vision/posture_detector_service.dart';

enum DashboardEvent {
  openOcr,
  scrollUp,
  scrollDown,
  nextItem,
  previousItem,
  none,
}

class DashboardAiMentorService extends ChangeNotifier {
  final AiVoiceRouter _router;
  final VoiceService _voiceService;
  final TeacherWorkService _workService;
  final PostureDetectorService _postureService;
  final AiIntentService _intentService; // New dependency

  final StreamController<DashboardEvent> _eventController =
      StreamController<DashboardEvent>.broadcast();
  Stream<DashboardEvent> get eventStream => _eventController.stream;

  DashboardAiMentorService(
    this._router,
    this._voiceService,
    this._workService,
    this._postureService,
    this._intentService,
  );

  void startMonitoring() {
    _router.registerHandler(_handleCommand);
    _voiceService.speak(
      "Dashboard Mentor Active. Ask me about your work or say Guide My Posture.",
    );
  }

  void stopMonitoring() {
    _router.unregisterHandler();
  }

  Future<void> _handleCommand(String command) async {
    if (kDebugMode) {
      debugPrint("DashboardAiMentor received: $command");
    }

    // Use LLM to determine intent
    final intent = await _intentService.determineDashboardIntent(command);

    switch (intent) {
      case 'READ_WORK':
        await _announceTodaysWork();
        break;
      case 'READ_SCREEN':
        _voiceService.speak("Reading the current section content...");
        // In a real app, we would track the focused item
        break;
      case 'OPEN_OCR':
        _voiceService.speak("Opening OCR Scanner");
        _eventController.add(DashboardEvent.openOcr);
        break;
      case 'SCROLL_DOWN':
        _eventController.add(DashboardEvent.scrollDown);
        break;
      case 'SCROLL_UP':
        _eventController.add(DashboardEvent.scrollUp);
        break;
      case 'NEXT_ITEM':
        _eventController.add(DashboardEvent.nextItem);
        break;
      case 'PREV_ITEM':
        _eventController.add(DashboardEvent.previousItem);
        break;
      case 'POSTURE_GUIDE':
        _postureService.startMonitoring();
        break;
      case 'STOP':
        _postureService.stopMonitoring();
        break;
      default:
        // Handle unknown or specific assignment queries if needed
        if (command.contains("assignment")) {
          await _announceAssignments();
        }
        break;
    }
  }

  Future<void> _announceTodaysWork() async {
    final work = _workService.getTodaysWork();
    if (work.isEmpty) {
      await _voiceService.speak("You have no work due today.");
    } else {
      await _voiceService.speak("You have ${work.length} items for today.");
      for (var item in work) {
        await _voiceService.speak("${item.title}. ${item.type}.");
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<void> _announceAssignments() async {
    final assignments = _workService.assignments;
    if (assignments.isEmpty) {
      // Try loading if empty
      await _workService.loadAssignments();
    }

    if (_workService.assignments.isEmpty) {
      await _voiceService.speak("No assignments found.");
    } else {
      await _voiceService.speak(
        "You have ${_workService.assignments.length} total assignments.",
      );
    }
  }

  @override
  void dispose() {
    _eventController.close();
    super.dispose();
  }
}
