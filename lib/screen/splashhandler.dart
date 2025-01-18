import 'package:flutter/material.dart';
import 'package:sampleaura/screen/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splashScreen.dart';
import 'homescreen.dart';
import 'loginpage.dart';

class SplashHandler extends StatefulWidget {
  const SplashHandler({super.key});

  @override
  State<SplashHandler> createState() => _SplashHandlerState();
}

class _SplashHandlerState extends State<SplashHandler> {
  @override
  void initState() {
    super.initState();
    _determineNextScreen();
  }

  Future<void> _determineNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the app is launched for the first time
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Show splash screen for 2 seconds on the first launch
      await Future.delayed(const Duration(seconds: 2));
      prefs.setBool('isFirstLaunch', false);
    }

    // Check if user has a saved access token
    String? savedAccessToken = prefs.getString('access_token');

    if (savedAccessToken != null && savedAccessToken.isNotEmpty) {
      // Navigate to HomeScreen if token exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage('mail')),
      );
    } else {
      // Navigate to LoginPage if no token exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Splashscreen(); // Show splash screen while determining navigation
  }
}
