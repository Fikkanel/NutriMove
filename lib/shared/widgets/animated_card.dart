import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// Kartu kustom dengan animasi kemunculan memudar + membesar (fade & scale) dan efek menekan kartu (tap feedback)
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final int delay;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.delay = 0,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isTapped = false;

  // Inisialisasi controller animasi, tween opacity fade (0 ke 1) dan scale (0.95 ke 1.0) dengan efek delay
  @override
  void initState() {
    super.initState();
    // Mengatur durasi total animasi selama 600 milidetik
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    // Animasi perubahan transparansi dari transparan (0) ke penuh (1)
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    // Animasi perubahan skala dari 95% ukuran asli ke 100% ukuran asli
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Menjalankan animasi setelah jeda waktu (delay) yang ditentukan
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  // Membersihkan kontroler animasi saat widget dihapus dari memori HP untuk mencegah kebocoran memori (leak)
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Render widget dengan gabungan animasi FadeTransition, ScaleTransition, dan pendeteksi gestur tekan kartu
  @override
  Widget build(BuildContext context) {
    // Menerapkan animasi memudar (opacity)
    return FadeTransition(
      opacity: _fadeAnimation,
      // Menerapkan animasi pembesaran (scale)
      child: ScaleTransition(
        scale: _scaleAnimation,
        // Pendeteksi interaksi sentuhan pengguna
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isTapped = true), // Skala mengecil saat disentuh
          onTapUp: (_) => setState(() => _isTapped = false), // Skala kembali normal saat dilepas
          onTapCancel: () => setState(() => _isTapped = false), // Skala kembali normal jika batal ditekan
          onTap: widget.onTap,
          // Efek visual kartu mengecil secara interaktif
          child: AnimatedScale(
            scale: _isTapped ? 0.97 : 1.0, // Mengecil ke 97% saat ditekan
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: widget.padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
