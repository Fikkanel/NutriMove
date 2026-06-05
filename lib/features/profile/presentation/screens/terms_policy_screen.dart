import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

/// Layar untuk menampilkan Syarat & Ketentuan atau Kebijakan Privasi secara dinamis.
class TermsPolicyScreen extends StatelessWidget {
  final String type; // 'terms' atau 'policy'

  const TermsPolicyScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isTerms = type == 'terms';
    final title = isTerms ? 'Syarat & Ketentuan' : 'Kebijakan Privasi';

    return Scaffold(
      appBar: CustomAppBar(title: title, showBack: true),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Ringkas
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isTerms ? Icons.description_rounded : Icons.gavel_rounded,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Terakhir diperbarui: 5 Juni 2026',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Konten Hukum Utama
                if (isTerms) ..._buildTermsContent() else ..._buildPolicyContent(),

                const SizedBox(height: 32),

                // Tombol Setuju / Tutup
                SizedBox(
                  width: double.infinity,
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Saya Mengerti',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat konten terstruktur untuk Syarat & Ketentuan
  List<Widget> _buildTermsContent() {
    return [
      _buildSection(
        '1. Penerimaan Ketentuan',
        'Dengan mengunduh, memasang, atau menggunakan aplikasi NutriMove, Anda menyatakan telah membaca, memahami, dan menyetujui untuk terikat oleh seluruh syarat dan ketentuan penggunaan ini.',
      ),
      _buildSection(
        '2. Batasan Tanggung Jawab Medis (Disclaimer)',
        'NutriMove menggunakan teknologi AI (Gemini Vision & LLaMA) untuk mendeteksi makanan dan mengestimasikan kalori serta makronutrisi. Hasil analisis dan rekomendasi gizi yang disediakan oleh aplikasi ini bersifat estimasi informatif dan BUKAN merupakan saran medis atau medis profesional. Selalu konsultasikan dengan dokter atau ahli gizi berlisensi sebelum melakukan perubahan diet ekstrem.',
      ),
      _buildSection(
        '3. Keamanan Alergi Pengguna',
        'Meskipun aplikasi ini menyediakan fitur pemfilteran alergi, pengguna bertanggung jawab penuh untuk memverifikasi bahan makanan secara langsung sebelum mengonsumsinya. NutriMove tidak bertanggung jawab atas reaksi alergi, keracunan, atau dampak kesehatan lainnya dari makanan yang direkomendasikan aplikasi.',
      ),
      _buildSection(
        '4. Akun & Kredensial',
        'Anda bertanggung jawab atas keamanan data pribadi Anda di dalam perangkat. Data preferensi diet, alergi, dan log makanan harian Anda disimpan secara lokal di memori penyimpanan perangkat Anda sendiri.',
      ),
      _buildSection(
        '5. Hak Kekayaan Intelektual',
        'Seluruh logo, desain, aset visual, dan kode sumber aplikasi NutriMove sepenuhnya dilindungi undang-undang hak cipta dan merupakan hak kekayaan intelektual milik pengembang.',
      ),
    ];
  }

  // Membuat konten terstruktur untuk Kebijakan Privasi
  List<Widget> _buildPolicyContent() {
    return [
      _buildSection(
        '1. Pengumpulan Data Informasi',
        'Kami mengumpulkan preferensi profil diet Anda (seperti tinggi badan, berat badan, target kebugaran, dan jenis alergi) untuk menyajikan kalkulasi nutrisi dan saran makanan harian yang relevan bagi Anda.',
      ),
      _buildSection(
        '2. Pengolahan Data Gambar (Kamera)',
        'Saat menggunakan fitur Scanner AI untuk mendeteksi makanan, gambar yang Anda tangkap hanya akan dikirimkan ke model AI (Gemini/Groq API) untuk dianalisis secara instan. Kami tidak menyimpan, mengunggah, atau membagikan gambar makanan Anda ke server luar atau pihak ketiga lainnya secara permanen.',
      ),
      _buildSection(
        '3. Penyimpanan Data Lokal Perangkat',
        'Log makanan harian, pencapaian gamifikasi, dan riwayat mingguan Anda disimpan secara privat di dalam memori internal ponsel Anda sendiri menggunakan penyimpanan terenkripsi lokal.',
      ),
      _buildSection(
        '4. Integrasi Pihak Ketiga',
        'Aplikasi ini terintegrasi dengan Google Gemini API dan Groq API untuk memproses fitur AI (Vision Classifier, AI Chatbot, dan AI Recommendation). Pemrosesan tunduk pada kebijakan privasi masing-masing penyedia layanan kecerdasan buatan.',
      ),
      _buildSection(
        '5. Penghapusan Informasi',
        'Anda dapat menghapus seluruh riwayat log makanan, setelan alergi, dan data profil Anda secara instan kapan saja dengan membersihkan data aplikasi (clear data) lewat pengaturan sistem ponsel Anda.',
      ),
    ];
  }

  // Widget pembantu untuk menampilkan bagian dengan layout yang indah
  Widget _buildSection(String heading, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: AppTypography.titleSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTypography.bodyMedium.copyWith(height: 1.6),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
