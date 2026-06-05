import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../features/scanner/presentation/providers/scanner_provider.dart';
import '../../features/nutrigrade/presentation/providers/nutrigrade_provider.dart';
import '../../features/gamification/presentation/providers/gamification_provider.dart';
import '../../features/nutribot/presentation/providers/nutribot_provider.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../../features/nutrigrade/presentation/providers/recommendation_provider.dart';

import 'package:provider/single_child_widget.dart';

// Pendaftaran semua provider tingkat teratas untuk manajemen state aplikasi.
class AppProviders {
  AppProviders._();

  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
        ChangeNotifierProvider<ScannerProvider>(create: (_) => ScannerProvider()),
        ChangeNotifierProvider<NutriGradeProvider>(create: (_) => NutriGradeProvider()),
        ChangeNotifierProvider<GamificationProvider>(create: (_) => GamificationProvider()),
        ChangeNotifierProvider<NutribotProvider>(create: (_) => NutribotProvider()),
        ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
        ChangeNotifierProvider<RecommendationProvider>(create: (_) => RecommendationProvider()),
      ];
}
