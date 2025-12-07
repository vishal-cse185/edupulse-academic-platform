import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// A robust, continuous listening engine that auto-restarts on silence or error.
/// It provides a stream of recognized commands.
class ContinuousListeningService extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isInitialized = false;
  bool _isListening = false;
  bool _stopRequested = false;

  // Stream controller to broadcast recognized text to subscribers (Routers)
  final StreamController<String> _commandController =
      StreamController<String>.broadcast();
  Stream<String> get commandStream => _commandController.stream;

  bool get isListening => _isListening;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = await _speech.initialize(
        onStatus: (status) {
          if (kDebugMode) debugPrint('ContinuousListening Status: $status');
          if (status == 'done' || status == 'notListening') {
            if (!_stopRequested && _isListening) {
              // Auto-restart if it stopped but we didn't ask it to
              _restartListening();
            }
          }
        },
        onError: (error) {
          if (kDebugMode) debugPrint('ContinuousListening Error: $error');
          // On error, we also try to restart after a brief pause
          if (!_stopRequested && _isListening) {
            _restartListening();
          }
        },
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Error initializing SpeechToText: $e');
    }
  }

  Future<void> startListening() async {
    _stopRequested = false;
    if (!_isInitialized) {
      await initialize();
    }

    if (_isListening) return;

    _isListening = true;
    notifyListeners();
    _listenLoop();
  }

  void _listenLoop() async {
    if (_stopRequested) return;

    if (!_isInitialized) {
      // If init failed, try again
      await initialize();
      if (!_isInitialized) {
        // If still failed, wait and retry
        await Future.delayed(const Duration(seconds: 2));
        _listenLoop();
        return;
      }
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            if (kDebugMode) debugPrint("Recognized: ${result.recognizedWords}");
            _commandController.add(result.recognizedWords.toLowerCase());
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          cancelOnError: false,
          partialResults: false,
        ),
      );
    } catch (e) {
      if (kDebugMode) debugPrint("Listen loop error: $e");
      _restartListening();
    }
  }

  Future<void> _restartListening() async {
    if (_stopRequested) return;

    // Small delay to prevent tight loops on error
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_speech.isListening) {
      _listenLoop();
    }
  }

  Future<void> stopListening() async {
    _stopRequested = true;
    _isListening = false;
    notifyListeners();
    await _speech.stop();
  }

  @override
  void dispose() {
    _commandController.close();
    super.dispose();
  }
}
