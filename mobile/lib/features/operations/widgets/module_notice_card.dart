import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

/// Aviso de que o módulo de Operações ainda está em expansão.
class ModuleNoticeCard extends StatelessWidget {
  const ModuleNoticeCard({super.key});

  static const _upcomingFeatures = [
    'Consulta completa',
    'Detalhes da carga',
    'Registro de operações',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.construction_outlined, color: primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Módulo em expansão',
                style: theme.textTheme.titleSmall?.copyWith(color: primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Novas funcionalidades de gestão de operações estão sendo '
            'desenvolvidas e serão liberadas nas próximas versões do Atlas One.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final feature in _upcomingFeatures)
                Chip(
                  label: Text(feature),
                  labelStyle: theme.textTheme.labelSmall,
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                  backgroundColor: theme.colorScheme.surface,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
