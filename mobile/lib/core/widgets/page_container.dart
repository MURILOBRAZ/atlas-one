import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';

/// Centraliza o conteúdo e limita sua largura em telas grandes
/// (ex.: navegador), evitando cards esticados de ponta a ponta.
class PageContainer extends StatelessWidget {
  const PageContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          child: child,
        ),
      ),
    );
  }
}
