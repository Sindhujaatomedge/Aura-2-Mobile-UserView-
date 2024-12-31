import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? timer;
  DateTime? checkInTime;
  Duration currentSessionElapsed = Duration.zero;
  Duration totalElapsed = Duration.zero;
  bool isCheckedIn = false; // fetched from API
  final String timezone = "Your_Timezone"; // Set your timezone here

  @override
  void initState() {
    super.initState();
    _loadTimerState();
  }

  Future<void> _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final isCheckedInValue = prefs.getBool('isCheckedIn') ?? false;
    final checkInTimeValue = prefs.getString('checkInTime');
    final totalElapsedValue = prefs.getInt('totalElapsed') ?? 0;

    setState(() {
      isCheckedIn = isCheckedInValue;
      totalElapsed = Duration(seconds: totalElapsedValue);

      if (checkInTimeValue != null) {
        checkInTime = DateTime.parse(checkInTimeValue);
        if (isCheckedIn) {
          // Resume the timer if user was checked in
          startTimer(resume: true);
        }
      }
    });
  }

  Future<void> _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCheckedIn', isCheckedIn);
    prefs.setString('checkInTime', checkInTime?.toIso8601String() ?? "");
    prefs.setInt('totalElapsed', totalElapsed.inSeconds);
  }

  void startTimer({bool resume = false}) {
    if (!resume) {
      checkInTime = DateTime.now();
      currentSessionElapsed = Duration.zero;
    }

    _saveTimerState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentSessionElapsed = DateTime.now().difference(checkInTime!);
      });
    });

    setState(() {
      isCheckedIn = true;
    });
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;

    setState(() {
      totalElapsed += currentSessionElapsed;
      currentSessionElapsed = Duration.zero;
      isCheckedIn = false;
    });

    _saveTimerState();
  }

  Future<void> resetTimerIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckoutTimeValue = prefs.getString('lastCheckoutTime');
    if (lastCheckoutTimeValue != null) {
      final lastCheckoutTime = DateTime.parse(lastCheckoutTimeValue);
      if (DateTime.now().difference(lastCheckoutTime).inHours >= 24) {
        setState(() {
          totalElapsed = Duration.zero;
        });
        prefs.setInt('totalElapsed', 0);
      }
    }
  }

  void onCheckOut() async {
    stopTimer();

    // Save the checkout time
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastCheckoutTime', DateTime.now().toIso8601String());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = totalElapsed + currentSessionElapsed;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Timer Screen"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Elapsed Time: ${elapsed.inHours.toString().padLeft(2, '0')}:${(elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              isCheckedIn
                  ? ElevatedButton(
                onPressed: onCheckOut,
                child: Text("Check Out"),
              )
                  : ElevatedButton(
                onPressed: () {
                  startTimer();
                },
                child: Text("Check In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
