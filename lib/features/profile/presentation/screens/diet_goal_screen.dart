// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_snackbar.dart';
import '../providers/profile_provider.dart';

class DietGoalScreen extends StatefulWidget {
  const DietGoalScreen({super.key});

  @override
  State<DietGoalScreen> createState() => _DietGoalScreenState();
}

class _DietGoalScreenState extends State<DietGoalScreen> {
  String _selectedGoal = 'maintain';
  double _targetCal = 2000;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final prof = context.read<ProfileProvider>();
    _selectedGoal = prof.dietGoal.isEmpty ? 'maintain' : prof.dietGoal;
    _targetCal = prof.targetCalories;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await context.read<ProfileProvider>().updateProfile(
      dietGoal: _selectedGoal,
      targetCalories: _targetCal,
    );
    if (mounted) {
      setState(() => _isSaving = false);
      NutriMoveSnackbar.show(
        context,
        message: 'Target Diet berhasil diperbarui!',
        type: SnackbarType.success,
        title: 'Tersimpan',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Target Diet', showBack: true),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pilih Tujuan Diet Anda', style: AppTypography.titleLarge),
                const SizedBox(height: 16),
                _GoalOption(
                  title: 'Turunkan Berat Badan',
                  value: 'lose',
                  groupValue: _selectedGoal,
                  onChanged: (v) => setState(() => _selectedGoal = v!),
                ),
                _GoalOption(
                  title: 'Pertahankan Berat Badan',
                  value: 'maintain',
                  groupValue: _selectedGoal,
                  onChanged: (v) => setState(() => _selectedGoal = v!),
                ),
                _GoalOption(
                  title: 'Naikkan Berat Badan',
                  value: 'gain',
                  groupValue: _selectedGoal,
                  onChanged: (v) => setState(() => _selectedGoal = v!),
                ),
                const SizedBox(height: 32),
                Text('Target Kalori Harian: ${_targetCal.toInt()} kcal', style: AppTypography.titleLarge),
                Slider(
                  value: _targetCal,
                  min: 1000,
                  max: 4000,
                  divisions: 30,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _targetCal = v),
                ),
                const Spacer(),
                NutriMoveButton(
                  label: 'Simpan Perubahan',
                  isLoading: _isSaving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final String title, value, groupValue;
  final ValueChanged<String?> onChanged;

  const _GoalOption({required this.title, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceCard,
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
            Expanded(child: Text(title, style: AppTypography.titleSmall.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary))),
          ],
        ),
      ),
    );
  }
}
