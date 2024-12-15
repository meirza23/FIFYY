import 'package:fify/blocs/movies_bloc.dart';
import 'package:fify/models/item_model.dart';
import 'package:fify/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarIconBrightness: Brightness.light));

    return Scaffold(
      body: ContentPage(),
    );
  }
}

class ContentPage extends StatefulWidget {
  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    bloc.fetchAllMovies();
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 50),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: bgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Text(
                'Search',
                style: TextStyle(
                    fontFamily: 'SubstanceMedium',
                    fontSize: 30,
                    color: Colors.white),
              ),
              SizedBox(
                height: 6,
              ),
              TextField(
                style: TextStyle(color: textColor, fontSize: 28),
                decoration: new InputDecoration.collapsed(
                    hintText: 'Movie,Actors,Directors...',
                    hintStyle: TextStyle(color: textColor, fontSize: 28)),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 28,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: new Text(
                        'Recent',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    Positioned(
                      top: 3,
                      right: 20,
                      child: new Text(
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
              StreamBuilder(
                  stream: bloc.allMovies,
                  builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width: 200,
                        height: 200,
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: new Text('Bisiler yanlis'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }
}
