import 'package:flutter/material.dart';
import 'package:sampleaura/screen/homepage.dart';
import 'package:sampleaura/screen/homescreen.dart';
import 'package:sampleaura/screen/loginpage.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  String email =" ";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.push(
          context,
          // MaterialPageRoute(builder: (context) => Homepage(email)),
          MaterialPageRoute(builder: (context) => HomeScreen()),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      body: Center(
        child: Image.asset('assets/images/splash2.gif'),
      ),
    );
  }
}
