import 'dart:async';

import 'package:flutter/material.dart';
import 'package:komkom/utils/constants.dart';
import 'package:komkom/ui/SplashScreen.dart';
import 'package:komkom/ui/signup.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {

  @override
  MyAppState createState() => MyAppState();

}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: new Color(0xFFFFFFFF),
          accentColor: Colors.blueAccent,
          fontFamily: 'Source Code Pro'),
      home: SplashScreen(),
      routes: getRoutes(),
    );
  }

  Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      ANIMATED_SPLASH: (BuildContext context) => new SplashScreen(),
      LOGIN_SCREEN: (BuildContext context) => new LoginScreen()
    };
  }
}