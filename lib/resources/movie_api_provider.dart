import 'dart:convert';

import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:http/http.dart' show Client;

class MovieApiProvider {
  Client client = Client();
  final apiKey = "4b93d35d5c2089b7716defdd6d32c769";
  final baseUrl = "https://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchAllMoviesList(bool isRecent) async {
    // Popüler ve top rated filmleri aynı anda çekiyoruz
    final popularMoviesFuture =
        client.get(Uri.parse("$baseUrl/popular?api_key=$apiKey###&region=TR"));
    final topRatedMoviesFuture = client
        .get(Uri.parse("$baseUrl/top_rated?api_key=$apiKey###&region=TR"));

    try {
      // Her iki isteği aynı anda bekliyoruz
      final responses =
          await Future.wait([popularMoviesFuture, topRatedMoviesFuture]);

      // İki response'ı kontrol ediyoruz
      final popularMoviesResponse = responses[0];
      final topRatedMoviesResponse = responses[1];

      // Yanıtların durum kodunu kontrol ediyoruz
      if (popularMoviesResponse.statusCode == 200 &&
          topRatedMoviesResponse.statusCode == 200) {
        // JSON verilerini çözme ve debugging için basit loglama
        print('Popular Movies Response: ${popularMoviesResponse.body}');
        print('Top Rated Movies Response: ${topRatedMoviesResponse.body}');

        var popularMovies = ItemModel.fromJson(
            json.decode(popularMoviesResponse.body), isRecent);
        var topRatedMovies = ItemModel.fromJson(
            json.decode(topRatedMoviesResponse.body), isRecent);

        print('Popular Movies Length: ${popularMovies.results.length}');
        print('Top Rated Movies Length: ${topRatedMovies.results.length}');

        // Verilerin doğru bir şekilde birleştiğinden emin olmak için
        popularMovies.results.addAll(topRatedMovies.results);

        print(
            'Total Movies Length after Adding: ${popularMovies.results.length}');

        return popularMovies;
      } else {
        throw Exception("Failed to load movies");
      }
    } catch (e) {
      throw Exception("Failed to load movies: $e");
    }
  }

  Future<ItemModel> fetchPopularMovieList(bool isRecent) async {
    //print('entered');
    final response = await client
        .get(Uri.parse("$baseUrl/popular?api_key=$apiKey###&region=TR"));
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
        .get(Uri.parse("$baseUrl/top_rated?api_key=$apiKey###&region=TR"));
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
        .get(Uri.parse("$baseUrl/upcoming?api_key=$apiKey###&region=TR"));
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
        .get(Uri.parse("$baseUrl/now_playing?api_key=$apiKey###&region=TR"));
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
