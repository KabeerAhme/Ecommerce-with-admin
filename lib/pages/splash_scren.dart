import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:edpic_eccommerce_app/pages/bottom_nav.dart';
import 'package:edpic_eccommerce_app/pages/login.dart';
import 'package:edpic_eccommerce_app/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // get splash => null;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return AnimatedSplashScreen(
      splash: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child:
                  LottieBuilder.asset("assets/Animation - 1721812646393.json"),
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
                child: Image.asset(
              "assets/eco.png",
              width: 100,
              fit: BoxFit.cover,
            ))
          ],
        ),
      ),
      nextScreen: user != null ? BottomNav() : LogIn(),
      splashIconSize: 400,
      backgroundColor: Color(0xfff2f2f2),
    );
  }
}
