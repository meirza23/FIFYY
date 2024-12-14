import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/resources/movie_api_provider.dart';

class Repository {
  final movieapiprovider = MovieApiProvider();

  Future<ItemModel> fetchAllMovies() =>
      movieapiprovider.fetchPopularMovieList();
  Future<ItemModel> fetchAllTopRatedMovies() =>
      movieapiprovider.fetchTopRatedMovieList();
  Future<ItemModel> fetchAllUpcomingMovies() =>
      movieapiprovider.fetchUpcomingMovieList();
  Future<ItemModel> fetchAllNowPlayingMovies() =>
      movieapiprovider.fetchNowPlayingMovieList();
  Future<ItemModel> fetchInterstellar() => movieapiprovider.fetchInterstellar();
  Future<GenreModel> fetchAllGenres() => movieapiprovider.fetchGenresList();
}
