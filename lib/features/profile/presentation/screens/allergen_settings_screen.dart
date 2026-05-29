import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/nutrimove_text_field.dart';
import '../providers/profile_provider.dart';

class AllergenSettingsScreen extends StatefulWidget {
  const AllergenSettingsScreen({super.key});

  @override
  State<AllergenSettingsScreen> createState() => _AllergenSettingsScreenState();
}

class _AllergenSettingsScreenState extends State<AllergenSettingsScreen> {
  final _ctrl = TextEditingController();
  List<String> _allergens = [];

  @override
  void initState() {
    super.initState();
    _allergens = List.from(context.read<ProfileProvider>().allergens);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _saveAllergens() async {
    await context.read<ProfileProvider>().updateProfile(allergens: _allergens);
  }

  void _addAllergen() {
    final text = _ctrl.text.trim();
    if (text.isNotEmpty && !_allergens.contains(text)) {
      setState(() {
        _allergens.add(text);
        _ctrl.clear();
      });
      _saveAllergens();
    }
  }

  void _removeAllergen(String allergen) {
    setState(() {
      _allergens.remove(allergen);
    });
    _saveAllergens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pengaturan Alergi', showBack: true),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tambahkan alergi makanan Anda agar NutriMove dapat memberikan peringatan pada produk makanan.', style: AppTypography.bodyMedium),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: NutriMoveTextField(
                        label: 'Bahan Makanan',
                        hint: 'Kacang, Susu, Seafood...',
                        controller: _ctrl,
                        onFieldSubmitted: (_) => _addAllergen(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add_rounded, color: Colors.white),
                          onPressed: _addAllergen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allergens.map((a) => Chip(
                    label: Text(a, style: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary)),
                    backgroundColor: AppColors.surfaceCard,
                    deleteIconColor: AppColors.error,
                    onDeleted: () => _removeAllergen(a),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
