import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/model/request/regularize.dart';
import 'package:sampleaura/model/response/attendancebyorgid.dart';
import 'package:sampleaura/widget/attendanceself.dart';

import '../controller/attendance.dart';
import '../model/dropdown/member.dart';
import '../widget/requestshimmer.dart';
import 'homescreen.dart';

class Attendanceself extends StatefulWidget {
  const Attendanceself({super.key});

  @override
  _AttendanceselfState createState() => _AttendanceselfState();
}

class _AttendanceselfState extends StateMVC<Attendanceself> {
  AttendanceController? _con = null;
  ScrollController scrollController = ScrollController();
  bool isExtended = true;
  final _regularizeformkey = GlobalKey<FormState>();
  TextEditingController _fromdateController = TextEditingController();
  TextEditingController _todateController = TextEditingController();
  TextEditingController _comments = TextEditingController();
  TextEditingController _checkin = TextEditingController();
  TextEditingController _checkout = TextEditingController();
  DateTime? _fromselectedDate;
  String from_date = '';
  DateTime? _toselectedDate;
  String to_date = '';
  String? modalSelected;
  List<MemberDropdown> membervalue= [];
  Regularize _regularizeModel = Regularize();
  _AttendanceselfState() : super(AttendanceController()) {
    _con = controller as AttendanceController?;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadmember();
    print("Attendancevalue");
    print(_con?.attendancelist.length);

    _con?.fetchResponse();
   // _con?.fetchResponseattendancerequest();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isExtended) {
          setState(() {
            isExtended = false;
          });
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isExtended) {
          setState(() {
            isExtended = true;
          });
        }
      }
    });
  }
  Future<void> _loadmember() async {
    try {
      if (_con != null) {
        await _con!.viewmembervalue(); // Fetch leavetype
        if (_con!.viewmembervalue() != null) {
          setState(() {
            membervalue = _con!.fetchmemberdatavlaue;
            print('Loaded member: $membervalue'); // Verify the data here
          });
        } else {
          print('Error: fetchroledatavlaue is null');
        }
      } else {
        print('Error: _con is null');
      }
    } catch (e) {
      print('Error loading membervalue: $e');
    } finally {
      setState(() {
        _con?.isLoading = false;
      });
    }
  }
  Future<void> _checkInTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF004AAD), // Header background color
            colorScheme: ColorScheme.light(
              primary: Color(0xFF004AAD), // Selected date and header text color
            ),
            dialogBackgroundColor: Colors.white, // Picker background color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF004AAD), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      final String formattedInTime = selectedTime.format(context);
      setState(() {
        _checkin.text = formattedInTime;
      });
    }
  }

  Future<void> _checkOutTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF004AAD), // Header background color
            colorScheme: ColorScheme.light(
              primary: Color(0xFF004AAD), // Selected date and header text color
            ),
            dialogBackgroundColor: Colors.white, // Picker background color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF004AAD), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      final String formattedInTime = selectedTime.format(context);
      setState(() {
        _checkout.text = formattedInTime;
      });
    }
  }

  Future<void> _fromselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default date shown in the picker
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF004AAD), // Header background color
            colorScheme: ColorScheme.light(
              primary: Color(0xFF004AAD), // Selected date and header text color
            ),
            dialogBackgroundColor: Colors.white, // Picker background color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF004AAD), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _fromselectedDate) {
      setState(() {
        _fromselectedDate = picked;
        _fromdateController.text =
            DateFormat('yyyy-MM-dd').format(_fromselectedDate!);
      });

      from_date = DateFormat('yyyy-MM-dd').format(_fromselectedDate!);
      print("Selected Date: $from_date");
    }
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date); // Parse the ISO 8601 string
    final formattedDate = DateFormat('dd MMM, yyyy')
        .format(parsedDate); // Format to desired output
    return formattedDate;
  }

  String formatedTime(String time) {
    String trimtime = time.trim();

    final parsedTime = DateFormat("HH:mm:ss").parse(trimtime);
    print(parsedTime);
    String formattedTime = DateFormat("hh:mm a").format(parsedTime);

    return formattedTime;

  }

  String calculateTimeDifference(String checkInTime, String checkOutTime) {
    // Trim spaces from input times
    String trimCheckIn = checkInTime.trim();
    String trimCheckOut = checkOutTime.trim();

    // Parse the times using 12-hour format with AM/PM
    final DateTime checkIn = DateFormat("hh:mm a").parse(trimCheckIn);
    final DateTime checkOut = DateFormat("hh:mm a").parse(trimCheckOut);

    // Calculate the difference
    final Duration totalDuration = checkOut.difference(checkIn);

    // Handle negative durations (if checkout is on the next day)
    final Duration adjustedDuration = totalDuration.isNegative
        ? totalDuration + Duration(hours: 24)
        : totalDuration;

    // Extract hours, minutes, and seconds from the duration
    final int totalHours = adjustedDuration.inHours;
    final int remainingMinutes = adjustedDuration.inMinutes % 60;
    final int remainingSeconds = adjustedDuration.inSeconds % 60;

    // Format the result as HH:mm:ss
    final String formattedTotal = "${totalHours.toString().padLeft(2, '0')}:"
        "${remainingMinutes.toString().padLeft(2, '0')}:"
        "${remainingSeconds.toString().padLeft(2, '0')}";

    return formattedTotal;
  }

  Future<void> _toselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Earliest date allowed
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF004AAD), // Header background color
            colorScheme: ColorScheme.light(
              primary: Color(0xFF004AAD), // Selected date and header text color
            ),
            dialogBackgroundColor: Colors.white, // Picker background color
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF004AAD), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      }, // Latest date allowed
    );
    if (picked != null && picked != _toselectedDate) {
      setState(() {
        _toselectedDate = picked;
        _todateController.text =
            DateFormat('yyyy-MM-dd').format(_toselectedDate!);
      });
      to_date = DateFormat('yyyy-MM-dd').format(_toselectedDate!);

      print(to_date);
      "Selected Date: ${DateFormat('yyyy-MM-dd').format(_toselectedDate!)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0xFFF9FAFB),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF9FAFB),
            title: const Text(
              'Attendance',
              style: TextStyle(color: Colors.black),
            ),
            leading: InkWell(
              child: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          floatingActionButton: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: isExtended
                ? FloatingActionButton.extended(
                    backgroundColor: Color(0xFF004AAD),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.88,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: StatefulBuilder(
                                builder: (BuildContext context, setModalState) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 4,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF98A2B3),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              'Reqularize Attendance',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF004AAD),
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Divider(
                                                indent: 4,
                                                endIndent: 4,
                                                color: Colors.black12,
                                                thickness: 0.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Form(
                                        key: _regularizeformkey,
                                        child: Row(
                                          children: [],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: const Text(
                                              'Employee',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Color(0xFF667085),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 50,
                                            width: 361,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Color(0xFFE9E9E9)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 10.0),
                                              child: DropdownButton<String>(
                                                focusColor:
                                                Colors.transparent,
                                                isExpanded: true,
                                                underline:
                                                SizedBox(), // Removes underline
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Color(0xFF667085),
                                                ),
                                                iconSize: 22,
                                                value:
                                                modalSelected, // Ensure modalSelectedItem matches one of the values in leavetype
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    4),
                                                items: membervalue.map((r) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: r
                                                        .id, // Use ID as the value
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical:
                                                          8.0),
                                                      child: Text(
                                                        r.name, // Display the name in the dropdown
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors
                                                                .black),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  setModalState(() {
                                                    modalSelected =
                                                        value; // Update the selected ID
                                                    print(
                                                        "Selected ID: $modalSelected"); // Debugging
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'From Date',
                                                      style: TextStyle(
                                                          color: Color(0xFF667085)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 75,
                                                    width: 160,
                                                    child: TextFormField(
                                                      controller:
                                                          _fromdateController,
                                                      readOnly: true,
                                                      decoration: InputDecoration(
                                                        floatingLabelStyle:
                                                            const TextStyle(
                                                          color: Color(0xFFC5C5C5),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        labelStyle: const TextStyle(
                                                          color: Color(
                                                              0xFFC5C5C5), // Default label color
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical:
                                                              10.0, // Adjust vertical padding for height
                                                          horizontal:
                                                              10.0, // Adjust horizontal padding
                                                        ),
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .calendar_month_outlined,
                                                            color: Color(
                                                                0xFF004AAD), // Example color for the icon
                                                          ),
                                                          onPressed: () {
                                                            _fromselectDate(
                                                                context); // Call the date picker function
                                                          },
                                                        ),
                                                        errorStyle: const TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          color: Color(0xFFDC897C),
                                                        ),

                                                        // Borders
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFE9E9E9), // Border color when enabled
                                                            width:
                                                                1, // Adjust the border width as needed
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFE9E9E9), // Border color when focused
                                                            width: 1,
                                                          ),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFDC897C), // Border color when error occurs
                                                            width: 1,
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFDC897C), // Border color when error occurs and focused
                                                            width: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'To Date',
                                                      style: TextStyle(
                                                          color: Color(0xFF667085)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 75,
                                                    width: 160,
                                                    child: TextFormField(
                                                      controller: _todateController,
                                                      readOnly: true,
                                                      decoration: InputDecoration(
                                                        floatingLabelStyle:
                                                            const TextStyle(
                                                          color: Color(0xFFC5C5C5),
                                                          fontFamily: 'Poppins',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        labelStyle: const TextStyle(
                                                          color: Color(
                                                              0xFFC5C5C5), // Default label color
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical:
                                                              10.0, // Adjust vertical padding for height
                                                          horizontal:
                                                              10.0, // Adjust horizontal padding
                                                        ),
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .calendar_month_outlined,
                                                            color: Color(
                                                                0xFF004AAD), // Example color for the icon
                                                          ),
                                                          onPressed: () {
                                                            _toselectDate(
                                                                context); // Call the date picker function
                                                          },
                                                        ),
                                                        errorStyle: const TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Poppins',
                                                          color: Color(0xFFDC897C),
                                                        ),

                                                        // Borders
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFE9E9E9), // Border color when enabled
                                                            width:
                                                                1, // Adjust the border width as needed
                                                          ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFE9E9E9), // Border color when focused
                                                            width: 1,
                                                          ),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFDC897C), // Border color when error occurs
                                                            width: 1,
                                                          ),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
                                                          borderSide:
                                                              const BorderSide(
                                                            color: Color(
                                                                0xFFDC897C), // Border color when error occurs and focused
                                                            width: 1,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'check-in',
                                                  style: TextStyle(
                                                      color: Color(0xFF667085)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 75,
                                                width: 160,
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _checkin,
                                                  decoration: InputDecoration(
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                      color: Color(0xFFC5C5C5),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Color(
                                                          0xFFC5C5C5), // Default label color
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      vertical:
                                                          10.0, // Adjust vertical padding for height
                                                      horizontal:
                                                          10.0, // Adjust horizontal padding
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .watch_later_outlined,
                                                        color: Color(
                                                            0xFF004AAD), // Example color for the icon
                                                      ),
                                                      onPressed: () {
                                                        _checkInTime(
                                                            context); // Call the date picker function
                                                      },
                                                    ),
                                                    errorStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFDC897C),
                                                    ),

                                                    // Borders
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when enabled
                                                        width:
                                                            1, // Adjust the border width as needed
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs
                                                        width: 1,
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs and focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Check-out',
                                                  style: TextStyle(
                                                      color: Color(0xFF667085)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 75,
                                                width: 160,
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _checkout,
                                                  decoration: InputDecoration(
                                                    floatingLabelStyle:
                                                        const TextStyle(
                                                      color: Color(0xFFC5C5C5),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Color(
                                                          0xFFC5C5C5), // Default label color
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      vertical:
                                                          10.0, // Adjust vertical padding for height
                                                      horizontal:
                                                          10.0, // Adjust horizontal padding
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .watch_later_outlined,
                                                        color: Color(
                                                            0xFF004AAD), // Example color for the icon
                                                      ),
                                                      onPressed: () {
                                                        _checkOutTime(
                                                            context); // Call the date picker function
                                                      },
                                                    ),
                                                    errorStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFDC897C),
                                                    ),

                                                    // Borders
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when enabled
                                                        width:
                                                            1, // Adjust the border width as needed
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs
                                                        width: 1,
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs and focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Comments',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF667085)),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            height: 100.0, // Set desired height
                                            width: 361.0, // Set desired width
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: Color(0xFFE9E9E9)),
                                            ),
                                            child: TextFormField(
                                              controller: _comments,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 8.0),
                                                border: InputBorder
                                                    .none, // Removes default border
                                              ),
                                              maxLines:
                                                  null, // Allows multiple lines of text
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: [
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      width: 151, height: 42),
                                              child: ElevatedButton.icon(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFFE4E7EC),
                                                    elevation: .1,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                  ),
                                                  label: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                          child: InkWell(
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color(
                                                                  0xFF030303)),
                                                        ),
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ConstrainedBox(
                                              constraints:
                                                  BoxConstraints.tightFor(
                                                      width: 151, height: 42),
                                              child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    if (_regularizeformkey
                                                        .currentState!
                                                        .validate()) {
                                                      _regularizeformkey
                                                          .currentState
                                                          ?.save();
                                                      _regularizeModel.checkin =
                                                          _fromdateController
                                                              .text;
                                                      _regularizeModel
                                                              .checkout =
                                                          _todateController
                                                              .text;
                                                      _regularizeModel
                                                              .checkintime =
                                                          _checkin.text + ":00";
                                                      _regularizeModel
                                                              .checkouttime =
                                                          _checkout.text +
                                                              ":00";
                                                      _regularizeModel
                                                              .comments =
                                                          _comments.text;
                                                      print(_regularizeModel
                                                          .checkin);
                                                      print(_regularizeModel
                                                          .checkout);
                                                      print(_regularizeModel
                                                          .checkintime);
                                                      print(_regularizeModel
                                                          .checkouttime);
                                                      _con?.applymanual(
                                                          _regularizeModel,context);
                                                      _regularizeformkey.currentState?.reset();

                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFF004AAD),
                                                    elevation: .1,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                  ),
                                                  label: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                          child: InkWell(
                                                        child: const Text(
                                                          "Apply",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    label: const Text(
                      'Regularize',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 14),
                    ),
                  )
                : FloatingActionButton(
                    backgroundColor: Color(0xFF004AAD),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.88,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: StatefulBuilder(
                                builder: (BuildContext context, setModalState) {
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 4,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF98A2B3),
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Text(
                                              'Reqularize Attendance',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFF004AAD),
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Divider(
                                                indent: 4,
                                                endIndent: 4,
                                                color: Colors.black12,
                                                thickness: 0.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Form(
                                        key: _regularizeformkey,
                                        child: Row(
                                          children: [],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'From Date',
                                                  style: TextStyle(
                                                      color: Color(0xFF667085)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 75,
                                                width: 160,
                                                child: TextFormField(
                                                  controller:
                                                  _fromdateController,
                                                  decoration: InputDecoration(
                                                    floatingLabelStyle:
                                                    const TextStyle(
                                                      color: Color(0xFFC5C5C5),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Color(
                                                          0xFFC5C5C5), // Default label color
                                                    ),
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                      vertical:
                                                      10.0, // Adjust vertical padding for height
                                                      horizontal:
                                                      10.0, // Adjust horizontal padding
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .calendar_month_outlined,
                                                        color: Color(
                                                            0xFF004AAD), // Example color for the icon
                                                      ),
                                                      onPressed: () {
                                                        _fromselectDate(
                                                            context); // Call the date picker function
                                                      },
                                                    ),
                                                    errorStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFDC897C),
                                                    ),

                                                    // Borders
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when enabled
                                                        width:
                                                        1, // Adjust the border width as needed
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs
                                                        width: 1,
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs and focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'To Date',
                                                  style: TextStyle(
                                                      color: Color(0xFF667085)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 75,
                                                width: 160,
                                                child: TextFormField(
                                                  controller: _todateController,
                                                  decoration: InputDecoration(
                                                    floatingLabelStyle:
                                                    const TextStyle(
                                                      color: Color(0xFFC5C5C5),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Color(
                                                          0xFFC5C5C5), // Default label color
                                                    ),
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                      vertical:
                                                      10.0, // Adjust vertical padding for height
                                                      horizontal:
                                                      10.0, // Adjust horizontal padding
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .calendar_month_outlined,
                                                        color: Color(
                                                            0xFF004AAD), // Example color for the icon
                                                      ),
                                                      onPressed: () {
                                                        _toselectDate(
                                                            context); // Call the date picker function
                                                      },
                                                    ),
                                                    errorStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFDC897C),
                                                    ),

                                                    // Borders
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when enabled
                                                        width:
                                                        1, // Adjust the border width as needed
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs
                                                        width: 1,
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs and focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'check-in',
                                                  style: TextStyle(
                                                      color: Color(0xFF667085)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 75,
                                                width: 160,
                                                child: TextFormField(
                                                  controller: _checkin,
                                                  decoration: InputDecoration(
                                                    floatingLabelStyle:
                                                    const TextStyle(
                                                      color: Color(0xFFC5C5C5),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Color(
                                                          0xFFC5C5C5), // Default label color
                                                    ),
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                      vertical:
                                                      10.0, // Adjust vertical padding for height
                                                      horizontal:
                                                      10.0, // Adjust horizontal padding
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .watch_later_outlined,
                                                        color: Color(
                                                            0xFF004AAD), // Example color for the icon
                                                      ),
                                                      onPressed: () {
                                                        _checkInTime(
                                                            context); // Call the date picker function
                                                      },
                                                    ),
                                                    errorStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFDC897C),
                                                    ),

                                                    // Borders
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when enabled
                                                        width:
                                                        1, // Adjust the border width as needed
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs
                                                        width: 1,
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs and focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Check-out',
                                                  style: TextStyle(
                                                      color: Color(0xFF667085)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 75,
                                                width: 160,
                                                child: TextFormField(
                                                  controller: _checkout,
                                                  decoration: InputDecoration(
                                                    floatingLabelStyle:
                                                    const TextStyle(
                                                      color: Color(0xFFC5C5C5),
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                    ),
                                                    labelStyle: const TextStyle(
                                                      color: Color(
                                                          0xFFC5C5C5), // Default label color
                                                    ),
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                      vertical:
                                                      10.0, // Adjust vertical padding for height
                                                      horizontal:
                                                      10.0, // Adjust horizontal padding
                                                    ),
                                                    suffixIcon: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .watch_later_outlined,
                                                        color: Color(
                                                            0xFF004AAD), // Example color for the icon
                                                      ),
                                                      onPressed: () {
                                                        _checkOutTime(
                                                            context); // Call the date picker function
                                                      },
                                                    ),
                                                    errorStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                      color: Color(0xFFDC897C),
                                                    ),

                                                    // Borders
                                                    enabledBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when enabled
                                                        width:
                                                        1, // Adjust the border width as needed
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFE9E9E9), // Border color when focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs
                                                        width: 1,
                                                      ),
                                                    ),
                                                    focusedErrorBorder:
                                                    OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                      borderSide:
                                                      const BorderSide(
                                                        color: Color(
                                                            0xFFDC897C), // Border color when error occurs and focused
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Comments',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF667085)),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            height: 100.0, // Set desired height
                                            width: 361.0, // Set desired width
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: Color(0xFFE9E9E9)),
                                            ),
                                            child: TextFormField(
                                              controller: _comments,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0),
                                                border: InputBorder
                                                    .none, // Removes default border
                                              ),
                                              maxLines:
                                              null, // Allows multiple lines of text
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 20.0),
                                        child: Row(
                                          children: [
                                            ConstrainedBox(
                                              constraints:
                                              BoxConstraints.tightFor(
                                                  width: 151, height: 42),
                                              child: ElevatedButton.icon(
                                                  onPressed: () {},
                                                  style:
                                                  ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                    Color(0xFFE4E7EC),
                                                    elevation: .1,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                    ),
                                                  ),
                                                  label: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Center(
                                                          child: InkWell(
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  'Poppins',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Color(
                                                                      0xFF030303)),
                                                            ),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            ConstrainedBox(
                                              constraints:
                                              BoxConstraints.tightFor(
                                                  width: 151, height: 42),
                                              child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    if (_regularizeformkey
                                                        .currentState!
                                                        .validate()) {
                                                      _regularizeformkey
                                                          .currentState
                                                          ?.save();
                                                      _regularizeModel.checkin =
                                                          _fromdateController
                                                              .text;
                                                      _regularizeModel
                                                          .checkout =
                                                          _todateController
                                                              .text;
                                                      _regularizeModel
                                                          .checkintime =
                                                          _checkin.text + ":00";
                                                      _regularizeModel
                                                          .checkouttime =
                                                          _checkout.text +
                                                              ":00";
                                                      _regularizeModel
                                                          .comments =
                                                          _comments.text;
                                                      print(_regularizeModel
                                                          .checkin);
                                                      print(_regularizeModel
                                                          .checkout);
                                                      print(_regularizeModel
                                                          .checkintime);
                                                      print(_regularizeModel
                                                          .checkouttime);
                                                      _con?.applymanual(
                                                          _regularizeModel,context);
                                                      _regularizeformkey.currentState?.reset();

                                                    }
                                                  },
                                                  style:
                                                  ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                    Color(0xFF004AAD),
                                                    elevation: .1,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                    ),
                                                  ),
                                                  label: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Center(
                                                          child: InkWell(
                                                            child: const Text(
                                                              "Apply",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  'Poppins',
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color:
                                                                  Colors.white),
                                                            ),
                                                          )),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
          ),
          body: Column(
            children: [
              // Search and Filter Row
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    // Search Container
                    Container(
                      height: 45,
                      width: 295,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        color: Color(0xFFFCFCFC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.search,
                                    color: Color(0xFF98A2B3), size: 20),
                                SizedBox(width: 2),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Color(0xFF98A2B3),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Filter Button
                    Container(
                      height: 40,
                      width: 35,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Image.asset('assets/images/filter.png'),
                    ),
                  ],
                ),
              ),
              // Tabs and TabBarView
              DefaultTabController(
                length: 3,
                child: Expanded(
                  child: Column(
                    children: [
                      ButtonsTabBar(
                        radius: 12,
                        labelSpacing: 12,
                        backgroundColor: const Color(0xFFE0EDFF),
                        unselectedBackgroundColor: Colors.transparent,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 32),
                        unselectedBorderColor: Colors.transparent,
                        unselectedLabelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF98A2B3),
                        ),
                        labelStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF030303),
                        ),
                        tabs: const [
                          Tab(text: 'All'),
                          Tab(text: 'Manual'),
                          Tab(text: 'Others'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _con!.isLoading ?
                            ListView.builder(
                              itemCount:4,
                              itemBuilder: (BuildContext context, int index) {
                                return const AttendanceShimmer();
                              },
                            )
                                : _con!.attendancelist.isEmpty? Container(
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/norecord.svg',
                                ),
                              ),
                            ):
                            ListView.builder(
                              controller: scrollController,
                              itemCount: _con?.attendancelist.length,
                              itemBuilder: (BuildContext context, int index) {
                                var attendance = _con?.attendancelist[index];
                                print(attendance?.checkintime);
                                return SingleChildScrollView(
                                  child:
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, left: 10, right: 10),
                                          child: Stack(children: [
                                            Positioned(
                                              top: 17,
                                              right: -17,
                                              child: Container(
                                                height: 100,
                                                width: 100,
                                                child: Image.asset(
                                                  'assets/images/biometric.png',
                                                  fit: BoxFit.contain,
                                                  color: Color(0xFFE0EDFF),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 141,
                                              width: 361,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFFE4E7EC)),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Center(
                                                            child: Text(
                                                          formatDate(attendance!
                                                              .checkin),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Color(
                                                                  0xFF030303),
                                                              fontFamily:
                                                                  'Poppins'),
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7.0, left: 10),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                                child: Text(
                                                              attendance
                                                                  .checkinmedium,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      0xFF004AAD),
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20.0,
                                                                    left: 10),
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      'In & Out',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF98A2B3),
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'Poppins'),
                                                                    ))
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10.0,
                                                                    left: 10),
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      "${formatedTime(attendance.checkintime)} - ${attendance.checkouttime.isEmpty ? " " : formatedTime(attendance.checkouttime)}",
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF030303),
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'Poppins'),
                                                                    ))
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 60,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 20.0,
                                                                    left: 10),
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      'Total Hours',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF98A2B3),
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'Poppins'),
                                                                    ))
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10.0,
                                                                    left: 10),
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      attendance
                                                                              .checkouttime
                                                                              .isEmpty
                                                                          ? "0"
                                                                          : calculateTimeDifference(formatedTime(attendance.checkintime), formatedTime(attendance.checkouttime.isEmpty ? "00:00:00" : attendance.checkouttime)) +
                                                                              " Hours ",
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF030303),
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'Poppins'),
                                                                    ))
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            ListView.builder(
                              controller: scrollController,
                              itemCount: _con?.attendancelist.length,
                              itemBuilder: (BuildContext context, int index) {
                                var attendance = _con?.attendancelist[index];
                                print(attendance?.checkintime);
                                return attendance?.checkinmedium == 'manual'
                                    ? SingleChildScrollView(

                                        child:
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10,
                                                    right: 10),
                                                child: Stack(children: [
                                                  Positioned(
                                                    top: 17,
                                                    right: -17,
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: Image.asset(
                                                        'assets/images/biometric.png',
                                                        fit: BoxFit.contain,
                                                        color:
                                                            Color(0xFFE0EDFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 200,
                                                    width: 361,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFE4E7EC)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 15.0,
                                                              left: 10),
                                                          child: Row(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  Center(
                                                                      child:
                                                                      Text(
                                                                        attendance
                                                                            !.checkinmedium,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            14,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                            color: Color(
                                                                                0xFF004AAD),
                                                                            fontFamily:
                                                                            'Poppins'),
                                                                      )),
                                                                ],
                                                              ),
                                                              Spacer(),

                                                              attendance.status == 'pending'?
                                                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(50),
                                                                        border: Border.all(
                                                                            color: Colors.black12
                                                                        )),
                                                                    child: Center(
                                                                        child: InkWell(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Center(
                                                                              child: Image.asset(
                                                                                'assets/images/edit-2.png',
                                                                                height: 20,
                                                                                width: 20,
                                                                                color:
                                                                                Color(0xFF004AAD),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () {
                                                                            editmanualcheckin(attendance,attendance.id);

                                                                          },
                                                                        )),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(50),
                                                                        border: Border.all(
                                                                            color: Colors.black12
                                                                        )),
                                                                    child: Center(
                                                                        child: InkWell(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Center(
                                                                              child: Image.asset(
                                                                                'assets/images/trash.png',
                                                                                height: 20,
                                                                                width: 20,
                                                                                color:
                                                                                Color(0xFFEA7971),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () {
                                                                            deletemanual(attendance.id,context,attendance.userid);

                                                                          },
                                                                        )),
                                                                  ),
                                                                ],
                                                              ) : Container(),
                                                            ],
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Center(
                                                                  child: Text(
                                                                '${formatDate(attendance!.checkin)} -${formatDate(attendance!.checkout)}' ,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xFF030303),
                                                                    fontFamily:
                                                                        'Poppins'),
                                                              )),
                                                            ],
                                                          ),
                                                        ),

                                                        Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only( top: 10,

                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            'In & Out',
                                                                            style: TextStyle(
                                                                                color: Color(0xFF98A2B3),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 10.0,
                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            "${formatedTime(attendance.checkintime)} - ${attendance.checkouttime.isEmpty ? " " : formatedTime(attendance.checkouttime)}",
                                                                            style: TextStyle(
                                                                                color: Color(0xFF030303),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 60,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                    top: 10,

                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            'Total Hours',
                                                                            style: TextStyle(
                                                                                color: Color(0xFF98A2B3),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 10.0,
                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            attendance.checkouttime.isEmpty
                                                                                ? "0"
                                                                                : calculateTimeDifference(formatedTime(attendance.checkintime), formatedTime(attendance.checkouttime.isEmpty ? "00:00:00" : attendance.checkouttime)) + " Hours ",
                                                                            style: TextStyle(
                                                                                color: Color(0xFF030303),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Container(
                                                            height: 25,
                                                            width: 78,
                                                            decoration: BoxDecoration(
                                                                color: attendance.status == 'approved'?Color(0xFF65BD95):Color(0xFFF1BB5B),
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                    4)),
                                                            child: Center(
                                                                child: Text(
                                                                    attendance
                                                                        .status,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                        'Poppins',
                                                                        fontSize:
                                                                        12,
                                                                        fontWeight:
                                                                        FontWeight.w400,
                                                                        color: Colors.white))),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(child: Container());
                              },
                            ),
                            ListView.builder(
                              itemCount: _con?.attendancelist.length,
                              itemBuilder: (BuildContext context, int index) {
                                var attendance = _con?.attendancelist[index];
                                print(attendance?.checkintime);
                                return attendance?.checkinmedium != 'manual'
                                    ? SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 10,
                                                    right: 10),
                                                child: Stack(children: [
                                                  Positioned(
                                                    top: 17,
                                                    right: -17,
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: Image.asset(
                                                        'assets/images/biometric.png',
                                                        fit: BoxFit.contain,
                                                        color:
                                                            Color(0xFFE0EDFF),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 141,
                                                    width: 361,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFE4E7EC)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Center(
                                                                  child: Text(
                                                                formatDate(
                                                                    attendance!
                                                                        .checkin),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xFF030303),
                                                                    fontFamily:
                                                                        'Poppins'),
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 7.0,
                                                                  left: 10),
                                                          child: Row(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    attendance
                                                                        .checkinmedium,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Color(
                                                                            0xFF004AAD),
                                                                        fontFamily:
                                                                            'Poppins'),
                                                                  )),
                                                                ],
                                                              ),

                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 20.0,
                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            'In & Out',
                                                                            style: TextStyle(
                                                                                color: Color(0xFF98A2B3),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 10.0,
                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            "${formatedTime(attendance.checkintime)} - ${attendance.checkouttime.isEmpty ? " " : formatedTime(attendance.checkouttime)}",
                                                                            style: TextStyle(
                                                                                color: Color(0xFF030303),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width: 60,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 20.0,
                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            'Total Hours',
                                                                            style: TextStyle(
                                                                                color: Color(0xFF98A2B3),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      top: 10.0,
                                                                      left: 10),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                              child: Text(
                                                                            attendance.checkouttime.isEmpty
                                                                                ? "0"
                                                                                : calculateTimeDifference(formatedTime(attendance.checkintime), formatedTime(attendance.checkouttime.isEmpty ? "00:00:00" : attendance.checkouttime)) + " Hours ",
                                                                            style: TextStyle(
                                                                                color: Color(0xFF030303),
                                                                                fontSize: 12,
                                                                                fontFamily: 'Poppins'),
                                                                          ))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(child: Container());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
 

  void editmanualcheckin(Attendancelog attendance,String id) {
    String _formatTime(String apiTime) {
      try {
        final parsedTime = DateFormat('HH:mm:ss').parse(apiTime);
        return DateFormat('HH:mm').format(parsedTime);
      } catch (e) {
        print('Error parsing time: $e');
        return apiTime; // Fallback to original if parsing fails
      }
    }
    _fromdateController.text = attendance.checkin;
    _todateController.text = attendance.checkout;
    _checkin.text=_formatTime(attendance.checkintime);
    _checkout.text =_formatTime(attendance.checkouttime);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.88,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StatefulBuilder(
              builder: (BuildContext context, setModalState) {
                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF98A2B3),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0),
                          child: Text(
                            'Edit Reqularize Attendance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF004AAD),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Divider(
                              indent: 4,
                              endIndent: 4,
                              color: Colors.black12,
                              thickness: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: _regularizeformkey,
                      child: Row(
                        children: [],
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Text(
                                'From Date',
                                style: TextStyle(
                                    color: Color(0xFF667085)),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              width: 160,
                              child: TextFormField(
                                controller:
                                _fromdateController,
                                decoration: InputDecoration(
                                  floatingLabelStyle:
                                  const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w400,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Color(
                                        0xFFC5C5C5), // Default label color
                                  ),
                                  contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                    vertical:
                                    10.0, // Adjust vertical padding for height
                                    horizontal:
                                    10.0, // Adjust horizontal padding
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons
                                          .calendar_month_outlined,
                                      color: Color(
                                          0xFF004AAD), // Example color for the icon
                                    ),
                                    onPressed: () {
                                      _fromselectDate(
                                          context); // Call the date picker function
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFDC897C),
                                  ),

                                  // Borders
                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when enabled
                                      width:
                                      1, // Adjust the border width as needed
                                    ),
                                  ),
                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when focused
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs and focused
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Text(
                                'To Date',
                                style: TextStyle(
                                    color: Color(0xFF667085)),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              width: 160,
                              child: TextFormField(
                                controller: _todateController,
                                decoration: InputDecoration(
                                  floatingLabelStyle:
                                  const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w400,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Color(
                                        0xFFC5C5C5), // Default label color
                                  ),
                                  contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                    vertical:
                                    10.0, // Adjust vertical padding for height
                                    horizontal:
                                    10.0, // Adjust horizontal padding
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons
                                          .calendar_month_outlined,
                                      color: Color(
                                          0xFF004AAD), // Example color for the icon
                                    ),
                                    onPressed: () {
                                      _toselectDate(
                                          context); // Call the date picker function
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFDC897C),
                                  ),

                                  // Borders
                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when enabled
                                      width:
                                      1, // Adjust the border width as needed
                                    ),
                                  ),
                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when focused
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs and focused
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Text(
                                'check-in',
                                style: TextStyle(
                                    color: Color(0xFF667085)),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              width: 160,
                              child: TextFormField(
                                controller: _checkin,
                                decoration: InputDecoration(
                                  floatingLabelStyle:
                                  const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w400,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Color(
                                        0xFFC5C5C5), // Default label color
                                  ),
                                  contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                    vertical:
                                    10.0, // Adjust vertical padding for height
                                    horizontal:
                                    10.0, // Adjust horizontal padding
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons
                                          .watch_later_outlined,
                                      color: Color(
                                          0xFF004AAD), // Example color for the icon
                                    ),
                                    onPressed: () {
                                      _checkInTime(
                                          context); // Call the date picker function
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFDC897C),
                                  ),

                                  // Borders
                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when enabled
                                      width:
                                      1, // Adjust the border width as needed
                                    ),
                                  ),
                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when focused
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs and focused
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Text(
                                'Check-out',
                                style: TextStyle(
                                    color: Color(0xFF667085)),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              width: 160,
                              child: TextFormField(
                                controller: _checkout,
                                decoration: InputDecoration(
                                  floatingLabelStyle:
                                  const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w400,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Color(
                                        0xFFC5C5C5), // Default label color
                                  ),
                                  contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                    vertical:
                                    10.0, // Adjust vertical padding for height
                                    horizontal:
                                    10.0, // Adjust horizontal padding
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons
                                          .watch_later_outlined,
                                      color: Color(
                                          0xFF004AAD), // Example color for the icon
                                    ),
                                    onPressed: () {
                                      _checkOutTime(
                                          context); // Call the date picker function
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFDC897C),
                                  ),

                                  // Borders
                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when enabled
                                      width:
                                      1, // Adjust the border width as needed
                                    ),
                                  ),
                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when focused
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4),
                                    borderSide:
                                    const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs and focused
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF667085)),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          height: 100.0, // Set desired height
                          width: 361.0, // Set desired width
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(8.0),
                            border: Border.all(
                                color: Color(0xFFE9E9E9)),
                          ),
                          child: TextFormField(
                            controller: _comments,
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0),
                              border: InputBorder
                                  .none, // Removes default border
                            ),
                            maxLines:
                            null, // Allows multiple lines of text
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          ConstrainedBox(
                            constraints:
                            BoxConstraints.tightFor(
                                width: 151, height: 42),
                            child: ElevatedButton.icon(
                                onPressed: () {},
                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Color(0xFFE4E7EC),
                                  elevation: .1,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4.0),
                                  ),
                                ),
                                label: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    Center(
                                        child: InkWell(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                fontFamily:
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                color: Color(
                                                    0xFF030303)),
                                          ),
                                          onTap: () {
                                            Navigator.pop(
                                                context);
                                          },
                                        )),
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ConstrainedBox(
                            constraints:
                            BoxConstraints.tightFor(
                                width: 151, height: 42),
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_regularizeformkey
                                      .currentState!
                                      .validate()) {
                                    _regularizeformkey
                                        .currentState
                                        ?.save();
                                    _regularizeModel.checkin =
                                        _fromdateController
                                            .text;
                                    _regularizeModel
                                        .checkout =
                                        _todateController
                                            .text;
                                    _regularizeModel
                                        .checkintime =
                                        _checkin.text + ":00";
                                    _regularizeModel
                                        .checkouttime =
                                        _checkout.text +
                                            ":00";
                                    _regularizeModel
                                        .comments =
                                        _comments.text;
                                    print(_regularizeModel
                                        .checkin);
                                    print(_regularizeModel
                                        .checkout);
                                    print(_regularizeModel
                                        .checkintime);
                                    print(_regularizeModel
                                        .checkouttime);
                                    _con?.editapplymanual(
                                        _regularizeModel,context,id);
                                  }
                                },
                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Color(0xFF004AAD),
                                  elevation: .1,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                        4.0),
                                  ),
                                ),
                                label: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    Center(
                                        child: InkWell(
                                          child: const Text(
                                            "Apply",
                                            style: TextStyle(
                                                fontFamily:
                                                'Poppins',
                                                fontSize: 14,
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                color:
                                                Colors.white),
                                          ),
                                        )),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );


  }
  void deletemanual(String id, BuildContext context, String userid) {
    print (id);
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      "Are you Sure ? ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "This action canot be undone",
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
                        label: "Delete",
                        backgroundColor: Color(0xFF004AAD),
                        textColor: Colors.white,
                        onPressed: () async {
                          _con?.deletemanualcheckin(context,id,userid);
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
}
