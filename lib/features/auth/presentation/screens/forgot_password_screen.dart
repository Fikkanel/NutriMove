import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_text_field.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() { _emailCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    final ok = await context.read<AuthProvider>().resetPassword(_emailCtrl.text.trim());
    if (ok && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              IconButton(onPressed: () => context.pop(), icon: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18))),
              const SizedBox(height: 24),
              Text('Reset Password', style: AppTypography.displaySmall),
              const SizedBox(height: 8),
              Text('Masukkan email untuk menerima link reset', style: AppTypography.bodyLarge),
              const SizedBox(height: 32),
              if (_sent) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.success.withValues(alpha: 0.3))),
                  child: Column(children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
                    const SizedBox(height: 16),
                    Text('Email Terkirim!', style: AppTypography.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Cek inbox email kamu untuk reset password.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                  ]),
                ),
                const SizedBox(height: 24),
                NutriMoveButton(label: 'Kembali ke Login', onPressed: () => context.go('/login')),
              ] else ...[
                NutriMoveTextField(label: 'Email', hint: 'contoh@email.com', controller: _emailCtrl, prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(builder: (_, auth, _) => NutriMoveButton(label: 'Kirim Link Reset', isLoading: auth.status == AuthStatus.loading, onPressed: _submit)),
              ],
            ]),
          ),
        ),
      ),
    );
  }
}
