import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/health_record.dart';

class HealthIndicator extends StatelessWidget {
  final HealthRecord record;

  const HealthIndicator({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _statusColor(record.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de Salud',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: record.attendanceRate / 100,
                      strokeWidth: 10,
                      backgroundColor: color.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(color),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_rounded, color: color, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        record.status,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Excelente':
        return AppColors.success;
      case 'Bueno':
        return AppColors.info;
      case 'En Riesgo':
        return AppColors.warning;
      case 'Crítico':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }
}
