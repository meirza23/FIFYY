import 'package:fify/blocs/genre_bloc.dart';
import 'package:fify/blocs/movies_bloc.dart';
import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/ui/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarIconBrightness: Brightness.light));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const PreLoadContent(),
      ),
    );
  }
}

class PreLoadContent extends StatefulWidget {
  const PreLoadContent({Key? key}) : super(key: key);

  @override
  State<PreLoadContent> createState() => _PreLoadContentState();
}

class _PreLoadContentState extends State<PreLoadContent> {
  @override
  Widget build(BuildContext context) {
    bloc_genres.fetchAllGenres();
    return StreamBuilder<GenreModel>(
      stream: bloc_genres.allGenres,
      builder: (context, AsyncSnapshot<GenreModel> snapshot) {
        if (snapshot.hasData) {
          return ContentPage(snapshot);
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ContentPage extends StatefulWidget {
  final AsyncSnapshot<GenreModel> snapshotGenres;
  const ContentPage(this.snapshotGenres, {Key? key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
    bloc.fetchAllTopRatedMovies();
    bloc.fetchAllUpcomingMovies();
    bloc.fetchAllNowPlayingMovies();
    bloc.fetchInterstellar();
  }

  Widget _buildMovieStream(
    Stream<ItemModel> stream, {
    required String title,
  }) {
    return StreamBuilder<ItemModel>(
      stream: stream,
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 215,
            color: bgColor,
            child: Trends(snapshot, widget.snapshotGenres),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1330,
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<ItemModel>(
                      stream: bloc.interstellar,
                      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 320,
                            color: bgColor,
                            child: ItemsLoad(snapshot),
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Trends',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildMovieStream(bloc.allMovies, title: 'Trends'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      child: Text(
                        'Top Rated',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildMovieStream(bloc.allTopRatedMovies,
                        title: 'Top Rated'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      child: Text(
                        'Upcoming',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildMovieStream(bloc.allUpcomingMovies,
                        title: 'Upcoming'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      child: Text(
                        'Now Playing',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildMovieStream(bloc.allNowPlayingMovies,
                        title: 'Now Playing'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Trends extends StatelessWidget {
  final AsyncSnapshot<ItemModel> snapshot;
  final AsyncSnapshot<GenreModel> snapshotGenres;
  const Trends(this.snapshot, this.snapshotGenres, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data?.results.length ?? 0,
      itemBuilder: (context, index) {
        String genres = snapshotGenres.data
                ?.getGenre(snapshot.data!.results[index].genreIds) ??
            '';

        return Container(
          height: 200,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetail(snapshot.data!.results[index], genres),
                    ),
                  );
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        snapshot.data!.results[index].posterPath,
                        height: 210,
                        width: 140,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
    );
  }
}

class ItemsLoad extends StatelessWidget {
  final AsyncSnapshot<ItemModel> snapshot;
  const ItemsLoad(this.snapshot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetail(snapshot.data!.results[0],
                      ""), // Boş string kullanabilirsiniz.
                ),
              );
            },
            child: Image.network(
              'https://media.idownloadblog.com/wp-content/uploads/2014/12/interstellar-wide-space-film-movie-art-9-wallpaper.jpg',
              height: 320,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
