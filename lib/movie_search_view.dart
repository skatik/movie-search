import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:movie_search/constant.dart';
import 'package:movie_search/details_page.dart';
import 'package:movie_search/model/movie_model.dart';
import 'package:movie_search/model/movies_search_model.dart';
import 'package:movie_search/service/api_service.dart';

class MovieSearchView extends StatefulWidget {
  @override
  _MovieSearchViewState createState() => _MovieSearchViewState();
}

class _MovieSearchViewState extends State<MovieSearchView> {
  List<MovieSearchModel> movielist = [];
  bool _loading = false;
  TextEditingController queryController = TextEditingController();
  @override
  void initState() {
    // getMovies();
    super.initState();
  }

  getMovies() async {
    MoviesSearch movies = MoviesSearch();
    await movies.getMovies(queryController.text.replaceAll(' ', '+'));
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoTextField(
                      controller: queryController,
                      placeholder: 'Search for movies',
                  onEditingComplete: () {
                          setState(() {
                            _loading = true;
                          });
                          FocusScope.of(context).requestFocus(FocusNode());
                          getMovies();
                        } ,
                      prefix: IconButton(
                          onPressed: () {
                            queryController.clear();
                          },
                          icon: Icon(Icons.clear)),
                      suffix: IconButton(
                        color: Colors.blue,
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _loading = true;
                          });
                          FocusScope.of(context).requestFocus(FocusNode());
                          getMovies();
                        },
                      ),
                    ),
                  ),
                  if (_loading) CircularProgressIndicator(),
                  if (movielist.isEmpty) Center(child: Text("No data found")),
                  if (movielist.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: ListView.builder(
                          itemCount: movielist.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MovieSearchTile(
                              movielist: movielist[index],
                              imgUrl: movielist[index].posterPath == null
                                  ? noImage
                                  : baseUrl + movielist[index].posterPath!,
                              releaseDate: movielist[index].release_date,
                              title: movielist[index].title,
                              overview: movielist[index].overview,
                              voteAverage: movielist[index].voteAverage,
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

class MovieSearchTile extends StatelessWidget {
  final MovieSearchModel? movielist;
  final String? imgUrl, title, releaseDate, overview;
  var voteAverage;

  MovieSearchTile(
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
