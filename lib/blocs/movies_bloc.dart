import 'package:fify/models/item_model.dart';
import 'package:rxdart/rxdart.dart';

import '../resources/repository.dart';

class MoviesBloc {
  final repo = Repository();

  final movieFetcher = PublishSubject<ItemModel>();
  final movieFetcher2 = PublishSubject<ItemModel>();
  final movieFetcher3 = PublishSubject<ItemModel>();
  final movieFetcher4 = PublishSubject<ItemModel>();
  final movieFetcher5 = PublishSubject<ItemModel>();

  Stream<ItemModel> get allMovies => movieFetcher.stream;
  Stream<ItemModel> get allTopRatedMovies => movieFetcher2.stream;
  Stream<ItemModel> get allUpcomingMovies => movieFetcher3.stream;
  Stream<ItemModel> get allNowPlayingMovies => movieFetcher4.stream;
  Stream<ItemModel> get allPopularMovies => movieFetcher5.stream;
  fetchAllMovies() async {
    // Popüler ve en yüksek puanlı filmleri aynı anda çekiyoruz
    final popularMovies = await repo.fetchAllPopularMovies();
    final topRatedMovies = await repo.fetchAllTopRatedMovies();

    // Her iki listeyi birleştiriyoruz
    popularMovies.results.addAll(topRatedMovies.results);
    // Birleştirilmiş listeyi döndürüyoruz
    return popularMovies;
  }

  fetchAllPopularMovies() async {
    ItemModel itemModel = await repo.fetchAllPopularMovies();
    movieFetcher.sink.add(itemModel);
  }

  fetchAllTopRatedMovies() async {
    ItemModel itemModel = await repo.fetchAllTopRatedMovies();
    movieFetcher2.sink.add(itemModel);
  }

  fetchAllUpcomingMovies() async {
    ItemModel itemModel = await repo.fetchAllUpcomingMovies();
    movieFetcher3.sink.add(itemModel);
  }

  fetchAllNowPlayingMovies() async {
    ItemModel itemModel = await repo.fetchAllNowPlayingMovies();
    movieFetcher4.sink.add(itemModel);
  }

  dispose() {
    movieFetcher.close();
    movieFetcher2.close();
    movieFetcher3.close();
    movieFetcher4.close();
    movieFetcher5.close();
  }
}

final bloc = MoviesBloc();
