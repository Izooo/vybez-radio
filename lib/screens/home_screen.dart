import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vybez_radio/controllers/PlaylistController.dart';
import 'package:vybez_radio/controllers/auth_controller.dart';
import 'package:vybez_radio/controllers/category_controller.dart';
import 'package:vybez_radio/controllers/showWebView_controller.dart';
import 'package:vybez_radio/controllers/video_controller.dart';
import 'package:vybez_radio/controllers/videos_controller.dart';
import 'package:vybez_radio/models/playlist.dart';
import 'package:vybez_radio/models/video.dart';
import 'package:vybez_radio/utils/api.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_api/youtube_api.dart';

import 'social_media_embed.dart';
import 'video_playing_webview.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  WebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final controller = Get.find<ShowWebViewController>();
    switch (state) {
      case AppLifecycleState.paused:
        print("paused");
        controller.showWebView.value = false;
        setState(() {});
        break;

      case AppLifecycleState.resumed:
        print("resumed");
        controller.showWebView.value = true;
        setState(() {});
        break;

      default:
        print("default");
        break;
    }
  }

  void _onRefresh() async {
    webViewController!.reload();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch\
    setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    CategoryController categoryController = Get.find();
    AuthController authController = Get.find();



    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Vybez Radio Livestream'),
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       // DrawerHeader(
      //       //   child: UserAccountsDrawerHeader(
      //       //     decoration: BoxDecoration(
      //       //       image: DecorationImage(
      //       //         image: AssetImage("assets/images/vybez_background.jpeg"),
      //       //         fit: BoxFit.cover,
      //       //       ),
      //       //     ),
      //       //     currentAccountPicture: CachedNetworkImage(
      //       //       imageUrl: authController.user!.photoUrl ??
      //       //           "https://epaper.standardmedia.co.ke/assets/images/backgrounds/user.jpg",
      //       //     ),
      //       //     accountName: Text(authController.user!.name),
      //       //     accountEmail: Text(authController.user!.email),
      //       //   ),
      //       //   // child: Text('Vybez Radio'),
      //       // ),
      //       ListTile(
      //         leading: Icon(Icons.live_tv),
      //         title: const Text('Livestream'),
      //         onTap: () {
      //           // Update the state of the app.
      //           Navigator.pushReplacementNamed(context, '/livestream');
      //         },
      //       ),
      //       ExpansionTile(
      //         leading: Icon(Icons.video_collection_outlined),
      //         title: Text("Videos"),
      //         children: <Widget>[
      //           ListTile(
      //             title: const Text('Morning Vybez'),
      //             onTap: () {
      //               categoryController.category =
      //                   "PLW8phN0rxA1LFkGaqpGG2SNBDYKtHesIj";
      //               Navigator.pushReplacementNamed(context, '/videos');
      //               // Navigator.pop(context);
      //             },
      //           ),
      //           SizedBox(
      //             height: 4,
      //           ),
      //           ListTile(
      //             title: const Text('Vybez Adrenaline'),
      //             onTap: () {
      //               categoryController.category =
      //                   "PLW8phN0rxA1ITUm9I6bVxr8VpjuXuhYM2";
      //               Navigator.pushReplacementNamed(context, '/videos');
      //               // Navigator.pop(context);
      //             },
      //           ),
      //           SizedBox(
      //             height: 4,
      //           ),
      //           ListTile(
      //             title: const Text('Cease N Sekkle'),
      //             onTap: () {
      //               categoryController.category =
      //                   "PLW8phN0rxA1JEb-kkeRNwhb1YeKMQJQzF";
      //               Navigator.pushReplacementNamed(context, '/videos');
      //               // Navigator.pop(context);
      //             },
      //           ),
      //           SizedBox(
      //             height: 4,
      //           ),
      //           ListTile(
      //             title: const Text('Empress Divine'),
      //             onTap: () {
      //               categoryController.category =
      //                   "PLW8phN0rxA1Kyw9I_2BuY3N15OxdEVjVU";
      //               Navigator.pushReplacementNamed(context, '/videos');
      //               // Navigator.pop(context);
      //             },
      //           ),
      //           SizedBox(
      //             height: 4,
      //           ),
      //           ListTile(
      //             title: const Text('Acoustic Thursdays'),
      //             onTap: () {
      //               categoryController.category =
      //                   "PLW8phN0rxA1Kyw9I_2BuY3N15OxdEVjVU";
      //               Navigator.pushReplacementNamed(context, '/videos');
      //               // Navigator.pop(context);
      //             },
      //           ),
      //         ],
      //       ),
      //       ExpansionTile(
      //         leading: Icon(Icons.chat),
      //         title: Text("Socials"),
      //         children: <Widget>[
      //           ListTile(
      //             title: const Text('Twitter'),
      //             onTap: () {
      //               Navigator.pushReplacementNamed(context, '/social_media_embed');
      //               // Navigator.pop(context);
      //             },
      //           ),
      //         ],
      //       ),
      //       Divider(),
      //       ListTile(
      //         leading: Icon(Icons.logout),
      //         title: const Text('Logout'),
      //         onTap: () {
      //           // logout
      //           authController.logOut();
      //           Navigator.pushReplacementNamed(context, "/authenticator");
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: VideoPlayingWebView(),
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