import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/recommendation_provider.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final profile = context.read<ProfileProvider>();
        profile.loadProfile().then((_) {
          if (mounted && profile.hasConfiguredAllergens) {
            final goal = profile.dietGoal;
            context.read<RecommendationProvider>().loadRecommendations(
              goal,
              allergens: profile.allergens,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<RecommendationProvider>().isLoading;
    final isProfileLoading = context.watch<ProfileProvider>().isLoading;
    final showRefresh = !isLoading && !isProfileLoading;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rekomendasi Menu',
        showBack: true,
        actions: [
          if (showRefresh)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
              tooltip: 'Muat ulang rekomendasi',
              onPressed: () {
                final profile = context.read<ProfileProvider>();
                context.read<RecommendationProvider>().loadRecommendations(
                  profile.dietGoal,
                  allergens: profile.allergens,
                );
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Consumer2<ProfileProvider, RecommendationProvider>(
          builder: (_, profile, provider, child) {
            if (profile.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (!profile.hasConfiguredAllergens) {
              return _buildAllergySetupView(context, profile);
            }

            if (provider.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text('AI sedang menyusun rekomendasi...', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            final items = provider.recommendations;
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Gagal memuat rekomendasi', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        provider.loadRecommendations(profile.dietGoal, allergens: profile.allergens);
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final grade = items[i]['grade']?.toString() ?? 'A';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedCard(
                    delay: i * 100,
                    onTap: () => _showMenuDetail(context, items[i]),
                    child: Row(children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          color: _getGradeColor(grade).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            grade,
                            style: AppTypography.titleLarge.copyWith(color: _getGradeColor(grade)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${items[i]['name']}', style: AppTypography.titleSmall),
                        const SizedBox(height: 4),
                        Text(
                          '${items[i]['desc']}',
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ])),
                      const SizedBox(width: 8),
                      Text('${items[i]['cal']} kcal', style: AppTypography.labelMedium.copyWith(color: AppColors.primary)),
                    ]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showMenuDetail(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _buildBottomDrawer(ctx, item),
    );
  }

  Widget _buildBottomDrawer(BuildContext context, Map<String, dynamic> item) {
    final grade = item['grade']?.toString() ?? 'A';
    final gradeColor = _getGradeColor(grade);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle Indicator
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Header Row: Grade & Calories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: gradeColor.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    grade,
                    style: AppTypography.headlineMedium.copyWith(color: gradeColor),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${item['cal']} kcal',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Food Name
          Text(
            '${item['name']}',
            style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Divider
          Container(
            height: 1,
            color: AppColors.border,
          ),
          const SizedBox(height: 16),

          // Explanation Header
          Text(
            'Info & Analisis Nutrisi AI:',
            style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary),
          ),
          const SizedBox(height: 8),

          // Detailed Explanation
          Text(
            '${item['detail'] ?? item['desc']}',
            style: AppTypography.bodyMedium.copyWith(height: 1.5, fontSize: 15),
          ),
          const SizedBox(height: 32),

          // Tutup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
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

  Widget _buildAllergySetupView(BuildContext context, ProfileProvider profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.security_rounded,
                color: AppColors.primary,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Keamanan Diet Anda',
              style: AppTypography.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Sebelum AI menyusun rekomendasi menu, mohon konfirmasi apakah Anda memiliki alergi makanan untuk memastikan semua makanan yang disarankan aman untuk Anda.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Pilih Alergi Makanan Anda (jika ada):',
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: 12),
          _AllergySelector(
            onSave: (selectedAllergens) async {
              await profile.updateProfile(allergens: selectedAllergens);
              if (context.mounted) {
                context.read<RecommendationProvider>().loadRecommendations(
                  profile.dietGoal,
                  allergens: selectedAllergens,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _AllergySelector extends StatefulWidget {
  final Function(List<String>) onSave;
  const _AllergySelector({required this.onSave});

  @override
  State<_AllergySelector> createState() => _AllergySelectorState();
}

class _AllergySelectorState extends State<_AllergySelector> {
  final List<String> _commonAllergens = [
    'Kacang',
    'Seafood',
    'Susu',
    'Gandum',
    'Telur',
    'Kedelai',
    'Ikan',
  ];

  final List<String> _selected = [];
  final _customCtrl = TextEditingController();
  bool _showCustomInput = false;

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ..._commonAllergens.map((allergen) {
              final isSelected = _selected.contains(allergen);
              return FilterChip(
                label: Text(allergen),
                selected: isSelected,
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                ),
                backgroundColor: AppColors.surface,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      _selected.add(allergen);
                    } else {
                      _selected.remove(allergen);
                    }
                  });
                },
              );
            }),
            
            // Selected Custom Allergens
            ..._selected.where((a) => !_commonAllergens.contains(a)).map((allergen) {
              return Chip(
                label: Text(allergen),
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.error),
                onDeleted: () {
                  setState(() {
                    _selected.remove(allergen);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.primary),
                ),
              );
            }),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (!_showCustomInput)
          TextButton.icon(
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Tambah Alergi Kustom'),
            onPressed: () {
              setState(() {
                _showCustomInput = true;
              });
            },
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan alergi (misal: Madu, Wijen)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                onPressed: () {
                  final txt = _customCtrl.text.trim();
                  if (txt.isNotEmpty && !_selected.contains(txt)) {
                    setState(() {
                      _selected.add(txt);
                      _customCtrl.clear();
                      _showCustomInput = false;
                    });
                  }
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
          
        const SizedBox(height: 40),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => widget.onSave([]),
                child: Text(
                  'Tidak Ada Alergi',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () => widget.onSave(_selected),
                child: const Text(
                  'Simpan & Lanjutkan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
