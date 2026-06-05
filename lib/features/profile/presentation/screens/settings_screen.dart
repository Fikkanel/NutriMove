import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pengaturan', showBack: true),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Preferensi Aplikasi', style: AppTypography.titleMedium),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text('Notifikasi Pengingat', style: AppTypography.bodyLarge),
                subtitle: Text('Ingatkan saya untuk mencatat makanan', style: AppTypography.bodySmall),
                value: _notifEnabled,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _notifEnabled = v),
              ),
              const SizedBox(height: 32),
              Text('Tentang', style: AppTypography.titleMedium),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Versi Aplikasi', style: AppTypography.bodyLarge),
                trailing: Text('1.0.0', style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary)),
              ),
              ListTile(
                title: Text('Syarat & Ketentuan', style: AppTypography.bodyLarge),
                trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                onTap: () {},
              ),
              ListTile(
                title: Text('Kebijakan Privasi', style: AppTypography.bodyLarge),
                trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
