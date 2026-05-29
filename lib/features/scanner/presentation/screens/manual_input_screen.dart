import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_text_field.dart';
import '../providers/scanner_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  bool _isSaving = false;

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
    if (val == null || val.trim().isEmpty) {
      return 'Wajib diisi';
    }
    return null;
  }

  String? _numberValidator(String? val) {
    if (val == null || val.trim().isEmpty) {
      return 'Wajib diisi';
    }
    if (double.tryParse(val.trim()) == null) {
      return 'Harus angka';
    }
    return null;
  }

  Future<void> _saveManual() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final scanner = context.read<ScannerProvider>();
      final dashboard = context.read<DashboardProvider>();
      final gamification = context.read<GamificationProvider>();

      final data = {
        'name': _nameController.text.trim(),
        'calories': double.tryParse(_caloriesController.text.trim()) ?? 0.0,
        'protein': double.tryParse(_proteinController.text.trim()) ?? 0.0,
        'carbs': double.tryParse(_carbsController.text.trim()) ?? 0.0,
        'fat': double.tryParse(_fatController.text.trim()) ?? 0.0,
      };

      await scanner.saveManualMeal(data);
      await gamification.incrementStreak();
      await dashboard.loadDashboardData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Makanan berhasil disimpan!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan makanan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Input Manual', showBack: true),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tambah Makanan', style: AppTypography.headlineMedium),
              const SizedBox(height: 8),
              Text('Masukkan data nutrisi secara manual', style: AppTypography.bodyMedium),
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
                  ),
                ),
              ]),
              const SizedBox(height: 32),
              NutriMoveButton(
                label: _isSaving ? 'Menyimpan...' : 'Simpan',
                icon: Icons.check_rounded,
                onPressed: _isSaving ? () {} : () => _saveManual(),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
