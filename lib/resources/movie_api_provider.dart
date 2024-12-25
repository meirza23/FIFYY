import 'dart:convert';

import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:http/http.dart' show Client;

class MovieApiProvider {
  Client client = Client();
  final apiKey = "4b93d35d5c2089b7716defdd6d32c769";
  final baseUrl = "https://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchAllMoviesList(bool isRecent) async {
    final temp = []; // Geçici liste
    for (int page = 1; page <= 50; page++) {
      final response = await client.get(
        Uri.parse("$baseUrl/popular?api_key=$apiKey&page=$page"),
      );

      if (response.statusCode == 200) {
        // Gelen JSON'daki "results" kısmını geçici listeye ekle
        final jsonData = json.decode(response.body);
        temp.addAll(jsonData["results"]);
      } else {
        throw Exception("Failed to load movies on page $page");
      }
    }

    // Tüm veriler birleştirildikten sonra ItemModel'e dönüştür
    final combinedData = {"results": temp}; // Tek bir JSON formatı oluştur
    return ItemModel.fromJson(combinedData, isRecent);
  }

  Future<ItemModel> fetchPopularMovieList(bool isRecent) async {
    final temp = []; // Geçici liste
    for (int page = 1; page <= 5; page++) {
      final response = await client.get(
        Uri.parse("$baseUrl/popular?api_key=$apiKey&page=$page"),
      );

      if (response.statusCode == 200) {
        // Gelen JSON'daki "results" kısmını geçici listeye ekle
        final jsonData = json.decode(response.body);
        temp.addAll(jsonData["results"]);
      } else {
        throw Exception("Failed to load movies on page $page");
      }
    }

    // Tüm veriler birleştirildikten sonra ItemModel'e dönüştür
    final combinedData = {"results": temp}; // Tek bir JSON formatı oluştur
    return ItemModel.fromJson(combinedData, isRecent);
  }

  Future<ItemModel> fetchTopRatedMovieList(bool isRecent) async {
    final temp = []; // Geçici liste
    for (int page = 1; page <= 5; page++) {
      final response = await client.get(
        Uri.parse("$baseUrl/top_rated?api_key=$apiKey&page=$page"),
      );

      if (response.statusCode == 200) {
        // Gelen JSON'daki "results" kısmını geçici listeye ekle
        final jsonData = json.decode(response.body);
        temp.addAll(jsonData["results"]);
      } else {
        throw Exception("Failed to load movies on page $page");
      }
    }

    // Tüm veriler birleştirildikten sonra ItemModel'e dönüştür
    final combinedData = {"results": temp}; // Tek bir JSON formatı oluştur
    return ItemModel.fromJson(combinedData, isRecent);
  }

  Future<ItemModel> fetchUpcomingMovieList(bool isRecent) async {
    final temp = []; // Geçici liste
    for (int page = 1; page <= 5; page++) {
      final response = await client.get(
        Uri.parse("$baseUrl/upcoming?api_key=$apiKey&page=$page"),
      );

      if (response.statusCode == 200) {
        // Gelen JSON'daki "results" kısmını geçici listeye ekle
        final jsonData = json.decode(response.body);
        temp.addAll(jsonData["results"]);
      } else {
        throw Exception("Failed to load movies on page $page");
      }
    }

    // Tüm veriler birleştirildikten sonra ItemModel'e dönüştür
    final combinedData = {"results": temp}; // Tek bir JSON formatı oluştur
    return ItemModel.fromJson(combinedData, isRecent);
  }

  Future<ItemModel> fetchNowPlayingMovieList(bool isRecent) async {
    final temp = []; // Geçici liste
    for (int page = 1; page <= 5; page++) {
      final response = await client.get(
        Uri.parse("$baseUrl/now_playing?api_key=$apiKey&page=$page"),
      );

      if (response.statusCode == 200) {
        // Gelen JSON'daki "results" kısmını geçici listeye ekle
        final jsonData = json.decode(response.body);
        temp.addAll(jsonData["results"]);
      } else {
        throw Exception("Failed to load movies on page $page");
      }
    }

    // Tüm veriler birleştirildikten sonra ItemModel'e dönüştür
    final combinedData = {"results": temp}; // Tek bir JSON formatı oluştur
    return ItemModel.fromJson(combinedData, isRecent);
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
