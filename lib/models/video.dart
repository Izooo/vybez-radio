import 'dart:convert';

class Video {
  Video({
    required this.title,
    required this.description,
    required this.videoThumbnail,
    required this.videoId,
    required this.publishedAt,
    required this.playlistId,
    required this.createdAt,
    required this.updatedAt,
  });

  String title;
  String description;
  String videoThumbnail;
  String videoId;
  DateTime publishedAt;
  String playlistId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    title: json["title"],
    description: json["description"],
    videoThumbnail: json["videoThumbnail"],
    videoId: json["videoId"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    playlistId: json["playlistId"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "videoThumbnail": videoThumbnail,
    "videoId": videoId,
    "publishedAt": publishedAt.toIso8601String(),
    "playlistId": playlistId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}