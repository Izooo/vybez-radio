
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vybez_radio/app_theme/app_theme.dart';
import 'package:vybez_radio/controllers/PlaylistController.dart';
import 'package:vybez_radio/controllers/videos_controller.dart';
import 'package:vybez_radio/screens/home_screen.dart';
import 'package:vybez_radio/screens/sign_in_page.dart';
import 'package:vybez_radio/screens/video_playing_screen.dart';
import 'package:vybez_radio/screens/video_playing_webview.dart';
import 'package:vybez_radio/screens/youtube_videos.dart';
import 'package:vybez_radio/utils/authenticator.dart';

import 'controllers/auth_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/showWebView_controller.dart';
import 'controllers/video_controller.dart';
import 'screens/social_media_embed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(VideosController());
    Get.put(VideoController());
    Get.put(ShowWebViewController());
    Get.put(CategoryController());
    Get.put(PlaylistController());



    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vybez Radio',
      theme: appTheme,
      routes: {
        '/': (context) => Authenticator(),
        // '/': (context) => HomeScreen(),
        '/home': (context) => HomeScreen(),
        '/sign_in': (context) => SignInPage(),
        '/videos': (context) => DemoApp(),
        '/video_player': (context) => VideoPlayingScreen(),
        '/livestream': (context) => VideoPlayingWebView(),
        '/authenticator': (context) => Authenticator(),
        '/social_media_embed': (context) => TwitterWebView(),

      },
      // home: DemoApp(),
    );
  }
}

