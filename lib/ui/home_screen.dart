import 'package:fify/blocs/movies_bloc.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: ContentPage(),
    );
  }
}

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 50),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: bgColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'Search',
                  style: TextStyle(
                    fontFamily: 'SubstanceMedium',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                TextField(
                  style: TextStyle(color: textColor, fontSize: 28),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Movie, Actors, Directors...',
                    hintStyle: TextStyle(color: textColor, fontSize: 28),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Text(
                          'Recent',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3,
                        right: 20,
                        child: Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RecentMovies(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Text(
                          'Top Rated',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        child: Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TopRatedMovies(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 28,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Text(
                          'Upcoming',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        child: Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UpcomingMovies(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ItemsLoad extends StatefulWidget {
  final AsyncSnapshot<ItemModel> snapshot;
  const ItemsLoad(this.snapshot, {Key? key}) : super(key: key);

  @override
  _ItemsLoadState createState() => _ItemsLoadState();
}

class _ItemsLoadState extends State<ItemsLoad> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, int index) {
        final movie = widget.snapshot.data?.results?[index];
        if (movie == null) {
          return SizedBox.shrink();
        }
        return Row(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 300.0,
                minWidth: MediaQuery.of(context).size.width * 0.40,
                maxHeight: 300.0,
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

class RecentMovies extends StatefulWidget {
  const RecentMovies({Key? key}) : super(key: key);

  @override
  _RecentMoviesState createState() => _RecentMoviesState();
}

class _RecentMoviesState extends State<RecentMovies> {
  void initState() {
    super.initState();
    bloc.fetchAllNowPlayingMovies();
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
            height: 300,
            child: ItemsLoad(snapshot),
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
            height: 300,
            child: ItemsLoad(snapshot),
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
            height: 300,
            child: ItemsLoad(snapshot),
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
