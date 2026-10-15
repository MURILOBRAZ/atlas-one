/// Comunicado interno exibido na aba "Avisos".
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.isRead,
  });

  final String id;
  final String title;
  final String description;
  final DateTime publishedAt;
  final bool isRead;

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String).toLocal(),
      isRead: json['isRead'] as bool,
    );
  }
}
