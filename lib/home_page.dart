import 'dart:convert';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:movie_search/details_page.dart';
import 'package:movie_search/model/movie_model.dart';
import 'package:movie_search/movie_search_view.dart';
import 'package:movie_search/service/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MovieModel>? movielist;
  bool _loading = true;

  @override
  void initState() {
    getMovies();
    super.initState();
  }

  void getMovies() async {
    Movies movies = Movies();
    await movies.getMovies();
    movielist = movies.movies;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Home',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            // this textfield do not take any inputs
                            onTap: () {
                              // ontap navigate to movie search page
                              Get.to(MovieSearchView());
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            decoration: InputDecoration(
                              hintText: 'Search for movies',
                              prefixIcon: Icon(Icons.search),
                              // suffix: Icon(Icons.clear),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          child: ListView.builder(
                              itemCount: movielist!.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MovieTile(
                                  movielist: movielist![index],
                                  imgUrl: movielist![index].posterPath,
                                  releaseDate: movielist![index].release_date,
                                  title: movielist![index].title,
                                  overview: movielist![index].overview,
                                  voteAverage: movielist![index].voteAverage,
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class MovieTile extends StatelessWidget {
  final MovieModel? movielist;
  final String? imgUrl, title, releaseDate, overview;
  var voteAverage;

  MovieTile(
      {this.movielist,
      required this.imgUrl,
      required this.releaseDate,
      required this.title,
      required this.voteAverage,
      required this.overview});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Get.to(MovieDetailsPage(movielist: movielist));
        },
        child: Container(
          // margin: EdgeInsets.only(bottom: 10, top: 10),
          // padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(6),
                  bottomLeft: Radius.circular(6))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imgUrl!,
                    height: 200,
                    width: 150,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 26,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        overview!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Release Date: ' + releaseDate!,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color:
                                voteAverage! <= 7 ? Colors.blue : Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            'Rating: ' + voteAverage!.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
