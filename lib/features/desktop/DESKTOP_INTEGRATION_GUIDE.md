# Desktop Integration Guide

This guide explains how to integrate the new desktop modules into your existing Flutter application.

## 1. Add Dependencies
Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_webrtc: ^0.10.8
  # Ensure google_generative_ai is present if using Gemini for OCR
```

## 2. Register Providers
Update your `MultiProvider` in `main.dart` to include the new desktop services:

```dart
// Import new services
import 'features/desktop/services/desktop_camera_service.dart';
import 'features/desktop/services/desktop_ocr_service.dart';
import 'features/desktop/services/desktop_posture_service.dart';
import 'features/desktop/services/continuous_desktop_listener.dart';
import 'features/desktop/services/desktop_ai_voice_router.dart';
import 'features/desktop/services/desktop_teacher_work_service.dart';

// In MultiProvider providers list:
MultiProvider(
  providers: [
    // ... existing providers ...
    
    // Desktop Services
    ChangeNotifierProvider(create: (_) => DesktopCameraService()),
    ChangeNotifierProvider(create: (_) => DesktopOcrService()),
    ChangeNotifierProvider(create: (_) => DesktopTeacherWorkService()),
    
    // Services dependent on VoiceService (ensure VoiceService is provided above or passed)
    ChangeNotifierProxyProvider<VoiceService, DesktopPostureService>(
      create: (context) => DesktopPostureService(Provider.of<VoiceService>(context, listen: false)),
      update: (context, voiceService, previous) => DesktopPostureService(voiceService),
    ),
    ChangeNotifierProxyProvider<VoiceService, ContinuousDesktopListener>(
      create: (context) => ContinuousDesktopListener(Provider.of<VoiceService>(context, listen: false)),
      update: (context, voiceService, previous) => ContinuousDesktopListener(voiceService),
    ),
    ChangeNotifierProxyProvider2<ContinuousDesktopListener, VoiceService, DesktopAiVoiceRouter>(
      create: (context) => DesktopAiVoiceRouter(
        Provider.of<ContinuousDesktopListener>(context, listen: false),
        Provider.of<VoiceService>(context, listen: false),
      ),
      update: (context, listener, voiceService, previous) => DesktopAiVoiceRouter(listener, voiceService),
    ),
  ],
  child: ...
)
```

## 3. Register Routes
Add the new desktop screens to your `routes` map in `MaterialApp`:

```dart
// Import screens
import 'features/desktop/screens/desktop_posture_screen.dart';
import 'features/desktop/screens/desktop_teacher_content_screen.dart';

routes: {
  // ... existing routes ...
  '/desktop_posture': (context) => const DesktopPostureScreen(),
  '/desktop_teacher_content': (context) => const DesktopTeacherContentScreen(),
  // Add other desktop screens as needed
}
```

## 4. Wrap the App
Wrap your main home screen or the entire `MaterialApp` builder with `DesktopAppWrapper` to enable the continuous listener on desktop platforms.

```dart
import 'features/desktop/ui/desktop_app_wrapper.dart';

// In MaterialApp builder or home:
home: DesktopAppWrapper(
  child: const AuthWrapper(), // Your existing home/auth wrapper
),
```

## 5. Platform Specifics
- **macOS**: Ensure you have camera and microphone entitlements in `macos/Runner/DebugProfile.entitlements` and `Release.entitlements`.
- **Windows**: Ensure you have microphone permissions enabled in Windows settings.

## 6. Usage
- The app will automatically detect if it's running on a desktop.
- The `ContinuousDesktopListener` will start listening for commands like "open blind dashboard", "guide my posture", etc.
- The `DesktopPostureScreen` will use the webcam to simulate posture analysis.
