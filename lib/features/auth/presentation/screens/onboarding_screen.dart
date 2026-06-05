import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/nutrimove_button.dart';

/// Onboarding screen with page carousel.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.camera_alt_rounded,
      iconColor: AppColors.primary,
      title: 'Scan & Kenali\nMakananmu',
      subtitle: 'Arahkan kamera ke makanan dan biarkan AI mengenali jenis serta estimasi nutrisinya secara instan.',
    ),
    _OnboardingPage(
      icon: Icons.shield_rounded,
      iconColor: AppColors.secondary,
      title: 'Peringatan\nAlergen Cerdas',
      subtitle: 'NutriGrade memberikan rating makananmu dan memperingatkan alergen berbahaya sesuai profil kesehatanmu.',
    ),
    _OnboardingPage(
      icon: Icons.local_fire_department_rounded,
      iconColor: AppColors.streakFire,
      title: 'Bangun Kebiasaan\nSehat Setiap Hari',
      subtitle: 'Daily Streak & Achievement system menjaga motivasimu untuk terus konsisten mencatat pola makan.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text('Lewati', style: AppTypography.labelLarge.copyWith(color: AppColors.textTertiary)),
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _pages[i],
                ),
              ),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i ? AppColors.primary : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _currentPage == _pages.length - 1
                    ? NutriMoveButton(
                        label: 'Mulai Sekarang',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => context.go('/login'),
                      )
                    : NutriMoveButton(
                        label: 'Selanjutnya',
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: iconColor.withValues(alpha: 0.25), width: 2),
            ),
            child: Icon(icon, size: 64, color: iconColor),
          ),
          const SizedBox(height: 48),
          Text(title, style: AppTypography.displaySmall, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(subtitle, style: AppTypography.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
