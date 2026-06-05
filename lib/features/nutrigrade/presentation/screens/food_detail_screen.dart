import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class FoodDetailScreen extends StatelessWidget {
  final String foodId;
  const FoodDetailScreen({super.key, required this.foodId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Makanan', showBack: true),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: Center(child: Text('Food Detail: $foodId', style: AppTypography.headlineSmall)),
      ),
    );
  }
}
