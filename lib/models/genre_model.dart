// ignore_for_file: prefer_interpolation_to_compose_strings

class GenreModel {
  List<ResultGenre> results = [];

  GenreModel.fromJson(Map<String, dynamic> parsedJson) {
    List<ResultGenre> temp = [];

    for (var i = 0; i < parsedJson['genres'].length; i++) {
      ResultGenre result = ResultGenre(parsedJson['genres'][i]);
      temp.add(result);
    }
    results = temp;
  }

  List<ResultGenre> get getGenres => results;

  // Modify the method to retrieve genre name by ID
  String getGenreNameById(int id) {
    var genre = results.firstWhere((result) => result.id == id,
        orElse: () => ResultGenre({'id': -1, 'name': 'Unknown'}));
    return genre.name;
  }

  String getGenre(List<int> ids) {
    ids = ids.toSet().toList();
    String myGenre = "";

    for (var i = 0; i < ids.length; i++) {
      myGenre += results.where((user) => user.id == ids[i]).first.name + ", ";
    }

    myGenre = myGenre.substring(0, myGenre.length - 2);
    return myGenre;
  }
}

class ResultGenre {
  late int id;
  late String name;

  ResultGenre(result) {
    id = result['id'];
    name = result['name'].toString();
  }

  String get get_name => name;
  int get get_id => id;
}
