import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../providers/dashboard_provider.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<DashboardProvider>().loadDashboardData();
        context.read<GamificationProvider>().loadStreakData();
        context.read<ProfileProvider>().loadProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Consumer3<DashboardProvider, GamificationProvider, ProfileProvider>(
            builder: (_, dash, gam, prof, _) {
              if (dash.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Halo, ${prof.displayName.isNotEmpty ? prof.displayName.split(" ")[0] : "User"}! 👋', style: AppTypography.bodyLarge),
                      Text('Dashboard', style: AppTypography.headlineLarge),
                    ]),
                    GestureDetector(
                      onTap: () => context.push('/achievements'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(gradient: AppColors.streakGradient, borderRadius: BorderRadius.circular(30)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 4),
                          Text('${gam.currentStreak}', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
                        ]),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  // Calorie Card
                  AnimatedCard(
                    delay: 100,
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Kalori Hari Ini', style: AppTypography.titleMedium),
                        TextButton(onPressed: () => context.push('/reports'), child: const Text('Lihat Laporan')),
                      ]),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 140,
                        child: Stack(alignment: Alignment.center, children: [
                          SizedBox(
                            width: 130, height: 130,
                            child: CircularProgressIndicator(
                              value: dash.calorieProgress.clamp(0, 1),
                              strokeWidth: 10,
                              backgroundColor: AppColors.surfaceLight,
                              color: dash.calorieProgress > 1 ? AppColors.error : AppColors.primary,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Column(mainAxisSize: MainAxisSize.min, children: [
                            Text('${dash.caloriesConsumed.toInt()}', style: AppTypography.calorieCount),
                            Text('/ ${dash.calorieTarget.toInt()} kcal', style: AppTypography.bodySmall),
                          ]),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      // Macros
                      Row(children: [
                        _MacroItem(label: 'Protein', value: '${dash.protein.toInt()}g', color: AppColors.secondary, progress: dash.protein / 50),
                        const SizedBox(width: 12),
                        _MacroItem(label: 'Karbo', value: '${dash.carbs.toInt()}g', color: AppColors.primary, progress: dash.carbs / 250),
                        const SizedBox(width: 12),
                        _MacroItem(label: 'Lemak', value: '${dash.fat.toInt()}g', color: AppColors.tertiary, progress: dash.fat / 65),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  // Quick Actions
                  Row(children: [
                    Expanded(child: _QuickAction(icon: Icons.camera_alt_rounded, label: 'Scan', color: AppColors.primary, onTap: () => context.go('/scan'))),
                    const SizedBox(width: 12),
                    Expanded(child: _QuickAction(icon: Icons.edit_note_rounded, label: 'Manual', color: AppColors.secondary, onTap: () => context.push('/scan/manual'))),
                    const SizedBox(width: 12),
                    Expanded(child: _QuickAction(icon: Icons.recommend_rounded, label: 'Rekomendasi', color: AppColors.tertiary, onTap: () => context.push('/recommendations'))),
                  ]),
                  const SizedBox(height: 24),
                  // Today Meals
                  Text('Makanan Hari Ini', style: AppTypography.titleMedium),
                  const SizedBox(height: 12),
                  ...dash.todayMeals.asMap().entries.map((e) {
                    final grade = (e.value['grade'] ?? 'B').toString();
                    final name = (e.value['name'] ?? 'Makanan').toString();
                    final calories = (e.value['calories'] ?? 0);
                    
                    String time = '';
                    final dynamic ts = e.value['timestamp'];
                    if (ts is Timestamp) {
                      time = DateFormat('HH:mm').format(ts.toDate());
                    } else if (ts is String) {
                      try {
                        time = DateFormat('HH:mm').format(DateTime.parse(ts));
                      } catch (_) {}
                    }
                    
                    return AnimatedCard(
                      onTap: () => context.push('/meal/edit', extra: {
                        'index': e.key,
                        'meal': Map<String, dynamic>.from(e.value),
                      }),
                      delay: 200 + (e.key * 80),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(color: _gradeColor(grade).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text(grade, style: AppTypography.titleMedium.copyWith(color: _gradeColor(grade)))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(name, style: AppTypography.titleSmall),
                          if (time.isNotEmpty) Text(time, style: AppTypography.bodySmall),
                        ])),
                        Text('${calories is num ? calories.toInt() : calories} kcal', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
                      ]),
                    );
                  }),
                  const SizedBox(height: 100),
                ]),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'A': return AppColors.gradeA;
      case 'B': return AppColors.gradeB;
      case 'C': return AppColors.gradeC;
      default: return AppColors.gradeD;
    }
  }
}

class _MacroItem extends StatelessWidget {
  final String label, value;
  final Color color;
  final double progress;
  const _MacroItem({required this.label, required this.value, required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Text(value, style: AppTypography.nutriValue.copyWith(color: color)),
      const SizedBox(height: 4),
      Text(label, style: AppTypography.bodySmall),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress.clamp(0, 1), backgroundColor: AppColors.surfaceLight, color: color, minHeight: 6)),
    ]));
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.25))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.labelSmall.copyWith(color: color)),
        ]),
      ),
    );
  }
}
