import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vybez_radio/controllers/auth_controller.dart';
import 'package:vybez_radio/screens/home_screen.dart';
import 'package:vybez_radio/screens/sign_in_page.dart';
import 'package:vybez_radio/screens/video_playing_webview.dart';

class Authenticator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    print("The auth controller name ${authController.user?.name}");

    return Obx(() {
      if(authController.user != null) {

        return HomeScreen();
      }

      return SignInPage();
    });
  }
}
