class Playlist {
  Playlist({
    required this.id,
    required this.playlistId,
    required this.title,
    required this.videoThumbnail,
    required this.videoCount,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String playlistId;
  String title;
  String videoThumbnail;
  String videoCount;
  DateTime publishedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
    id: json["id"],
    playlistId: json["playlistId"],
    title: json["title"],
    videoThumbnail: json["videoThumbnail"],
    videoCount: json["videoCount"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "playlistId": playlistId,
    "title": title,
    "videoThumbnail": videoThumbnail,
    "videoCount": videoCount,
    "publishedAt": publishedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
