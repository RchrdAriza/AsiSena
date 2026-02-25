import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/stat_card.dart';
import '../providers/dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardProvider);
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
              'Resumen general del centro de formación',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 2 : 1);
                final aspectRatio = constraints.maxWidth > 600 ? 1.6 : 1.4;
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: aspectRatio,
                  children: [
                    StatCard(
                      title: AppStrings.totalStudents,
                      value: '${stats.totalStudents}',
                      icon: Icons.people_rounded,
                      iconColor: AppColors.info,
                    ),
                    StatCard(
                      title: AppStrings.totalInstructors,
                      value: '${stats.totalInstructors}',
                      icon: Icons.school_rounded,
                      iconColor: AppColors.secondary,
                    ),
                    StatCard(
                      title: AppStrings.activePrograms,
                      value: '${stats.activePrograms}',
                      icon: Icons.book_rounded,
                      iconColor: AppColors.success,
                    ),
                    StatCard(
                      title: AppStrings.attendanceRate,
                      value: '${stats.attendanceRate}%',
                      icon: Icons.check_circle_rounded,
                      iconColor: AppColors.warning,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.recentActivity,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    ...stats.recentActivity.map((activity) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(child: Text(activity)),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
