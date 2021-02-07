import 'package:flutter/material.dart';

import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    ));
  }
}
