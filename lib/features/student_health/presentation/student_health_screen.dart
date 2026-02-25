import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/role.dart';
import '../../../shared/providers/auth_provider.dart';
import '../providers/health_provider.dart';
import 'widgets/attendance_chart.dart';
import 'widgets/health_indicator.dart';
import 'widgets/medical_excuses_list.dart';
import 'widgets/submit_excuse_dialog.dart';

class StudentHealthScreen extends ConsumerStatefulWidget {
  const StudentHealthScreen({super.key});

  @override
  ConsumerState<StudentHealthScreen> createState() => _StudentHealthScreenState();
}

class _StudentHealthScreenState extends ConsumerState<StudentHealthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExcuses();
    });
  }

  void _loadExcuses() {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final notifier = ref.read(medicalExcusesProvider.notifier);
    if (user.role == Role.apprentice) {
      notifier.loadExcuses(user.id);
    } else {
      notifier.loadAllExcuses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final healthAsync = ref.watch(healthRecordProvider(user.id));
    final attendanceAsync = ref.watch(attendanceHistoryProvider(user.id));
    final wellbeingAsync = ref.watch(wellbeingReportsProvider(user.id));
    final theme = Theme.of(context);
    final isApprentice = user.role == Role.apprentice;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.studentHealth,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.healthOverview,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          // Health indicator card
          healthAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
            data: (record) => isSmall
                ? Column(
                    children: [
                      HealthIndicator(record: record),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Resumen', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 16),
                              _InfoRow(label: AppStrings.attendanceRate, value: '${record.attendanceRate}%'),
                              _InfoRow(label: 'Inasistencias', value: '${record.totalAbsences}'),
                              _InfoRow(label: AppStrings.wellbeingReports, value: '${record.wellbeingReports}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: HealthIndicator(record: record)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Resumen', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 16),
                                _InfoRow(label: AppStrings.attendanceRate, value: '${record.attendanceRate}%'),
                                _InfoRow(label: 'Inasistencias', value: '${record.totalAbsences}'),
                                _InfoRow(label: AppStrings.wellbeingReports, value: '${record.wellbeingReports}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          // Attendance chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.attendance, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  attendanceAsync.when(
                    loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    error: (e, _) => Text('$e'),
                    data: (records) => SizedBox(
                      height: 200,
                      child: AttendanceChart(records: records),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Medical excuses section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.medical_services_rounded, color: theme.colorScheme.primary, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Excusas Médicas',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (isApprentice)
                        FilledButton.icon(
                          onPressed: () async {
                            final result = await showDialog<bool>(
                              context: context,
                              builder: (_) => const SubmitExcuseDialog(),
                            );
                            if (result == true) _loadExcuses();
                          },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(isSmall ? 'Nueva' : 'Nueva Excusa'),
                          style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MedicalExcusesList(showActions: !isApprentice),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Wellbeing reports
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.wellbeingReports, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  wellbeingAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('$e'),
                    data: (reports) => reports.isEmpty
                        ? const Text('No hay reportes registrados')
                        : Column(
                            children: reports.map((r) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.info.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.description_rounded, color: AppColors.info),
                              ),
                              title: Text(r['type'] as String),
                              subtitle: Text(r['notes'] as String),
                              trailing: Chip(
                                label: Text(r['status'] as String, style: const TextStyle(fontSize: 12)),
                                backgroundColor: AppColors.success.withValues(alpha: 0.1),
                              ),
                            )).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
