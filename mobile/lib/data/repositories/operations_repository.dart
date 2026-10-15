import '../../models/operation.dart';
import '../services/api_service.dart';

class OperationsRepository {
  OperationsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  /// Retorna apenas uma pequena amostra das operações mais recentes.
  Future<List<Operation>> fetchPreview() async {
    final json = await _apiService.get('/api/operations/preview');
    return (json as List<dynamic>)
        .map((item) => Operation.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
