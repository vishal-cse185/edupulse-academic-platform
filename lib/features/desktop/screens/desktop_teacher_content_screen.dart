import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/voice_service.dart';
import '../../../../services/auth_service.dart';
import '../services/desktop_teacher_work_service.dart';
import '../widgets/accessible_voice_button.dart';

class DesktopTeacherContentScreen extends StatefulWidget {
  const DesktopTeacherContentScreen({super.key});

  @override
  State<DesktopTeacherContentScreen> createState() =>
      _DesktopTeacherContentScreenState();
}

class _DesktopTeacherContentScreenState
    extends State<DesktopTeacherContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.getCurrentUserModel();

      if (user != null && mounted) {
        Provider.of<DesktopTeacherWorkService>(
          context,
          listen: false,
        ).loadAssignments(user.uid);
        Provider.of<VoiceService>(
          context,
          listen: false,
        ).speak("Assignments loaded. Use voice commands to navigate.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final workService = Provider.of<DesktopTeacherWorkService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Assignments (Desktop)")),
      body:
          workService.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(32),
                itemCount: workService.assignments.length,
                itemBuilder: (context, index) {
                  final assignment = workService.assignments[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: AccessibleVoiceButton(
                      label:
                          "${assignment.title}. Due ${assignment.dueDate.toString().split(' ')[0]}",
                      onTap: () {
                        // Read details
                        Provider.of<VoiceService>(context, listen: false).speak(
                          "${assignment.title}. ${assignment.description}. Due date is ${assignment.dueDate}",
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
