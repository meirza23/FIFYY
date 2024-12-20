// ignore_for_file: library_private_types_in_public_api

import 'package:fify/blocs/genre_bloc.dart';
import 'package:fify/models/genre_model.dart';
import 'package:fify/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/blocs/movies_bloc.dart';
import 'package:flutter/services.dart';

class SeeAll extends StatefulWidget {
  final String title;
  final Stream<ItemModel> movieStream;

  const SeeAll({required this.title, required this.movieStream, super.key});

  @override
  _SeeAllState createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: bgColor,
        child: SeeAllContent(
          title: widget.title,
          movieStream: widget.movieStream,
        ),
      ),
    );
  }
}

class SeeAllContent extends StatefulWidget {
  final String title;
  final Stream<ItemModel> movieStream;

  const SeeAllContent({
    required this.title,
    required this.movieStream,
    super.key,
  });

  @override
  State<SeeAllContent> createState() => _SeeAllContentState();
}

class _SeeAllContentState extends State<SeeAllContent> {
  @override
  Widget build(BuildContext context) {
    bloc_genres.fetchAllGenres();
    return StreamBuilder(
      stream: bloc_genres.allGenres,
      builder: (context, AsyncSnapshot<GenreModel> snapshot) {
        if (snapshot.hasData) {
          return SeeAllPage(
            title: widget.title,
            movieStream: widget.movieStream,
            snapshotGenres: snapshot,
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class SeeAllPage extends StatefulWidget {
  final AsyncSnapshot<GenreModel> snapshotGenres;
  final String title;
  final Stream<ItemModel> movieStream;

  const SeeAllPage({
    required this.title,
    required this.movieStream,
    required this.snapshotGenres,
    super.key,
  });

  @override
  _SeeAllPageState createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    // widget.title’a göre uygun class’ı çağırıyoruz
    Widget movieContent;

    switch (widget.title) {
      case 'Popular Movies':
        movieContent = PopularMovies(widget.snapshotGenres);
        break;
      case 'Top Rated Movies':
        movieContent = TopRatedMovies(widget.snapshotGenres);
        break;
      case 'Recent Movies':
        movieContent = RecentMovies(widget.snapshotGenres);
        break;
      case 'Upcoming Movies':
        movieContent = UpcomingMovies(widget.snapshotGenres);
        break;
      default:
        movieContent = const Center(
          child: Text('No content available'),
        );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, top: 50),
        color: bgColor,
        child: SingleChildScrollView(
          // Tüm içerik kaydırılabilir olacak
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 28,
                child: Stack(
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              movieContent, // İlgili sınıfı buraya ekledik
            ],
          ),
        ),
      ),
    );
  }
}

class SAItemsLoad extends StatefulWidget {
  final AsyncSnapshot<ItemModel> snapshot;
  final AsyncSnapshot<GenreModel> snapshotGenres;
  const SAItemsLoad(this.snapshot, this.snapshotGenres, {super.key});

  @override
  _SAItemsLoadState createState() => _SAItemsLoadState();
}

class _SAItemsLoadState extends State<SAItemsLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.snapshot.data?.results.length,
      itemBuilder: (context, int index) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.snapshot.data!.results[index].posterPath,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20 - 185,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 10, right: 10, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          widget.snapshot.data!.results[index].title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.snapshot.data!.results[index].releaseDate,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          widget.snapshotGenres.data!.getGenre(widget
                              .snapshot
                              .data!
                              .results[index]
                              .genreIds), // Genre adlarını virgülle ayırarak yazdırıyoruz
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: iconColor,
                              size: 28,
                            ),
                            RichText(
                              text: TextSpan(
                                text: widget
                                    .snapshot.data!.results[index].voteAverage
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                children: const <TextSpan>[
                                  TextSpan(
                                    text: '/10',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            )
          ],
        );
      },
    );
  }
}

class PopularMovies extends StatefulWidget {
  final AsyncSnapshot<GenreModel> snapshotGenres;
  PopularMovies(this.snapshotGenres, {super.key});

  @override
  _PopularMoviesState createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height - 90,
            child: SAItemsLoad(snapshot, widget.snapshotGenres),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class RecentMovies extends StatefulWidget {
  final AsyncSnapshot<GenreModel> snapshotGenres;
  const RecentMovies(this.snapshotGenres, {super.key});

  @override
  _RecentMoviesState createState() => _RecentMoviesState();
}

class _RecentMoviesState extends State<RecentMovies> {
  bool isRecent = true; // Burada 'isRecent' değişkeni tanımlandı

  @override
  void initState() {
    super.initState();
    if (isRecent) {
      bloc.fetchAllNowPlayingMovies(); // Recent filmleri getirecek
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allNowPlayingMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height - 90,
            child: SAItemsLoad(snapshot, widget.snapshotGenres),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class UpcomingMovies extends StatefulWidget {
  final AsyncSnapshot<GenreModel> snapshotGenres;
  const UpcomingMovies(this.snapshotGenres, {super.key});

  @override
  _UpcomingMoviesState createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends State<UpcomingMovies> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allUpcomingMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height - 90,
            child: SAItemsLoad(snapshot, widget.snapshotGenres),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class TopRatedMovies extends StatefulWidget {
  final AsyncSnapshot<GenreModel> snapshotGenres;
  const TopRatedMovies(this.snapshotGenres, {super.key});
  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allTopRatedMovies,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height - 90,
            child: SAItemsLoad(snapshot, widget.snapshotGenres),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
