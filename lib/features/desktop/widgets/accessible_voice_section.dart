import 'package:flutter/material.dart';

class AccessibleVoiceSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AccessibleVoiceSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
