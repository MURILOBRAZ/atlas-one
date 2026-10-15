import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../models/operation.dart';

/// Resumo visual de uma operação logística.
class OperationCard extends StatelessWidget {
  const OperationCard({super.key, required this.operation});

  final Operation operation;

  StatusTone get _tone {
    switch (operation.status) {
      case OperationStatus.completed:
        return StatusTone.success;
      case OperationStatus.inTransit:
        return StatusTone.info;
      case OperationStatus.awaitingPickup:
        return StatusTone.warning;
      case OperationStatus.delayed:
        return StatusTone.danger;
      case OperationStatus.unknown:
        return StatusTone.neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.onSurfaceVariant;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    operation.code,
                    style: theme.textTheme.titleMedium?.copyWith(
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                StatusBadge(label: operation.status.label, tone: _tone),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.trip_origin, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    operation.origin,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Icon(Icons.arrow_forward, size: 16, color: secondaryColor),
                ),
                Flexible(
                  child: Text(
                    operation.destination,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: secondaryColor),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Previsto: ${DateFormatter.dateTime(operation.scheduledDate)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: secondaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
