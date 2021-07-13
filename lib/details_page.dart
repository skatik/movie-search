import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_search/constant.dart';
import 'package:movie_search/video_player.dart';

class MovieDetailsPage extends StatelessWidget {
  final movielist;
  const MovieDetailsPage({Key? key, this.movielist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      height: 300,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            movielist.posterPath == null
                                ? noImage
                                : baseUrl + movielist.posterPath,
                            height: 300,
                            width: 200,
                            fit: BoxFit.fill,
                          )),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(VideoScreen());
                        },
                        icon: Icon(
                          Icons.play_circle,
                          size: 60,
                        ))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Release Date: ' + movielist!.release_date!,
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
                      color: movielist!.voteAverage! <= 7
                          ? Colors.blue
                          : Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      'Rating: ' + movielist!.voteAverage!.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Text(
                  movielist!.title!,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 26,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  movielist!.overview!,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
