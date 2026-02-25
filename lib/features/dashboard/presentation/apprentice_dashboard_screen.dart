import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/stat_card.dart';
import '../providers/dashboard_provider.dart';

class ApprenticeDashboardScreen extends ConsumerWidget {
  const ApprenticeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(apprenticeDashboardProvider);
    final theme = Theme.of(context);

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('${AppStrings.errorGeneric}: $err')),
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.dashboard,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${stats.currentProgram} • Ficha ${stats.group}',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
                final aspectRatio = constraints.maxWidth > 600 ? 1.8 : 1.5;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                  children: [
                    StatCard(
                      title: AppStrings.attendanceRate,
                      value: '${stats.attendanceRate}%',
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.success,
                    ),
                    StatCard(
                      title: AppStrings.healthIndicator,
                      value: stats.healthStatus,
                      icon: Icons.favorite_rounded,
                      iconColor: _healthColor(stats.healthStatus),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.upcomingClasses,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          ...stats.upcomingClasses.map((c) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.class_rounded, color: AppColors.primary),
                            ),
                            title: Text(c['subject'] ?? ''),
                            subtitle: Text('${c['instructor']} • ${c['time']}'),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Últimas Notas',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          ...stats.recentGrades.map((g) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.grade_rounded, size: 20, color: AppColors.warning),
                                const SizedBox(width: 12),
                                Expanded(child: Text(g)),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _healthColor(String status) {
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
