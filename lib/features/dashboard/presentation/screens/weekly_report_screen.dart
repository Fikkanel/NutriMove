import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../data/models/daily_log_model.dart';

class WeeklyReportScreen extends StatefulWidget {
  const WeeklyReportScreen({super.key});

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  final _repository = DashboardRepositoryImpl();
  List<DailyLogModel>? _logs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> _loadData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'local_user';
    final logs = await _repository.getLogHistory(userId, 7);
    if (mounted) {
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Laporan Mingguan',
        showBack: true,
        onBack: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            context.go('/home');
          }
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_logs == null || _logs!.isEmpty) {
      return const Center(child: Text('Tidak ada data'));
    }

    // Calculate averages
    double totalCal = 0, totalPro = 0, totalCarb = 0, totalFat = 0;
    int daysLogged = 0;
    for (var log in _logs!) {
      if (log.totalCalories > 0) {
        totalCal += log.totalCalories;
        totalPro += log.totalProtein;
        totalCarb += log.totalCarbs;
        totalFat += log.totalFat;
        daysLogged++;
      }
    }
    
    final avgCal = daysLogged > 0 ? totalCal / daysLogged : 0;
    
    // Find max calorie for chart scaling
    double maxCal = 2000;
    for (var log in _logs!) {
      if (log.totalCalories > maxCal) maxCal = log.totalCalories;
    }
    maxCal = ((maxCal / 500).ceil() * 500).toDouble(); // Round up to nearest 500

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan 7 Hari Terakhir', style: AppTypography.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Rata-rata: ${avgCal.toInt()} kcal / hari',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          
          // Chart
          Container(
            height: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCal,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < _logs!.length) {
                          final date = _logs![value.toInt()].date;
                          final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(days[date.weekday - 1], style: AppTypography.labelSmall),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) => FlLine(color: AppColors.border, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_logs!.length, (i) {
                  final log = _logs![i];
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: log.totalCalories,
                        color: AppColors.primary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxCal,
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          Text('Rata-rata Makronutrisi', style: AppTypography.titleLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMacroCard('Protein', (daysLogged > 0 ? totalPro / daysLogged : 0), Colors.redAccent),
              const SizedBox(width: 12),
              _buildMacroCard('Karbo', (daysLogged > 0 ? totalCarb / daysLogged : 0), Colors.orangeAccent),
              const SizedBox(width: 12),
              _buildMacroCard('Lemak', (daysLogged > 0 ? totalFat / daysLogged : 0), Colors.blueAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String title, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(title, style: AppTypography.labelMedium.copyWith(color: color)),
            const SizedBox(height: 8),
            Text('${amount.toInt()}g', style: AppTypography.titleMedium.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}
