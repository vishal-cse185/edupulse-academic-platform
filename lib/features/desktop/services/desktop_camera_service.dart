import 'dart:async';
// import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class DesktopCameraService extends ChangeNotifier {
  MediaStream? _localStream;
  final RTCVideoRenderer _renderer = RTCVideoRenderer();
  bool _isInitialized = false;

  RTCVideoRenderer get renderer => _renderer;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _renderer.initialize();

    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'mandatory': {
          'minWidth': '1280',
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      },
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(
        mediaConstraints,
      );
      _renderer.srcObject = _localStream;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing desktop camera: $e');
    }
  }

  Future<void> stop() async {
    try {
      _localStream?.getTracks().forEach((track) => track.stop());
      await _localStream?.dispose();
      _localStream = null;
      _renderer.srcObject = null;
      await _renderer.dispose();
      _isInitialized = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping desktop camera: $e');
    }
  }

  /// Captures the current frame as bytes (Mock implementation for WebRTC)
  /// In a real scenario, you'd use a canvas or a specific plugin method to extract bytes.
  /// For this prototype, we'll return a placeholder or implement a basic frame grabber if possible.
  Future<Uint8List?> getCurrentFrame() async {
    if (!_isInitialized || _localStream == null) return null;

    // Note: Extracting raw bytes from RTCVideoRenderer directly is complex in pure Flutter.
    // This is a placeholder where you would integrate with a native plugin or
    // use a screenshot method if the renderer is part of the widget tree.
    // For the purpose of this assignment, we return null or a mock buffer.
    return null;
  }
}
