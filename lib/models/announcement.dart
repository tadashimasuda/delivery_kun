class Announcement {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final bool read;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.read
  });

  Announcement.fromJson(Map<String, dynamic> json)
      : id = json['data']['id'],
        title = json['data']['title'],
        description = json['data']['description'],
        createdAt = json['data']['createdAt'],
        read = json['data']['read'];
}