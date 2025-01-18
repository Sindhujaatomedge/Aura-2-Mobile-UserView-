import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampleaura/screen/applyleave.dart';
import 'package:sampleaura/screen/managedashboard.dart';
import 'package:sampleaura/screen/splashhandler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sampleaura/screen/homescreen.dart';
import 'package:sampleaura/screen/loginpage.dart';
import 'package:sampleaura/screen/splashScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFFCFCFC),
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0x00fcfcfc),
        useMaterial3: true,
      ),
    home: const SplashHandler(),
      //home: TimerScreen(),
    //home: Dashboard(),
    );
  }
}
