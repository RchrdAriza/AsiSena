import 'package:flutter/material.dart';
import '../../shared/models/role.dart';
import '../../core/constants/app_strings.dart';

class AppSidebar extends StatelessWidget {
  final Role role;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool expanded;
  final VoidCallback? onToggleExpanded;

  const AppSidebar({
    super.key,
    required this.role,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.expanded = true,
    this.onToggleExpanded,
  });

  List<_NavItem> get _navItems {
    final items = <_NavItem>[
      const _NavItem(icon: Icons.dashboard_rounded, label: AppStrings.dashboard),
    ];

    if (role == Role.admin || role == Role.instructor) {
      items.add(const _NavItem(icon: Icons.health_and_safety_rounded, label: AppStrings.studentHealth));
    }
    if (role == Role.apprentice) {
      items.add(const _NavItem(icon: Icons.monitor_heart_rounded, label: AppStrings.studentHealth));
    }

    items.addAll([
      const _NavItem(icon: Icons.smart_toy_rounded, label: AppStrings.chatbot),
      const _NavItem(icon: Icons.newspaper_rounded, label: AppStrings.news),
      const _NavItem(icon: Icons.person_rounded, label: AppStrings.profile),
    ]);

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final items = _navItems;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: expanded ? 240 : 72,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Logo / App name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.school_rounded, color: colorScheme.primary, size: 32),
                if (expanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.appName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: colorScheme.outline.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 8),
          // Nav items
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = index == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Material(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onDestinationSelected(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                            if (expanded) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Toggle button
          if (onToggleExpanded != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: onToggleExpanded,
                icon: Icon(
                  expanded ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});
}
