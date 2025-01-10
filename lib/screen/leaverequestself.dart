import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sampleaura/controller/homapage.dart';
import 'package:sampleaura/model/dropdown/leavetype.dart';
import 'package:sampleaura/model/dropdown/member.dart';
import 'package:sampleaura/model/request/leaverequest.dart';
import 'package:sampleaura/model/response/leaverequestbtuserid.dart';
import 'package:sampleaura/screen/homepage.dart';
import 'package:sampleaura/screen/leaverequest.dart';
import 'package:sampleaura/widget/attendanceself.dart';

import '../controller/leaverequest.dart';
import 'homescreen.dart';

class SelfLeaveRequest extends StatefulWidget {
  const SelfLeaveRequest({Key? key}) : super(key: key);

  @override
  _SelfLeaveRequestState createState() => _SelfLeaveRequestState();
}

class _SelfLeaveRequestState extends StateMVC<SelfLeaveRequest> {
  LeaveRequestController? _con = null;
  HomePageController? homepagecontroller = null;
  ScrollController scrollController = ScrollController();
  bool isExtended = true;
  final List<String> items = ["Item 1", "Item 2", "Item 3", "Item 4"];
  String? selectedItems;
  TextEditingController _fromdateController = TextEditingController();
  TextEditingController _todateController = TextEditingController();
  TextEditingController _reason = TextEditingController();
  TextEditingController _fromdateeditController = TextEditingController();
  TextEditingController _todateeditController = TextEditingController();
  TextEditingController _editreason = TextEditingController();
  DateTime? _fromselectedDate;
  String from_date = '';
  DateTime? _toselectedDate;
  String to_date = '';
  List<LeaveTypeDropdownValue> leavetype = [];
  List<MemberDropdown> membervalue= [];
  final _leaveformkey = GlobalKey<FormState>();

  final _editleaveformkey = GlobalKey<FormState>();
  String? leaveid;
  LeaveRequestModel _leaveRequestModel = LeaveRequestModel();
  String? modalSelectedItem;
  String? modalSelectedItems = 'half';
  String? modalSelected;
  bool edit =false;
  bool? create = false;
  bool? leaveedit = false;
  bool? leavedelete = false;
  //
  // _SelfLeaveRequestState() : super(LeaveRequestController()) {
  //   _con = controller as LeaveRequestController?;
  // }
   _SelfLeaveRequestState() : super (){
     _con = LeaveRequestController();
     homepagecontroller = HomePageController();
   }
  // _HomepageState() : super(){
  //   attendanceController = AttendanceController();
  //   homePageController = HomePageController();
  // }
  final Map<String, String> leaveTypeImageMap = {
    'Sick leave': 'assets/images/Vector.png',
    'Casual Leave': 'assets/images/beach2.png'
  };

  @override
  void initState() {
    super.initState();
    _con?.fetchresponseuserleave();
    _con?.viewLeaveTypevalue();
    _con?.viewmembervalue();
    print('leave balance');
    print(_con?.balance);

    _loadLeavetype();
    _loadmember();
    DateTime.now();
    print(_con?.leaveuserdata.length);
    _loadpermission();

    // Add listener to scroll controller to detect scroll direction
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
  Future<void> _loadpermission()async {
    await homepagecontroller?.fetchrolepermission();
    print(homepagecontroller?.permission?.permission?.self);
    //print(homepagecontroller?.create);
    create = homepagecontroller!.create;
    leaveedit = homepagecontroller!.edit;
    leavedelete = homepagecontroller!.delete;
    print(create);

  }
  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date); // Parse the ISO 8601 string
    final formattedDate = DateFormat('dd MMM, yyyy')
        .format(parsedDate); // Format to desired output
    return formattedDate;
  }

  Future<void> _loadLeavetype() async {
    try {
      if (_con != null) {
        await _con!.viewLeaveTypevalue(); // Fetch leavetype
        if (_con!.fetchroledatavlaue != null) {
          setState(() {
            leavetype = _con!.fetchroledatavlaue;
            print('Loaded roles: $leavetype'); // Verify the data here
          });
        } else {
          print('Error: fetchroledatavlaue is null');
        }
      } else {
        print('Error: _con is null');
      }
    } catch (e) {
      print('Error loading leavetype: $e');
    } finally {
      setState(() {
        _con?.isLoading = false;
      });
    }
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

  Future<void> _fromselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromselectedDate ?? DateTime.now(), // Use current date if `_fromselectedDate` is null
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

    if (picked != null) {
      setState(() {
        _fromselectedDate = picked;
        _fromdateController.text = DateFormat('yyyy-MM-dd').format(picked); // Update the TextFormField with the selected date
      });

      from_date = DateFormat('yyyy-MM-dd').format(picked); // Update the `from_date` variable
      print("Selected Date: $from_date");
      _fromdateController.text = from_date;
      // Log the selected date
    }
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
        _todateController.text = DateFormat('yyyy-MM-dd').format(picked);

      });
      to_date = DateFormat('yyyy-MM-dd').format(_toselectedDate!);

      print(to_date);
      "Selected Date: ${DateFormat('yyyy-MM-dd').format(_toselectedDate!)}";
    }
  }

  Future<void> _fromeditselectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromselectedDate ?? DateTime.now(), // Use current date if `_fromselectedDate` is null
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

    if (picked != null) {
      setState(() {
        _fromselectedDate = picked;
        _fromdateeditController.text = DateFormat('yyyy-MM-dd').format(picked); // Update the TextFormField with the selected date
      });

      from_date = DateFormat('yyyy-MM-dd').format(picked); // Update the `from_date` variable
      print("Selected Date: $from_date");
      _fromdateController.text = from_date;
      // Log the selected date
    }
  }

  Future<void> _toeditselectDate(BuildContext context) async {
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
        _todateeditController.text = DateFormat('yyyy-MM-dd').format(picked);

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
            'Leaves',
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onTap: () {
              String email ='';
              Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(email)));
            },
          ),
        ),
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: isExtended
              ? create! ?
          FloatingActionButton.extended(
                  backgroundColor: Color(0xFF004AAD),
            onPressed:  () {
                    _fromdateController.text ='';
                    _todateController.text = '';
                    edit = false;
                    modalSelectedItem= null;
                    modalSelectedItems = null;
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        String? leavetypeid;
                        // Declare a local variable for modal state

                        return FractionallySizedBox(
                          heightFactor: 0.88,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: StatefulBuilder(
                              builder: (BuildContext context, setModalState) {
                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Form(
                                        key: _leaveformkey,
                                        child: Column(
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
                                                    padding:
                                                    const EdgeInsets.only(top: 20.0),
                                                    child: Text(
                                                      'Apply Leave',
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
                                              Column(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
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
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),

                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(
                                                                    left: 8.0),
                                                                child: Row(
                                                                  children: [
                                                                    const Text(
                                                                      'Leave type',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Poppins',
                                                                        fontSize: 14,
                                                                        color: Color(0xFF667085),
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: 20,),

                                                                    Container(
                                                                      height: 40,
                                                                      width: 40,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          color: Colors.blue.withOpacity(0.4)
                                                                      ),
                                                                      child: Center(child:  Text(_con!.balance.toString())),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                height: 50,
                                                                width: 160,
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
                                                                    modalSelectedItem, // Ensure modalSelectedItem matches one of the values in leavetype
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 14.0),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        4),
                                                                    items: leavetype.map((r) {
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
                                                                        modalSelectedItem =
                                                                            value; // Update the selected ID
                                                                        print(
                                                                            "Selected ID: $modalSelectedItem");
                                                                        _con?.viewLeavebalance(modalSelectedItem!);
                                                                        print(_con?.balance);// Debugging
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
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
                                                                padding: const EdgeInsets.only(
                                                                    left: 8.0),
                                                                child: const Text(
                                                                  'Leave Duration',
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
                                                                width: 160,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(4),
                                                                  border: Border.all(
                                                                    color: Color(0xFFE9E9E9),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                  child: DropdownButton<String>(
                                                                    isExpanded: true, // Ensures the dropdown covers the full width of the container
                                                                    underline: Container(), // Removes default underline
                                                                    value: modalSelectedItems, // This value should match one of the dropdown items
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    icon: Icon(
                                                                      Icons.keyboard_arrow_down,
                                                                      color: Color(0xFF667085),
                                                                    ), // Dropdown icon
                                                                    iconSize: 22,
                                                                    alignment: AlignmentDirectional.centerStart,
                                                                    style: TextStyle(color: Colors.black),
                                                                    items: <String>[
                                                                      'half',
                                                                      'full',
                                                                    ].map<DropdownMenuItem<String>>((String value) {
                                                                      return DropdownMenuItem<String>(
                                                                        value: value,
                                                                        child: Text(
                                                                          value,
                                                                          style: TextStyle(color: Colors.black),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                    onChanged: (String? value) {
                                                                      if (value != null) {
                                                                        setModalState(() {
                                                                          modalSelectedItems = value; // Update selected item
                                                                          print("Selected Item: $modalSelectedItems"); // Debugging output
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),

                                                          // TextFormField(
                                                          //   style: TextStyle(
                                                          //     fontSize: 18,
                                                          //
                                                          //   ),
                                                          //   decoration: InputDecoration(
                                                          //     hintText: ""
                                                          //
                                                          //   ),
                                                          // )
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
                                                              'From Date',
                                                              style: TextStyle(
                                                                  color: Color(0xFF667085)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 75,
                                                            width: 160,
                                                            child: TextFormField(
                                                              controller: _fromdateController,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return 'Select To Date';

                                                                }
                                                                return null;
                                                              },

                                                              readOnly: true,
                                                              decoration: InputDecoration(
                                                                floatingLabelStyle:
                                                                const TextStyle(
                                                                  color: Color(0xFFC5C5C5),
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400,
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
                                                              readOnly: true,
                                                              controller: _todateController,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return 'Select To Date';

                                                                }
                                                                return null;
                                                              },
                                                              decoration: InputDecoration(
                                                                floatingLabelStyle:
                                                                const TextStyle(
                                                                  color: Color(0xFFC5C5C5),
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w400,
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
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Reason',
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
                                                          controller: _reason,

                                                          decoration: InputDecoration(
                                                            contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 16.0,
                                                                vertical: 8.0),
                                                            border: InputBorder
                                                                .none, // Removes default border
                                                          ),
                                                          validator: (value){
                                                            if(value!.isEmpty){
                                                              return 'Please Enter valid Reason';

                                                            }
                                                            return null;
                                                          },
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
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Attachment',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(0xFF667085)),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Container(
                                                        height: 145,
                                                        width: 361,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(4),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Color(0xFFE9E9E9))),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            const Icon(
                                                                Icons.file_upload_outlined,
                                                                size: 20,
                                                                color: Color(0xFF004AAD)),
                                                            const SizedBox(height: 3),
                                                            Column(
                                                              children: [
                                                                Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      const Text(
                                                                          "Drag & drop file or",
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xFF000000),
                                                                              fontSize: 14,
                                                                              fontFamily:
                                                                              'Poppins')),
                                                                      TextButton(
                                                                          onPressed: () {},
                                                                          child: Text(
                                                                            "Browse",
                                                                            style: TextStyle(
                                                                                decoration:
                                                                                TextDecoration
                                                                                    .underline,
                                                                                color: Color(
                                                                                    0xFF004AAD),
                                                                                fontSize: 14,
                                                                                fontFamily:
                                                                                'Poppins'),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    'supports:doc,.jpg,png,pdf upto 10MB',
                                                                    style: TextStyle(
                                                                        fontFamily: 'Poppins',
                                                                        color:
                                                                        Color(0xFF98A2B3),
                                                                        fontSize: 14),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
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
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                Color(0xFFE4E7EC),
                                                                elevation: .1,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      4.0),
                                                                ),
                                                              ),
                                                              label: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                                children: [
                                                                  Center(
                                                                      child: const Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                            fontFamily: 'Poppins',
                                                                            fontSize: 14,
                                                                            fontWeight:
                                                                            FontWeight.w400,
                                                                            color: Color(
                                                                                0xFF030303)),
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
                                                                if (_leaveformkey
                                                                    .currentState!
                                                                    .validate()) {
                                                                  _leaveformkey.currentState
                                                                      ?.save();
                                                                  _leaveRequestModel
                                                                      .start_date =
                                                                      _fromdateController.text
                                                                          .toString();
                                                                  _leaveRequestModel
                                                                      .end_date =
                                                                      _todateController.text
                                                                          .toString();
                                                                  _leaveRequestModel.reason =
                                                                      _reason.text.toString();
                                                                  _leaveRequestModel
                                                                      .leave_type_id =
                                                                      modalSelectedItem;
                                                                  _leaveRequestModel
                                                                      .leave_duration =
                                                                      modalSelectedItems;
                                                                  _leaveRequestModel.behalf=modalSelected;
                                                                  print(_leaveRequestModel
                                                                      .start_date);
                                                                  print(_leaveRequestModel
                                                                      .end_date);
                                                                  print(_leaveRequestModel
                                                                      .reason);
                                                                  print(_leaveRequestModel
                                                                      .leave_type_id);
                                                                  print(_leaveRequestModel
                                                                      .leave_duration);
                                                                  _con?.applyLeaveRequest(
                                                                      _leaveRequestModel,context);
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                Color(0xFF004AAD),
                                                                elevation: .1,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      4.0),
                                                                ),
                                                              ),
                                                              label: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                                children: [
                                                                  Center(
                                                                      child: const Text(
                                                                        "Apply",
                                                                        style: TextStyle(
                                                                            fontFamily: 'Poppins',
                                                                            fontSize: 14,
                                                                            fontWeight:
                                                                            FontWeight.w400,
                                                                            color: Colors.white),
                                                                      )),
                                                                ],
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],

                                        )

                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } ,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Apply',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 14),
                  ),
                ) :
          FloatingActionButton.extended(
            backgroundColor: Color(0xFFADD8E6),

            onPressed: (){},

            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: const Text(
              'Apply',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 14),
            ),
          )
              : FloatingActionButton(
                  backgroundColor: Color(0xFF004AAD),
            onPressed: () {
              _fromdateController.text ='';
              _todateController.text = '';
              edit = false;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  String? leavetypeid;
                  // Declare a local variable for modal state

                  return FractionallySizedBox(
                    heightFactor: 0.88,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: StatefulBuilder(
                        builder: (BuildContext context, setModalState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    padding:
                                    const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      'Apply Leave',
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
                                key: _leaveformkey,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0),
                                          child: const Text(
                                            'Leave type',
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
                                          width: 160,
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
                                              modalSelectedItem, // Ensure modalSelectedItem matches one of the values in leavetype
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  4),
                                              items: leavetype.map((r) {
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
                                                  modalSelectedItem =
                                                      value; // Update the selected ID
                                                  print(
                                                      "Selected ID: $modalSelectedItem"); // Debugging
                                                });
                                              },
                                            ),
                                          ),
                                        ),
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
                                          padding: const EdgeInsets.only(
                                              left: 8.0),
                                          child: const Text(
                                            'Leave Duration',
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
                                          width: 160,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(4),
                                            border: Border.all(
                                              color: Color(0xFFE9E9E9),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10.0),
                                            child: DropdownButton<String>(
                                              isExpanded:
                                              true, // Ensures the dropdown covers the full width of the container
                                              underline:
                                              Container(), // Removes default underline
                                              value: modalSelectedItems,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                              icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down,
                                                  color: Color(
                                                      0xFF667085)), // Dropdown icon at the end
                                              iconSize: 22,
                                              alignment:
                                              AlignmentDirectional
                                                  .centerStart,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              items: <String>[
                                                'half',
                                                'full',
                                              ].map<
                                                  DropdownMenuItem<
                                                      String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,

                                                      child: Text(value,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      // Text for each item
                                                    );
                                                  }).toList(),
                                              onChanged: (String? value) {
                                                setModalState(() {
                                                  modalSelectedItems =
                                                      value;
                                                  print(
                                                      "Selected Item: $modalSelectedItems");
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    // TextFormField(
                                    //   style: TextStyle(
                                    //     fontSize: 18,
                                    //
                                    //   ),
                                    //   decoration: InputDecoration(
                                    //     hintText: ""
                                    //
                                    //   ),
                                    // )
                                  ],
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
                                          controller: _fromdateController,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return 'Please Select From Date';

                                            }
                                          },
                                          decoration: InputDecoration(
                                            floatingLabelStyle:
                                            const TextStyle(
                                              color: Color(0xFFC5C5C5),
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
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
                                              fontWeight: FontWeight.w400,
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
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reason',
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
                                      controller: _reason,
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
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Attachment',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF667085)),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Container(
                                    height: 145,
                                    width: 361,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(4),
                                        border: Border.all(
                                            width: 1,
                                            color: Color(0xFFE9E9E9))),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                            Icons.file_upload_outlined,
                                            size: 20,
                                            color: Color(0xFF004AAD)),
                                        const SizedBox(height: 3),
                                        Column(
                                          children: [
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  const Text(
                                                      "Drag & drop file or",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFF000000),
                                                          fontSize: 14,
                                                          fontFamily:
                                                          'Poppins')),
                                                  TextButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        "Browse",
                                                        style: TextStyle(
                                                            decoration:
                                                            TextDecoration
                                                                .underline,
                                                            color: Color(
                                                                0xFF004AAD),
                                                            fontSize: 14,
                                                            fontFamily:
                                                            'Poppins'),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'supports:doc,.jpg,png,pdf upto 10MB',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color:
                                                    Color(0xFF98A2B3),
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
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
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Color(0xFFE4E7EC),
                                            elevation: .1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  4.0),
                                            ),
                                          ),
                                          label: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color: Color(
                                                            0xFF030303)),
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
                                            if (_leaveformkey
                                                .currentState!
                                                .validate()) {
                                              _leaveformkey.currentState
                                                  ?.save();
                                              _leaveRequestModel
                                                  .start_date =
                                                  _fromdateController.text
                                                      .toString();
                                              _leaveRequestModel
                                                  .end_date =
                                                  _todateController.text
                                                      .toString();
                                              _leaveRequestModel.reason =
                                                  _reason.text.toString();
                                              _leaveRequestModel
                                                  .leave_type_id =
                                                  modalSelectedItem;
                                              _leaveRequestModel
                                                  .leave_duration =
                                                  modalSelectedItems;
                                              print(_leaveRequestModel
                                                  .start_date);
                                              print(_leaveRequestModel
                                                  .end_date);
                                              print(_leaveRequestModel
                                                  .reason);
                                              print(_leaveRequestModel
                                                  .leave_type_id);
                                              print(_leaveRequestModel
                                                  .leave_duration);
                                              _con?.applyLeaveRequest(
                                                  _leaveRequestModel,context);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            Color(0xFF004AAD),
                                            elevation: .1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  4.0),
                                            ),
                                          ),
                                          label: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: const Text(
                                                    "Apply",
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color: Colors.white),
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
                    Icons.add,
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
              length: 4,
              child: Expanded(
                child: Column(
                  children: [
                    ButtonsTabBar(
                      radius: 12,
                      labelSpacing: 12,
                      backgroundColor: const Color(0xFFE0EDFF),
                      unselectedBackgroundColor: Colors.transparent,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
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
                        Tab(text: 'Pending'),
                        Tab(text: 'Approved'),
                        Tab(text: 'Rejected'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                         _con!.isLoading ? ListView.builder(
                           itemCount: 5,
                           itemBuilder: (BuildContext context, int index) {
                             return AttendanceShimmer();
                           },
                         ):
                         _con!.leaveuserdata.isEmpty?  Container(
                           child: Center(
                             child: SvgPicture.asset(
                               'assets/images/norecord.svg',
                             ),
                           ),
                         )
                         :ListView.builder(
                            controller: scrollController,
                            itemCount: _con?.leaveuserdata.length,
                            itemBuilder: (BuildContext context, int index) {
                              var userleave = _con?.leaveuserdata[index];
                              return SingleChildScrollView(
                               // controller: scrollController,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text(
                                      //     'January,2024',
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontFamily: 'Poppins',
                                      //       fontWeight: FontWeight.w400,
                                      //       color: Color(0xFF1D2939),
                                      //     ),
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return FractionallySizedBox(
                                                  heightFactor: 0.72,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            height: 4,
                                                            width: 60,
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xFF98A2B3),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 20.0),
                                                              child: Text(
                                                                userleave!
                                                                    .leavetype,
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xFF004AAD),
                                                                    fontFamily:
                                                                        'Poppins'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                                child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      5.0),
                                                              child: Divider(
                                                                indent: 4,
                                                                endIndent: 4,
                                                                color: Colors
                                                                    .black12,
                                                                thickness: .4,
                                                              ),
                                                            )),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  top: 5),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/calendar1.png',
                                                                height: 22,
                                                                width: 22,
                                                                color: Color(
                                                                    0xFF98A2B3),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                userleave.noOfDays
                                                                        .toString() +
                                                                    " Day",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Color(
                                                                        0xFF030303),
                                                                    fontFamily:
                                                                        'Poppins'),
                                                              ),
                                                              Spacer(),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10.0),
                                                                child: Positioned(
                                                                  top: 75,
                                                                  right: 30,
                                                                  child:
                                                                      Container(
                                                                    height: 28,
                                                                    width: 110,
                                                                    decoration: BoxDecoration(
                                                                        color: getStatusColor(userleave.status),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                4)),
                                                                    child: Center(
                                                                        child: Text(
                                                                            capitalize(userleave.status),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Poppins',
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.white))),
                                                                  ),
                                                                  // child: ElevatedButton.icon(
                                                                  //
                                                                  //     onPressed: (){},
                                                                  //     style: ElevatedButton.styleFrom(
                                                                  //       backgroundColor: Color(0xFF65BD95),
                                                                  //       elevation: .5,
                                                                  //
                                                                  //       shape: RoundedRectangleBorder(
                                                                  //         borderRadius: BorderRadius.circular(4.0),
                                                                  //       ),
                                                                  //     ),
                                                                  //     label:  const Text("Approved",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  top: 5),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/images/calendar2.png',
                                                                height: 22,
                                                                width: 22,
                                                                color: Color(
                                                                    0xFF98A2B3),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF030303),
                                                                    fontSize: 14,
                                                                    fontFamily:
                                                                        'Poppins'),
                                                              )
                                                              // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 8.0,
                                                                  top: 5),
                                                          child: Row(
                                                            children: [
                                                              userleave.leaveDuration ==
                                                                      'half'
                                                                  ? Image.asset(
                                                                      'assets/images/radix-icons_half-2.png',
                                                                      height: 22,
                                                                      width: 22,
                                                                      color: Color(
                                                                          0xFF98A2B3),
                                                                    )
                                                                  : Image.asset(
                                                                      'assets/images/radix-icons_half-1.png',
                                                                      height: 22,
                                                                      width: 22,
                                                                      color: Color(
                                                                          0xFF98A2B3),
                                                                    ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                userleave
                                                                    .leaveDuration,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF030303),
                                                                    fontSize: 14,
                                                                    fontFamily:
                                                                        'Poppins'),
                                                              )
                                                              // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 16),
                                                        Center(
                                                          child: Container(
                                                            height: 112,
                                                            width: 321,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Color(
                                                                        0xFFE4E7EC)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              //child: Text(leaverequest.reason,),
                                                              child: Text(
                                                                  userleave
                                                                      .reason),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 15.0),
                                                          child: Text(
                                                            "Attachment",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Color(
                                                                    0xFF98A2B3)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              width: 155,
                                                              height: 55,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(5),
                                                                              border: Border.all(
                                                                                color: Color(0xFFE9E9E9),
                                                                              )),
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets
                                                                                .only(
                                                                                left: 5.0),
                                                                            child:
                                                                                Image.asset(
                                                                              'assets/images/document.png',
                                                                              height:
                                                                                  22,
                                                                              width:
                                                                                  22,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                                child: Text(
                                                                                  "Prescription2.pdf",
                                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 10),
                                                                                child: Text(
                                                                                  "100kb",
                                                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              width: 155,
                                                              height: 55,
                                                              child: Row(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(
                                                                                color: Color(0xFFE9E9E9),
                                                                              )),
                                                                          child: Row(
                                                                            // mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 5.0),
                                                                                child: Image.asset(
                                                                                  'assets/images/document.png',
                                                                                  height: 22,
                                                                                  width: 22,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                                    child: Text(
                                                                                      "Prescription2.pdf",
                                                                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(right: 10),
                                                                                    child: Text(
                                                                                      "100kb",
                                                                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              // builder: (BuildContext context) {
                                              //   return _buildBottomSheetContent();
                                              // },
                                              );
                                          // buildScrollablesheet();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5.0, left: 10, right: 10),
                                          child: Stack(children: [
                                            Positioned(
                                              top: 17,
                                              right: -17,
                                              child: Container(
                                                height: 110,
                                                width: 120,
                                                child: Image.asset(
                                                  'assets/images/beachbg.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 118,
                                              left: 15,

                                              child: Container(
                                                height: 28,
                                                width: 110,
                                                decoration: BoxDecoration(
                                                    color: getStatusColor(userleave?.status),
                                                    borderRadius:
                                                        BorderRadius.circular(4)),
                                                child:
                                                Center(
                                                    child: Text(capitalize(userleave!.status),
                                                        style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ),
                                            Container(
                                              height: 155,
                                              width: 361,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFFE4E7EC)),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        // Center(
                                                        //     child: Image.asset(
                                                        //   leaveTypeImageMap[userleave?.leavetype]!,
                                                        //   height: 22,
                                                        //   width: 22,
                                                        //   color:
                                                        //       Color(0xFF030303),
                                                        // )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Center(
                                                            child: Text(
                                                          userleave!.leavetype,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              color: Color(
                                                                  0xFF030303),
                                                              fontFamily:
                                                                  'Poppins'),
                                                        )),
                                                      Spacer(),
                                                       userleave.status == 'pending'? Row(
                                                          children: [
                                                           leaveedit! ? Container(
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
                                                                  edituserleave(userleave,userleave.id,edit);
                                                                },
                                                              )),
                                                            ) :
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
                                                                         Color(0xFFADD8E6),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   // onTap: () {
                                                                   //   edituserleave(userleave,userleave.id,edit);
                                                                   // },
                                                                     onTap: () {

                                                                     }
                                                                 )),
                                                           ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                           leavedelete! ?
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
                                                                      deleteleaverequest(userleave.id,context);
                                                                    },
                                                                  )),
                                                            ) :
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
                                                                         Color(0xFFFEE5E2),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   onTap: () {
                                                                     deleteleaverequest(userleave.id,context);
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
                                                                child:
                                                                    Image.asset(
                                                              'assets/images/calendar1.png',
                                                              height: 20,
                                                              width: 20,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            )),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Center(
                                                                child: Text(
                                                              userleave.noOfDays
                                                                      .toString() +
                                                                  ' Day',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Color(
                                                                      0xFF98A2B3),
                                                                  fontFamily:
                                                                      'Poppins'),
                                                            )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0, left: 10),
                                                    child: Row(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Center(
                                                                child:
                                                                    Image.asset(
                                                              'assets/images/calendar2.png',
                                                              height: 20,
                                                              width: 20,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            )),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Center(
                                                                child: Text(
                                                              '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF98A2B3),
                                                                  fontSize: 12,
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
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          _con!.isLoading ? ListView.builder(
                            itemCount: _con?.leaveuserdata.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AttendanceShimmer();
                              },
                           ):

                          ListView.builder(
                            controller: scrollController,
                            itemCount: _con?.leaveuserdata.where((userLeave) => userLeave.status == 'pending').length ?? 0,
                            itemBuilder: (BuildContext context, int index) {

                              var pendingLeaves = _con?.leaveuserdata.where((userLeave) => userLeave.status == 'pending').toList();


                              if (pendingLeaves == null || pendingLeaves.isEmpty) {
                                return Center(
                                  child: SvgPicture.asset(
                                    'assets/images/norecord.svg',
                                  ),
                                );
                              }

                              var userleave = pendingLeaves[index];
                              return _con!.leaveuserdata.where((userleave) => userleave.status == 'pending').isNotEmpty ?
                              SingleChildScrollView(
                                // controller: scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'January,2024',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF1D2939),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return FractionallySizedBox(
                                                heightFactor: 0.72,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Center(
                                                        child: Container(
                                                          height: 4,
                                                          width: 60,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  8)),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 20.0),
                                                            child: Text(
                                                              userleave!
                                                                  .leavetype,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Color(
                                                                      0xFF004AAD),
                                                                  fontFamily:
                                                                  'Poppins'),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                              child: Padding(
                                                                padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                                child: Divider(
                                                                  indent: 4,
                                                                  endIndent: 4,
                                                                  color: Colors
                                                                      .black12,
                                                                  thickness: .4,
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0,
                                                            top: 5),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/calendar1.png',
                                                              height: 22,
                                                              width: 22,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              userleave.noOfDays
                                                                  .toString() +
                                                                  " Day",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Color(
                                                                      0xFF030303),
                                                                  fontFamily:
                                                                  'Poppins'),
                                                            ),
                                                            Spacer(),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right:
                                                                  10.0),
                                                              child: Positioned(
                                                                top: 75,
                                                                right: 30,
                                                                child:
                                                                Container(
                                                                  height: 28,
                                                                  width: 110,
                                                                  decoration: BoxDecoration(
                                                                      color: Color(
                                                                          0xFFF1BB5B),
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          4)),
                                                                  child: Center(
                                                                      child: Text(
                                                                         capitalize(userleave.status) ,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.white))),
                                                                ),
                                                                // child: ElevatedButton.icon(
                                                                //
                                                                //     onPressed: (){},
                                                                //     style: ElevatedButton.styleFrom(
                                                                //       backgroundColor: Color(0xFF65BD95),
                                                                //       elevation: .5,
                                                                //
                                                                //       shape: RoundedRectangleBorder(
                                                                //         borderRadius: BorderRadius.circular(4.0),
                                                                //       ),
                                                                //     ),
                                                                //     label:  const Text("Approved",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0,
                                                            top: 5),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/calendar2.png',
                                                              height: 22,
                                                              width: 22,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF030303),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                  'Poppins'),
                                                            )
                                                            // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 8.0,
                                                            top: 5),
                                                        child: Row(
                                                          children: [
                                                            userleave.leaveDuration ==
                                                                'half'
                                                                ? Image.asset(
                                                              'assets/images/radix-icons_half-2.png',
                                                              height: 22,
                                                              width: 22,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            )
                                                                : Image.asset(
                                                              'assets/images/radix-icons_half-1.png',
                                                              height: 22,
                                                              width: 22,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              userleave
                                                                  .leaveDuration,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF030303),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                  'Poppins'),
                                                            )
                                                            // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 16),
                                                      Center(
                                                        child: Container(
                                                          height: 112,
                                                          width: 321,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Color(
                                                                      0xFFE4E7EC)),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                            //child: Text(leaverequest.reason,),
                                                            child: Text(
                                                                userleave
                                                                    .reason),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 15.0),
                                                        child: Text(
                                                          "Attachment",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                              'Poppins',
                                                              color: Color(
                                                                  0xFF98A2B3)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Container(
                                                            width: 155,
                                                            height: 55,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                    decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                        BorderRadius.circular(5),
                                                                        border: Border.all(
                                                                          color: Color(0xFFE9E9E9),
                                                                        )),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 5.0),
                                                                          child:
                                                                          Image.asset(
                                                                            'assets/images/document.png',
                                                                            height:
                                                                            22,
                                                                            width:
                                                                            22,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                          10,
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                              child: Text(
                                                                                "Prescription2.pdf",
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 10),
                                                                              child: Text(
                                                                                "100kb",
                                                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            width: 155,
                                                            height: 55,
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            border: Border.all(
                                                                              color: Color(0xFFE9E9E9),
                                                                            )),
                                                                        child: Row(
                                                                          // mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 5.0),
                                                                              child: Image.asset(
                                                                                'assets/images/document.png',
                                                                                height: 22,
                                                                                width: 22,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                                  child: Text(
                                                                                    "Prescription2.pdf",
                                                                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 10),
                                                                                  child: Text(
                                                                                    "100kb",
                                                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          ],
                                                                        )),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          // builder: (BuildContext context) {
                                          //   return _buildBottomSheetContent();
                                          // },
                                        );
                                        // buildScrollablesheet();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, left: 10, right: 10),
                                        child: Stack(children: [
                                          Positioned(
                                            top: 17,
                                            right: -17,
                                            child: Container(
                                              height: 110,
                                              width: 120,
                                              child: Image.asset(
                                                'assets/images/beachbg.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 118,
                                            left: 15,

                                            child: Container(
                                              height: 28,
                                              width: 110,
                                              decoration: BoxDecoration(
                                                  color: Color(0xFFF1BB5B),
                                                  borderRadius:
                                                  BorderRadius.circular(4)),
                                              child: Center(
                                                  child: Text(userleave!.status,
                                                      style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color:
                                                          Colors.white))),
                                            ),
                                          ),
                                          Container(
                                            height: 155,
                                            width: 361,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xFFE4E7EC)),
                                                borderRadius:
                                                BorderRadius.circular(8)),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      // Center(
                                                      //     child: Image.asset(
                                                      //   leaveTypeImageMap[userleave?.leavetype]!,
                                                      //   height: 22,
                                                      //   width: 22,
                                                      //   color:
                                                      //       Color(0xFF030303),
                                                      // )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Center(
                                                          child: Text(
                                                            capitalize(userleave!.leavetype),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                color: Color(
                                                                    0xFF030303),
                                                                fontFamily:
                                                                'Poppins'),
                                                          )),
                                                      Spacer(),
                                                      Row(
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
                                                                    edituserleave(userleave,userleave.id,edit);
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
                                                                    deleteleaverequest(userleave.id,context);
                                                                  },
                                                                )),
                                                          ),
                                                        ],
                                                      ),
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
                                                              child:
                                                              Image.asset(
                                                                'assets/images/calendar1.png',
                                                                height: 20,
                                                                width: 20,
                                                                color: Color(
                                                                    0xFF98A2B3),
                                                              )),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Center(
                                                              child: Text(
                                                                userleave.noOfDays
                                                                    .toString() +
                                                                    ' Day',
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Color(
                                                                        0xFF98A2B3),
                                                                    fontFamily:
                                                                    'Poppins'),
                                                              )),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 10.0, left: 10),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        children: [
                                                          Center(
                                                              child:
                                                              Image.asset(
                                                                'assets/images/calendar2.png',
                                                                height: 20,
                                                                width: 20,
                                                                color: Color(
                                                                    0xFF98A2B3),
                                                              )),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          Center(
                                                              child: Text(
                                                                '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF98A2B3),
                                                                    fontSize: 12,
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
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ) : Container(
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/images/norecord.svg',
                                  ),
                                ),
                              );
                            },
                          ),
                          _con!.isLoading ? AttendanceShimmer():ListView.builder(
                          controller: scrollController,
                          itemCount: _con?.leaveuserdata.length,
                          itemBuilder: (BuildContext context, int index) {
                            var userleave = _con?.leaveuserdata[index];
                            return userleave!.status == 'approved'?
                            SingleChildScrollView(
                              // controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'January,2024',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF1D2939),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.72,
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        height: 4,
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xFF98A2B3),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8)),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 20.0),
                                                          child: Text(
                                                            userleave!
                                                                .leavetype,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                color: Color(
                                                                    0xFF004AAD),
                                                                fontFamily:
                                                                'Poppins'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  5.0),
                                                              child: Divider(
                                                                indent: 4,
                                                                endIndent: 4,
                                                                color: Colors
                                                                    .black12,
                                                                thickness: .4,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          left: 8.0,
                                                          top: 5),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/calendar1.png',
                                                            height: 22,
                                                            width: 22,
                                                            color: Color(
                                                                0xFF98A2B3),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            userleave.noOfDays
                                                                .toString() +
                                                                " Day",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                color: Color(
                                                                    0xFF030303),
                                                                fontFamily:
                                                                'Poppins'),
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right:
                                                                10.0),
                                                            child: Positioned(
                                                              top: 75,
                                                              right: 30,
                                                              child:
                                                              Container(
                                                                height: 28,
                                                                width: 110,
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xFF65BD95),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        4)),
                                                                child: Center(
                                                                    child: Text(
                                                                        capitalize(userleave.status),
                                                                        style: TextStyle(
                                                                            fontFamily: 'Poppins',
                                                                            fontSize: 12,
                                                                            fontWeight: FontWeight.w400,
                                                                            color: Colors.white))),
                                                              ),
                                                              // child: ElevatedButton.icon(
                                                              //
                                                              //     onPressed: (){},
                                                              //     style: ElevatedButton.styleFrom(
                                                              //       backgroundColor: Color(0xFF65BD95),
                                                              //       elevation: .5,
                                                              //
                                                              //       shape: RoundedRectangleBorder(
                                                              //         borderRadius: BorderRadius.circular(4.0),
                                                              //       ),
                                                              //     ),
                                                              //     label:  const Text("Approved",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          left: 8.0,
                                                          top: 5),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/calendar2.png',
                                                            height: 22,
                                                            width: 22,
                                                            color: Color(
                                                                0xFF98A2B3),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF030303),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                'Poppins'),
                                                          )
                                                          // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          left: 8.0,
                                                          top: 5),
                                                      child: Row(
                                                        children: [
                                                          userleave.leaveDuration ==
                                                              'half'
                                                              ? Image.asset(
                                                            'assets/images/radix-icons_half-2.png',
                                                            height: 22,
                                                            width: 22,
                                                            color: Color(
                                                                0xFF98A2B3),
                                                          )
                                                              : Image.asset(
                                                            'assets/images/radix-icons_half-1.png',
                                                            height: 22,
                                                            width: 22,
                                                            color: Color(
                                                                0xFF98A2B3),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            userleave
                                                                .leaveDuration,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF030303),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                'Poppins'),
                                                          )
                                                          // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Center(
                                                      child: Container(
                                                        height: 112,
                                                        width: 321,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Color(
                                                                    0xFFE4E7EC)),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(8.0),
                                                          //child: Text(leaverequest.reason,),
                                                          child: Text(
                                                              userleave
                                                                  .reason),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          left: 15.0),
                                                      child: Text(
                                                        "Attachment",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                            'Poppins',
                                                            color: Color(
                                                                0xFF98A2B3)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          width: 155,
                                                          height: 55,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                  decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(5),
                                                                      border: Border.all(
                                                                        color: Color(0xFFE9E9E9),
                                                                      )),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left: 5.0),
                                                                        child:
                                                                        Image.asset(
                                                                          'assets/images/document.png',
                                                                          height:
                                                                          22,
                                                                          width:
                                                                          22,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                        10,
                                                                      ),
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                            child: Text(
                                                                              "Prescription2.pdf",
                                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right: 10),
                                                                            child: Text(
                                                                              "100kb",
                                                                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 155,
                                                          height: 55,
                                                          child: Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          border: Border.all(
                                                                            color: Color(0xFFE9E9E9),
                                                                          )),
                                                                      child: Row(
                                                                        // mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(left: 5.0),
                                                                            child: Image.asset(
                                                                              'assets/images/document.png',
                                                                              height: 22,
                                                                              width: 22,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                                child: Text(
                                                                                  "Prescription2.pdf",
                                                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 10),
                                                                                child: Text(
                                                                                  "100kb",
                                                                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        // builder: (BuildContext context) {
                                        //   return _buildBottomSheetContent();
                                        // },
                                      );
                                      // buildScrollablesheet();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 10, right: 10),
                                      child: Stack(children: [
                                        Positioned(
                                          top: 17,
                                          right: -17,
                                          child: Container(
                                            height: 110,
                                            width: 120,
                                            child: Image.asset(
                                              'assets/images/beachbg.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 118,
                                          left: 15,

                                          child: Container(
                                            height: 28,
                                            width: 110,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF65BD95),
                                                borderRadius:
                                                BorderRadius.circular(4)),
                                            child: Center(
                                                child: Text(capitalize(userleave!.status),
                                                    style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        color:
                                                        Colors.white))),
                                          ),
                                        ),
                                        Container(
                                          height: 155,
                                          width: 361,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFFE4E7EC)),
                                              borderRadius:
                                              BorderRadius.circular(8)),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    // Center(
                                                    //     child: Image.asset(
                                                    //   leaveTypeImageMap[userleave?.leavetype]!,
                                                    //   height: 22,
                                                    //   width: 22,
                                                    //   color:
                                                    //       Color(0xFF030303),
                                                    // )),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Center(
                                                        child: Text(
                                                          capitalize(userleave!.leavetype),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight.w400,
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
                                                            child:
                                                            Image.asset(
                                                              'assets/images/calendar1.png',
                                                              height: 20,
                                                              width: 20,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            )),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Center(
                                                            child: Text(
                                                              userleave.noOfDays
                                                                  .toString() +
                                                                  ' Day',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                                  color: Color(
                                                                      0xFF98A2B3),
                                                                  fontFamily:
                                                                  'Poppins'),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 10.0, left: 10),
                                                child: Row(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Center(
                                                            child:
                                                            Image.asset(
                                                              'assets/images/calendar2.png',
                                                              height: 20,
                                                              width: 20,
                                                              color: Color(
                                                                  0xFF98A2B3),
                                                            )),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Center(
                                                            child: Text(
                                                              '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF98A2B3),
                                                                  fontSize: 12,
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
                                        ),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ) : Container();
                          },
                        ),
                          _con!.isLoading ? AttendanceShimmer():ListView.builder(
                        controller: scrollController,
                        itemCount: _con?.leaveuserdata.length,
                        itemBuilder: (BuildContext context, int index) {
                          var userleave = _con?.leaveuserdata[index];
                          return userleave!.status == 'rejected'?
                          SingleChildScrollView(
                            // controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'January,2024',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF1D2939),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.72,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      height: 4,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                          color: Color(
                                                              0xFF98A2B3),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              8)),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 20.0),
                                                        child: Text(
                                                          capitalize(userleave!.leavetype),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              color: Color(
                                                                  0xFF004AAD),
                                                              fontFamily:
                                                              'Poppins'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                5.0),
                                                            child: Divider(
                                                              indent: 4,
                                                              endIndent: 4,
                                                              color: Colors
                                                                  .black12,
                                                              thickness: .4,
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 8.0,
                                                        top: 5),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/calendar1.png',
                                                          height: 22,
                                                          width: 22,
                                                          color: Color(
                                                              0xFF98A2B3),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          userleave.noOfDays
                                                              .toString() +
                                                              " Day",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              color: Color(
                                                                  0xFF030303),
                                                              fontFamily:
                                                              'Poppins'),
                                                        ),
                                                        Spacer(),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right:
                                                              10.0),
                                                          child: Positioned(
                                                            top: 75,
                                                            right: 30,
                                                            child:
                                                            Container(
                                                              height: 28,
                                                              width: 110,
                                                              decoration: BoxDecoration(
                                                                  color: Color(0xFFEA7971),
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      4)),
                                                              child: Center(
                                                                  child: Text(
                                                                      userleave.status,
                                                                      style: TextStyle(
                                                                          fontFamily: 'Poppins',
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Colors.white))),
                                                            ),
                                                            // child: ElevatedButton.icon(
                                                            //
                                                            //     onPressed: (){},
                                                            //     style: ElevatedButton.styleFrom(
                                                            //       backgroundColor: Color(0xFF65BD95),
                                                            //       elevation: .5,
                                                            //
                                                            //       shape: RoundedRectangleBorder(
                                                            //         borderRadius: BorderRadius.circular(4.0),
                                                            //       ),
                                                            //     ),
                                                            //     label:  const Text("Approved",style: TextStyle(fontFamily:'Poppins',fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white),)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 8.0,
                                                        top: 5),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/calendar2.png',
                                                          height: 22,
                                                          width: 22,
                                                          color: Color(
                                                              0xFF98A2B3),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF030303),
                                                              fontSize: 14,
                                                              fontFamily:
                                                              'Poppins'),
                                                        )
                                                        // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 8.0,
                                                        top: 5),
                                                    child: Row(
                                                      children: [
                                                        userleave.leaveDuration ==
                                                            'half'
                                                            ? Image.asset(
                                                          'assets/images/radix-icons_half-2.png',
                                                          height: 22,
                                                          width: 22,
                                                          color: Color(
                                                              0xFF98A2B3),
                                                        )
                                                            : Image.asset(
                                                          'assets/images/radix-icons_half-1.png',
                                                          height: 22,
                                                          width: 22,
                                                          color: Color(
                                                              0xFF98A2B3),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          userleave
                                                              .leaveDuration,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF030303),
                                                              fontSize: 14,
                                                              fontFamily:
                                                              'Poppins'),
                                                        )
                                                        // Center(child: Text('${formatDate(leaverequest.startDate.toString())} - ${formatDate(leaverequest.endDate.toString())}',style: TextStyle(color: Color(0xFF98A2B3),fontSize: 12,fontFamily: 'Poppins'),))
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Center(
                                                    child: Container(
                                                      height: 112,
                                                      width: 321,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xFFE4E7EC)),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10)),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(8.0),
                                                        //child: Text(leaverequest.reason,),
                                                        child: Text(
                                                            userleave
                                                                .reason),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 15.0),
                                                    child: Text(
                                                      "Attachment",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                          'Poppins',
                                                          color: Color(
                                                              0xFF98A2B3)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Container(
                                                        width: 155,
                                                        height: 55,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.circular(5),
                                                                    border: Border.all(
                                                                      color: Color(0xFFE9E9E9),
                                                                    )),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left: 5.0),
                                                                      child:
                                                                      Image.asset(
                                                                        'assets/images/document.png',
                                                                        height:
                                                                        22,
                                                                        width:
                                                                        22,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                      10,
                                                                    ),
                                                                    Column(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.start,
                                                                      crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                          child: Text(
                                                                            "Prescription2.pdf",
                                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 10),
                                                                          child: Text(
                                                                            "100kb",
                                                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Container(
                                                        width: 155,
                                                        height: 55,
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        border: Border.all(
                                                                          color: Color(0xFFE9E9E9),
                                                                        )),
                                                                    child: Row(
                                                                      // mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 5.0),
                                                                          child: Image.asset(
                                                                            'assets/images/document.png',
                                                                            height: 22,
                                                                            width: 22,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: 10,
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 8.0, right: 8),
                                                                              child: Text(
                                                                                "Prescription2.pdf",
                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 10),
                                                                              child: Text(
                                                                                "100kb",
                                                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Poppins', color: Color(0xFF98A2B3)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      // builder: (BuildContext context) {
                                      //   return _buildBottomSheetContent();
                                      // },
                                    );
                                    // buildScrollablesheet();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, left: 10, right: 10),
                                    child: Stack(children: [
                                      Positioned(
                                        top: 17,
                                        right: -17,
                                        child: Container(
                                          height: 110,
                                          width: 120,
                                          child: Image.asset(
                                            'assets/images/beachbg.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 118,
                                        left: 15,

                                        child: Container(
                                          height: 28,
                                          width: 110,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFEA7971),
                                              borderRadius:
                                              BorderRadius.circular(4)),
                                          child: Center(
                                              child: Text(capitalize(userleave!.status),
                                                  style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color:
                                                      Colors.white))),
                                        ),
                                      ),
                                      Container(
                                        height: 155,
                                        width: 361,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFFE4E7EC)),
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  // Center(
                                                  //     child: Image.asset(
                                                  //   leaveTypeImageMap[userleave?.leavetype]!,
                                                  //   height: 22,
                                                  //   width: 22,
                                                  //   color:
                                                  //       Color(0xFF030303),
                                                  // )),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Center(
                                                      child: Text(
                                                       capitalize(userleave!.leavetype) ,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                            FontWeight.w400,
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
                                                          child:
                                                          Image.asset(
                                                            'assets/images/calendar1.png',
                                                            height: 20,
                                                            width: 20,
                                                            color: Color(
                                                                0xFF98A2B3),
                                                          )),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Center(
                                                          child: Text(
                                                            userleave.noOfDays
                                                                .toString() +
                                                                ' Day',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                                color: Color(
                                                                    0xFF98A2B3),
                                                                fontFamily:
                                                                'Poppins'),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 10.0, left: 10),
                                              child: Row(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Center(
                                                          child:
                                                          Image.asset(
                                                            'assets/images/calendar2.png',
                                                            height: 20,
                                                            width: 20,
                                                            color: Color(
                                                                0xFF98A2B3),
                                                          )),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Center(
                                                          child: Text(
                                                            '${formatDate(userleave.startDate.toString())} - ${formatDate(userleave.endDate.toString())}',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF98A2B3),
                                                                fontSize: 12,
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
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container();
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
      ),
    );
  }

  void edituserleave(LeaveRequestByuserId userleave, String id, bool edit,) {
    edit = true;
    print(userleave.leavetype);
    print(userleave.leaveDuration);
    print(modalSelectedItem);

    if(edit){
      _fromdateeditController.text=  DateFormat('yyyy-MM-dd').format(userleave.startDate).toString();
      _todateeditController.text=  DateFormat('yyyy-MM-dd').format(userleave.endDate).toString();


    //  _fromdateeditController.text = formatDate(userleave.startDate.toString());
     // _todateeditController.text = formatDate(userleave.endDate.toString());
      _editreason.text =userleave.reason.toString();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.88,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StatefulBuilder(
              builder: (BuildContext context, setModalState1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xFF98A2B3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Edit Leave',
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
                      key: _editleaveformkey,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: const Text(
                                  'Leave type',
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
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xFFE9E9E9)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: DropdownButton<String>(
                                    focusColor: Colors.transparent,
                                    isExpanded: true,
                                    underline: SizedBox(), // Removes underline
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF667085),
                                    ),
                                    iconSize: 22,
                                    hint: Text(userleave.leavetype),
                                    value:
                                        modalSelectedItem, // Ensure modalSelectedItem matches one of the values in leavetype
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0),
                                    borderRadius: BorderRadius.circular(4),
                                    items: leavetype.map((r) {
                                      return DropdownMenuItem<String>(
                                        value: r.id, // Use ID as the value
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                            r.name, // Display the name in the dropdown
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setModalState1(() {
                                        modalSelectedItem = value; // Update the selected ID
                                        print(
                                            "Selected ID: $modalSelectedItem"); // Debugging
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: const Text(
                                  'Leave Duration',
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
                                width: 160,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Color(0xFFE9E9E9),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: DropdownButton<String>(
                                    isExpanded:
                                        true, // Ensures the dropdown covers the full width of the container
                                    underline:
                                        Container(), // Removes default underline
                                    value: modalSelectedItems,
                                    borderRadius: BorderRadius.circular(20),
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        color: Color(
                                            0xFF667085)), // Dropdown icon at the end
                                    iconSize: 22,
                                    hint: Text(userleave.leaveDuration),
                                    alignment: AlignmentDirectional.centerStart,
                                    style: TextStyle(color: Colors.black),
                                    items: <String>[
                                      'half',
                                      'full',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,

                                        child: Text(value,
                                            style:
                                                TextStyle(color: Colors.black)),
                                        // Text for each item
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setModalState1(() {
                                        modalSelectedItems = value;
                                        print(
                                            "Selected Item: $modalSelectedItems");
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          // TextFormField(
                          //   style: TextStyle(
                          //     fontSize: 18,
                          //
                          //   ),
                          //   decoration: InputDecoration(
                          //     hintText: ""
                          //
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'From Date',
                                style: TextStyle(color: Color(0xFF667085)),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              width: 160,
                              child: TextFormField(
                                controller: _fromdateeditController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  floatingLabelStyle: const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Color(
                                        0xFFC5C5C5), // Default label color
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical:
                                        10.0, // Adjust vertical padding for height
                                    horizontal:
                                        10.0, // Adjust horizontal padding
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.calendar_month_outlined,
                                      color: Color(
                                          0xFF004AAD), // Example color for the icon
                                    ),
                                    onPressed: () {
                                      _fromeditselectDate(
                                          context); // Call the date picker function
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFDC897C),
                                  ),

                                  // Borders
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when enabled
                                      width:
                                          1, // Adjust the border width as needed
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when focused
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'To Date',
                                style: TextStyle(color: Color(0xFF667085)),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              width: 160,
                              child: TextFormField(
                                controller: _todateeditController,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Enter Todate';

                                  }
                                  return null;
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  floatingLabelStyle: const TextStyle(
                                    color: Color(0xFFC5C5C5),
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,

                                  ),
                                  labelStyle: const TextStyle(
                                    color: Color(
                                        0xFFC5C5C5), // Default label color
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical:
                                        10.0, // Adjust vertical padding for height
                                    horizontal:
                                        10.0, // Adjust horizontal padding
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.calendar_month_outlined,
                                      color: Color(
                                          0xFF004AAD), // Example color for the icon
                                    ),
                                    onPressed: () {
                                      _toeditselectDate(
                                          context); // Call the date picker function
                                    },
                                  ),
                                  errorStyle: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Color(0xFFDC897C),
                                  ),

                                  // Borders
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when enabled
                                      width:
                                          1, // Adjust the border width as needed
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFFE9E9E9), // Border color when focused
                                      width: 1,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
                                      color: Color(
                                          0xFFDC897C), // Border color when error occurs
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: const BorderSide(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF667085)),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          height: 100.0, // Set desired height
                          width: 361.0, // Set desired width
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Color(0xFFE9E9E9)),
                          ),
                          child: TextFormField(
                            controller: _editreason,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              border:
                                  InputBorder.none, // Removes default border
                            ),
                            maxLines: null, // Allows multiple lines of text
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attachment',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF667085)),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          height: 145,
                          width: 361,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 1, color: Color(0xFFE9E9E9))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.file_upload_outlined,
                                  size: 20, color: Color(0xFF004AAD)),
                              const SizedBox(height: 3),
                              Column(
                                children: [
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Drag & drop file or",
                                            style: TextStyle(
                                                color: Color(0xFF000000),
                                                fontSize: 14,
                                                fontFamily: 'Poppins')),
                                        TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              "Browse",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Color(0xFF004AAD),
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins'),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'supports:doc,.jpg,png,pdf upto 10MB',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Color(0xFF98A2B3),
                                          fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 151, height: 42),
                            child: ElevatedButton.icon(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE4E7EC),
                                  elevation: .1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                label: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF030303)),
                                    )),
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 151, height: 42),
                            child: ElevatedButton.icon(
                                onPressed: () {

                                  if (_editleaveformkey.currentState!.validate()) {
                                    _editleaveformkey.currentState?.save();
                                    modalSelectedItem == '' ? _leaveRequestModel.leave_type_id == userleave.leavetype : modalSelectedItem;
                                    modalSelectedItems == '' ? _leaveRequestModel.leave_duration == userleave.leavetype : modalSelectedItems;
                                    _leaveRequestModel.start_date = _fromdateeditController.text.toString();
                                    _leaveRequestModel.end_date = _todateeditController.text.toString();
                                    _leaveRequestModel.reason = _editreason.text.toString();
                                    _leaveRequestModel.leave_type_id = modalSelectedItem;
                                    _leaveRequestModel.leave_duration = modalSelectedItems;
                                    print(_leaveRequestModel.start_date);
                                    print(_leaveRequestModel.end_date);
                                    print(_leaveRequestModel.reason);
                                    print(_leaveRequestModel.leave_type_id);
                                    print(_leaveRequestModel.leave_duration);
                                    _con?.editLeaveRequest(_leaveRequestModel,id,context);
                                    FocusScope.of(context).unfocus();
                                    _leaveformkey.currentState?.reset();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF004AAD),
                                  elevation: .1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                label: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: const Text(
                                      "Apply",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
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

  void deleteleaverequest(String id, BuildContext context) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
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
                          _con?.deleteLeaveRequest(id,context);
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

 Color?  getStatusColor(String? status) {
    switch(status){
      case 'pending':
        {
          return Color(0xFFF1BB5B);
        }
      case 'approved' :
        {
          return Color(0xFF65BD95);
        }
      case 'auto-approved' :
        {
          return Color(0xFF65BD95);
        }
      case 'rejected':
        {
          return Color(0xFFEA7971);
        }
    }
 }
}
