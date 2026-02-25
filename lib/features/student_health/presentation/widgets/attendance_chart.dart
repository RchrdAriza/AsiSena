import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/attendance_record.dart';

class AttendanceChart extends StatelessWidget {
  final List<AttendanceRecord> records;

  const AttendanceChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    // Group by week and calculate attendance percentage
    final weeklyData = <int, List<AttendanceRecord>>{};
    for (var i = 0; i < records.length; i++) {
      final week = i ~/ 7;
      weeklyData.putIfAbsent(week, () => []).add(records[i]);
    }

    final spots = weeklyData.entries.map((entry) {
      final weekRecords = entry.value.where((r) => r.date.weekday < 6).toList();
      if (weekRecords.isEmpty) return FlSpot(entry.key.toDouble(), 100);
      final presentCount = weekRecords.where((r) => r.present).length;
      final rate = (presentCount / weekRecords.length) * 100;
      return FlSpot(entry.key.toDouble(), rate);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppColors.outline.withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}%',
                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                'S${value.toInt() + 1}',
                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
