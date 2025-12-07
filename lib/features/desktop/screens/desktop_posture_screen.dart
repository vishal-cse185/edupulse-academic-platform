import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/desktop_posture_service.dart';
import '../services/desktop_camera_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class DesktopPostureScreen extends StatefulWidget {
  const DesktopPostureScreen({super.key});

  @override
  State<DesktopPostureScreen> createState() => _DesktopPostureScreenState();
}

class _DesktopPostureScreenState extends State<DesktopPostureScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-start monitoring when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DesktopPostureService>(
        context,
        listen: false,
      ).startMonitoring();
      Provider.of<DesktopCameraService>(context, listen: false).initialize();
    });
  }

  @override
  void dispose() {
    // Stop monitoring when leaving screen
    // Note: In a full app, you might want this service to run in background.
    // For this screen, we'll pause it to be safe, or let the user decide.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postureService = Provider.of<DesktopPostureService>(context);
    final cameraService = Provider.of<DesktopCameraService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Posture Check")),
      body: Row(
        children: [
          // Camera Feed (Left Side)
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child:
                  cameraService.isInitialized
                      ? RTCVideoView(cameraService.renderer)
                      : const Center(child: CircularProgressIndicator()),
            ),
          ),
          // Feedback Panel (Right Side)
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[900],
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.accessibility_new,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    postureService.currentFeedback,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () {
                      if (postureService.isMonitoring) {
                        postureService.stopMonitoring();
                      } else {
                        postureService.startMonitoring();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                    ),
                    child: Text(
                      postureService.isMonitoring
                          ? "Stop Monitoring"
                          : "Start Monitoring",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
