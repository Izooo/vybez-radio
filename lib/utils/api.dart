import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vybez_radio/models/playlist.dart';
import 'package:vybez_radio/models/video.dart';


class API {

  static const String baseUrl = "https://www.standardmedia.co.ke/vybez_radio_app/api";

  static Future<http.Response> socialSignIn({
    String? email,
    String? providerID,
    String? name,
    String? provider,
    String? phoneNumber,
    String? location,
    String? yearOfBirth,
    String? gender,
  }) {
    String endpoint = '$baseUrl/create-user';

    print("user login");

    return http.post(Uri.parse(endpoint), body: {
      'email': email,
      'name': name,
      'id': providerID,
      'provider': provider,
      'phone_number': phoneNumber,
      'location': location,
      'year_of_birth': yearOfBirth,
      'gender': gender

    });
  }

  static Future<List<Playlist>> getPlaylists() async {
    String endpoint = '$baseUrl/youtube/playlist';
    List<Playlist> playlist = [];



    var result = await http.get(Uri.parse(endpoint));

    var responseBody = result.body;

    List jsonResponse = json.decode(responseBody);

    for (var playlistElement in jsonResponse) {
      playlist.add(Playlist.fromJson(playlistElement));
    }
    print("The playlists are  ${playlist[1].title}");

    print("The playlists are  $playlist");

    return playlist;

  }

  static Future<List<Video>> getVideos({
    required String playlistId
  }) async {

    String endpoint = '$baseUrl/youtube/videos';
    List<Video> videos = [];

    var result = await http.post(Uri.parse(endpoint), body: {
      'playlistId': playlistId
    });
    var responseBody = result.body;

    List jsonResponse = json.decode(responseBody);

    for (var video in jsonResponse) {
      videos.add(Video.fromJson(video));
    }

    print("The videos $videos");
    return videos;

  }

  static Future<http.Response> profileUpdate({
    required String email,
    required String providerID,
    required String phoneNumber,
    required String name,
    required String provider,
  }) {
    String endpoint = '$baseUrl/create-user';

    return http.post(Uri.parse(endpoint), body: {
      'email': email,
      'name': name,
      'id': providerID,
      'provider': provider,
    });
  }

}