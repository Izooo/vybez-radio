import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vybez_radio/controllers/auth_controller.dart';
import 'package:vybez_radio/controllers/category_controller.dart';
import 'package:vybez_radio/controllers/video_controller.dart';
import 'package:vybez_radio/controllers/videos_controller.dart';
import 'package:vybez_radio/models/video.dart';
import 'package:vybez_radio/utils/api.dart';
import 'package:youtube_api/youtube_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DemoApp(),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {

  CategoryController categoryController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Vybez Radio Videos'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/vybez_background.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                currentAccountPicture: CachedNetworkImage(
                  imageUrl: authController.user!.photoUrl ??
                      "https://epaper.standardmedia.co.ke/assets/images/backgrounds/user.jpg",
                ),
                accountName: Text(authController.user!.name),
                accountEmail: Text(authController.user!.email),
              ),
              // child: Text('Vybez Radio'),
            ),
            ListTile(
              leading: Icon(Icons.live_tv),
              title: const Text('Livestream'),
              onTap: () {
                // Update the state of the app.
                Navigator.pushReplacementNamed(context, '/livestream');
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.video_collection_outlined),
              title: Text("Videos"),
              children: <Widget>[
                ListTile(
                  title: const Text('Morning Vybez'),
                  onTap: () {
                    categoryController.category =
                        "PLW8phN0rxA1LFkGaqpGG2SNBDYKtHesIj";
                    Navigator.pushReplacementNamed(context, '/videos');
                    // Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 4,
                ),
                ListTile(
                  title: const Text('Vybez Adrenaline'),
                  onTap: () {
                    categoryController.category =
                        "PLW8phN0rxA1ITUm9I6bVxr8VpjuXuhYM2";
                    Navigator.pushReplacementNamed(context, '/videos');
                    // Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 4,
                ),
                ListTile(
                  title: const Text('Cease N Sekkle'),
                  onTap: () {
                    categoryController.category =
                        "PLW8phN0rxA1JEb-kkeRNwhb1YeKMQJQzF";
                    Navigator.pushReplacementNamed(context, '/videos');
                    // Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 4,
                ),
                ListTile(
                  title: const Text('Empress Divine'),
                  onTap: () {
                    categoryController.category =
                        "PLW8phN0rxA1Kyw9I_2BuY3N15OxdEVjVU";
                    Navigator.pushReplacementNamed(context, '/videos');
                    // Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 4,
                ),
                ListTile(
                  title: const Text('Acoustic Thursdays'),
                  onTap: () {
                    categoryController.category =
                        "PLW8phN0rxA1Kyw9I_2BuY3N15OxdEVjVU";
                    Navigator.pushReplacementNamed(context, '/videos');
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.chat),
              title: Text("Socials"),
              children: <Widget>[
                ListTile(
                  title: const Text('Twitter'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/social_media_embed');
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // logout
                authController.logOut();
                Navigator.pushReplacementNamed(context, "/authenticator");
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/vybez_background2.jpeg"),
          fit: BoxFit.cover,
        )),
        child: FutureBuilder<List<Video>>(
            future: API.getVideos(playlistId: categoryController.category!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.done) {
                  VideosController videosController = Get.find();
                  videosController.video = snapshot.data;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          VideoController videoController =
                              Get.find<VideoController>();
                          Video youtubeVideo = Video(
                            videoThumbnail:
                                videosController.video![index].videoThumbnail,
                            playlistId:
                                videosController.video![index].playlistId,
                            videoId: videosController.video![index].videoId,
                            updatedAt: videosController.video![index].updatedAt,
                            createdAt: videosController.video![index].createdAt,
                            description:
                                videosController.video![index].description,
                            title: videosController.video![index].title,
                            publishedAt:
                                videosController.video![index].publishedAt,
                          );

                          videoController.video = youtubeVideo;

                          Navigator.of(context).pushNamed("/video_player");
                        },
                        child: Card(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 7.0),
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Image.network(
                                    videosController
                                        .video![index].videoThumbnail,
                                    width: 150.0,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        videosController.video![index].title,
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: videosController.video!.length,
                  );
                }
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Text("An Error Occurred"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "Ensure you are connected to the internet before Refreshing the page"),
                      SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
        // child: videoResult.isEmpty ? ComingSoonScreen() :
        // ListView(
        //   children: videoResult.map<Widget>(listItem).toList(),
        // ),
      ),
    );
  }

}

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text('Coming soon'),
      ),
    );
  }
}
