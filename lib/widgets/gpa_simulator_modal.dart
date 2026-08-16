import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import 'risk_badge.dart';

class GPASimulatorModal extends StatefulWidget {
  final double currentAttendance;
  final double currentGpa;

  const GPASimulatorModal({
    super.key,
    this.currentAttendance = 64.0,
    this.currentGpa = 2.4,
  });

  @override
  State<GPASimulatorModal> createState() => _GPASimulatorModalState();
}

class _GPASimulatorModalState extends State<GPASimulatorModal> {
  late double _simulatedAttendance;
  double _targetExamScore = 85.0;
  double _targetAssignmentScore = 90.0;

  @override
  void initState() {
    super.initState();
    _simulatedAttendance = widget.currentAttendance;
  }

  @override
  Widget build(BuildContext context) {
    // Multi-factor equation: 40% exams + 35% assignments + 25% attendance
    final simulatedComposite = (_targetExamScore * 0.40) +
        (_targetAssignmentScore * 0.35) +
        (_simulatedAttendance * 0.25);

    double simulatedGpa = 2.0;
    if (simulatedComposite >= 90) {
      simulatedGpa = 3.9;
    } else if (simulatedComposite >= 80) {
      simulatedGpa = 3.5;
    } else if (simulatedComposite >= 70) {
      simulatedGpa = 3.0;
    } else if (simulatedComposite >= 60) {
      simulatedGpa = 2.5;
    } else {
      simulatedGpa = 1.8;
    }

    RiskLevel simulatedRisk = RiskLevel.low;
    if (_simulatedAttendance < 75.0 || _targetExamScore < 60.0 || simulatedComposite < 50.0) {
      simulatedRisk = RiskLevel.high;
    } else if (simulatedComposite < 70.0) {
      simulatedRisk = RiskLevel.medium;
    }

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
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      Icon(Icons.tune, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '"What-If" GPA & Academic Recovery Simulator',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Simulate Target Performance & Academic Recovery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Adjust upcoming exam targets and attendance goals to preview predicted composite score, projected GPA, and risk level improvement.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Projected Results Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildResultStat(
                          'Projected Composite',
                          '${simulatedComposite.toStringAsFixed(1)}%',
                          AppColors.primary,
                        ),
                        _buildResultStat(
                          'Projected GPA',
                          '${simulatedGpa.toStringAsFixed(2)} / 4.0',
                          AppColors.accent,
                        ),
                        Column(
                          children: [
                            const Text(
                              'Predicted Risk Status',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            RiskBadge(riskLevel: simulatedRisk),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Slider 1: Target Exam Score
                  Text(
                    'Target Midterm / Final Exam Score: ${_targetExamScore.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Slider(
                    value: _targetExamScore,
                    min: 30,
                    max: 100,
                    divisions: 70,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _targetExamScore = val),
                  ),
                  const SizedBox(height: 16),

                  // Slider 2: Target Assignment Average
                  Text(
                    'Target Upcoming Assignment Score: ${_targetAssignmentScore.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Slider(
                    value: _targetAssignmentScore,
                    min: 30,
                    max: 100,
                    divisions: 70,
                    activeColor: AppColors.secondary,
                    onChanged: (val) =>
                        setState(() => _targetAssignmentScore = val),
                  ),
                  const SizedBox(height: 16),

                  // Slider 3: Target Attendance
                  Text(
                    'Target Attendance Rate: ${_simulatedAttendance.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _simulatedAttendance < 75.0
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
                  ),
                  Slider(
                    value: _simulatedAttendance,
                    min: 50,
                    max: 100,
                    divisions: 50,
                    activeColor: _simulatedAttendance < 75.0
                        ? AppColors.error
                        : AppColors.success,
                    onChanged: (val) =>
                        setState(() => _simulatedAttendance = val),
                  ),
                  const SizedBox(height: 16),

                  // AI Strategy Suggestion
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: simulatedRisk == RiskLevel.low
                          ? AppColors.successBg
                          : AppColors.errorBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: simulatedRisk == RiskLevel.low
                            ? AppColors.success.withOpacity(0.4)
                            : AppColors.error.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          simulatedRisk == RiskLevel.low
                              ? Icons.verified
                              : Icons.warning_amber_rounded,
                          color: simulatedRisk == RiskLevel.low
                              ? AppColors.success
                              : AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            simulatedRisk == RiskLevel.low
                                ? 'Target plan successfully recovers academic standing to "On-Track" (Low Risk)! Maintaining >= 75% attendance and >= 80% exam marks will secure accreditation.'
                                : 'Warning: Attendance remains below the mandatory 75% threshold or exam score is deficient. Increase attendance target to at least 75% to clear high-risk flag.',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: simulatedRisk == RiskLevel.low
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFF991B1B),
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildResultStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
