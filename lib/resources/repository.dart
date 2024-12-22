import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/resources/movie_api_provider.dart';

class Repository {
  final movieapiprovider = MovieApiProvider();

  Future<ItemModel> fetchAllPopularMovies() =>
      movieapiprovider.fetchPopularMovieList(false);
  Future<ItemModel> fetchAllTopRatedMovies() =>
      movieapiprovider.fetchTopRatedMovieList(false);
  Future<ItemModel> fetchAllUpcomingMovies() =>
      movieapiprovider.fetchUpcomingMovieList(false);
  Future<ItemModel> fetchAllNowPlayingMovies() =>
      movieapiprovider.fetchNowPlayingMovieList(true);
  Future<GenreModel> fetchAllGenres() => movieapiprovider.fetchGenresList();
}
