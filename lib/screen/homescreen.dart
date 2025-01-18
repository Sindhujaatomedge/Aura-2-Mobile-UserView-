import 'package:flutter/material.dart';
import 'package:sampleaura/screen/holiday.dart';
import 'package:sampleaura/screen/homepage.dart';

import 'package:sampleaura/screen/loginpage.dart';

import 'attendanceself.dart';

import 'leaverequest.dart';
import 'leaverequestself.dart';

// Import other pages like 'DesignationHome', etc.

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String email = '';


  final List<Widget> _screens = [

    //Loginpage(),
    Homepage(AutofillHints.email ),
    SelfLeaveRequest(),
    Attendanceself(),
    Leaverequest(),
    SelfHoliday()


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Displaying the selected screen
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: Color(0xFFFCFCFC),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_sharp),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Leave',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_sharp),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_sharp),
            label: 'Holiday',
          ),

        ],
      ),
    );
  }
}
