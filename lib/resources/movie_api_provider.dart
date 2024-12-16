import 'dart:convert';

import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:http/http.dart' show Client;

class MovieApiProvider {
  Client client = Client();
  final apiKey = "4b93d35d5c2089b7716defdd6d32c769";
  final baseUrl = "https://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchPopularMovieList(bool isRecent) async {
    //print('entered');
    final response = await client
        .get(Uri.parse("$baseUrl/popular?api_key=$apiKey###&region=US"));
    //print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body), isRecent);
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<ItemModel> fetchTopRatedMovieList(bool isRecent) async {
    //print('entered');
    final response = await client
        .get(Uri.parse("$baseUrl/top_rated?api_key=$apiKey###&region=US"));
    //print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body), isRecent);
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<ItemModel> fetchUpcomingMovieList(bool isRecent) async {
    //print('entered');
    final response = await client
        .get(Uri.parse("$baseUrl/upcoming?api_key=$apiKey###&region=US"));
    //print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body), isRecent);
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<ItemModel> fetchNowPlayingMovieList(bool isRecent) async {
    //print('entered');
    final response = await client
        .get(Uri.parse("$baseUrl/now_playing?api_key=$apiKey###&region=US"));
    //print(response.body.toString());
    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body), isRecent);
    } else {
      throw Exception("Failed to load movies");
    }
  }

  Future<GenreModel> fetchGenresList() async {
    //print('entered');
    final response = await client.get(Uri.parse(
        "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey"));
    //print(response.body.toString());
    if (response.statusCode == 200) {
      return GenreModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
