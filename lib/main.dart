import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'login.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      backgroundColor: Colors.white,
      image: Image.asset('assets/images/icon.png'),
      loadingText: Text('Orbius', style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Color(0xff027373),
      ),),
      photoSize: 100.0,
      loaderColor: Colors.white,
      navigateAfterSeconds: Login(),
    );
  }
}
