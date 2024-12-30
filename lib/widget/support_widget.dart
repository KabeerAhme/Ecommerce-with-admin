import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        fontFamily: "FontMain");
  }

  static TextStyle lightTextFieldStyle() {
    return TextStyle(
        color: Colors.black54,
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        fontFamily: "FontMain");
  }

  static TextStyle semiBoldTextFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: "FontMain");
  }
}
