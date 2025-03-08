import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import '../screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  final Auth auth;
  SplashScreen(this.auth);
  @override
  _MySplashState createState() => new _MySplashState();
}

class _MySplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 6), () {
      widget.auth.changeSplash();
      Navigator.of(context).pushReplacementNamed('/');
    }
  );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.amber,
        body: Container(
            alignment: Alignment.center,
            height: double.infinity, //281,
            width: 500,
            child: Image.asset("assets/images/fondo.gif",
                gaplessPlayback: true, fit: BoxFit.fill)));
  }
}
