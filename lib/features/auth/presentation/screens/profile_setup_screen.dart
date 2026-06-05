import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_text_field.dart';
import 'package:provider/provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _calorieCtrl = TextEditingController(text: '2000');
  String _goal = 'maintain';
  final List<String> _selectedAllergens = [];
  final _allergenOptions = ['Kacang', 'Susu', 'Telur', 'Gluten', 'Seafood', 'Kedelai'];
  bool _isSaving = false;

  @override
  void dispose() { _heightCtrl.dispose(); _weightCtrl.dispose(); _calorieCtrl.dispose(); super.dispose(); }

  Future<void> _saveAndContinue() async {
    setState(() => _isSaving = true);
    await context.read<ProfileProvider>().updateProfile(
      height: double.tryParse(_heightCtrl.text),
      weight: double.tryParse(_weightCtrl.text),
      targetCalories: double.tryParse(_calorieCtrl.text),
      dietGoal: _goal,
      allergens: _selectedAllergens,
    );
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 40),
              Text('Setup Profil', style: AppTypography.displaySmall),
              const SizedBox(height: 8),
              Text('Bantu kami mengenalmu lebih baik', style: AppTypography.bodyLarge),
              const SizedBox(height: 32),
              Row(children: [
                Expanded(child: NutriMoveTextField(label: 'Tinggi (cm)', hint: '170', controller: _heightCtrl, prefixIcon: Icons.height_rounded, keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: NutriMoveTextField(label: 'Berat (kg)', hint: '65', controller: _weightCtrl, prefixIcon: Icons.monitor_weight_outlined, keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: 24),
              Text('Target Diet', style: AppTypography.labelMedium),
              const SizedBox(height: 12),
              Row(children: [
                _GoalChip(label: 'Turun', value: 'lose', selected: _goal == 'lose', onTap: () => setState(() => _goal = 'lose')),
                const SizedBox(width: 8),
                _GoalChip(label: 'Jaga', value: 'maintain', selected: _goal == 'maintain', onTap: () => setState(() => _goal = 'maintain')),
                const SizedBox(width: 8),
                _GoalChip(label: 'Naik', value: 'gain', selected: _goal == 'gain', onTap: () => setState(() => _goal = 'gain')),
              ]),
              const SizedBox(height: 24),
              NutriMoveTextField(label: 'Target Kalori Harian', hint: '2000', controller: _calorieCtrl, prefixIcon: Icons.local_fire_department_rounded, keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              Text('Alergi Makanan', style: AppTypography.labelMedium),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: _allergenOptions.map((a) {
                final sel = _selectedAllergens.contains(a);
                return FilterChip(
                  label: Text(a),
                  selected: sel,
                  onSelected: (v) => setState(() { v ? _selectedAllergens.add(a) : _selectedAllergens.remove(a); }),
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                );
              }).toList()),
              const SizedBox(height: 40),
              NutriMoveButton(label: 'Mulai NutriMove', icon: Icons.arrow_forward_rounded, isLoading: _isSaving, onPressed: _saveAndContinue),
              const SizedBox(height: 16),
              Center(child: TextButton(onPressed: () => context.go('/home'), child: Text('Lewati untuk sekarang', style: AppTypography.labelMedium.copyWith(color: AppColors.textTertiary)))),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final String label, value;
  final bool selected;
  final VoidCallback onTap;
  const _GoalChip({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 2 : 1),
          ),
          child: Center(child: Text(label, style: AppTypography.labelLarge.copyWith(color: selected ? AppColors.primary : AppColors.textSecondary))),
        ),
      ),
    );
  }
}
