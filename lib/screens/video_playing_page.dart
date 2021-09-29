import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VybezPlayingScreen extends StatefulWidget {
  @override
  _VybezPlayingScreenState createState() => _VybezPlayingScreenState();
}

class _VybezPlayingScreenState extends State<VybezPlayingScreen> {
  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.network(
      "https://media.w3.org/2010/05/sintel/trailer.mp4"
      // "https://www.dailymotion.com/video/x7eob6j",
    )..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vybez Radio"),
      ),
      body: Center(
        child: playerController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: playerController!.value.aspectRatio,
                child: VideoPlayer(playerController!),
              )
            : SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            playerController!.value.isPlaying
                ? playerController!.pause()
                : playerController!.play();
          });
        },
        child: Icon(
          playerController!.value.isPlaying ? Icons.pause : Icons.play_arrow
        ),
      ),
    );
  }
}
