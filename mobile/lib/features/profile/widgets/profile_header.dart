import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/employee.dart';

/// Avatar, nome e cargo do funcionário.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.navy,
          child: Text(
            employee.initials,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          employee.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          employee.jobTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
