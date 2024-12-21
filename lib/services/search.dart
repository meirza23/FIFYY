import 'package:fify/models/item_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static Future<List<ItemModel>> getSuggestions(String query) async {
    if (query.isEmpty) return [];

    final response = await http.get(
      Uri.parse(
        "https://api.themoviedb.org/3/search/movie?api_key=4b93d35d5c2089b7716defdd6d32c769&query=$query",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      return results.map((json) => ItemModel.fromJson(json, false)).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
