import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'features/auth/role_selection_screen.dart';
import 'features/auth/parent_login_screen.dart';
import 'features/auth/teacher_login_screen.dart';
import 'features/auth/student_login_screen.dart';

import 'services/voice_service.dart';
import 'services/llm_service.dart';
import 'features/desktop/services/desktop_camera_service.dart';
import 'features/desktop/services/desktop_ocr_service.dart';
import 'features/desktop/services/desktop_teacher_work_service.dart';
import 'features/desktop/services/desktop_posture_service.dart';
import 'features/desktop/services/continuous_desktop_listener.dart';
import 'features/desktop/services/desktop_ai_voice_router.dart';
import 'features/desktop/services/desktop_notes_service.dart';
import 'features/desktop/ui/desktop_app_wrapper.dart';
import 'features/desktop/screens/desktop_posture_screen.dart';
import 'features/desktop/screens/desktop_teacher_content_screen.dart';

import 'features/desktop/services/desktop_quiz_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        Provider<NotificationService>(create: (_) => NotificationService()),

        // Core AI & Voice Services
        Provider<VoiceService>(create: (_) => VoiceService()),
        Provider<LLMService>(create: (_) => LLMService()),

        // Desktop Services
        ChangeNotifierProvider(create: (_) => DesktopCameraService()),
        ChangeNotifierProvider(create: (_) => DesktopOcrService()),

        ChangeNotifierProxyProvider<DatabaseService, DesktopTeacherWorkService>(
          create:
              (context) => DesktopTeacherWorkService(
                Provider.of<DatabaseService>(context, listen: false),
              ),
          update:
              (context, dbService, previous) =>
                  DesktopTeacherWorkService(dbService),
        ),

        ChangeNotifierProxyProvider<DatabaseService, DesktopNotesService>(
          create:
              (context) => DesktopNotesService(
                Provider.of<DatabaseService>(context, listen: false),
              ),
          update:
              (context, dbService, previous) => DesktopNotesService(dbService),
        ),

        // Quiz Service (depends on LLM and WorkService)
        ChangeNotifierProxyProvider2<
          LLMService,
          DesktopTeacherWorkService,
          DesktopQuizService
        >(
          create:
              (context) => DesktopQuizService(
                Provider.of<LLMService>(context, listen: false),
                Provider.of<DesktopTeacherWorkService>(context, listen: false),
              ),
          update:
              (context, llmService, workService, previous) =>
                  DesktopQuizService(llmService, workService),
        ),

        // Desktop Services dependent on VoiceService
        ChangeNotifierProxyProvider<VoiceService, DesktopPostureService>(
          create:
              (context) => DesktopPostureService(
                Provider.of<VoiceService>(context, listen: false),
              ),
          update:
              (context, voiceService, previous) =>
                  DesktopPostureService(voiceService),
        ),
        ChangeNotifierProxyProvider<VoiceService, ContinuousDesktopListener>(
          create:
              (context) => ContinuousDesktopListener(
                Provider.of<VoiceService>(context, listen: false),
              ),
          update:
              (context, voiceService, previous) =>
                  ContinuousDesktopListener(voiceService),
        ),
        ChangeNotifierProxyProvider5<
          ContinuousDesktopListener,
          VoiceService,
          DesktopNotesService,
          AuthService,
          DesktopQuizService,
          DesktopAiVoiceRouter
        >(
          create:
              (context) => DesktopAiVoiceRouter(
                Provider.of<ContinuousDesktopListener>(context, listen: false),
                Provider.of<VoiceService>(context, listen: false),
                Provider.of<DesktopNotesService>(context, listen: false),
                Provider.of<AuthService>(context, listen: false),
                Provider.of<DesktopQuizService>(context, listen: false),
              ),
          update:
              (
                context,
                listener,
                voiceService,
                notesService,
                authService,
                quizService,
                previous,
              ) => DesktopAiVoiceRouter(
                listener,
                voiceService,
                notesService,
                authService,
                quizService,
              ),
        ),
      ],
      child: DesktopAppWrapper(
        child: MaterialApp(
          title: 'EduGuardian',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const AuthWrapper(),
          routes: {
            '/parent-login': (context) => const ParentLoginScreen(),
            '/teacher-login': (context) => const TeacherLoginScreen(),
            '/student-login': (context) => const StudentLoginScreen(),
            '/desktop_posture': (context) => const DesktopPostureScreen(),
            '/desktop_teacher_content':
                (context) => const DesktopTeacherContentScreen(),
          },
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // User is logged in - Navigate based on role
          return FutureBuilder(
            future: authService.getCurrentUserModel(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (userSnapshot.hasData) {
                // final user = userSnapshot.data!;

                // Navigate to appropriate dashboard based on role
                // Note: This is handled by login screens, so we just show loading
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If no user data, go to role selection
              return const RoleSelectionScreen();
            },
          );
        }

        // User is not logged in
        return const RoleSelectionScreen();
      },
    );
  }
}
