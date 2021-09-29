import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:vybez_radio/controllers/video_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayingScreen extends StatefulWidget {
  const VideoPlayingScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayingScreenState createState() => _VideoPlayingScreenState();
}

class _VideoPlayingScreenState extends State<VideoPlayingScreen> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    VideoController videoController = Get.find();
    _controller = YoutubePlayerController(
        initialVideoId: videoController.video!.videoId);
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VideoController videoController = Get.find();

    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              title: const Text('Vybez Radio Videos'),
            ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/vybez_background.jpeg"),
          fit: BoxFit.cover,
        )),
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
          ),
          onEnterFullScreen: () => setState(() {
            isFullScreen = true;
          }),
          onExitFullScreen: () => setState(() {
            isFullScreen = false;
          }),
          builder: (_, player) => Column(
            children: [
              player,
              if (!isFullScreen)Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    videoController.video!.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalVideoTile extends StatelessWidget {
  const HorizontalVideoTile({
    Key? key,
    this.maxHeight = 150,
    required this.videoThumbnail,
    required this.onTapped,
    required this.title,
  }) : super(key: key);

  final String title;
  final String videoThumbnail;
  final double maxHeight;
  final VoidCallback? onTapped;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: ListTile(
        onTap: onTapped,
        leading: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxHeight),
          child: CachedNetworkImage(
            imageUrl:
                'https://img.youtube.com/vi/$videoThumbnail/mqdefault.jpg',
            progressIndicatorBuilder: (_, __, progress) => Container(
              width: 140,
              height: 195,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (_, __, ___) => Center(
              child: Text('Error occurred'),
            ),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vybez Radio'),
      ),
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
