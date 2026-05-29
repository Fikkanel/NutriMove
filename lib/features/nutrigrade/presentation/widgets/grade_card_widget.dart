import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Visual grade card showing NutriGrade A-D with color coding.
class GradeCardWidget extends StatelessWidget {
  final String grade;
  final double score;
  final String foodName;
  const GradeCardWidget({super.key, required this.grade, required this.score, this.foodName = ''});

  Color get _color {
    switch (grade) {
      case 'A': return AppColors.gradeA;
      case 'B': return AppColors.gradeB;
      case 'C': return AppColors.gradeC;
      default: return AppColors.gradeD;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(grade, style: AppTypography.gradeLabel.copyWith(color: _color)),
        const SizedBox(height: 4),
        Text('NutriGrade', style: AppTypography.labelMedium),
        if (foodName.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(foodName, style: AppTypography.titleSmall, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 8),
        Text('Score: ${score.toStringAsFixed(0)}', style: AppTypography.bodySmall.copyWith(color: _color)),
      ]),
    );
  }
}
