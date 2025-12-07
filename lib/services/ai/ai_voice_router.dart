import 'dart:async';
import 'package:flutter/foundation.dart';
import 'continuous_listening_service.dart';

typedef CommandHandler = void Function(String command);

class AiVoiceRouter extends ChangeNotifier {
  final ContinuousListeningService _listeningService;
  CommandHandler? _activeHandler;
  StreamSubscription? _subscription;

  AiVoiceRouter(this._listeningService) {
    _init();
  }

  void _init() {
    _subscription = _listeningService.commandStream.listen((command) {
      if (_activeHandler != null) {
        _activeHandler!(command);
      } else {
        if (kDebugMode) {
          debugPrint("VoiceRouter: No active handler for command: $command");
        }
      }
    });
  }

  /// Registers a handler for voice commands.
  /// Only one handler can be active at a time (e.g., based on the current screen).
  void registerHandler(CommandHandler handler) {
    _activeHandler = handler;
    if (kDebugMode) {
      debugPrint("VoiceRouter: Handler registered");
    }
  }

  /// Unregisters the current handler.
  void unregisterHandler() {
    _activeHandler = null;
    if (kDebugMode) {
      debugPrint("VoiceRouter: Handler unregistered");
    }
  }

  void startListening() {
    _listeningService.startListening();
  }

  void stopListening() {
    _listeningService.stopListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
