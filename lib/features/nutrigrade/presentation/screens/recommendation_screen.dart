import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/recommendation_provider.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final profile = context.read<ProfileProvider>();
        profile.loadProfile().then((_) {
          if (mounted) {
            final goal = profile.dietGoal;
            context.read<RecommendationProvider>().loadRecommendations(goal);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Rekomendasi Menu', showBack: true),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Consumer<RecommendationProvider>(
          builder: (_, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('AI sedang menyusun rekomendasi...', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            final items = provider.recommendations;
            if (items.isEmpty) {
              return const Center(child: Text('Gagal memuat rekomendasi', style: TextStyle(color: AppColors.textSecondary)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final grade = items[i]['grade']?.toString() ?? 'A';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedCard(
                    delay: i * 100,
                    onTap: () => _showMenuDetail(context, items[i]),
                    child: Row(children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: _getGradeColor(grade).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            grade,
                            style: AppTypography.titleLarge.copyWith(color: _getGradeColor(grade)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${items[i]['name']}', style: AppTypography.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          '${items[i]['desc']}',
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ])),
                      const SizedBox(width: 8),
                      Text('${items[i]['cal']} kcal', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showMenuDetail(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _buildBottomDrawer(ctx, item),
    );
  }

  Widget _buildBottomDrawer(BuildContext context, Map<String, dynamic> item) {
    final grade = item['grade']?.toString() ?? 'A';
    final gradeColor = _getGradeColor(grade);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle Indicator
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Header Row: Grade & Calories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: gradeColor.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    grade,
                    style: AppTypography.headlineMedium.copyWith(color: gradeColor),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${item['cal']} kcal',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Food Name
          Text(
            '${item['name']}',
            style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Divider
          Container(
            height: 1,
            color: AppColors.border,
          ),
          const SizedBox(height: 16),

          // Explanation Header
          Text(
            'Info & Analisis Nutrisi AI:',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 8),

          // Detailed Explanation
          Text(
            '${item['detail'] ?? item['desc']}',
            style: AppTypography.bodyMedium.copyWith(height: 1.5, fontSize: 15),
          ),
          const SizedBox(height: 32),

          // Tutup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return AppColors.gradeA;
      case 'B': return AppColors.gradeB;
      case 'C': return AppColors.gradeC;
      default: return AppColors.gradeD;
    }
  }
}
