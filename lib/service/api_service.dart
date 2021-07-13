import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_search/constant.dart';
import 'package:movie_search/model/movie_model.dart';
import 'package:movie_search/model/movies_search_model.dart';

class Movies {
  // this is for initial movies in home page
  List<MovieModel> movies = [];

  Future<void> getMovies() async {
    // String url =
    //     "https://api.themoviedb.org/3/movie/popular?api_key=$api_key&language=en-US&page=1";
    //'https://api.themoviedb.org/3/search/movie?api_key=$api_key&query=Jack+Reacher'

    var response =
        await http.get(Uri.https('api.themoviedb.org', '/3/movie/popular', {
      //api_key coming from constant file
      "api_key": api_key,
      // "language": "en-US",
      // "page": "2"
    }));

    var jsonData = jsonDecode(response.body);

    jsonData["results"].forEach((element) {
      MovieModel article = MovieModel(
        title: element['title'] ?? '',
        overview: element['overview'] ?? '',
        posterPath: 'https://image.tmdb.org/t/p/w500' + element['poster_path'],
        original_language: element['original_language'] ?? '',
        release_date: element['release_date'] ?? '',
        voteAverage: element['vote_average'],
      );
      movies.add(article);
    });
  }
}

class MoviesSearch {
  // search movies get here
  List<MovieSearchModel> movies = [];

  Future<void> getMovies(String query) async {
    String url =
        'https://api.themoviedb.org/3/search/movie?api_key=$api_key&query=$query'; //api_key coming from constant file
    //'https://api.themoviedb.org/3/search/movie?api_key=$api_key&query=Jack+Reacher'

    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    jsonData["results"].forEach((element) {
      MovieSearchModel article = MovieSearchModel(
        title: element['title'] ?? '',
        overview: element['overview'] ?? '',
        posterPath: element['poster_path'],
        original_language: element['original_language'] ?? '',
        release_date: element['release_date'] ?? '',
        voteAverage: element['vote_average'],
      );
      movies.add(article);
    });
  }
}
