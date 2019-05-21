import 'dart:async';
import 'package:komkom/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:komkom/style/animations.dart';
import 'package:flutter/scheduler.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  AnimationController animationController;
  Animation<double> animation;

  AnimationController animationControllerText;
  Animation<double> animationText;


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN);
  }

  @override
  initState() {
    super.initState();
    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 3));
    animation = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    animationControllerText = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animationText = CurvedAnimation(parent: animationControllerText, curve: Curves.easeIn);
    animationControllerText.forward();

    startTime();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Container(
              decoration: new BoxDecoration(color: Colors.white)
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/img/logo.png',
                width: animation.value * 80,
                height: animation.value * 80,
              ),
              Container(
                height: 14.0,
              ),
              FadeTransition(
                  opacity: animationText,
                  child: Text("Komunikasi Komunitas", style: TextStyle(fontFamily: "MontserratItalic", fontSize: 14.0, color: Colors.black))
              ),
            ],
          ),
        ],
      ),
    );;
  }
}