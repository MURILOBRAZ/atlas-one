import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/distribution_center.dart';

/// Faixa de destaque com a situação geral da rede de centros de distribuição.
class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key, required this.centers});

  final List<DistributionCenter> centers;

  int get _centersRequiringAttention => centers
      .where((center) => center.status != DistributionCenterStatus.normal)
      .length;

  String get _statusMessage {
    final count = _centersRequiringAttention;
    if (count == 0) {
      return 'Todas as unidades operando normalmente';
    }
    if (count == 1) {
      return '1 unidade requer atenção';
    }
    return '$count unidades requerem atenção';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allNormal = _centersRequiringAttention == 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg + 4),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.hub_outlined, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rede Atlas · ${centers.length} centros monitorados',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _statusMessage,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            allNormal ? Icons.check_circle : Icons.error,
            color: allNormal ? AppColors.success : AppColors.warning,
          ),
        ],
      ),
    );
  }
}
