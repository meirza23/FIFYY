import 'package:fify/blocs/genre_bloc.dart';
import 'package:fify/models/genre_model.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/ui/colors.dart';
import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  final Result data;
  MovieDetail(this.data);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PreloadContent(data: widget.data),
    );
  }
}

class PreloadContent extends StatefulWidget {
  final Result data;
  const PreloadContent({required this.data, super.key});

  @override
  State<PreloadContent> createState() => _PreloadContentState();
}

class _PreloadContentState extends State<PreloadContent> {
  @override
  Widget build(BuildContext context) {
    bloc_genres.fetchAllGenres();
    return StreamBuilder(
      stream: bloc_genres.allGenres,
      builder: (context, AsyncSnapshot<GenreModel> snapshot) {
        if (snapshot.hasData) {
          return ContentPage(
            data: widget.data,
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

class ContentPage extends StatefulWidget {
  final Result data;
  final AsyncSnapshot<GenreModel>? snapshotGenres;

  ContentPage({required this.data, this.snapshotGenres, super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: bgColor,
      child: Stack(
        children: <Widget>[
          Container(
            height: 410,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                image: NetworkImage(
                  widget.data.posterPath.replaceAll("w185", "w400"),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Image.asset('assets/images/left-arrow.png', width: 30),
              onPressed: () {
                Navigator.pop(context); // Bir önceki sayfaya yönlendirir
              },
            ),
          ),
          Positioned(
            top: 330,
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 8),
              width: width,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                  colors: [
                    bgColor.withOpacity(0.0),
                    bgColor.withOpacity(0.2),
                    bgColor.withOpacity(0.5),
                    bgColor.withOpacity(0.7),
                    bgColor,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 280,
            child: Container(
              width: width - 20,
              child: Text(
                widget.data.title,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 350,
            child: GetGenres(
              snapshotGenres: widget.snapshotGenres,
              data: this.widget.data,
            ),
          ),
          Positioned(
            left: 20,
            top: 430,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 0.5,
              color: textColor,
            ),
          ),
          Positioned(
            left: 20,
            top: 430,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                widget.data.popularity.toString(),
                                style: TextStyle(
                                    color: popularityColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              ),
                              new Text(
                                'Popularity',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: iconColor,
                                size: 32,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: widget.data.voteAverage.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                          ),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 40) / 3,
                        height: 120,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                widget.data.voteCount,
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                              new Text(
                                'Vote Count',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 550,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 0.5,
              color: textColor,
            ),
          ),
          Positioned(
            left: 20,
            top: 560,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Text(
                    'Description',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  new Text(
                    widget.data.overview,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                    ),
                    maxLines: 11,
                    overflow: TextOverflow.ellipsis, // Max 3 satır göster
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GetGenres extends StatefulWidget {
  final AsyncSnapshot<GenreModel>? snapshotGenres;
  final Result data;

  const GetGenres({this.snapshotGenres, required this.data, super.key});

  @override
  State<GetGenres> createState() => _GetGenresState();
}

class _GetGenresState extends State<GetGenres> {
  @override
  Widget build(BuildContext context) {
    if (widget.snapshotGenres == null || !widget.snapshotGenres!.hasData) {
      return const CircularProgressIndicator();
    }

    final genreIdsList = widget.data.genreIds; // genreIds zaten liste olmalı
    final genres = widget.snapshotGenres?.data?.getGenre(genreIdsList);

    // genres null veya boşsa, kullanıcıya bir şeyler gösterelim
    if (genres == null || genres.isEmpty) {
      return const Center(
        child: Text('No genres available'),
      );
    }

    // Eğer genres bir String ise, split kullanarak liste haline getiriyoruz
    List<String> genreList = genres.split(','); // Virgülle ayırıyoruz

    // genreList üzerinde döngü ile RowItems widget'larını oluşturuyoruz
    List<Widget> genreWidgets = [];
    for (var genre in genreList) {
      genreWidgets
          .add(RowItems(genre.trim())); // trim() ile boşlukları temizliyoruz
    }

    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 8,
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: genreWidgets,
      ),
    );
  }

  // RowItems widget'ı
  Widget RowItems(String genreName) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          genreName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
