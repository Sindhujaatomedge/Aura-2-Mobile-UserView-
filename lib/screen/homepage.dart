import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/controller/attendance.dart';
import 'package:sampleaura/controller/homapage.dart';
import 'package:sampleaura/helper/app_constant.dart';
import 'package:sampleaura/screen/attendanceself.dart';
import 'package:sampleaura/screen/holiday.dart';
import 'package:sampleaura/screen/leaverequest.dart';
import 'package:sampleaura/screen/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import '../model/tokenmodel.dart';
import 'attendancerequest.dart';
import 'leaverequestself.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'managedashboard.dart';
class Homepage extends StatefulWidget {
  String email;
  Homepage(this.email,{super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends StateMVC<Homepage> {
  AttendanceController? attendanceController = null;
  HomePageController? homePageController = null;
  List<String?> quickmenu = [' Apply\n Leave',' Regularize\n Attendance', ' Leave\n Request','Regularize\n Request'];
  List<String>? listimage =['assets/images/login.png','assets/images/check-square.png','assets/images/organization.png','assets/images/beach2.png'];
  //List<String>? leavetype =['Sick Leave','Paid Leave','Causal Leave','Maternity Leave'];
  List<String>? leavetypeimage = ['assets/images/Vector.png','assets/images/moneyfont.png','assets/images/beach2.png','assets/images/iconoir_stroller.png'];
  List<Color>? color=[Color(0xFFFDDFDD),Color(0xFFF5DEEE),Color(0xFFE6E6FA),Color(0xFFDFF5F2)];

  DateTime? checkInTime;
  DateTime? checkOutTime;
  Timer? _timer;

  Duration currentSessionElapsed = Duration.zero;
  Duration totalElapsed = Duration.zero;
 // bool isCheckedIn = true;
  String? _timezone;
  String formattedDate ='';
  int hrs =0;
  int mins = 0;
  int sec =0;
   int _elapsedSeconds = 0;
  bool _isCheckedIn = false;



  _HomepageState() : super(){
    attendanceController = AttendanceController();
    homePageController = HomePageController();
  }
  @override
  @override
  void initState() {
    super.initState();
    _initData();
    _loadbithday();
   // _restoreTimer();
    _loadState();
    _loadpermission();
homePageController?.fetchleavetype();
    setState(() {
      _loadAttendanceStatus();

    });
    setState(() {
      homePageController?.fetchcheckin().then((_){
        print(homePageController?.attendanceCheckin?.orgId);
        _isCheckedIn = homePageController!.attendanceCheckin!.isCheckoutPending;
       // _elapsedSeconds = homePageController!.attendanceCheckin!.sec;
        sec = homePageController!.attendanceCheckin!.sec.toInt();
        mins = homePageController!.attendanceCheckin!.mins.toInt();
        hrs = homePageController!.attendanceCheckin!.hours.toInt();
        print(_isCheckedIn);
        _elapsedSeconds = ((hrs* 3600) +
            (mins * 60) +
            (sec)) ;
      });
    });
    homePageController?.fetchUpcominghoilday().then((_){
      print(homePageController?.upcomingholiday.length);
      homePageController?.fetchUpcomingBirthday().then((_){
        print(' Upcoming Birthday ${ homePageController?.upcomingbirthday.length}');

        homePageController?.fetchleavetype().then((value){
          print("Leave Balance");
          print(value);

        });

      });
    });





    attendanceController?.fetchResponse().then((_) {
      print('Home Page: ${attendanceController?.attendancelist.length}');
      print('filtered list : ${attendanceController?.filteredAttendancelist.length}');
    });




    // Format date
    setState(() {
      DateTime today = DateTime.now();
      formattedDate = DateFormat('d MMMM, yyyy').format(today);
    });




  }
  Future<void> _loadbithday() async {
    await homePageController?.fetchUpcomingBirthday();
    print(' Upcoming Birthday ${ homePageController?.upcomingbirthday
        .length}');// Safely access after fetching
  }
  Future<void> _loadpermission()async {
    await homePageController?.fetchrolepermission();
    print(homePageController?.permission?.permission?.self);

  }
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckInTimestamp = prefs.getInt('lastCheckInTimestamp');
    final totalElapsedSeconds = prefs.getInt('totalElapsedSeconds') ?? 0;

    final today = DateTime.now();
    final lastSavedDate = prefs.getString('lastSavedDate');
    final isSameDay = lastSavedDate == "${today.year}-${today.month}-${today.day}";

    // setState(() {
    //   _elapsedSeconds = ((
    //       homePageController?.attendanceCheckin?.hours* 3600) +
    //       (data['mins'] * 60) +
    //       (data['sec'])) as int; // Convert API response to total seconds
    //   _statusMessage = data['ischeckoutpending'] ? "Checked In" : "Checked Out";
    //   _isLoading = false; // Stop loading
    // });

    setState(() {
      _elapsedSeconds = isSameDay ? totalElapsedSeconds : 0;
      _isCheckedIn = lastCheckInTimestamp != null && isSameDay;

      if (_isCheckedIn && lastCheckInTimestamp != null) {
        final elapsed = DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(lastCheckInTimestamp))
            .inSeconds;
        _elapsedSeconds += elapsed;
        _startTimer();
      }
    });
  }
  Future<void> _initData() async {
    try {
      _timezone = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isCheckedIn) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  /// Check-in logic
  Future<void> _checkIn() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    await prefs.setInt('lastCheckInTimestamp', now.millisecondsSinceEpoch);
    await prefs.setString('lastSavedDate', "${now.year}-${now.month}-${now.day}");

    setState(() {
      _isCheckedIn = true;
    });
    _startTimer();
    checkin(_timezone);
  }

  /// Check-out logic
  Future<void> _checkOut() async {
    final prefs = await SharedPreferences.getInstance();

    // Save the total elapsed time
    await prefs.setInt('totalElapsedSeconds', _elapsedSeconds);
    await prefs.remove('lastCheckInTimestamp');

    setState(() {
      _isCheckedIn = false;
    });
    _timer?.cancel();
    checkout(_timezone);
  }

  /// Format the elapsed time
  String _formatDuration(int seconds) {
    int hours = (seconds / 3600).floor();
    int minutes = ((seconds % 3600) / 60).floor();
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }


  Future<void> _loadAttendanceStatus() async {
    // Fetch check-in status from API and update isCheckedIn
    await homePageController?.fetchcheckin();
    setState(() {
      // Update isCheckedIn based on the response from the API
      _isCheckedIn = homePageController?.attendanceCheckin?.isCheckoutPending ?? true;
      _isCheckedIn ? _startTimer():"";
      print(_isCheckedIn); // Debugging the value of isCheckedIn
    });
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date); // Parse the ISO 8601 string
    final formattedDate = DateFormat('dd MMM, yyyy')
        .format(parsedDate); // Format to desired output
    return formattedDate;
  }



//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }
//
// // Restore the last session and manage the timer accordingly
//   Future<void> _restoreTimer() async {
//     final restoredCheckInTime = await getCheckInTime();
//     final restoredCheckOutTime = await getCheckOutTime(); // Fetch the checkout time if available
//
//     print('Restored Check-In Time: $restoredCheckInTime');
//     print('Restored Check-Out Time: $restoredCheckOutTime');
//
//     if (restoredCheckInTime != null) {
//       setState(() {
//         if (restoredCheckOutTime != null) {
//           // If both check-in and check-out times exist, restore the session as completed
//           checkInTime = restoredCheckOutTime;  // Use the last checkout time as the check-in time
//           currentSessionElapsed = restoredCheckOutTime.difference(restoredCheckInTime); // Calculate elapsed time
//           isCheckedIn = false; // User is not checked in
//           print('User is checked out. Elapsed time: $currentSessionElapsed');
//         } else {
//           // If no checkout time exists, user is still checked in, use the check-in time
//           checkInTime = restoredCheckInTime;
//           isCheckedIn = true; // User is still checked in
//           print('User is checked in from: $checkInTime');
//
//           // Start the timer from the restored check-in time
//           timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//             setState(() {
//               currentSessionElapsed = DateTime.now().difference(checkInTime!);
//               print('Current session elapsed: $currentSessionElapsed');
//             });
//           });
//         }
//       });
//     } else {
//       setState(() {
//         isCheckedIn = false;
//       });
//       print('No check-in time found, user is not checked in.');
//     }
//   }
//
// // Save the check-in time
//   Future<void> saveCheckInTime(DateTime checkInTime) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('checkInTime', checkInTime.toIso8601String());
//     print('Check-in time saved: $checkInTime');
//   }
//
// // Get the saved check-in time
//   Future<DateTime?> getCheckInTime() async {
//     final prefs = await SharedPreferences.getInstance();
//     final checkInTimeStr = prefs.getString('checkInTime');
//     print('Retrieved Check-in time: $checkInTimeStr');
//     return checkInTimeStr != null ? DateTime.parse(checkInTimeStr) : null;
//   }
//
// // Save the check-out time
//   Future<void> saveCheckOutTime(DateTime checkOutTime) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('checkOutTime', checkOutTime.toIso8601String());
//     print('Check-out time saved: $checkOutTime');
//   }
//
// // Get the saved check-out time
//   Future<DateTime?> getCheckOutTime() async {
//     final prefs = await SharedPreferences.getInstance();
//     final checkOutTimeStr = prefs.getString('checkOutTime');
//     print('Retrieved Check-out time: $checkOutTimeStr');
//     return checkOutTimeStr != null ? DateTime.parse(checkOutTimeStr) : null;
//   }
//
// // Start the timer (when the user checks in)
//   void startTimer() async {
//     if (isCheckedIn) return;
//
//     final restoredCheckOutTime = await getCheckOutTime();
//     checkInTime = restoredCheckOutTime ?? DateTime.now(); // Use checkout time if available, otherwise current time
//     await saveCheckInTime(checkInTime!);
//
//     setState(() {
//       isCheckedIn = true;
//     });
//
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         currentSessionElapsed = DateTime.now().difference(checkInTime!);
//       });
//     });
//
//     try {
//       await checkin(_timezone);
//     } catch (error) {
//       print("Error during check-in: $error");
//     }
//   }
//
//
//
//
// // Stop the timer (when the user checks out)
//   void stopTimer() async {
//     if (!isCheckedIn) return;
//
//     checkOutTime = DateTime.now();
//     totalElapsed += currentSessionElapsed;
//
//     setState(() {
//       isCheckedIn = false;
//       // Do not reset currentSessionElapsed to Duration.zero
//       print('Check-out time: $checkOutTime');
//     });
//
//     timer?.cancel();
//
//     // Save the checkout time and clear check-in time
//     await saveCheckOutTime(checkOutTime!);
//
//     try {
//       await checkout(_timezone);
//     } catch (error) {
//       print("Error during check-out: $error");
//     }
//   }


// // Clear the check-out time
//   Future<void> clearCheckOutTime() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('checkOutTime');
//     print('Check-out time cleared');
//   }

















  String _formatTime(int hours, int minutes, int seconds) {
    return '${_twoDigitFormat(hours)}:${_twoDigitFormat(minutes)}:${_twoDigitFormat(seconds)}';
  }
  String _twoDigitFormat(int value) {
    return value.toString().padLeft(2, '0');
  }



  Future <void> checkin (String? timezone) async {
    TokenModel? tokenmodel = await TokenModel.loadFromPrefs();
    String accessToken = tokenmodel?.accessToken ?? '';
    String refreshToken =tokenmodel?.refreshToken ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    if(rawString != null){
      String orgId = rawString.split(':')[1].replaceAll('}','').trim();

      tokenmodel?.orgid = orgId;
    }
    final body = {
      "orgid": tokenmodel?.orgid,
      "checkinmedium": "web",
      "locate":_timezone
    };
    final jsonString = json.encode(body);
    print(jsonString);


    //   final url = Uri.parse('http://3.110.95.121:8080/check-in');
   // final url = Uri.parse('http://192.168.29.232:8080/check-in');
    final url = AppConstant().checkin;
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token':accessToken,
        'Refresh-Token': refreshToken


      },
      body: json.encode(body),
    );

    if (response.statusCode == 202) {
      print(response.body);
      final Map<String,dynamic> message= json.decode(response.body);
      // String parts = message.replaceAll("\"", "");
      //  String parts = message[message];
      // print(parts);
      Fluttertoast.cancel();
      await Fluttertoast.showToast(
        msg:  message['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      // setState((){
      //   homePageController?.fetchcheckin();
      //
      // });



    }
    else {
      print(response.body);
      final Map<String, dynamic> message = json.decode(response.body);



      throw Exception('Error');
    }

  }
  Future <void> checkout (String? timezone) async {
    TokenModel? tokenmodel = await TokenModel.loadFromPrefs();
    String accessToken = tokenmodel?.accessToken ?? '';
    String refreshToken =tokenmodel?.refreshToken ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    if(rawString != null){
      String orgId = rawString.split(':')[1].replaceAll('}','').trim();

      tokenmodel?.orgid = orgId;
    }
    final body = {
      "orgid": tokenmodel?.orgid,
      "checkinmedium": "bio",
      "locate":_timezone
    };
    final jsonString = json.encode(body);
    print(jsonString);

final url = AppConstant().checkout;
    //  final url = Uri.parse('http://3.110.95.121:8080/check-out');
   // final url = Uri.parse('http://192.168.29.232:8080/check-out');
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token':accessToken,
        'Refresh-Token': refreshToken


      },
      body: json.encode(body),
    );

    if (response.statusCode == 202) {
      print(response.body);
      final Map<String,dynamic> message= json.decode(response.body);

      await Fluttertoast.showToast(
        msg:  message['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      // setState((){
      //   homePageController?.fetchcheckin();
      //
      // });


    }
    else {
      print(response.body);
      final Map<String, dynamic> message = json.decode(response.body);
      await Fluttertoast.showToast(
        msg: message['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );



      throw Exception('Error');
    }

  }

  void _onGridItemTap(int index){
    switch (index){
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  SelfLeaveRequest()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Attendanceself() ));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Leaverequest() ));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => Attendancerequest() ));
        break;

    }
  }

  void  _showdialog(){
    showDialog(context: context, builder: (context) {
      return
        AlertDialog(
          titlePadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          insetPadding: EdgeInsets.symmetric(horizontal: 24), // Reduces default margin
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: Container(
            width: 350,
            height: 150,// Specify the desired width
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures the height adjusts dynamically
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: Text(
                      "Are you Sure ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "You will be signed out of the account?",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF98A2B3),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionButton(
                        label: "Cancel",
                        backgroundColor: Color(0xFFE4E7EC),
                        textColor: Color(0xFF030303),
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                      ),
                      _buildActionButton(
                        label: "Logout",
                        backgroundColor: Color(0xFF004AAD),
                        textColor: Colors.white,
                        onPressed: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          String? savedAccessToken = prefs.getString('access_token');
                          String? savedRefreshToken = prefs.getString('refresh_token');
                          print('Saved Access Token: $savedAccessToken');
                          print('Saved Refresh Token: $savedRefreshToken');
                          await prefs.remove('access_token');
                          await prefs.remove('refresh_token');

                          final accessToken = prefs.getString('access_token');
                          final refreshToken = prefs.getString('refresh_token');

                          if (accessToken == null && refreshToken == null) {
                            print('Tokens successfully removed.');

                          } else {
                            print('Tokens still exist:');
                            print('Access Token: $accessToken');
                            print('Refresh Token: $refreshToken');
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Loginpage()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    });
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 45),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final elapsed = totalElapsed + currentSessionElapsed;
    return Material(
      color: Color(0xFFFCFCFC),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFFFCFCFC),
            title: Text("Home"),
            actions: [
              InkWell(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logout.png',height:24 ,width: 24,),
            ),onTap: (){
              _showdialog();
            }
            ),
               InkWell(child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text("Manage Dashboard"),
               ),onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard() ));
               },)
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:10.0,left: 10,right: 10),
                  child: Container(
                    height: 91,
                    width: 361,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: Color(0xFFE9E9E9)
                        ),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:15.0,left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Center(child: Text('Welcome  ${widget.email}',style: TextStyle(fontFamily: 'Poppins',color: Color(0xFF98A2B3),fontSize:14 ),)),
                                Center(child: Text('Welcome',style: TextStyle(fontFamily: 'Poppins',color: Color(0xFF98A2B3),fontSize:14 ),)),
                                SizedBox(height: 6,),
                                Center(child: Text('Lets begin the day!',style: TextStyle(fontFamily: 'Poppins',color: Color(0xFF004AAD),fontSize:16 ),))
                              ],
                            ),
                          ),
                          SizedBox(width:20),


                          Padding(
                            padding: const EdgeInsets.only(top:15.0,left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(child: Text(DateFormat('d MMM yyyy').format(DateTime.now()),style: TextStyle(fontFamily: 'Poppins',color: Color(0xFF536493),fontSize: 12),)),
                                SizedBox(height: 6,),
                                // Center(child: Text(
                                //   " ${currentSessionElapsed.inHours.toString().padLeft(2, '0')}:${(currentSessionElapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(currentSessionElapsed.inSeconds % 60).toString().padLeft(2, '0')} Hrs",
                                //   style: TextStyle(fontSize: 20),
                                // ),)
                                Center(child: Text(
                                  _formatDuration(_elapsedSeconds),
                                  style: TextStyle(fontSize: 20),
                                ),)


                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    height: 50,
                          width: 361,
                    decoration: BoxDecoration(
                      color: _isCheckedIn ? const Color(0xFFFF8C8C) : const Color(0xFF4B9B77), // Dynamic color
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (_isCheckedIn) {
                          _checkOut(); // Call the Check Out function
                        } else {
                          _checkIn(); // Call the Check In function
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                        child: Text(
                          _isCheckedIn ? 'Check Out' : 'Check In',
                          style: TextStyle(
                            color: Color(0xFFF9FAFB),
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),



                // Padding(
                //   padding: const EdgeInsets.only(left: 10, right: 10),
                //   child:
                //   !isCheckedIn
                //       ? InkWell(
                //     onTap: _isCheckedIn ? null : _checkIn,
                //     child: Container(
                //       height: 50,
                //       width: 361,
                //       decoration: BoxDecoration(
                //         color: const Color(0xFF4B9B77),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: const Center(
                //         child: Text(
                //           'Check In',
                //           style: TextStyle(
                //             color: Color(0xFFF9FAFB),
                //             fontSize: 16,
                //             fontFamily: 'Poppins',
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ),
                //   )
                //       : InkWell(
                //     onTap: !_isCheckedIn ? null : _checkOut,
                //     child: Container(
                //       height: 50,
                //       width: 361,
                //       decoration: BoxDecoration(
                //         color: const Color(0xFFFF8C8C),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: const Center(
                //         child: Text(
                //           'Check Out',
                //           style: TextStyle(
                //             color: Color(0xFFF9FAFB),
                //             fontSize: 16,
                //             fontFamily: 'Poppins',
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),


                SizedBox(
                  height: 24,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12,right: 12),
                  child: Text('Quick Menus',style: TextStyle(fontFamily: 'Poppins',fontSize: 18,fontWeight: FontWeight.w500),),
                ),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 5,mainAxisSpacing: 8,childAspectRatio: 2,mainAxisExtent: 74),
                    itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 10,right: 10),
                        child: InkWell(
                          onTap: (){
                            _onGridItemTap(index);
                          },
                          child: Container(
                            height: 74,
                            width: 170,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Color(0xFFE0EDFF)
                                ),
                                color: Color(0xFFF5FAFF),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(listimage![index],height: 35,width: 35,),
                                  SizedBox(width: 5,),
                                  Text(quickmenu[index]!, textAlign: TextAlign.start,style: TextStyle(fontFamily: 'Poppins',fontSize: 14 ,color: Color(0xFF1D2939))),
                                ],
                              ),
                            ),

                          ),
                        ),
                      );

                    }),

                Padding(
                  padding: EdgeInsets.only(left: 12, top :20),
                  child: Row(
                    children: [
                      Text('Leave Balance',style: TextStyle(fontFamily: 'Poppins',fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xFF030303)),),

                    ],
                  ),
                ),
                homePageController!.leavetypedata.isNotEmpty?
                SizedBox(
                  height: 126,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    GridView.builder(
                      scrollDirection: Axis.horizontal,

                      ///physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 155
                      ),
                      itemCount: homePageController?.leavetypedata.length,
                      itemBuilder: (context, index) {
                        var leavetype = homePageController?.leavetypedata[index];
                        return Padding(
                          padding: const EdgeInsets.only(top:8.0,left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: color?[index], // Consider using a theme or constant
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top:12,
                                  right: 16,
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child: Center(
                                      child: Image.asset(leavetypeimage![index],height: 25,width: 25,color: color?[index],),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 55,
                                    left: 12,
                                    child: Text(leavetype!.leavetypename)),
                                Positioned(
                                    top: 75,
                                    left: 12,
                                    child: Text(leavetype.availableleaves.toString())),
                              ],

                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(top:20.0,left: 20),
                  child: Text("Your leave balance is about to refresh—get ready to check it out!",style: TextStyle(fontFamily: 'Poppins',color: Colors.grey.shade400),),
                ),


                Padding(
                  padding: EdgeInsets.only(left: 15,top: 20),
                  child: Row(
                    children: [
                      Text('UpComing Holidays',style: TextStyle(fontFamily: 'Poppins',fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xFF030303)),),
                      Spacer(),
                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SelfHoliday()));
                      }, icon: Icon(Icons.arrow_forward_ios,size:20 ,))

                    ],
                  ),
                ), homePageController!.upcomingholiday.isNotEmpty?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: homePageController?.upcomingholiday.length,
                    shrinkWrap: true, // Let the ListView size itself
                    physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                    itemBuilder: (BuildContext context, int index) {
                      var holidaylist = homePageController?.upcomingholiday[index];
                      return
                        Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 15, right: 10),
                        child: Container(
                          height: 97,
                          width: 361,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Color(0xFFE9E9E9)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 10, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(holidaylist!.name,
                                          style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                                    ),
                                    Spacer(),
                                    Text(formatDate(holidaylist.fromdate))
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Holiday Description',
                                      style: TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ) : Padding(
        padding: const EdgeInsets.only(top:20.0,left: 20),
        child: Text("Get ready to enjoy the upcoming holidays—relaxation is calling!",style: TextStyle(fontFamily: 'Poppins',color: Colors.grey.shade400),),
      ),



                Padding(
                  padding: EdgeInsets.only(left: 15,top:20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('UpComing BirthDay',style: TextStyle(fontFamily: 'Poppins',fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xFF030303)),),
                      ),

                    ],
                  ),
                ), homePageController!.upcomingbirthday.isNotEmpty ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 112,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: homePageController?.upcomingbirthday.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,crossAxisSpacing: 10,mainAxisExtent: 112),
                      itemBuilder: (BuildContext context, int index) {
                        var birthdaylist = homePageController?.upcomingbirthday[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 112,
                            width: 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Image.asset('assets/images/profile2.png',height: 50,width: 50,),
                                Image.network(birthdaylist!.avatar,height: 50,width: 50,),
                                Text(birthdaylist.name,style: TextStyle(fontFamily: 'Poppins',color: Color(0xFF98A2B3),fontSize: 12),),
                                Text(formatDate(birthdaylist.dateofbith),style: TextStyle(fontFamily: 'Poppins',color: Color(0xFF536493),fontSize: 12),)
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.only(top:20.0,left: 20),
                  child: Text("Exciting birthdays are on the way—let’s get ready to celebrate!",style: TextStyle(fontFamily: 'Poppins',color: Colors.grey.shade400),),
                ),
              ],
            ),
          )
      ),
    );
  }
}

