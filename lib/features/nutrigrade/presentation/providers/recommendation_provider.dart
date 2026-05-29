import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/config/env_config.dart';

/// Provider to handle AI food recommendations based on the user's diet goal.
class RecommendationProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _recommendations = [];
  String _error = '';

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get recommendations => _recommendations;
  String get error => _error;

  static const Map<String, List<Map<String, dynamic>>> _fallbacks = {
    'lose': [
      {
        'name': 'Salad Quinoa',
        'cal': 320,
        'grade': 'A',
        'desc': 'Kaya protein nabati & serat.',
        'detail': 'Salad Quinoa mengandung asam amino lengkap dan serat tinggi yang membantu mempertahankan rasa kenyang lebih lama. Sangat rendah indeks glikemik, menjadikannya pilihan sempurna untuk membakar lemak tubuh tanpa kehilangan massa otot.'
      },
      {
        'name': 'Sup Ayam Sayur',
        'cal': 280,
        'grade': 'A',
        'desc': 'Rendah lemak, tinggi vitamin.',
        'detail': 'Sup ayam hangat dengan potongan sayur segar memberikan asupan protein hewani bebas lemak jenuh dan tinggi mikronutrien penting. Pilihan sup ini sangat rendah kalori namun sangat menghidrasi dan mengenyangkan tubuh.'
      },
      {
        'name': 'Oatmeal Buah',
        'cal': 350,
        'grade': 'A',
        'desc': 'Karbohidrat kompleks untuk energi.',
        'detail': 'Oatmeal gandum utuh lambat dicerna tubuh sehingga menjaga kadar gula darah tetap stabil. Dilengkapi potongan buah segar kaya antioksidan dan serat untuk menahan lapar hingga jam makan berikutnya.'
      },
      {
        'name': 'Ikan Panggang',
        'cal': 400,
        'grade': 'A',
        'desc': 'Omega-3 dan protein tinggi.',
        'detail': 'Ikan panggang (seperti kakap atau salmon) mengandung protein murni berkualitas tinggi dan asam lemak esensial Omega-3. Membantu mempercepat pembakaran lemak perut dan mendukung pemulihan sel-sel tubuh.'
      },
    ],
    'maintain': [
      {
        'name': 'Salmon Panggang',
        'cal': 450,
        'grade': 'A',
        'desc': 'Lemak sehat Omega-3 & protein tinggi.',
        'detail': 'Salmon panggang menyajikan kombinasi ideal antara protein berkualitas tinggi dan asam lemak tak jenuh ganda. Sangat baik untuk memelihara kesehatan jantung, mengontrol nafsu makan, dan menjaga kestabilan berat badan.'
      },
      {
        'name': 'Salad Ayam Panggang',
        'cal': 380,
        'grade': 'A',
        'desc': 'Protein tanpa lemak & serat optimal.',
        'detail': 'Salad sayuran hijau segar berpadu dada ayam panggang tanpa kulit menyajikan serat pangan melimpah serta protein pembangun otot. Membantu metabolisme tetap aktif tanpa menambah timbunan kalori berlebih.'
      },
      {
        'name': 'Smoothie Pisang & Beri',
        'cal': 290,
        'grade': 'B',
        'desc': 'Antioksidan dan energi seimbang.',
        'detail': 'Smoothie segar kaya kalium dari pisang dan antioksidan polifenol dari buah beri. Mengembalikan energi setelah beraktivitas sekaligus menutrisi sel tubuh dengan vitamin alami tanpa gula tambahan.'
      },
      {
        'name': 'Telur Rebus & Roti Gandum',
        'cal': 310,
        'grade': 'A',
        'desc': 'Sarapan praktis kaya gizi makro.',
        'detail': 'Telur rebus merupakan sumber kolin dan protein terlengkap, dipadukan dengan roti gandum utuh sebagai sumber karbohidrat kompleks. Menjaga fokus mental dan tingkat energi tetap stabil sepanjang hari.'
      },
    ],
    'gain': [
      {
        'name': 'Nasi Merah & Dada Ayam Panggang',
        'cal': 650,
        'grade': 'A',
        'desc': 'Tinggi karbohidrat kompleks & protein.',
        'detail': 'Kombinasi nasi merah padat nutrisi dan dada ayam panggang tebal menyuplai surplus karbohidrat dan protein murni secara seimbang. Mendukung pertumbuhan jaringan otot baru saat Anda melakukan latihan kekuatan.'
      },
      {
        'name': 'Smoothie Alpukat & Selai Kacang',
        'cal': 580,
        'grade': 'B',
        'desc': 'Lemak sehat padat kalori.',
        'detail': 'Minuman padat energi yang kaya akan asam lemak tak jenuh tunggal dari alpukat asli dan selai kacang. Sangat efektif untuk mencapai target surplus kalori harian secara sehat tanpa membuat perut begah.'
      },
      {
        'name': 'Daging Sapi Lada Hitam',
        'cal': 520,
        'grade': 'B',
        'desc': 'Tinggi protein & zat besi.',
        'detail': 'Daging sapi tanpa lemak mengandung zat besi heme yang mudah diserap tubuh serta kreatin alami. Membantu memperkuat struktur otot dan menambah berat badan melalui massa otot kering yang sehat.'
      },
      {
        'name': 'Kacang Almond & Kismis',
        'cal': 450,
        'grade': 'A',
        'desc': 'Camilan padat kalori & nutrisi mikro.',
        'detail': 'Kombinasi kacang almond kaya vitamin E dan lemak sehat dengan kismis manis yang kaya antioksidan. Menjadi camilan praktis berkalori tinggi yang mudah dikonsumsi kapan saja untuk menyuplai energi.'
      },
    ],
  };

  Future<void> loadRecommendations(String goal) async {
    _isLoading = true;
    _error = '';
    _recommendations = [];
    notifyListeners();

    final cleanGoal = goal.isEmpty ? 'maintain' : goal;

    if (EnvConfig.geminiApiKey.isEmpty) {
      _recommendations = _fallbacks[cleanGoal] ?? _fallbacks['maintain']!;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-3.5-flash',
        apiKey: EnvConfig.geminiApiKey,
        systemInstruction: Content.system(
          "Kamu adalah ahli gizi dari NutriMove. Tugasmu adalah memberikan rekomendasi menu makanan sehat berdasarkan target diet user. "
          "Target diet user adalah salah satu dari: 'lose' (turunkan berat badan), 'maintain' (jaga berat badan), 'gain' (naikkan berat badan). "
          "Berikan 4 rekomendasi makanan dalam format JSON array. Setiap objek memiliki key: \n"
          "- 'name' (string nama makanan Indonesia)\n"
          "- 'cal' (integer estimasi kalori per porsi)\n"
          "- 'grade' (string grade gizi A/B/C/D)\n"
          "- 'desc' (string deskripsi singkat alasan makanan ini cocok untuk target diet tersebut, maks 8 kata)\n"
          "- 'detail' (string penjelasan lengkap & analisis nutrisi detail mengapa makanan ini direkomendasikan untuk target diet tersebut, minimal 30 kata)\n"
          "Berikan respon berupa JSON mentah HANYA dalam format array, tanpa block markdown (seperti ```json) atau teks pengantar lainnya."
        ),
      );

      String goalPrompt = '';
      if (cleanGoal == 'lose') {
        goalPrompt = "Berikan 4 menu sehat untuk menurunkan berat badan (lose weight/diet).";
      } else if (cleanGoal == 'gain') {
        goalPrompt = "Berikan 4 menu sehat padat kalori dan gizi untuk menaikkan berat badan (gain weight/bulking).";
      } else {
        goalPrompt = "Berikan 4 menu sehat gizi seimbang untuk menjaga berat badan (maintain weight).";
      }

      final response = await model.generateContent([
        Content.text(goalPrompt)
      ]).timeout(const Duration(seconds: 7));

      String responseText = response.text?.trim() ?? '';
      if (responseText.startsWith('```')) {
        responseText = responseText
            .replaceAll(RegExp(r'^```\w*\n?'), '')
            .replaceAll(RegExp(r'\n?```$'), '')
            .trim();
      }

      final List<dynamic> parsed = jsonDecode(responseText) as List<dynamic>;
      _recommendations = parsed.map((item) {
        final map = item as Map<String, dynamic>;
        return {
          'name': map['name'] ?? 'Menu Sehat',
          'cal': (map['cal'] ?? 300) as int,
          'grade': map['grade']?.toString().toUpperCase() ?? 'A',
          'desc': map['desc'] ?? 'Menu sehat dengan kandungan gizi seimbang',
          'detail': map['detail'] ?? map['desc'] ?? 'Penjelasan gizi lengkap untuk mendukung diet sehat Anda.',
        };
      }).toList();
    } catch (e) {
      debugPrint('Gemini recommendations error: $e. Falling back to local templates.');
      _recommendations = _fallbacks[cleanGoal] ?? _fallbacks['maintain']!;
    }

    _isLoading = false;
    notifyListeners();
  }
}
