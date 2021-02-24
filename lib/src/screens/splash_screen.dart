import 'dart:async';

import 'package:farmers_market/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    User _currentUser = FirebaseAuth.instance.currentUser;
    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      auth.adminId = _currentUser.uid;
    } catch (e) {
      print(e);
    }
    var _duration = new Duration(seconds: 3);
    return _currentUser == null
        ? Timer(_duration, navigateToLogin)
        : Timer(_duration, navigateToHome);
  }

  void navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
  }

  void navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: new Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.center,
              image: AssetImage("assets/images/logo.png"),
              // fit: BoxFit.fill,
              // fit: BoxFit.fitWidth also can use fit: BoxFit.fitHeight
            ),
          ),
        ),
      ),
    );
  }
}
