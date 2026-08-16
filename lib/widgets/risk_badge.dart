import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';

class RiskBadge extends StatelessWidget {
  final RiskLevel riskLevel;
  final bool showLabel;

  const RiskBadge({
    super.key,
    required this.riskLevel,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    switch (riskLevel) {
      case RiskLevel.high:
        bgColor = AppColors.errorBg;
        textColor = AppColors.riskHigh;
        icon = Icons.warning_rounded;
        text = 'High Risk';
        break;
      case RiskLevel.medium:
        bgColor = AppColors.warningBg;
        textColor = AppColors.riskMedium;
        icon = Icons.info_outline_rounded;
        text = 'Moderate Risk';
        break;
      case RiskLevel.low:
        bgColor = AppColors.successBg;
        textColor = AppColors.riskLow;
        icon = Icons.check_circle_outline_rounded;
        text = 'On Track (Low Risk)';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
