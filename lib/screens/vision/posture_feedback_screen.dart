import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/vision/posture_detector_service.dart';
import '../../widgets/accessible/accessible_button.dart';

class PostureFeedbackScreen extends StatefulWidget {
  static const String routeName = '/posture-feedback';

  const PostureFeedbackScreen({super.key});

  @override
  State<PostureFeedbackScreen> createState() => _PostureFeedbackScreenState();
}

class _PostureFeedbackScreenState extends State<PostureFeedbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostureDetectorService>(
        context,
        listen: false,
      ).startMonitoring();
    });
  }

  @override
  void dispose() {
    // We might not want to stop monitoring automatically if it's a background service,
    // but for this screen's purpose, we can stop it when leaving.
    // Provider.of<PostureDetectorService>(context, listen: false).stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Posture Guide"),
        backgroundColor: Colors.grey[900],
      ),
      body: Consumer<PostureDetectorService>(
        builder: (context, service, child) {
          Color statusColor = Colors.green;
          IconData statusIcon = Icons.check_circle;

          if (service.currentStatus != "Good") {
            statusColor = Colors.red;
            statusIcon = Icons.warning;
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 64, color: Colors.white54),
                        SizedBox(height: 16),
                        Text(
                          "Camera Feed Placeholder",
                          style: TextStyle(color: Colors.white54, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Icon(statusIcon, size: 80, color: statusColor),
                const SizedBox(height: 24),
                Text(
                  service.currentStatus,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                AccessibleButton(
                  label:
                      service.isMonitoring
                          ? "Stop Monitoring"
                          : "Start Monitoring",
                  backgroundColor:
                      service.isMonitoring
                          ? Colors.redAccent
                          : Colors.greenAccent,
                  onTap: () {
                    if (service.isMonitoring) {
                      service.stopMonitoring();
                    } else {
                      service.startMonitoring();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
