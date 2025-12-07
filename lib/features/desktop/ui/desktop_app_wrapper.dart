import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/desktop_ai_voice_router.dart';
import '../services/continuous_desktop_listener.dart';

class DesktopAppWrapper extends StatefulWidget {
  final Widget child;
  const DesktopAppWrapper({super.key, required this.child});

  @override
  State<DesktopAppWrapper> createState() => _DesktopAppWrapperState();
}

class _DesktopAppWrapperState extends State<DesktopAppWrapper> {
  @override
  void initState() {
    super.initState();
    if (_isDesktop()) {
      // Initialize desktop listeners
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final router = Provider.of<DesktopAiVoiceRouter>(
          context,
          listen: false,
        );
        final listener = Provider.of<ContinuousDesktopListener>(
          context,
          listen: false,
        );

        // Setup navigation callback
        router.onNavigate = (route) {
          Navigator.of(context).pushNamed(route);
        };

        // Start listening
        listener.startListening();
      });
    }
  }

  bool _isDesktop() {
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDesktop()) return widget.child;

    return Scaffold(
      body: Row(
        children: [
          // Desktop Sidebar (Optional, for visual confirmation)
          Container(
            width: 60,
            color: Colors.grey[900],
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.computer, color: Colors.white),
                const Spacer(),
                Consumer<ContinuousDesktopListener>(
                  builder: (context, listener, _) {
                    return Icon(
                      listener.isListening ? Icons.mic : Icons.mic_off,
                      color: listener.isListening ? Colors.red : Colors.grey,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Main Content
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
