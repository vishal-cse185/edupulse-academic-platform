import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';

class AIStudyTutorModal extends StatefulWidget {
  final String? initialSubject;

  const AIStudyTutorModal({super.key, this.initialSubject});

  @override
  State<AIStudyTutorModal> createState() => _AIStudyTutorModalState();
}

class _AIStudyTutorModalState extends State<AIStudyTutorModal> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text':
          'Hello! I am your EduPulse 24/7 AI Socratic Academic Tutor. I can explain complex concepts, debug algorithms, or generate practice quizzes for your enrolled courses. What topic would you like to review today?',
      'time': 'Just now',
    },
  ];

  bool _isTyping = false;

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? presetText]) {
    final text = presetText ?? _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'time': 'Just now',
      });
      _isTyping = true;
    });

    if (presetText == null) _msgController.clear();
    _scrollToBottom();

    // Socratic AI response generator
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      String aiReply = '';
      final lower = text.toLowerCase();

      if (lower.contains('red-black') || lower.contains('tree') || lower.contains('rotation')) {
        aiReply =
            '🌲 **Red-Black Tree Invariants & Rotations**:\n\n1. **Root & Leaves**: Root is always Black; null NIL leaves are Black.\n2. **Red Property**: If a node is Red, both children MUST be Black (no adjacent red nodes).\n3. **Black-Height**: Every simple path from a node to descendant leaves contains the same number of Black nodes.\n\n💡 **Rotation Tip**: When inserting a right-heavy child on a right child, perform a **Left Rotation** on the parent and recolor the parent Black and grandparent Red.';
      } else if (lower.contains('svd') || lower.contains('singular') || lower.contains('matrix')) {
        aiReply =
            '📐 **Singular Value Decomposition (SVD)**:\n\nAny real matrix A in R^(m x n) can be factored as:\nA = U * Sigma * V^T\n\n• U: Left singular vectors (orthonormal eigenvectors of A*A^T)\n• Sigma: Diagonal singular values (square roots of eigenvalues)\n• V^T: Right singular vectors (transposed eigenvectors of A^T*A)\n\n🎯 Would you like a 3D projection example or a practice proof?';
      } else if (lower.contains('backprop') || lower.contains('neural') || lower.contains('gradient')) {
        aiReply =
            '🧠 **Backpropagation & Gradient Flow**:\n\nBackpropagation applies the multivariate **Chain Rule** across computational graph layers:\ndL/dW[l] = dL/dZ[l] * (A[l-1])^T\n\n⚠️ **Common Trap**: Watch out for vanishing gradients when using Sigmoid/Tanh activations over deep layers. Prefer **ReLU / LeakyReLU** with He initialization.';
      } else if (lower.contains('quiz') || lower.contains('practice')) {
        aiReply =
            '📝 **Quick Diagnostic Quiz (Algorithms)**:\n\n**Question**: What is the worst-case time complexity of searching in an AVL Tree with N elements?\n\nA) O(1)\nB) O(log N)\nC) O(N)\nD) O(N log N)\n\n*Type your answer (A, B, C, or D) to check!*';
      } else if (lower == 'b' || lower.contains('o(log n)')) {
        aiReply =
            '🎉 **Correct!** Because AVL trees maintain a strict balance factor of <= 1, the height is strictly bounded by ~1.44 log2(N), guaranteeing O(log N) worst-case lookup!';
      } else {
        aiReply =
            '💡 **AI Diagnostic Insight**: To master this topic, review the core definitions in Module 2 slides, implement the standard algorithm in your IDE, and verify boundary conditions with unit tests. Would you like a step-by-step breakdown?';
      }

      setState(() {
        _isTyping = false;
        _messages.add({
          'isUser': false,
          'text': aiReply,
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              gradient: AppColors.aiGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EduPulse 24/7 AI Socratic Tutor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Interactive concept explanations & remedial practice',
                          style: TextStyle(
                            color: Color(0xFFE0E7FF),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Preset Topic Quick Prompts
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF8FAFC),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPromptPill(
                      '🌲 Explain Red-Black Trees', 'Explain Red-Black tree rotations and invariants'),
                  _buildPromptPill(
                      '📐 Derive SVD Matrix Math', 'How does Singular Value Decomposition work?'),
                  _buildPromptPill(
                      '🧠 Backpropagation Flow', 'Explain gradient flow in backpropagation'),
                  _buildPromptPill(
                      '📝 Take Practice Quiz', 'Give me a practice quiz question on algorithms'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Chat Messages View
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primary
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight:
                            isUser ? const Radius.circular(0) : null,
                        bottomLeft:
                            !isUser ? const Radius.circular(0) : null,
                      ),
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isUser ? Colors.white : AppColors.textPrimary,
                        height: 1.45,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Row(
                children: const [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'AI Tutor is formulating explanation...',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText:
                          'Ask anything (e.g., "Explain Dijkstra algorithm with pseudo-code")...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _sendMessage(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.send_rounded, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptPill(String label, String prompt) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _sendMessage(prompt),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
