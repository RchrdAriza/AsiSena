import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/medical_excuse.dart';
import '../../providers/health_provider.dart';

class MedicalExcusesList extends ConsumerWidget {
  final bool showActions;

  const MedicalExcusesList({super.key, this.showActions = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final excusesAsync = ref.watch(medicalExcusesProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return excusesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (excuses) {
        if (excuses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.folder_open_rounded, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Text('No hay excusas registradas', style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
                ],
              ),
            ),
          );
        }

        return Column(
          children: excuses.map((excuse) => _ExcuseTile(
            excuse: excuse,
            dateFormat: dateFormat,
            showActions: showActions,
          )).toList(),
        );
      },
    );
  }
}

class _ExcuseTile extends ConsumerWidget {
  final MedicalExcuse excuse;
  final DateFormat dateFormat;
  final bool showActions;

  const _ExcuseTile({
    required this.excuse,
    required this.dateFormat,
    required this.showActions,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'aprobada':
        return AppColors.success;
      case 'rechazada':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'aprobada':
        return Icons.check_circle_rounded;
      case 'rechazada':
        return Icons.cancel_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = _statusColor(excuse.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: excuse.imageBytes != null ? () => _showImageDialog(context) : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_statusIcon(excuse.status), color: color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      excuse.reason,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Chip(
                    label: Text(
                      excuse.status.toUpperCase(),
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: color.withValues(alpha: 0.1),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (showActions) ...[
                    Icon(Icons.person_outline, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(excuse.studentName, style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                    const SizedBox(width: 12),
                  ],
                  Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(dateFormat.format(excuse.date), style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
                  if (excuse.imageBytes != null) ...[
                    const SizedBox(width: 12),
                    Icon(Icons.image_rounded, size: 14, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text('Ver imagen', style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    )),
                  ],
                ],
              ),
              if (excuse.notes != null && excuse.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(excuse.notes!, style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
              ],
              if (showActions && excuse.status == 'pendiente') ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => ref.read(medicalExcusesProvider.notifier)
                          .updateStatus(excuse.id, 'rechazada', excuse.studentId),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Rechazar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () => ref.read(medicalExcusesProvider.notifier)
                          .updateStatus(excuse.id, 'aprobada', excuse.studentId),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Aprobar'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.success,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(excuse.reason),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.memory(
                excuse.imageBytes!,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
