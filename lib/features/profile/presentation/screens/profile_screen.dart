import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

import '../providers/profile_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() { super.initState(); Future.microtask(() { if (mounted) context.read<ProfileProvider>().loadProfile(); }); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Consumer<ProfileProvider>(
            builder: (_, p, _) => SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const SizedBox(height: 10),
                // Avatar
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    gradient: p.photoUrl == null ? AppColors.primaryGradient : null,
                    shape: BoxShape.circle, 
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20)],
                    image: p.photoUrl != null && p.photoUrl!.isNotEmpty
                        ? DecorationImage(image: NetworkImage(p.photoUrl!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: (p.photoUrl == null || p.photoUrl!.isEmpty)
                      ? Center(child: Text(p.displayName.isNotEmpty ? p.displayName[0].toUpperCase() : 'U', style: AppTypography.displayMedium))
                      : null,
                ),
                const SizedBox(height: 16),
                Text(p.displayName, style: AppTypography.headlineLarge),
                Text(p.email, style: AppTypography.bodyMedium),
                const SizedBox(height: 24),
                // Stats
                Row(children: [
                  _StatCard(label: 'BMI', value: p.bmi.toStringAsFixed(1), color: AppColors.primary),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Tinggi', value: '${p.height.toInt()} cm', color: AppColors.secondary),
                  const SizedBox(width: 12),
                  _StatCard(label: 'Berat', value: '${p.weight.toInt()} kg', color: AppColors.tertiary),
                ]),
                const SizedBox(height: 24),
                _MenuItem(icon: Icons.edit_rounded, label: 'Edit Profil', onTap: () => context.push('/profile/edit')),
                _MenuItem(icon: Icons.shield_rounded, label: 'Pengaturan Alergi', onTap: () => context.push('/profile/allergens')),
                _MenuItem(icon: Icons.track_changes_rounded, label: 'Target Diet', onTap: () => context.push('/profile/goals')),
                _MenuItem(icon: Icons.settings_rounded, label: 'Pengaturan', onTap: () => context.push('/settings')),
                const SizedBox(height: 16),
                _MenuItem(icon: Icons.logout_rounded, label: 'Keluar', color: AppColors.error, onTap: () async {
                  await context.read<AuthProvider>().signOut();
                  if (context.mounted) context.go('/login');
                }),
                const SizedBox(height: 60),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.25))),
      child: Column(children: [
        Text(value, style: AppTypography.nutriValue.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.bodySmall),
      ]),
    ));
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Icon(icon, color: color ?? AppColors.textSecondary, size: 22),
              const SizedBox(width: 14),
              Expanded(child: Text(label, style: AppTypography.titleSmall.copyWith(color: color ?? AppColors.textPrimary))),
              Icon(Icons.chevron_right_rounded, color: color ?? AppColors.textTertiary, size: 22),
            ]),
          ),
        ),
      ),
    );
  }
}
