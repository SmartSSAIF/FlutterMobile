import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageIcon(
        new AssetImage("assets/thas.png"),
        size: 400.0,
      ),
    );
  }
}
