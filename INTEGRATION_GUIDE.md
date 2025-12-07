# Integration Guide for AI Extensions

This guide details how to integrate the newly generated AI, Vision, and Content modules into your existing Flutter application.

## 1. Register Providers

Open your `main.dart` (or wherever you initialize `MultiProvider`) and add the following providers to your `providers` list.

**Import the new services:**
```dart
import 'services/ai/continuous_listening_service.dart';
import 'services/ai/ai_voice_router.dart';
import 'services/ai/ai_intent_service.dart';
import 'services/ai/entry_ai_mentor_service.dart';
import 'services/ai/dashboard_ai_mentor_service.dart';
import 'services/vision/posture_detector_service.dart';
import 'services/content/teacher_work_service.dart';
import 'services/voice_service.dart'; // Existing service
```

**Add to MultiProvider:**
```dart
MultiProvider(
  providers: [
    // ... existing providers ...
    
    // 1. Core AI Services
    ChangeNotifierProvider(create: (_) => ContinuousListeningService()),
    Provider(create: (_) => AiIntentService()), // New LLM Service
    
    // 2. Voice Router (Depends on Listening Service)
    ChangeNotifierProxyProvider<ContinuousListeningService, AiVoiceRouter>(
      create: (context) => AiVoiceRouter(context.read<ContinuousListeningService>()),
      update: (context, listeningService, previous) => 
          previous ?? AiVoiceRouter(listeningService),
    ),

    // 3. Domain Services
    ChangeNotifierProvider(create: (_) => TeacherWorkService()),
    
    // 4. Vision Services (Depends on VoiceService)
    ChangeNotifierProxyProvider<VoiceService, PostureDetectorService>(
      create: (context) => PostureDetectorService(context.read<VoiceService>()),
      update: (context, voiceService, previous) => 
          previous ?? PostureDetectorService(voiceService),
    ),

    // 5. AI Mentors (Depend on Router, VoiceService, IntentService, and Domain Services)
    ChangeNotifierProxyProvider3<AiVoiceRouter, VoiceService, AiIntentService, EntryAiMentorService>(
      create: (context) => EntryAiMentorService(
        context.read<AiVoiceRouter>(),
        context.read<VoiceService>(),
        context.read<AiIntentService>(),
      ),
      update: (context, router, voiceService, intentService, previous) => 
          previous ?? EntryAiMentorService(router, voiceService, intentService),
    ),

    ChangeNotifierProxyProvider5<AiVoiceRouter, VoiceService, TeacherWorkService, PostureDetectorService, AiIntentService, DashboardAiMentorService>(
      create: (context) => DashboardAiMentorService(
        context.read<AiVoiceRouter>(),
        context.read<VoiceService>(),
        context.read<TeacherWorkService>(),
        context.read<PostureDetectorService>(),
        context.read<AiIntentService>(),
      ),
      update: (context, router, voiceService, workService, postureService, intentService, previous) => 
          previous ?? DashboardAiMentorService(router, voiceService, workService, postureService, intentService),
    ),
  ],
  child: const MyApp(),
)
```

## 2. Register Routes

Add the new screens to your `routes` map in `MaterialApp`.

**Import the screens:**
```dart
import 'screens/teacher_content/teacher_content_screen.dart';
import 'screens/vision/posture_feedback_screen.dart';
```

**Add to routes:**
```dart
routes: {
  // ... existing routes ...
  TeacherContentScreen.routeName: (context) => const TeacherContentScreen(),
  PostureFeedbackScreen.routeName: (context) => const PostureFeedbackScreen(),
},
```

## 3. Integrate Entry AI Mentor

In your **Entry Screen** (e.g., `LoginScreen` or `HomeScreen`), initialize the `EntryAiMentorService`.

```dart
class EntryScreen extends StatefulWidget {
  // ...
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    // Start the Mentor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mentor = Provider.of<EntryAiMentorService>(context, listen: false);
      mentor.startMonitoring();
      
      // Listen for navigation events
      mentor.navigationStream.listen((event) {
        if (event == EntryNavigationEvent.dashboard) {
          Navigator.pushNamed(context, '/dashboard'); // Replace with your actual route
        } else if (event == EntryNavigationEvent.profile) {
          Navigator.pushNamed(context, '/profile');
        } else if (event == EntryNavigationEvent.teacherContent) {
          Navigator.pushNamed(context, TeacherContentScreen.routeName);
        }
      });
      
      // Start listening engine
      Provider.of<ContinuousListeningService>(context, listen: false).startListening();
    });
  }

  @override
  void dispose() {
    // Stop monitoring when leaving this screen
    Provider.of<EntryAiMentorService>(context, listen: false).stopMonitoring();
    super.dispose();
  }
  // ...
}
```

## 4. Integrate Dashboard AI Mentor

In your **Blind Dashboard Screen**, initialize the `DashboardAiMentorService`.

```dart
class BlindDashboardScreen extends StatefulWidget {
  // ...
}

class _BlindDashboardScreenState extends State<BlindDashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mentor = Provider.of<DashboardAiMentorService>(context, listen: false);
      mentor.startMonitoring();
      
      // Handle Dashboard Events
      mentor.eventStream.listen((event) {
        switch (event) {
          case DashboardEvent.scrollDown:
            _scrollController.animateTo(
              _scrollController.offset + 300, 
              duration: const Duration(milliseconds: 500), 
              curve: Curves.easeInOut
            );
            break;
          case DashboardEvent.scrollUp:
            _scrollController.animateTo(
              _scrollController.offset - 300, 
              duration: const Duration(milliseconds: 500), 
              curve: Curves.easeInOut
            );
            break;
          case DashboardEvent.openOcr:
            // Navigate to existing OCR screen
            // Navigator.pushNamed(context, '/ocr'); 
            break;
          case DashboardEvent.nextItem:
            // Logic to focus next item
            break;
          // ... handle other events
        }
      });
    });
  }

  @override
  void dispose() {
    Provider.of<DashboardAiMentorService>(context, listen: false).stopMonitoring();
    _scrollController.dispose();
    super.dispose();
  }
  // ...
}
```

## 5. Updated Blind Workflow End-to-End

1.  **App Launch**: The user opens the app. The **Entry AI Mentor** greets them: *"Welcome. Say Open Blind Dashboard..."*.
2.  **Voice Command**: User says *"Open Blind Dashboard"*.
3.  **Navigation**: The app navigates to the Dashboard. The Entry Mentor stops, and the **Dashboard AI Mentor** starts.
4.  **Dashboard Interaction**:
    *   User says *"What is my today's work?"*.
    *   Mentor replies: *"You have 2 items..."*.
    *   User says *"Guide my posture"*.
    *   **Posture Detector** starts and gives feedback: *"Sit upright"*.
    *   User says *"Open Teacher Content"*.
5.  **Content Consumption**: App opens `TeacherContentScreen`. User navigates the list using large accessible buttons or voice commands (if further extended).

## 6. Posture Module Connection

The **Posture Module** (`PostureDetectorService`) is a standalone service that uses the camera (simulated in this placeholder) to analyze user position.
- It is injected into the `DashboardAiMentorService`.
- The Mentor listens for the command *"Guide my posture"*.
- When triggered, the Mentor calls `postureService.startMonitoring()`.
- The Posture Service then uses the `VoiceService` directly to speak feedback (e.g., *"Move left"*), independent of the Mentor's main dialogue loop.
