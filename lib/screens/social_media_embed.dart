import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vybez_radio/controllers/auth_controller.dart';
import 'package:vybez_radio/controllers/category_controller.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TwitterWebView extends StatefulWidget {
  @override
  _TwitterWebViewState createState() => _TwitterWebViewState();
}

class _TwitterWebViewState extends State<TwitterWebView> {
  AuthController authController = Get.find();
  CategoryController categoryController = Get.find();
  WebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Twitter'),),
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
      body: WebView(
        onWebResourceError: (WebResourceError webviewerrr){
          webViewController!.reload();
        },

        onWebViewCreated: (WebViewController c) {
          webViewController = c;
        },
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://twitter.com/VybezRadioKE?ref_src=twsrc%5Etfw',
      ),
    );
  }
}
