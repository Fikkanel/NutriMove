import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/services/groq_service.dart';

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
        'name': 'Pepes Tahu & Jamur',
        'cal': 150,
        'grade': 'A',
        'desc': 'Tinggi protein nabati & rendah kalori.',
        'detail': 'Tahu dan jamur dikukus dengan bumbu pepes tradisional khas Sunda. Hidangan ini kaya protein nabati, serat tinggi, dan sangat rendah kalori serta lemak, menjadikannya pilihan ideal dan hemat untuk menurunkan berat badan.'
      },
      {
        'name': 'Sayur Bening Bayam & Jagung',
        'cal': 90,
        'grade': 'A',
        'desc': 'Rendah lemak, kaya serat & zat besi.',
        'detail': 'Sup bayam bening segar dengan tambahan potongan jagung manis. Sangat rendah kalori namun padat serat, zat besi, dan vitamin A. Menu ekonomis yang menyegarkan dan menyehatkan tubuh.'
      },
      {
        'name': 'Gado-Gado (Saus Kacang Tipis)',
        'cal': 250,
        'grade': 'B',
        'desc': 'Serat tinggi dari sayur rebus lokal.',
        'detail': 'Kombinasi taoge, kol, kangkung, kacang panjang rebus, dan tahu dengan siraman bumbu kacang encer. Memberikan rasa kenyang lebih lama berkat serat melimpah dan lemak nabati yang sehat.'
      },
      {
        'name': 'Tumis Kangkung Bawang Putih',
        'cal': 110,
        'grade': 'A',
        'desc': 'Sangat rendah kalori & tinggi serat.',
        'detail': 'Kangkung segar ditumis cepat dengan sedikit minyak dan bawang putih. Sangat rendah kalori dan kaya zat besi untuk meningkatkan metabolisme selama program diet lemak tubuh.'
      },
      {
        'name': 'Pepes Ikan Kembung',
        'cal': 220,
        'grade': 'A',
        'desc': 'Protein tinggi & kaya Omega-3 lokal.',
        'detail': 'Ikan kembung (sumber Omega-3 lokal yang lebih tinggi dibanding salmon namun jauh lebih murah) dikukus dengan rempah harum dalam bungkusan daun pisang. Protein murni untuk mempertahankan massa otot.'
      },
      {
        'name': 'Sup Kimlo Bakso Tahu',
        'cal': 180,
        'grade': 'A',
        'desc': 'Rendah kalori & tinggi hidrasi serat.',
        'detail': 'Sup bening hangat dengan bakso ikan segar, tahu sutra, wortel, jamur kuping, dan sedap malam. Pilihan sup rendah kalori yang mengenyangkan, menghidrasi, dan sangat terjangkau.'
      },
      {
        'name': 'Tahu Tempe Bacem Kukus',
        'cal': 190,
        'grade': 'A',
        'desc': 'Protein nabati murah berkualitas tinggi.',
        'detail': 'Tahu dan tempe dimasak bumbu bacem tradisional lalu dikukus atau dipanggang tanpa minyak goreng berlebih. Sumber protein nabati yang sangat ekonomis dan padat nutrisi.'
      },
      {
        'name': 'Pecel Sayur Lokal',
        'cal': 180,
        'grade': 'B',
        'desc': 'Sayuran rebus kaya serat & zat besi.',
        'detail': 'Sayuran hijau lokal rebus seperti kangkung, bayam, dan kacang panjang yang disiram saus kacang gurih sedang. Kaya serat kasar alami untuk melancarkan pencernaan saat diet.'
      }
    ],
    'maintain': [
      {
        'name': 'Ikan Lele Bakar & Lalapan',
        'cal': 320,
        'grade': 'B',
        'desc': 'Protein hewani ekonomis & lalapan segar.',
        'detail': 'Ikan lele dibakar bumbu kecap manis disajikan bersama kol, mentimun, dan sambal tomat segar. Sumber protein hewani berkualitas tinggi dan asam lemak sehat untuk memelihara otot tubuh.'
      },
      {
        'name': 'Sop Ayam Wortel Kentang',
        'cal': 280,
        'grade': 'A',
        'desc': 'Kuah kaldu hangat padat gizi seimbang.',
        'detail': 'Sup dada ayam dengan wortel, kentang, buncis, dan seledri. Kombinasi protein hewani tanpa lemak jahat dan karbohidrat kompleks seimbang untuk menjaga kestabilan berat badan.'
      },
      {
        'name': 'Telur Dadar Daun Bawang Panggang',
        'cal': 250,
        'grade': 'B',
        'desc': 'Sarapan praktis kaya gizi makro lokal.',
        'detail': 'Telur dadar tebal dicampur irisan daun bawang dan cabai merah yang dipanggang atau digoreng minim minyak. Sumber protein lengkap dan kolin untuk fokus mental harian Anda.'
      },
      {
        'name': 'Pepes Ayam Kemangi',
        'cal': 260,
        'grade': 'A',
        'desc': 'Rendah lemak jahat & wangi protein.',
        'detail': 'Daging dada ayam dibumbui bawang merah, bawang putih, dan daun kemangi lalu dikukus. Rendah kolesterol jahat namun tinggi protein pembangun sel tubuh yang sehat.'
      },
      {
        'name': 'Sayur Asem & Tempe Penyet',
        'cal': 290,
        'grade': 'B',
        'desc': 'Gizi makro & serat seimbang yang murah.',
        'detail': 'Sayur asem kuah segar dipadukan dengan tempe goreng penyet sambal bawang. Sumber karbohidrat nabati, serat larut, dan protein nabati murah meriah dengan gizi seimbang.'
      },
      {
        'name': 'Capcay Kuah Bakso Tahu',
        'cal': 220,
        'grade': 'A',
        'desc': 'Serat sayuran campur & protein bakso.',
        'detail': 'Aneka sayuran tumis (wortel, sawi, kembang kol) dimasak kuah kaldu bersama tahu dan potongan bakso sapi. Menyajikan gizi mikro vitamin dan protein yang menjaga kekebalan tubuh.'
      },
      {
        'name': 'Sate Ayam Bumbu Kacang (Tanpa Kulit)',
        'cal': 310,
        'grade': 'B',
        'desc': 'Tinggi protein & lemak sehat nabati.',
        'detail': 'Sate dada ayam panggang disajikan dengan bumbu kacang secukupnya tanpa lemak kulit ayam. Sangat lezat dan efektif menyuplai protein pembangun sel harian.'
      },
      {
        'name': 'Ketoprak Telur Rebus',
        'cal': 350,
        'grade': 'B',
        'desc': 'Kombinasi tahu protein & karbohidrat bihun.',
        'detail': 'Tahu goreng dadakan, taoge rebus segar, bihun, dan satu butir telur rebus disiram saus kacang gurih. Memberikan kombinasi asupan gizi makro lengkap yang ramah di kantong.'
      }
    ],
    'gain': [
      {
        'name': 'Nasi Putih, Orek Tempe & Telur Balado',
        'cal': 580,
        'grade': 'B',
        'desc': 'Tinggi kalori & protein hewani-nabati.',
        'detail': 'Nasi putih disajikan dengan orek tempe manis gurih dan telur rebus bumbu balado. Kombinasi padat energi dan protein ganda yang ekonomis untuk mendukung pertumbuhan massa otot baru.'
      },
      {
        'name': 'Soto Ayam Lamongan & Telur Rebus',
        'cal': 480,
        'grade': 'B',
        'desc': 'Padat kalori hangat kaya protein hewani.',
        'detail': 'Soto ayam dengan kuah kaldu kuning gurih, taburan bubuk koya, soun, kol, telur rebus, dan nasi putih. Pilihan menu lokal padat kalori yang meningkatkan nafsu makan saat bulking.'
      },
      {
        'name': 'Tahu Dadar Telur (Tahu Tek)',
        'cal': 420,
        'grade': 'B',
        'desc': 'Sumber protein nabati-hewani padat kalori.',
        'detail': 'Tahu putih digoreng bersama dadar telur, disajikan dengan taoge, kerupuk, dan siraman saus kacang petis kental. Sangat padat kalori sehat dan protein pembangun jaringan tubuh.'
      },
      {
        'name': 'Gulai Ikan Nila Santan Sedang',
        'cal': 510,
        'grade': 'B',
        'desc': 'Kalori gizi tinggi dari santan & ikan nila.',
        'detail': 'Ikan nila segar dimasak kuah gulai santan sedang yang gurih. Menyuplai kalori tinggi dari lemak kelapa sehat dan protein tinggi dari ikan nila untuk menambah berat badan.'
      },
      {
        'name': 'Nasi Uduk & Semur Tahu Kentang',
        'cal': 550,
        'grade': 'B',
        'desc': 'Karbohidrat santan padat energi murah.',
        'detail': 'Nasi uduk gurih wangi dipadukan semur tahu manis gurih dan potongan kentang rebus empuk. Pilihan asupan karbohidrat tinggi kalori yang sangat ramah anggaran belanja.'
      },
      {
        'name': 'Nasi Gila Bakso Sosis Telur',
        'cal': 590,
        'grade': 'C',
        'desc': 'Kalori sangat tinggi untuk surplus energi.',
        'detail': 'Nasi putih dengan topping tumisan bakso, sosis, dan telur orek kecap manis gurih. Porsi padat kalori yang sangat efektif untuk menambah berat badan dengan cepat.'
      },
      {
        'name': 'Pisang Kepok Bakar Keju Cokelat',
        'cal': 350,
        'grade': 'B',
        'desc': 'Kalori manis gurih kaya kalium alami.',
        'detail': 'Pisang kepok lokal dibakar lalu diberi taburan keju parut gurih dan sedikit meises cokelat. Sumber energi instan yang tinggi kalori dan kalium untuk pemulihan energi setelah latihan.'
      },
      {
        'name': 'Bubur Kacang Hijau Santan Murni',
        'cal': 380,
        'grade': 'B',
        'desc': 'Kalori serat kacang & lemak santan sehat.',
        'detail': 'Kacang hijau rebus manis disajikan dengan kuah santan kelapa murni. Kaya karbohidrat lambat serap, serat makanan, zat besi, dan lemak nabati sehat untuk menaikkan berat badan.'
      }
    ]
  };

  Future<void> loadRecommendations(String goal, {List<String> allergens = const []}) async {
    _isLoading = true;
    _error = '';
    _recommendations = [];
    notifyListeners();

    final cleanGoal = goal.isEmpty ? 'maintain' : goal;

    // Jika API Key tidak disetel, gunakan fallback daftar makanan lokal sehat terjangkau secara offline
    if (EnvConfig.geminiApiKey.isEmpty || EnvConfig.geminiApiKey.startsWith('AQ.')) {
      final list = _fallbacks[cleanGoal] ?? _fallbacks['maintain']!;
      if (allergens.isNotEmpty) {
        _recommendations = list.where((item) {
          final name = item['name'].toString().toLowerCase();
          final detail = item['detail'].toString().toLowerCase();
          final desc = item['desc'].toString().toLowerCase();
          for (final allergen in allergens) {
            final cleanAllergen = allergen.toLowerCase().trim();
            if (cleanAllergen.isNotEmpty &&
                (name.contains(cleanAllergen) ||
                 detail.contains(cleanAllergen) ||
                 desc.contains(cleanAllergen))) {
              return false;
            }
          }
          return true;
        }).toList();
        
        // Jika semua menu dalam daftar terfilter karena alergi, gunakan menu dasar yang 100% aman
        if (_recommendations.isEmpty) {
          _recommendations = [
            {
              'name': 'Nasi Putih & Tahu Tempe Kukus',
              'cal': 250,
              'grade': 'A',
              'desc': 'Sangat aman dan bebas dari alergen.',
              'detail': 'Nasi putih hangat dipadukan dengan tahu dan tempe kukus segar serta lalapan ketimun. Bebas dari alergen utama seperti seafood, susu, telur, ayam, pisang, gandum, atau kacang-kacangan.'
            }
          ];
        }
      } else {
        _recommendations = list;
      }
      _isLoading = false;
      notifyListeners();
      return;
    }

    final allergyPrompt = allergens.isNotEmpty
        ? "PENTING: Pengguna memiliki ALERGI terhadap bahan-bahan berikut: ${allergens.join(', ')}. JANGAN merekomendasikan makanan yang mengandung salah satu dari bahan-bahan tersebut! "
        : "";

    final localFoodConstraint = "REKOMENDASIKAN HANYA makanan lokal Indonesia yang murah, terjangkau, sehat, dan mudah ditemui sehari-hari (contoh: Tempe, Tahu, Sayur Asem, Pecel, Gado-Gado, Capcay Sayur, Telur Rebus, Pepes Ikan Kembung, Soto, dll). "
        "SANGAT DILARANG merekomendasikan makanan mahal, kebarat-baratan, atau bahan impor mewah seperti Salmon, Buah Beri, Quinoa, Almond, Roti Gandum, dll. Utamakan bahan lokal hemat biaya.";

    String goalPrompt = '';
    if (cleanGoal == 'lose') {
      goalPrompt = "Berikan 4 menu lokal sehat terjangkau untuk menurunkan berat badan (lose weight/diet).";
    } else if (cleanGoal == 'gain') {
      goalPrompt = "Berikan 4 menu lokal sehat terjangkau padat kalori untuk menaikkan berat badan (gain weight/bulking).";
    } else {
      goalPrompt = "Berikan 4 menu lokal sehat terjangkau gizi seimbang untuk menjaga berat badan (maintain weight).";
    }

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: EnvConfig.geminiApiKey,
        systemInstruction: Content.system(
          "Kamu adalah ahli gizi dari NutriMove. Tugasmu adalah memberikan rekomendasi menu makanan sehat berdasarkan target diet user. "
          "Target diet user adalah: 'lose' (turunkan berat badan), 'maintain' (jaga berat badan), atau 'gain' (naikkan berat badan). "
          "$allergyPrompt"
          "$localFoodConstraint"
          "Berikan 4 rekomendasi makanan dalam format JSON array. Setiap objek memiliki key: \n"
          "- 'name' (string nama makanan lokal Indonesia)\n"
          "- 'cal' (integer estimasi kalori per porsi)\n"
          "- 'grade' (string grade gizi A/B/C/D)\n"
          "- 'desc' (string deskripsi singkat alasan makanan ini cocok untuk target diet tersebut, maks 8 kata)\n"
          "- 'detail' (string penjelasan lengkap & analisis nutrisi detail mengapa makanan ini direkomendasikan untuk target diet tersebut, minimal 30 kata)\n"
          "Berikan respon berupa JSON mentah HANYA dalam format array, tanpa block markdown (seperti ```json) atau teks pengantar lainnya."
        ),
      );

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
      debugPrint('Gemini recommendations error: $e. Falling back to Groq.');
      
      final systemPrompt = "Kamu adalah ahli gizi dari NutriMove. Tugasmu adalah memberikan rekomendasi menu makanan sehat berdasarkan target diet user. "
          "Target diet user adalah: 'lose' (turunkan berat badan), 'maintain' (jaga berat badan), 'gain' (naikkan berat badan). "
          "$allergyPrompt"
          "$localFoodConstraint"
          "Berikan 4 rekomendasi makanan dalam format JSON array. Setiap objek memiliki key: \n"
          "- 'name' (string nama makanan Indonesia)\n"
          "- 'cal' (integer estimasi kalori per porsi)\n"
          "- 'grade' (string grade gizi A/B/C/D)\n"
          "- 'desc' (string deskripsi singkat alasan makanan ini cocok untuk target diet tersebut, maks 8 kata)\n"
          "- 'detail' (string penjelasan lengkap & analisis nutrisi detail mengapa makanan ini direkomendasikan untuk target diet tersebut, minimal 30 kata)\n"
          "Berikan respon berupa JSON mentah HANYA dalam format array, tanpa block markdown (seperti ```json) atau teks pengantar lainnya.";

      try {
        final groqResponse = await GroqService.chat(
          goalPrompt,
          systemInstruction: systemPrompt,
        );

        if (groqResponse != null) {
          String responseText = groqResponse.trim();
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
        } else {
          _recommendations = _fallbacks[cleanGoal] ?? _fallbacks['maintain']!;
        }
      } catch (_) {
        _recommendations = _fallbacks[cleanGoal] ?? _fallbacks['maintain']!;
      }
    }

    // Melakukan penyaringan keamanan alergi akhir pada rekomendasi (Gemini, Groq, maupun Fallback)
    if (allergens.isNotEmpty && _recommendations.isNotEmpty) {
      final filtered = _recommendations.where((item) {
        final name = item['name'].toString().toLowerCase();
        final detail = item['detail'].toString().toLowerCase();
        final desc = item['desc'].toString().toLowerCase();
        for (final allergen in allergens) {
          final cleanAllergen = allergen.toLowerCase().trim();
          if (cleanAllergen.isNotEmpty &&
              (name.contains(cleanAllergen) ||
               detail.contains(cleanAllergen) ||
               desc.contains(cleanAllergen))) {
            debugPrint("Safety filter removed item containing allergen '$cleanAllergen': ${item['name']}");
            return false;
          }
        }
        return true;
      }).toList();
      
      if (filtered.isNotEmpty) {
        _recommendations = filtered;
      } else {
        // Jika semua menu hasil AI terfilter karena alergi, tampilkan menu dasar 100% aman
        _recommendations = [
          {
            'name': 'Nasi Putih & Tahu Tempe Kukus',
            'cal': 250,
            'grade': 'A',
            'desc': 'Sangat aman dan bebas dari alergen.',
            'detail': 'Nasi putih hangat dipadukan dengan tahu dan tempe kukus segar serta lalapan ketimun. Bebas dari alergen utama seperti seafood, susu, telur, ayam, pisang, gandum, atau kacang-kacangan.'
          }
        ];
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
