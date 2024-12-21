// ignore_for_file: prefer_interpolation_to_compose_strings

class ItemModel {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<Result> results;

  ItemModel.fromJson(Map<String, dynamic> parsedJson, bool ifRecent)
      : page = parsedJson['page'] ?? 0,
        totalPages = parsedJson['total_pages'] ?? 0,
        totalResults = parsedJson['total_results'] ?? 0,
        results = ((parsedJson['results'] as List?)
                ?.map((result) => Result.fromJson(result))
                .toList() ??
            [])
          ..sort((a, b) {
            if (ifRecent) {
              // Eğer 'ifRecent' true ise, releaseDate'e göre sıralama
              return DateTime.parse(b.releaseDate)
                  .compareTo(DateTime.parse(a.releaseDate));
            } else {
              // Eğer 'ifRecent' false ise, popülerliğe göre sıralama
              return b.popularity.compareTo(a.popularity);
            }
          });
}

class Result {
  final String _voteCount;
  final int _id;
  final bool _video;
  final double _voteAverage; // 'int' yerine 'double' kullanıyoruz.
  final String _title;
  final num
      _popularity; // 'num' olarak bırakabiliriz, ama 'int' de yapılabilir.
  final String _posterPath;
  final List<int> _genreIds;
  final String _backdropPath;
  final bool _adult;
  final String _overview;
  final String _releaseDate;

  Result.fromJson(Map<String, dynamic> json)
      : _voteCount = json['vote_count']?.toString() ?? '',
        _id = json['id'] ?? 0,
        _video = json['video'] ?? false,
        _voteAverage = (json['vote_average'] as num?)?.toDouble() ??
            0.0, // 'toDouble()' ekledik.
        _title = json['title'] ?? '',
        _popularity = json['popularity'] ?? 0,
        _posterPath =
            "https://image.tmdb.org/t/p/w185//" + (json['poster_path'] ?? ''),
        _genreIds = List<int>.from(json['genre_ids'] ?? []),
        _backdropPath = json['backdrop_path'] ?? '',
        _adult = json['adult'] ?? false,
        _overview = json['overview'] ?? '',
        _releaseDate = json['release_date'] ?? '';

  String get releaseDate => _releaseDate;
  String get overview => _overview;
  bool get isAdult => _adult;
  String get backdropPath => _backdropPath;
  List<int> get genreIds => _genreIds;
  String get posterPath => _posterPath;
  num get popularity => _popularity;
  String get title => _title;
  double get voteAverage => _voteAverage; // 'double' olarak güncellendi.
  bool get isVideo => _video;
  int get id => _id;
  String get voteCount => _voteCount;
}
