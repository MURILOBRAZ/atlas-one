import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/metric_card.dart';
import '../../../models/dashboard_summary.dart';

/// Os quatro indicadores principais do dia, organizados em duas linhas.
class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key, required this.summary});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(
          MetricCard(
            icon: Icons.local_shipping_outlined,
            label: 'Operações ativas',
            value: '${summary.activeOperations}',
            color: AppColors.blue,
          ),
          MetricCard(
            icon: Icons.inventory_2_outlined,
            label: 'Entregas hoje',
            value: '${summary.deliveriesToday}',
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildRow(
          MetricCard(
            icon: Icons.report_problem_outlined,
            label: 'Ocorrências',
            value: '${summary.incidents}',
            color: AppColors.danger,
          ),
          MetricCard(
            icon: Icons.schedule_outlined,
            label: 'Dentro do prazo',
            value: '${summary.onTimePercentage}%',
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  /// Coloca dois cards lado a lado, com a mesma altura.
  Widget _buildRow(Widget left, Widget right) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: right),
        ],
      ),
    );
  }
}
