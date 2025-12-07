import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/content/teacher_work_service.dart';
import '../../widgets/accessible/accessible_button.dart';
import '../../widgets/accessible/accessible_section.dart';

class TeacherContentScreen extends StatefulWidget {
  static const String routeName = '/teacher-content';

  const TeacherContentScreen({super.key});

  @override
  State<TeacherContentScreen> createState() => _TeacherContentScreenState();
}

class _TeacherContentScreenState extends State<TeacherContentScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-load content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherWorkService>(context, listen: false).loadAssignments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Teacher Content"),
        backgroundColor: Colors.grey[900],
      ),
      body: Consumer<TeacherWorkService>(
        builder: (context, service, child) {
          if (service.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (service.assignments.isEmpty) {
            return const Center(
              child: Text(
                "No content available",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: service.assignments.length,
            itemBuilder: (context, index) {
              final item = service.assignments[index];
              return AccessibleSection(
                title: item.title,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Due: ${item.dueDate.toString().split(' ')[0]}",
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AccessibleButton(
                      label: "Read Content",
                      icon: Icons.volume_up,
                      onTap: () {
                        // Trigger reading via voice service (not injected here directly for simplicity,
                        // but normally would call a method on the service or mentor)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Reading content...")),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
