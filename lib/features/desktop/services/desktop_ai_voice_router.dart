import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
import 'continuous_desktop_listener.dart';
import '../../../services/voice_service.dart';
import '../../../services/auth_service.dart';
import 'desktop_notes_service.dart';
import 'desktop_quiz_service.dart';

class DesktopAiVoiceRouter extends ChangeNotifier {
  final ContinuousDesktopListener _listener;
  final VoiceService _voiceService;
  final DesktopNotesService? _notesService;
  final AuthService? _authService;
  final DesktopQuizService? _quizService;

  // Callback to handle navigation actions
  Function(String route)? onNavigate;

  DesktopAiVoiceRouter(
    this._listener,
    this._voiceService, [
    this._notesService,
    this._authService,
    this._quizService,
  ]) {
    _listener.commandStream.listen(_handleCommand);
  }

  void _handleCommand(String command) {
    final lower = command.toLowerCase();

    if (lower.contains("open blind dashboard")) {
      _voiceService.speak("Opening Blind Dashboard");
      onNavigate?.call('/blind_dashboard');
    } else if (lower.contains("read this") || lower.contains("scan")) {
      _voiceService.speak("Scanning text...");
      // Trigger OCR logic via provider/callback in UI
      onNavigate?.call('/desktop_ocr');
    } else if (lower.contains("today's work") ||
        lower.contains("assignments")) {
      _voiceService.speak("Opening assignments");
      onNavigate?.call('/desktop_teacher_content');
    } else if (lower.contains("guide my posture") ||
        lower.contains("posture check")) {
      _voiceService.speak("Starting posture check");
      onNavigate?.call('/desktop_posture');
    } else if (lower.contains("take a note")) {
      _handleNoteTaking(command);
    } else if (lower.contains("quiz me") || lower.contains("start quiz")) {
      _handleQuiz(command);
    } else if (_quizService != null && _quizService.isQuizActive) {
      // If quiz is active, treat input as answer
      final response = _quizService.submitAnswer(command);
      _voiceService.speak(response);
    } else if (lower.contains("scroll down")) {
      // Broadcast scroll event or handle via callback
      debugPrint("Action: Scroll Down");
    } else if (lower.contains("scroll up")) {
      debugPrint("Action: Scroll Up");
    }
  }

  Future<void> _handleNoteTaking(String command) async {
    if (_notesService == null || _authService == null) return;

    final user = await _authService.getCurrentUserModel();
    if (user == null) {
      _voiceService.speak("You must be logged in to take notes.");
      return;
    }

    // Extract content: "Take a note [content]"
    // Simple parsing: remove "take a note"
    String content = command.toLowerCase().replaceAll("take a note", "").trim();
    if (content.isEmpty) {
      _voiceService.speak("What should I write?");
      return;
    }

    await _notesService.addNote(user.uid, content);
    _voiceService.speak("Note saved: $content");
  }

  Future<void> _handleQuiz(String command) async {
    if (_quizService == null) return;

    _voiceService.speak("Starting quiz generation. Please wait.");
    final response = await _quizService.startQuiz();
    _voiceService.speak(response);
  }
}
