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

  const SeeAll({required this.title, required this.movieStream, Key? key})
      : super(key: key);

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
    Key? key,
  }) : super(key: key);

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
  final String title;
  final Stream<ItemModel> movieStream;

  const SeeAllPage({
    required this.title,
    required this.movieStream,
    Key? key,
  }) : super(key: key);

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
        movieContent = PopularMovies();
        break;
      case 'Top Rated Movies':
        movieContent = TopRatedMovies();
        break;
      case 'Recent Movies':
        movieContent = RecentMovies();
        break;
      case 'Upcoming Movies':
        movieContent = UpcomingMovies();
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
  const SAItemsLoad(this.snapshot, {Key? key}) : super(key: key);

  @override
  _SAItemsLoadState createState() => _SAItemsLoadState();
}

class _SAItemsLoadState extends State<SAItemsLoad> {
  @override
  Widget build(BuildContext context) {
    final sortedMovies = widget.snapshot.data?.results;
    sortedMovies?.sort((a, b) => b.popularity.compareTo(a.popularity));
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.snapshot.data?.results.length,
      itemBuilder: (context, int index) {
        final movie = sortedMovies?[index];
        if (movie == null) {
          return SizedBox.shrink();
        }
        return Row(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 300,
                minWidth: MediaQuery.of(context).size.width * 0.40,
                maxHeight: 300,
                maxWidth: MediaQuery.of(context).size.width * 0.40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(movie.posterPath),
                  ),
                  SizedBox(height: 4),
                  Text(
                    movie.title,
                    style: TextStyle(color: Colors.white),
                    maxLines: 1, // Başlık en fazla bir satırda gösterilir
                    overflow:
                        TextOverflow.ellipsis, // Fazla metni "..." ile kısaltır
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
          ],
        );
      },
    );
  }
}

class PopularMovies extends StatefulWidget {
  const PopularMovies({Key? key}) : super(key: key);

  @override
  _PopularMoviesState createState() => _PopularMoviesState();
}

class _PopularMoviesState extends State<PopularMovies> {
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
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height,
            child: SAItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class RecentMovies extends StatefulWidget {
  const RecentMovies({Key? key}) : super(key: key);

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
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height,
            child: SAItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class UpcomingMovies extends StatefulWidget {
  const UpcomingMovies({Key? key}) : super(key: key);

  @override
  _UpcomingMoviesState createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends State<UpcomingMovies> {
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
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height,
            child: SAItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class TopRatedMovies extends StatefulWidget {
  @override
  _TopRatedMoviesState createState() => _TopRatedMoviesState();
}

class _TopRatedMoviesState extends State<TopRatedMovies> {
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
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height,
            child: SAItemsLoad(snapshot),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Bir şeyler yanlış gitti'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
