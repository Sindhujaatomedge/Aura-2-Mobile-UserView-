import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  final int hours;
  final int mins;
  final int sec;

  TimerScreen({required this.hours, required this.mins, required this.sec});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int _remainingHours;
  late int _remainingMins;
  late int _remainingSec;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingHours = widget.hours;
    _remainingMins = widget.mins;
    _remainingSec = widget.sec;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSec > 0) {
          _remainingSec--;
        } else {
          if (_remainingMins > 0) {
            _remainingMins--;
            _remainingSec = 59; // Reset seconds to 59
          } else {
            if (_remainingHours > 0) {
              _remainingHours--;
              _remainingMins = 59; // Reset minutes to 59
              _remainingSec = 59; // Reset seconds to 59
            } else {
              _timer.cancel(); // Stop the timer when time is up
            }
          }
        }
      });
    });
  }

  String _formatTime(int hours, int minutes, int seconds) {
    return '${_twoDigitFormat(hours)}:${_twoDigitFormat(minutes)}:${_twoDigitFormat(seconds)}';
  }

  String _twoDigitFormat(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Timer Example")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Time Remaining:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                _formatTime(_remainingHours, _remainingMins, _remainingSec),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _remainingHours = widget.hours;
                    _remainingMins = widget.mins;
                    _remainingSec = widget.sec;
                    _startTimer(); // Reset the timer
                  });
                },
                child: Text('Reset Timer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
