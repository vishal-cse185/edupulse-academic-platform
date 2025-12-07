// import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DesktopOcrService extends ChangeNotifier {
  final GenerativeModel? _visionModel;
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  DesktopOcrService({GenerativeModel? visionModel})
    : _visionModel = visionModel;

  Future<String> extractText(Uint8List imageBytes) async {
    if (_isProcessing) return "Already processing";

    _isProcessing = true;
    notifyListeners();

    try {
      // If we have a Gemini model, use it
      if (_visionModel != null) {
        final prompt = TextPart(
          "Read the text in this image clearly and concisely.",
        );
        final imagePart = DataPart('image/jpeg', imageBytes);

        final response = await _visionModel.generateContent([
          Content.multi([prompt, imagePart]),
        ]);

        return response.text ?? "No text found";
      }

      // Fallback / Mock logic
      await Future.delayed(const Duration(seconds: 2));
      return "This is a simulated OCR result for the desktop application. "
          "It represents text extracted from the webcam feed.";
    } catch (e) {
      debugPrint("OCR Error: $e");
      return "Error reading text";
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
