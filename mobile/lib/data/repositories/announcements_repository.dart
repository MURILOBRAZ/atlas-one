import '../../models/announcement.dart';
import '../services/api_service.dart';

class AnnouncementsRepository {
  AnnouncementsRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<Announcement>> fetchAnnouncements() async {
    final json = await _apiService.get('/api/announcements');
    return (json as List<dynamic>)
        .map((item) => Announcement.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
