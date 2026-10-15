import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/distribution_center.dart';

/// Resumo da situação de um centro de distribuição.
class DistributionCenterCard extends StatelessWidget {
  const DistributionCenterCard({super.key, required this.center});

  final DistributionCenter center;

  StatusTone get _tone {
    switch (center.status) {
      case DistributionCenterStatus.normal:
        return StatusTone.success;
      case DistributionCenterStatus.attention:
        return StatusTone.warning;
      case DistributionCenterStatus.critical:
        return StatusTone.danger;
      case DistributionCenterStatus.unknown:
        return StatusTone.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                Icons.warehouse_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(center.name, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    '${center.location} · ${center.code}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  StatusBadge(label: center.status.label, tone: _tone),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
