import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/ai_insight_model.dart';
import 'risk_badge.dart';

class AIInsightCard extends StatelessWidget {
  final AIInsightModel insight;
  final VoidCallback? onViewDetails;

  const AIInsightCard({
    super.key,
    required this.insight,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E7FF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner with AI Gradient
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              gradient: AppColors.aiGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Academic Intelligence Diagnostics',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                RiskBadge(riskLevel: insight.riskLevel),
              ],
            ),
          ),

          // Body Content
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Composite Summary
                Text(
                  insight.executiveSummary,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textPrimary,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Metrics Row
                Row(
                  children: [
                    _buildMetricPill(
                      label: 'Composite Score',
                      value: '${insight.overallScore.toStringAsFixed(1)}%',
                      icon: Icons.speed,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricPill(
                      label: 'Attendance',
                      value: '${insight.attendanceRate.toStringAsFixed(1)}%',
                      icon: Icons.calendar_today,
                      color: insight.attendanceRate < 75.0
                          ? AppColors.error
                          : AppColors.success,
                    ),
                    const SizedBox(width: 12),
                    _buildMetricPill(
                      label: 'Trend',
                      value: insight.trend.toUpperCase(),
                      icon: insight.trend == 'declining'
                          ? Icons.trending_down
                          : Icons.trending_up,
                      color: insight.trend == 'declining'
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ],
                ),

                if (insight.weakSubjects.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Identified Focus Areas / Weak Concepts:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: insight.weakSubjects.map((sub) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: const Color(0xFFFCA5A5), width: 1),
                        ),
                        child: Text(
                          '${sub.subjectName} (${sub.averageScore.toStringAsFixed(0)}%)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                if (insight.recommendations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Top AI Study Recommendations:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...insight.recommendations.take(2).map((rec) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.bolt,
                              size: 18, color: Color(0xFF6366F1)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: '${rec.title}: ',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                children: [
                                  TextSpan(
                                    text: rec.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                if (onViewDetails != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onViewDetails,
                      icon: const Text('View Full AI Diagnostic Plan',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      label: const Icon(Icons.arrow_forward, size: 16),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
