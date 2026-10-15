/// Funções simples de formatação de datas em português.
class DateFormatter {
  DateFormatter._();

  static const List<String> _weekdays = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo',
  ];

  static const List<String> _months = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];

  /// Ex.: "Quinta-feira, 17 de setembro"
  static String fullDate(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _months[date.month - 1];
    return '$weekday, ${date.day} de $month';
  }

  /// Ex.: "17/09/2026 às 14:30"
  static String dateTime(DateTime date) {
    final day = _twoDigits(date.day);
    final month = _twoDigits(date.month);
    final hour = _twoDigits(date.hour);
    final minute = _twoDigits(date.minute);
    return '$day/$month/${date.year} às $hour:$minute';
  }

  /// Ex.: "há 5 minutos", "há 3 horas", "há 2 dias"
  static String relative(DateTime date, {DateTime? now}) {
    final difference = (now ?? DateTime.now()).difference(date);

    if (difference.inMinutes < 1) {
      return 'agora mesmo';
    }
    if (difference.inHours < 1) {
      return _plural(difference.inMinutes, 'minuto', 'minutos');
    }
    if (difference.inDays < 1) {
      return _plural(difference.inHours, 'hora', 'horas');
    }
    if (difference.inDays < 30) {
      return _plural(difference.inDays, 'dia', 'dias');
    }
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  static String _plural(int value, String singular, String plural) {
    return 'há $value ${value == 1 ? singular : plural}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
