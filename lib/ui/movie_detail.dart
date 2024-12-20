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
            height: 360,
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
            top: 280,
            child: Container(
              padding: EdgeInsets.only(left: 20, top: 8),
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
            top: 230,
            child: Container(
              width: width - 20,
              child: Text(
                widget.data.title,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 290,
            child: GetGenres(
              snapshotGenres: widget.snapshotGenres,
              data: this.widget.data,
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
      return CircularProgressIndicator();
    }

    final genreIdsList = widget.data.genreIds; // genreIds zaten liste olmalı
    final genres = widget.snapshotGenres?.data?.getGenre(genreIdsList);

    // genres null veya boşsa, kullanıcıya bir şeyler gösterelim
    if (genres == null || genres.isEmpty) {
      return Center(
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
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
