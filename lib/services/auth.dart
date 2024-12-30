import 'package:edpic_eccommerce_app/pages/bottom_nav.dart';
import 'package:edpic_eccommerce_app/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteUser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    user?.delete();
  }

  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BottomNav()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
    }
  }
}
