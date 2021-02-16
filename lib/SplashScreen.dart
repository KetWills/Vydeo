import 'package:flutter/material.dart';
import 'package:vydeo/MyHomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final navigatorKey = GlobalKey<NavigatorState>();

  void initState() {
    super.initState();
    goHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/ic_splash.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Future<void> goHome() async {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }
}
