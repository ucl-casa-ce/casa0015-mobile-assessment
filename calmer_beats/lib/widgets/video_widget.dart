//code adapted from https://docs.flutter.dev/cookbook/plugins/play-video

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerWidget extends StatelessWidget {
  final String clip;
  final int duration;

  const VideoPlayerWidget({super.key, required this.clip, required this.duration} ) ;
  @override
  Widget build(BuildContext context) {
    return VideoPlayerScreen(clip: clip,duration: duration,);
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String clip;
  final int duration;
  const VideoPlayerScreen({super.key, required this.clip, required this.duration} ) ;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    /*_controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );
    */
    /*
      _controller = VideoPlayerController.asset('assets/videos/my_video.mp4')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
*/
    //_controller = VideoPlayerController.asset('lib/assets/clouds_comp.mp4');
    _controller = VideoPlayerController.asset(widget.clip);
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  void _goFullScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Container(
            alignment: Alignment.center,
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 100,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                //use video aspect ratio
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                // Add a play button as an overlay if the video is not playing.
                _controller.value.isPlaying
                    ? SizedBox.shrink() // If playing, do not show the play button.
                    : FloatingActionButton(
                  onPressed: () {
                    Future.delayed(Duration(minutes: widget.duration), () {
                      //pop x2 because fullscreen creates a new route
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                    setState(() {
                      //start playback
                      if (!_controller.value.isPlaying) {
                        _controller.play();
                      }
                    });
                    //take the user to a full screen mode to cut out distractions
                    _goFullScreen();
                  },
                  child: Icon(Icons.play_arrow),
                ),
              ],
            );

          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }
}