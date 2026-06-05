import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/gamification_provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Achievements', showBack: true),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Consumer<GamificationProvider>(
          builder: (_, gam, _) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Streak Card
              AnimatedCard(child: Row(children: [
                Container(width: 60, height: 60, decoration: BoxDecoration(gradient: AppColors.streakGradient, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 32)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${gam.currentStreak} Hari Berturut-turut! 🔥', style: AppTypography.headlineSmall),
                  Text('Rekor: ${gam.longestStreak} hari', style: AppTypography.bodySmall),
                ])),
              ])),
              const SizedBox(height: 24),
              Text('Badge & Achievement', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              ...gam.achievements.asMap().entries.map((e) {
                final a = e.value;
                final unlocked = a['unlocked'] as bool;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedCard(
                    delay: e.key * 100,
                    child: Row(children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: unlocked ? AppColors.achievementGold.withValues(alpha: 0.15) : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(unlocked ? Icons.emoji_events_rounded : Icons.lock_rounded, color: unlocked ? AppColors.achievementGold : AppColors.textDisabled, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(a['title'] as String, style: AppTypography.titleSmall.copyWith(color: unlocked ? AppColors.textPrimary : AppColors.textDisabled)),
                        Text(a['description'] as String, style: AppTypography.bodySmall),
                      ])),
                      if (unlocked) const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
                    ]),
                  ),
                );
              }),
            ]),
          ),
        ),
      ),
    );
  }
}
