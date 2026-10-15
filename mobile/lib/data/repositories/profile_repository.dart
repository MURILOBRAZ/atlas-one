import '../../models/employee.dart';
import '../services/api_service.dart';

class ProfileRepository {
  ProfileRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<Employee> fetchProfile() async {
    final json = await _apiService.get('/api/profile');
    return Employee.fromJson(json as Map<String, dynamic>);
  }

  /// Envia as alterações para a API, que as grava no banco de dados.
  /// Retorna o perfil atualizado.
  Future<Employee> updateProfile({
    required String name,
    required String phone,
    required String jobTitle,
  }) async {
    final json = await _apiService.put('/api/profile', {
      'name': name,
      'phone': phone,
      'jobTitle': jobTitle,
    });
    return Employee.fromJson(json as Map<String, dynamic>);
  }
}
