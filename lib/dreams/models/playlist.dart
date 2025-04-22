//stuff
class Playlist {
  final String id;
  final String name;
  final List<String> videoUrls;

  Playlist({
    required this.id,
    required this.name,
    List<String>? videoUrls,
  }) : videoUrls = videoUrls ?? [];

  factory Playlist.fromMap(Map<String, dynamic> data, String docId) {
    return Playlist(
      id: docId,
      name: data['name'] as String,
      videoUrls: List<String>.from(data['videoUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'videoUrls': videoUrls,
  };
}
