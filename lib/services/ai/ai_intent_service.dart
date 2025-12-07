import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AiIntentService {
  late GenerativeModel _model;
  // Using a standard key or the one from existing service if accessible.
  // For now, I'll use the one found in the existing file for consistency,
  // but in a real app this should be in an env file.
  static const String _apiKey = 'AIzaSyBwbpG7j5WoySrb901P4oSni25Nmct-hPA';

  AiIntentService() {
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
  }

  Future<String> determineEntryIntent(String userText) async {
    final prompt = '''
    You are an intent classifier for a blind student app.
    User Input: "$userText"
    
    Classify into one of these exact categories:
    - DASHBOARD (if user wants to open dashboard, blind mode, home)
    - PROFILE (if user wants to check profile, settings, me)
    - TEACHER_CONTENT (if user wants teacher work, assignments, lessons)
    - UNKNOWN (if unclear)
    
    Return ONLY the category name.
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text?.trim().toUpperCase() ?? 'UNKNOWN';
      if (kDebugMode) debugPrint("Entry Intent: $text");
      return text;
    } catch (e) {
      if (kDebugMode) debugPrint("LLM Error: $e");
      return 'UNKNOWN';
    }
  }

  Future<String> determineDashboardIntent(String userText) async {
    final prompt = '''
    You are an intent classifier for a blind student dashboard.
    User Input: "$userText"
    
    Classify into one of these exact categories:
    - READ_WORK (today's work, what do I have, assignments)
    - READ_SCREEN (read this, read screen, what's on screen)
    - OPEN_OCR (ocr, camera, read text, scan)
    - POSTURE_GUIDE (posture, sit straight, guide me)
    - SCROLL_DOWN (scroll down, go down, next page)
    - SCROLL_UP (scroll up, go up, previous page)
    - NEXT_ITEM (next, forward)
    - PREV_ITEM (previous, back)
    - STOP (stop, quiet, silence)
    - UNKNOWN
    
    Return ONLY the category name.
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text?.trim().toUpperCase() ?? 'UNKNOWN';
      if (kDebugMode) debugPrint("Dashboard Intent: $text");
      return text;
    } catch (e) {
      if (kDebugMode) debugPrint("LLM Error: $e");
      return 'UNKNOWN';
    }
  }
}
