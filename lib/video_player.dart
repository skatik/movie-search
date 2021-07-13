import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  //Video Player screen
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoScreen> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    setLandscape();
    _controller = VideoPlayerController.network(
      //initializing the video url
        'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
  }

  Future setLandscape() async {
    //set the Orientation landscape mode
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    //dispose landscape mode
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: Stack(
                  children: [
                    if (_controller!.value.isBuffering)
                      Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                    VideoPlayer(_controller!),
                  ],
                ),
              )
            : Container(
              // this screen will show when video is initializing
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ))),
      ),
      floatingActionButton: FloatingActionButton(
        // button for video play and pause
        // it could be in better design
        onPressed: () {
          setState(() {
            _controller!.value.isPlaying
                ? _controller!.pause()
                : _controller!.play();
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
