/// Escala de espaçamentos usada em todo o aplicativo.
///
/// Prefira estes valores a números soltos (ex.: `SizedBox(height: 13)`),
/// para manter o layout consistente entre as telas.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Largura máxima do conteúdo em telas grandes (ex.: navegador).
  static const double maxContentWidth = 720;
}

/// Raios de borda padrão.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
}
