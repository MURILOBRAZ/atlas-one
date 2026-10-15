import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../constants/app_spacing.dart';

/// Marca "Atlas One" exibida no topo do aplicativo.
class AtlasLogo extends StatelessWidget {
  const AtlasLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          ),
          child: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Text.rich(
          TextSpan(
            text: 'Atlas',
            children: [
              TextSpan(
                text: ' One',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ],
          ),
          style: theme.textTheme.titleLarge,
        ),
      ],
    );
  }
}
