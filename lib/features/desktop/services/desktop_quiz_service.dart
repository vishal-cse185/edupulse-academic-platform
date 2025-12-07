import 'package:flutter/foundation.dart';
import '../../../services/llm_service.dart';
import 'desktop_teacher_work_service.dart';

class DesktopQuizService extends ChangeNotifier {
  final LLMService? _llmService;
  final DesktopTeacherWorkService? _workService;

  bool _isQuizActive = false;
  List<String> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = false;

  DesktopQuizService([this._llmService, this._workService]);

  bool get isQuizActive => _isQuizActive;
  int get score => _score;
  bool get isLoading => _isLoading;

  Future<String> startQuiz() async {
    if (_llmService == null || _workService == null) {
      return "Quiz service not fully initialized.";
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Get context from assignments
      final assignments = _workService.assignments;
      String context = "General Knowledge";
      if (assignments.isNotEmpty) {
        context = assignments
            .map((a) => "${a.title}: ${a.description}")
            .join("; ");
      }

      // Generate questions using LLM
      _questions = await _llmService.generateQuizQuestions(context);

      if (_questions.isEmpty) {
        return "Could not generate quiz questions. Please try again.";
      }

      _isQuizActive = true;
      _currentQuestionIndex = 0;
      _score = 0;

      return "Quiz starting. Question 1: ${_questions[0]}";
    } catch (e) {
      return "Failed to start quiz.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String submitAnswer(String answer) {
    if (!_isQuizActive) return "No quiz active.";

    // Simple verification (since we don't have ground truth from LLM in this simple mode)
    // We just accept any answer and move on, or we could ask LLM to verify.
    // For this prototype, we'll just acknowledge and move to next.

    _currentQuestionIndex++;
    if (_currentQuestionIndex >= _questions.length) {
      stopQuiz();
      return "Quiz complete! You answered all questions.";
    }

    return "Next question: ${_questions[_currentQuestionIndex]}";
  }

  // Placeholder for now, will implement fully after updating LLMService
  void stopQuiz() {
    _isQuizActive = false;
    _questions = [];
    _currentQuestionIndex = 0;
    _score = 0;
    notifyListeners();
  }
}
