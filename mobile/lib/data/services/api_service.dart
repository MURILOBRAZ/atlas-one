import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';

/// Erro amigável retornado quando uma chamada à API falha.
/// A mensagem pode ser exibida diretamente para o usuário.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Responsável por toda a comunicação HTTP com a Atlas API.
///
/// Os widgets não usam esta classe diretamente: eles chamam os
/// repositories, que por sua vez usam o [ApiService].
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String path) {
    return _send(() => _client.get(_buildUri(path), headers: _headers));
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) {
    return _send(
      () => _client.put(
        _buildUri(path),
        headers: _headers,
        body: jsonEncode(body),
      ),
    );
  }

  Uri _buildUri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  /// Executa a requisição e converte falhas em [ApiException].
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    final http.Response response;

    try {
      response = await request().timeout(ApiConfig.requestTimeout);
    } on TimeoutException {
      throw const ApiException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Não foi possível conectar ao servidor. Verifique sua conexão.',
      );
    }

    final body = _decodeBody(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException(
      _extractErrorMessage(body) ??
          'Erro inesperado no servidor (código ${response.statusCode}).',
      statusCode: response.statusCode,
    );
  }

  dynamic _decodeBody(http.Response response) {
    if (response.bodyBytes.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw ApiException(
        'O servidor retornou uma resposta inválida.',
        statusCode: response.statusCode,
      );
    }
  }

  /// A Atlas API devolve erros no formato `{ "message": "..." }`.
  String? _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic> && body['message'] is String) {
      return body['message'] as String;
    }
    return null;
  }
}
