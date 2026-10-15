import 'package:flutter/foundation.dart';

/// Configuração de acesso à Atlas API.
///
/// Este é o ÚNICO lugar do aplicativo que conhece o endereço do backend.
/// O aplicativo nunca acessa o banco de dados diretamente.
class ApiConfig {
  ApiConfig._();

  static const int _port = 3333;

  /// Permite sobrescrever a URL na execução, útil para dispositivos físicos:
  /// `flutter run --dart-define=API_BASE_URL=http://192.168.0.10:3333`
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) {
      return _baseUrlOverride;
    }

    // O navegador acessa a API no próprio computador.
    if (kIsWeb) {
      return 'http://localhost:$_port';
    }

    // No emulador Android, 10.0.2.2 aponta para o computador que o executa.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$_port';
    }

    return 'http://localhost:$_port';
  }

  /// Tempo máximo de espera por uma resposta da API.
  static const Duration requestTimeout = Duration(seconds: 10);
}
