import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../services/voice_service.dart';

class ContinuousDesktopListener extends ChangeNotifier {
  // final VoiceService _voiceService; // Reuse existing mobile service for basic STT/TTS
  final SpeechToText _speechToText = SpeechToText();

  bool _isListening = false;
  String _lastRecognizedWords = "";
  Timer? _silenceTimer;

  // Stream controller to broadcast recognized commands
  final _commandController = StreamController<String>.broadcast();
  Stream<String> get commandStream => _commandController.stream;

  ContinuousDesktopListener(
    VoiceService voiceService,
  ); // Keep constructor signature for provider compatibility

  bool get isListening => _isListening;

  Future<void> startListening() async {
    if (_isListening) return;

    bool available = await _speechToText.initialize(
      onError: (val) => _restartListening(),
      onStatus: (val) => _onStatus(val),
    );

    if (available) {
      _isListening = true;
      notifyListeners();
      _listenLoop();
    } else {
      debugPrint("Desktop STT not available");
    }
  }

  void stopListening() {
    _isListening = false;
    _speechToText.stop();
    _silenceTimer?.cancel();
    notifyListeners();
  }

  void _listenLoop() {
    if (!_isListening) return;

    _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          _lastRecognizedWords = result.recognizedWords;
          _processCommand(_lastRecognizedWords);
          // Restart loop after a short pause
          Future.delayed(const Duration(milliseconds: 500), _listenLoop);
        } else {
          // Reset silence timer on partial results
          _resetSilenceTimer();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
        cancelOnError: false,
      ),
    );
  }

  void _processCommand(String command) {
    if (command.isNotEmpty) {
      debugPrint("Desktop Heard: $command");
      _commandController.add(command);
    }
  }

  void _restartListening() {
    if (_isListening) {
      Future.delayed(const Duration(seconds: 1), _listenLoop);
    }
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _restartListening();
    }
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(seconds: 5), () {
      // Logic for silence detection if needed
    });
  }
}
