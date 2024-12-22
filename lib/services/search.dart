import 'dart:convert';
import 'package:fify/models/item_model.dart';
import 'package:http/http.dart' as http;

class BackendService {
  static Future<List<Result>> getSuggestions(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=4b93d35d5c2089b7716defdd6d32c769&query=$query&page=1&include_adult=false'));

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if 'results' is empty
        if (data['results'] == null || (data['results'] as List).isEmpty) {
          print('No results found');
          return [];
        }

        // Parsing results into Result
        final List<Result> items = (data['results'] as List).map((item) {
          return Result.fromJson(item); // Directly map to Result
        }).toList();

        return items;
      } catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
