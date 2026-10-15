import 'package:flutter/material.dart';

/// Paleta oficial da Atlas Logistics.
///
/// As telas não devem usar essas cores diretamente sempre que houver um
/// equivalente no tema (`Theme.of(context).colorScheme`), para que o modo
/// escuro funcione automaticamente.
class AppColors {
  AppColors._();

  // Marca
  static const Color navy = Color(0xFF0B1F3A);
  static const Color navyLight = Color(0xFF16325C);
  static const Color blue = Color(0xFF1E5EFF);
  static const Color blueLight = Color(0xFF7FA6FF);

  // Neutros - tema claro
  static const Color background = Color(0xFFF4F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E7EF);
  static const Color textPrimary = Color(0xFF0F1B2D);
  static const Color textSecondary = Color(0xFF5E6B7E);

  // Neutros - tema escuro
  static const Color darkBackground = Color(0xFF0A1220);
  static const Color darkSurface = Color(0xFF121C2D);
  static const Color darkBorder = Color(0xFF223049);
  static const Color darkTextPrimary = Color(0xFFE8EDF5);
  static const Color darkTextSecondary = Color(0xFF93A1B5);

  // Estados (usados apenas para indicar situação)
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFE08A00);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = blue;
  static const Color neutral = Color(0xFF64748B);
}
