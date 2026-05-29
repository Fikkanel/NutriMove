import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Achievement badge widget with locked/unlocked states and progress.
class AchievementBadgeWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool unlocked;
  final double progress;
  const AchievementBadgeWidget({super.key, required this.title, required this.description, this.unlocked = false, this.progress = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.achievementGold.withValues(alpha: 0.1) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: unlocked ? AppColors.achievementGold.withValues(alpha: 0.4) : AppColors.border),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(unlocked ? Icons.emoji_events_rounded : Icons.lock_rounded, size: 32, color: unlocked ? AppColors.achievementGold : AppColors.textDisabled),
        const SizedBox(height: 8),
        Text(title, style: AppTypography.labelSmall.copyWith(color: unlocked ? AppColors.textPrimary : AppColors.textDisabled), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
        if (!unlocked && progress > 0) ...[
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: progress, minHeight: 4, backgroundColor: AppColors.border, color: AppColors.achievementGold)),
        ],
      ]),
    );
  }
}
