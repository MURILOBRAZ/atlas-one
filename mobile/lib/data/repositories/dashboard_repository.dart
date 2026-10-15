import '../../models/dashboard_summary.dart';
import '../services/api_service.dart';

class DashboardRepository {
  DashboardRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<DashboardSummary> fetchSummary() async {
    final json = await _apiService.get('/api/dashboard');
    return DashboardSummary.fromJson(json as Map<String, dynamic>);
  }
}
