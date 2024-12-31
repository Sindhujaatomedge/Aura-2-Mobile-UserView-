import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sampleaura/helper/app_constant.dart';
import 'package:sampleaura/model/request/regularize.dart';
import 'package:sampleaura/model/response/attendancebyorgid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/dropdown/member.dart';
import '../model/response/attendancerequetlog.dart';
import '../model/tokenmodel.dart';
import 'package:http/http.dart'as http;

import '../screen/attendanceself.dart';

List<Attendancelog> leaverequest = [];
List<AttendanceRequestLog> leaverequestlog =[];
String errorMessage ='';
List<MemberDropdown> dropdownmemberValues=[];


Future<List<Attendancelog>?> fetchResponseData() async {
  try {
    // Load tokens
    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';

    // Load organization ID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId;
    if (rawString != null) {
      orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    }

    if (orgId == null) {
      throw Exception('Organization ID is missing');
    }

    final body = {'orgid': orgId};
  //  final url = Uri.parse('http://192.168.29.232:8080/getattendancelogs');
  //  final url = Uri.parse('http://3.110.95.121:8080/getattendancelogs');
    final url = AppConstant().getattendancelogs;


    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Attendancelog> attendancelog = jsonData.map((data) => Attendancelog.fromJson(data)).toList();

      attendancelog = attendancelog.reversed.toList();

      return attendancelog;
    } else {
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to fetch data: $e');
  }
}

Future<List<AttendanceRequestLog>?> fetchResponseRequestData() async {
  try {

    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId;
    if (rawString != null) {
      orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    }

    if (orgId == null) {
      throw Exception('Organization ID is missing');
    }

    final body = {'orgid': orgId};
   // final url = Uri.parse('http://3.110.95.121:8080/regularize-manualcheckin');
   // final url = Uri.parse('http://192.168.29.232:8080/regularize-manualcheckin');
    final url = AppConstant().regularizemanualcheckin;


    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );
    print(json.encode(body));

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => AttendanceRequestLog.fromJson(data)).toList();

    }
    else {
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to fetch data: $e');
  }
}
Future<List<Attendancelog>?> postData(Regularize regularizeModel,BuildContext context) async {
  try {

    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId;
    if (rawString != null) {
      orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    }

    if (orgId == null) {
      throw Exception('Organization ID is missing');
    }

    final body = {
      'orgid': orgId,
      'checkin':regularizeModel.checkin,
      'checkintime':regularizeModel.checkintime,
      'checkout':regularizeModel.checkout,
      'checkouttime':regularizeModel.checkouttime,
      'comments':regularizeModel.comments

    };
    final url = AppConstant().manualcheckin;
    //final url = Uri.parse('http://192.168.29.232:8080/manual-check-in');
   //final url = Uri.parse('http://3.110.95.121:8080/manual-check-in');
    print(json.encode(body));
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 202) {
    //  List<dynamic> jsonData = json.decode(response.body);
      print(response.body);
      final Map<String,dynamic> message = json.decode(response.body);

      await Fluttertoast.showToast(
        msg: message['message'] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    //  return jsonData.map((data) => Attendancelog.fromJson(data)).toList();
      Navigator.push(context,MaterialPageRoute(builder: (context) =>Attendanceself()));



    }

    else if(response.statusCode == 400) {
      print(response.body);
      final Map<String,dynamic> message = json.decode(response.body);
      String? errormessage = message.values.firstWhere((value) => value is String,);

      await Fluttertoast.showToast(
        msg: errormessage ?? response.body,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
     // Navigator.push(context,MaterialPageRoute(builder: (context) =>Attendanceself()));

      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to fetch data: $e');
  }
}
Future<List<Attendancelog>?> editData(Regularize regularizeModel,BuildContext context,String id) async {
  try {

    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId;
    if (rawString != null) {
      orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    }

    if (orgId == null) {
      throw Exception('Organization ID is missing');
    }

    final body = {
      'id':id,
      'orgid': orgId,
      'checkin':regularizeModel.checkin,
      'checkintime':regularizeModel.checkintime,
      'checkout':regularizeModel.checkout,
      'checkouttime':regularizeModel.checkouttime,
      'comments':regularizeModel.comments

    };
    final url = AppConstant().updatemanualcheckin;
   //final url = Uri.parse('http://192.168.29.232:8080/updateattendancelog');
    //  final url = Uri.parse('http://3.110.95.121:8080/updateattendancelog');
    print(json.encode(body));


    // Make HTTP POST request
    final response = await http.patch(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 202) {
      //  List<dynamic> jsonData = json.decode(response.body);
      print(response.body);
      final Map<String,dynamic> message = json.decode(response.body);

      await Fluttertoast.showToast(
        msg: message['message'] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      //  return jsonData.map((data) => Attendancelog.fromJson(data)).toList();
      Navigator.push(context,MaterialPageRoute(builder: (context) =>Attendanceself()));



    }

    else if(response.statusCode == 400) {
      print(response.body);
      final Map<String,dynamic> message = json.decode(response.body);
      String? errormessage = message.values.firstWhere((value) => value is String,);

      await Fluttertoast.showToast(
        msg: errormessage ?? response.body,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      // Navigator.push(context,MaterialPageRoute(builder: (context) =>Attendanceself()));

      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to fetch data: $e');
  }
}
Future<List<Attendancelog>?> deleteData(BuildContext context,String id,String userid) async {
  try {

    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId;
    if (rawString != null) {
      orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    }

    if (orgId == null) {
      throw Exception('Organization ID is missing');
    }

    final body = {
      'id':id,
      'orgid': orgId,
      'userid':userid


    };
    final url = AppConstant().deletemanualcheckin;
   // final url = Uri.parse('http://192.168.29.232:8080/deleteattendancelog');
    //  final url = Uri.parse('http://3.110.95.121:8080/deleteattendancelog');
    print(json.encode(body));


    // Make HTTP POST request
    final response = await http.delete(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 202) {
      //  List<dynamic> jsonData = json.decode(response.body);
      print(response.body);
      final Map<String,dynamic> message = json.decode(response.body);

      await Fluttertoast.showToast(
        msg: message['message'] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      //  return jsonData.map((data) => Attendancelog.fromJson(data)).toList();
      Navigator.push(context,MaterialPageRoute(builder: (context) =>Attendanceself()));



    }

    else if(response.statusCode == 400) {
      print(response.body);
      final Map<String,dynamic> message = json.decode(response.body);

      await Fluttertoast.showToast(
        msg: message['message'] ?? response.body,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      // Navigator.push(context,MaterialPageRoute(builder: (context) =>Attendanceself()));

      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to fetch data: $e');
  }
}
Future<List<Attendancelog>?> approve(String id, AttendanceRequestLog attendancerequest) async {
  try {

    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId;
    if (rawString != null) {
      orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    }

    if (orgId == null) {
      throw Exception('Organization ID is missing');
    }

    final body = {
      'orgid': orgId,
      'ids':[id],
      'type' : attendancerequest.approver_type,
      'approvalstatus' : "approved"

    };
    final url = AppConstant().attendanceregularization;
  // final url = Uri.parse('http://192.168.29.232:8080/attendance-regularization');
  // final url = Uri.parse('http://3.110.95.121:8080/attendance-regularization');
    print(json.encode(body));


    // Make HTTP POST request
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 202) {
     // List<dynamic> jsonData = json.decode(response.body);
     // return jsonData.map((data) => Attendancelog.fromJson(data)).toList();

      final Map<String,dynamic> message = json.decode(response.body);

      await Fluttertoast.showToast(
        msg: message['message'] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );


    }

    else {

      final Map<String,dynamic> message = json.decode(response.body);

      await Fluttertoast.showToast(
        msg: message['message'] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      throw Exception('Failed to fetch data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error: $e");
    throw Exception('Failed to fetch data: $e');
  }
}
Future<List<MemberDropdown>> fetchResponseMemberDatadropdown() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();

  if (tokenModel == null) {
    print('Error: No token found');
    return []; // Return an empty list if token is missing
  }

  String accessToken = tokenModel.accessToken ?? '';
  String refreshToken = tokenModel.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');

  if (rawString == null) {
    print('Error: orgid not found in preferences');
    return []; // Return an empty list if orgid is missing
  }

  String orgId = rawString.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,
  };
  final url = AppConstant().getmembersbyorgid;

 // final url = Uri.parse('http://192.168.29.232:8080/getmembersbyorgid');  // Replace with your API URL
 //  final url = Uri.parse('http://3.110.95.121:8080/getmembersbyorgid');  // Replace with your API URL

  try {
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print(response.body);
      dynamic jsonData = jsonDecode(response.body);

      if (jsonData is List && jsonData.isNotEmpty) {

        var uniqueRoles = jsonData.toSet().toList();


        dropdownmemberValues = uniqueRoles
            .map((element) => MemberDropdown.fromJson(element))
            .toList();

        print('Fetched dropdown values: $dropdownmemberValues');
        return dropdownmemberValues;
      } else {
        print('Error: No valid data found in response');
        return []; // Return an empty list if no valid data is found
      }
    } else {
      print('Failed to load roles: ${response.statusCode}');
      return []; // Return an empty list if API call fails
    }
  } catch (e) {
    print('Error fetching roles: $e');
    return []; // Return an empty list in case of an error
  }
}

