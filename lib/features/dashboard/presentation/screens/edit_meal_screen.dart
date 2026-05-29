import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_text_field.dart';
import '../providers/dashboard_provider.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';

/// Screen for editing or deleting an existing meal entry.
class EditMealScreen extends StatefulWidget {
  final int mealIndex;
  final Map<String, dynamic> mealData;

  const EditMealScreen({super.key, required this.mealIndex, required this.mealData});

  @override
  State<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: (widget.mealData['name'] ?? '').toString());
    _caloriesController = TextEditingController(text: _numToStr(widget.mealData['calories']));
    _proteinController = TextEditingController(text: _numToStr(widget.mealData['protein']));
    _carbsController = TextEditingController(text: _numToStr(widget.mealData['carbs']));
    _fatController = TextEditingController(text: _numToStr(widget.mealData['fat']));
  }

  String _numToStr(dynamic val) {
    if (val == null) return '0';
    if (val is double) return val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
    return val.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? val) {
    if (val == null || val.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  String? _numberValidator(String? val) {
    if (val == null || val.trim().isEmpty) return 'Wajib diisi';
    if (double.tryParse(val.trim()) == null) return 'Harus angka';
    return null;
  }

  String _calculateGrade(double cal, double pro, double fat, double carb) {
    final proteinScore = (pro / 50.0).clamp(0.0, 1.0) * 40;
    final calScore = cal < 500 ? 20 : (cal < 800 ? 10 : 0);
    final fatScore = fat < 15 ? 20 : (fat < 30 ? 10 : 0);
    final carbScore = carb < 60 ? 20 : (carb < 100 ? 10 : 0);
    final score = proteinScore + calScore + fatScore + carbScore;
    if (score >= 80) return 'A';
    if (score >= 60) return 'B';
    if (score >= 40) return 'C';
    return 'D';
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final dashboard = context.read<DashboardProvider>();

      final cal = double.tryParse(_caloriesController.text.trim()) ?? 0;
      final pro = double.tryParse(_proteinController.text.trim()) ?? 0;
      final carb = double.tryParse(_carbsController.text.trim()) ?? 0;
      final fat = double.tryParse(_fatController.text.trim()) ?? 0;

      final updatedMeal = {
        'name': _nameController.text.trim(),
        'calories': cal,
        'protein': pro,
        'carbs': carb,
        'fat': fat,
        'grade': _calculateGrade(cal, pro, fat, carb),
      };

      await dashboard.updateMeal(widget.mealIndex, updatedMeal);

      if (mounted) {
        context.read<GamificationProvider>().loadStreakData();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil diperbarui!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteMeal() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Makanan?', style: AppTypography.headlineSmall),
        content: Text(
          'Data "${_nameController.text}" akan dihapus dari log hari ini.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: AppTypography.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Hapus', style: AppTypography.labelLarge.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isSaving = true);

    try {
      final dashboard = context.read<DashboardProvider>();
      await dashboard.deleteMeal(widget.mealIndex);

      if (mounted) {
        context.read<GamificationProvider>().loadStreakData();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil dihapus!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentGrade = _calculateGrade(
      double.tryParse(_caloriesController.text) ?? 0,
      double.tryParse(_proteinController.text) ?? 0,
      double.tryParse(_fatController.text) ?? 0,
      double.tryParse(_carbsController.text) ?? 0,
    );
    final gradeColor = _getGradeColor(currentGrade);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Makanan', showBack: true),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Grade Preview
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: gradeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gradeColor.withValues(alpha: 0.4), width: 2),
                  ),
                  child: Center(
                    child: Text(currentGrade, style: AppTypography.displaySmall.copyWith(color: gradeColor)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Grade Nutrisi', style: AppTypography.bodySmall),
              ),
              const SizedBox(height: 24),

              NutriMoveTextField(
                label: 'Nama Makanan',
                hint: 'Contoh: Nasi Goreng',
                prefixIcon: Icons.restaurant_rounded,
                controller: _nameController,
                validator: _requiredValidator,
                enabled: !_isSaving,
              ),
              const SizedBox(height: 16),
              NutriMoveTextField(
                label: 'Kalori (kcal)',
                hint: '0',
                prefixIcon: Icons.local_fire_department_rounded,
                keyboardType: TextInputType.number,
                controller: _caloriesController,
                validator: _numberValidator,
                enabled: !_isSaving,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: NutriMoveTextField(
                    label: 'Protein (g)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    controller: _proteinController,
                    validator: _numberValidator,
                    enabled: !_isSaving,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NutriMoveTextField(
                    label: 'Karbo (g)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    controller: _carbsController,
                    validator: _numberValidator,
                    enabled: !_isSaving,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NutriMoveTextField(
                    label: 'Lemak (g)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    controller: _fatController,
                    validator: _numberValidator,
                    enabled: !_isSaving,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ]),
              const SizedBox(height: 32),
              NutriMoveButton(
                label: _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                icon: Icons.check_rounded,
                onPressed: _isSaving ? () {} : _saveChanges,
              ),
              const SizedBox(height: 12),
              NutriMoveButton(
                label: 'Hapus Makanan',
                icon: Icons.delete_outline_rounded,
                type: ButtonType.outline,
                onPressed: _isSaving ? () {} : _deleteMeal,
              ),
            ]),
          ),
        ),
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
