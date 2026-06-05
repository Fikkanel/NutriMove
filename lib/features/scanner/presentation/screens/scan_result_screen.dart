import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/nutrimove_button.dart';
import '../../../../shared/widgets/nutrimove_snackbar.dart';
import '../../presentation/providers/scanner_provider.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';

class ScanResultScreen extends StatefulWidget {
  const ScanResultScreen({super.key});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  bool _isSaving = false;
  late TextEditingController _autocompleteController;
  late FocusNode _autocompleteFocusNode;

  @override
  void initState() {
    super.initState();
    final initialName = context.read<ScannerProvider>().scanResult?['foodName'] ?? '';
    _autocompleteController = TextEditingController(text: initialName);
    _autocompleteFocusNode = FocusNode();
    _autocompleteController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _autocompleteController.removeListener(_onTextChanged);
    _autocompleteController.dispose();
    _autocompleteFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _autocompleteController.text;
    context.read<ScannerProvider>().updateScannedFoodName(text);
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return AppColors.gradeA;
      case 'B':
        return AppColors.gradeB;
      case 'C':
        return AppColors.gradeC;
      case 'D':
        return AppColors.gradeD;
      default:
        return AppColors.primary;
    }
  }

  // Menyimpan makanan hasil identifikasi kamera AI ke dalam log harian di database
  Future<void> _saveMeal() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final scanner = context.read<ScannerProvider>();
      final dashboard = context.read<DashboardProvider>();
      final gamification = context.read<GamificationProvider>();

      scanner.updateScannedFoodName(_autocompleteController.text);

      await scanner.saveScannedMeal();
      await gamification.incrementStreak();
      await dashboard.loadDashboardData();

      if (!mounted) return;
      scanner.reset();
      NutriMoveSnackbar.show(
        context,
        message: 'Makanan berhasil disimpan ke log!',
        type: SnackbarType.success,
        title: 'Tersimpan',
      );
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      NutriMoveSnackbar.show(
        context,
        message: 'Gagal menyimpan makanan: $e',
        type: SnackbarType.error,
        title: 'Penyimpanan Gagal',
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
    final scannerProvider = context.watch<ScannerProvider>();
    final scanResult = scannerProvider.scanResult;

    if (scanResult == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Hasil Scan', showBack: true),
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
          child: const Center(
            child: Text('Tidak ada data hasil scan.'),
          ),
        ),
      );
    }

    final String grade = scanResult['grade'] ?? 'B';
    final double calories = (scanResult['calories'] ?? 0).toDouble();
    final double protein = (scanResult['protein'] ?? 0).toDouble();
    final double carbs = (scanResult['carbs'] ?? 0).toDouble();
    final double fat = (scanResult['fat'] ?? 0).toDouble();
    final Color gradeColor = _getGradeColor(grade);
    final double portionMultiplier = scannerProvider.portionMultiplier;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Hasil Scan', showBack: true),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(children: [
                            Autocomplete<String>(
                              textEditingController: _autocompleteController,
                              focusNode: _autocompleteFocusNode,
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                final list = context.read<ScannerProvider>().getLocalFoodNames();
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                final query = textEditingValue.text.toLowerCase();
                                return list.where((String option) {
                                  return option.toLowerCase().contains(query);
                                }).take(15);
                              },
                              onSelected: (String selection) {
                                context.read<ScannerProvider>().updateScannedFoodName(selection);
                              },
                              optionsViewBuilder: (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.surfaceCard,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 88,
                                      constraints: const BoxConstraints(maxHeight: 200),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.border),
                                        itemBuilder: (BuildContext context, int index) {
                                          final String option = options.elementAt(index);
                                          return InkWell(
                                            onTap: () => onSelected(option),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              child: Text(
                                                option,
                                                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onSubmitted: (val) {
                                    onFieldSubmitted();
                                    context.read<ScannerProvider>().updateScannedFoodName(val);
                                  },
                                  style: AppTypography.headlineLarge.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Ketik nama makanan...',
                                    hintStyle: AppTypography.headlineLarge.copyWith(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                                    suffixIcon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 22),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: gradeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Grade $grade', style: AppTypography.labelLarge.copyWith(color: gradeColor)),
                            ),
                            const SizedBox(height: 24),
                            _NutriRow(label: 'Kalori', value: '${calories.toStringAsFixed(0)} kcal', color: AppColors.primary),
                            _NutriRow(label: 'Protein', value: '${protein.toStringAsFixed(1)}g', color: AppColors.secondary),
                            _NutriRow(label: 'Karbohidrat', value: '${carbs.toStringAsFixed(1)}g', color: AppColors.gradeB),
                            _NutriRow(label: 'Lemak', value: '${fat.toStringAsFixed(1)}g', color: AppColors.tertiary),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Jumlah Porsi', style: AppTypography.titleSmall),
                                  Text(
                                    '${portionMultiplier.toStringAsFixed(2)}x Porsi',
                                    style: AppTypography.titleSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.primary,
                                  inactiveTrackColor: AppColors.border,
                                  thumbColor: AppColors.primary,
                                  overlayColor: AppColors.primary.withValues(alpha: 0.2),
                                  valueIndicatorColor: AppColors.primary,
                                  valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                                ),
                                child: Slider(
                                  value: portionMultiplier,
                                  min: 0.25,
                                  max: 3.0,
                                  divisions: 11, // 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.25, 2.5, 2.75, 3.0
                                  label: '${portionMultiplier.toStringAsFixed(2)}x',
                                  onChanged: (val) {
                                    context.read<ScannerProvider>().updateScannedFoodName(_autocompleteController.text);
                                    context.read<ScannerProvider>().updatePortion(val);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                NutriMoveButton(
                  label: _isSaving ? 'Menyimpan...' : 'Simpan ke Log',
                  icon: Icons.check_rounded,
                  onPressed: _isSaving ? () {} : () => _saveMeal(),
                ),
                const SizedBox(height: 12),
                NutriMoveButton(
                  label: 'Scan Ulang',
                  type: ButtonType.outline,
                  onPressed: _isSaving
                      ? () {}
                      : () {
                          context.read<ScannerProvider>().reset();
                          context.pop();
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NutriRow extends StatelessWidget {
  final String label, value;
  final Color color;
  const _NutriRow({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(value, style: AppTypography.titleSmall.copyWith(color: color)),
      ]),
    );
  }
}
