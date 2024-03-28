import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

import 'aftersplash.dart';

void main() {
  runApp(MaterialApp(
      home: const MyApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue)));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/screen.png'),
      title: const Text(
        'Jonathan Crivaro\n\n\n\nTic Tac Toe\n\n\n\nMarch 27, 2024',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      backgroundColor: Colors.blue, //ANY COLOR YOU CHOOSE
      showLoader: true,
      loaderColor: Colors.white, //ANY COLOR YOU CHOOSE
      loadingText: const Text('Starting Tic Tac Toe'),
      navigator: const AfterSplash(),
      durationInSeconds: 5,
    );
  }
}
