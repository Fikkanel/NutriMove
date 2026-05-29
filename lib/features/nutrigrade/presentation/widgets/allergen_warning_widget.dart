import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Allergen warning banner shown when food contains user's allergens.
class AllergenWarningWidget extends StatelessWidget {
  final List<String> allergens;
  const AllergenWarningWidget({super.key, required this.allergens});

  @override
  Widget build(BuildContext context) {
    if (allergens.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('⚠️ Peringatan Alergen!', style: AppTypography.titleSmall.copyWith(color: AppColors.error)),
          const SizedBox(height: 4),
          Text('Makanan ini mengandung: ${allergens.join(", ")}', style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
        ])),
      ]),
    );
  }
}
