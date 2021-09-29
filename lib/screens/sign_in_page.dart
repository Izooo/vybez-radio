import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:vybez_radio/controllers/auth_controller.dart';
import 'package:vybez_radio/presentation/apple_icon.dart';
import 'package:vybez_radio/presentation/social_login.dart';
import 'package:vybez_radio/widget/vybez_buttons.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();

  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.asset(
        "assets/videos/APP_START_SCREEN.mp4"
    )..initialize().then((_) {
      playerController!.play();
      playerController!.setLooping(true);
      playerController!.setVolume(0);

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

    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Vybez Radio"),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              child: SizedBox(
                width: playerController!.value.size.width,
                height: playerController!.value.size.height,
                child: VideoPlayer(playerController!),
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VybezButtons(
                    backgroundColor: Colors.black,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    icon: Icon(AppleIcon.apple),
                    text: "Login with Apple",
                    onPressed: () => {
                      authController.appleLogin()
                    },
                    height: 80,
                  ),
                  SizedBox(height: 24,),
                  VybezButtons(
                    icon: Icon(SocialLogin.google),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    text: "Login with Google",
                    height: 80,
                    onPressed: () => {
                      authController.signInWithGoogle()
                    },
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
