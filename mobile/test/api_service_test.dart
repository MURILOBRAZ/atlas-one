import 'dart:convert';

import 'package:atlas_one/data/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('retorna o JSON decodificado quando a resposta é de sucesso', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({'status': 'ok'}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final result = await ApiService(client: client).get('/api/health');

    expect(result, {'status': 'ok'});
  });

  test('usa a mensagem de erro enviada pela API', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({'message': 'Funcionário não encontrado.'}),
        404,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    expect(
      () => ApiService(client: client).get('/api/profile'),
      throwsA(
        isA<ApiException>()
            .having((e) => e.message, 'message', 'Funcionário não encontrado.')
            .having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });

  test('converte falha de conexão em mensagem amigável', () async {
    final client = MockClient((request) async {
      throw http.ClientException('Connection refused');
    });

    expect(
      () => ApiService(client: client).get('/api/dashboard'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          contains('Não foi possível conectar'),
        ),
      ),
    );
  });
}
