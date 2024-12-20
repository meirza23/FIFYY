import 'package:fify/models/item_model.dart';
import 'package:fify/ui/colors.dart';
import 'package:fify/ui/home_screen.dart';
import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  Result data;
  MovieDetail(this.data);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentPage(widget.data),
    );
  }
}

class ContentPage extends StatefulWidget {
  Result data;
  ContentPage(this.data, {super.key});

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
            top: 340,
            child: Container(
              width: width,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(stops: const [
                  0.1,
                  0.3,
                  0.6,
                  0.9
                ], colors: [
                  bgColor,
                  bgColor.withOpacity(0.9),
                  bgColor.withOpacity(0.6),
                  bgColor.withOpacity(0.3),
                  bgColor.withOpacity(0.01),
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
