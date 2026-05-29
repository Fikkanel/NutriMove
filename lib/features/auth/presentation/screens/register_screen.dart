import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) context.go('/profile-setup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Buat Akun Baru', style: AppTypography.displaySmall),
                const SizedBox(height: 8),
                Text('Daftar untuk mulai perjalanan sehatmu', style: AppTypography.bodyLarge),
                const SizedBox(height: 32),
                NutriMoveTextField(label: 'Nama Lengkap', hint: 'Masukkan nama', controller: _nameCtrl, prefixIcon: Icons.person_outlined, validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null),
                const SizedBox(height: 20),
                NutriMoveTextField(label: 'Email', hint: 'contoh@email.com', controller: _emailCtrl, prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) { if (v == null || v.isEmpty) return 'Wajib diisi'; if (!v.contains('@')) return 'Email tidak valid'; return null; }),
                const SizedBox(height: 20),
                NutriMoveTextField(label: 'Password', hint: 'Minimal 6 karakter', controller: _passCtrl, prefixIcon: Icons.lock_outlined, obscureText: _obscure1, suffixIcon: IconButton(icon: Icon(_obscure1 ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textTertiary), onPressed: () => setState(() => _obscure1 = !_obscure1)), validator: (v) { if (v == null || v.isEmpty) return 'Wajib diisi'; if (v.length < 6) return 'Minimal 6 karakter'; return null; }),
                const SizedBox(height: 20),
                NutriMoveTextField(label: 'Konfirmasi Password', hint: 'Ulangi password', controller: _confirmCtrl, prefixIcon: Icons.lock_outlined, obscureText: _obscure2, suffixIcon: IconButton(icon: Icon(_obscure2 ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: AppColors.textTertiary), onPressed: () => setState(() => _obscure2 = !_obscure2)), validator: (v) => v != _passCtrl.text ? 'Password tidak cocok' : null),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(builder: (_, auth, _) => NutriMoveButton(label: 'Daftar', isLoading: auth.status == AuthStatus.loading, onPressed: _submit)),
                const SizedBox(height: 24),
                Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('Sudah punya akun? ', style: AppTypography.bodyMedium),
                  GestureDetector(onTap: () => context.pop(), child: Text('Masuk', style: AppTypography.labelLarge.copyWith(color: AppColors.primary))),
                ])),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Atau daftar dengan', style: AppTypography.bodySmall),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: AppColors.border),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () async {
                        final auth = context.read<AuthProvider>();
                        final success = await auth.signInWithGoogle();
                        if (!context.mounted) return;
                        if (success) {
                          if (auth.isNewUser) {
                            context.go('/profile-setup');
                          } else {
                            context.go('/home');
                          }
                        }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/google_logo.png', width: 24, height: 24),
                        const SizedBox(width: 12),
                        Text('Daftar dengan Google', style: AppTypography.labelLarge.copyWith(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
