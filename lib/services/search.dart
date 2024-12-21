import 'dart:convert';
import 'package:fify/models/item_model.dart';
import 'package:http/http.dart' as http;

class BackendService {
  static Future<List<ItemModel>> getSuggestions(String query) async {
    // Eğer query boşsa, boş bir liste döndürebiliriz
    if (query.isEmpty) return [];

    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=4b93d35d5c2089b7716defdd6d32c769&query=' +
            query +
            '&page=1&include_adult=false'));

    if (response.statusCode == 200) {
      // JSON verisini parse et ve ItemModel nesnelerine dönüştür
      final Map<String, dynamic> data = json.decode(response.body);

      // `results` listesindeki her bir öğeyi `ItemModel`e dönüştür
      final List<ItemModel> items = (data['results'] as List)
          .map((item) => ItemModel.fromJson(item, false))
          .toList();

      return items; // Dönüştürülmüş listeyi döndür
    } else {
      throw Exception('Failed to load suggestions');
    }
  }
}
