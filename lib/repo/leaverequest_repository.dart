import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sampleaura/helper/app_constant.dart';
import 'package:sampleaura/model/dropdown/leavetype.dart';
import 'package:sampleaura/model/dropdown/member.dart';
import 'package:sampleaura/model/request/leaverequest.dart';
import 'package:sampleaura/model/response/leavebalance.dart';
import 'package:sampleaura/model/response/leaverequestbtuserid.dart';
import 'package:sampleaura/model/response/leaverequestbyorgid.dart';
import 'package:sampleaura/model/tokenmodel.dart';
import 'package:sampleaura/screen/leaverequestself.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

List<LeaveModel> leaverequest = [];
String errorMessage ='';
List<Map<String, String>> roles = [];
List<LeaveTypeDropdownValue> dropdownValues=[];
List<MemberDropdown> dropdownmemberValues=[];

Future<List<LeaveModel>?> fetchResponseData() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');
  String orgId = '';
  if (rawString != null) {
    orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
  }

  final body = {'orgid': orgId};
  final url = AppConstant().getallleaverequestbyorgid;

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print("Leave Request Response: ${response.body}");

    if (response.statusCode == 202) {
      List<LeaveModel> leaveRequests = (jsonDecode(response.body) as List)
          .map((data) => LeaveModel.fromJson(data))
          .toList();
      return leaveRequests;
    } else {
      print("Unexpected status code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error in fetchResponseData: $e");
    throw Exception('Failed to fetch leave requests');
  }
}
Future<List<LeaveModel>?> approve(String id, LeaveModel leavedata) async {
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
      'type' : "primary",
      'approvalstatus' : "approved"

    };
    final url = AppConstant().leaveapproval;
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
Future<List<LeaveModel>?> reject(String id, LeaveModel leavedata) async {
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
      'type' : "primary",
      'approvalstatus' : "rejected"

    };
    final url = AppConstant().leaveapproval;
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


  Future<List<LeaveRequestByuserId>?> fetchResponseUserData() async {

    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    TokenModel _tokenModel = TokenModel();

    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');

    if(rawString != null){
      String orgId = rawString.split(':')[1].replaceAll('}','').trim();
      _tokenModel.orgid = orgId;
    }
    final body = {
      'orgid' : _tokenModel.orgid,
    };
    final url = AppConstant().getallleaverequestbyuserid;
   // final url = Uri.parse('http://192.168.29.232:8080/getallleaverequestbyuserid');
  //  final url = Uri.parse('http://3.110.95.121:8080/getallleaverequestbyuserid');
    try {
      final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type':'application/json',
        'Access-Token': accessToken,
        'Refresh-Token' :refreshToken

      },
      body: json.encode(body),
      );
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 202){
        List<dynamic> jsonData= json.decode(response.body);
        return jsonData.map((data) => LeaveRequestByuserId.fromJson(data)).toList();
      }
    }
    catch (e) {
      throw Exception('e');
    }

  }




Future<List<LeaveTypeDropdownValue>> fetchResponseDatadropdown() async {
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
final url = AppConstant().getallleavetypebyorgid;
 // final url = Uri.parse('http://192.168.29.232:8080/getallleavetypebyorgid');  // Replace with your API URL
//  final url = Uri.parse('http://3.110.95.121:8080/getallleavetypebyorgid');  // Replace with your API URL

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
        // Remove duplicates using the `toSet` method and then convert it back to a list
        var uniqueRoles = jsonData.toSet().toList();

        // Map the filtered unique roles to LeaveTypeDropdownValue objects
        dropdownValues = uniqueRoles
            .map((element) => LeaveTypeDropdownValue.fromJson(element))
            .toList();

        print('Fetched dropdown values: $dropdownValues');
        return dropdownValues;
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
 // final url = Uri.parse('http://3.110.95.121:8080/getmembersbyorgid');  // Replace with your API URL

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
Future<LeaveDetails?> fetchleavedetails(String id) async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');



  String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,
    'leavetypeid':id
  };
  final url = AppConstant().leavebalance;
  // final url = Uri.parse('http://192.168.29.232:8080/getmembersbyorgid');  // Replace with your API URL
  // final url = Uri.parse('http://3.110.95.121:8080/getmembersbyorgid');  // Replace with your API URL

  try {
    final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken
      },
      body: json.encode(body),
    );

    if (response.statusCode == 202) {
      print(response.body);


      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return LeaveDetails.fromJson(jsonData);


      }
    else {
        print('Error: No valid data found in response');

      }

  } catch (e) {
    print('Error fetching roles: $e');

  }
}




Future<String> postdata(LeaveRequestModel leaverequestModel,BuildContext context) async {
  print(leaverequestModel.leave_duration);

  TokenModel _tokenModel = TokenModel();
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');
  if (rawString != null) {
    String orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    _tokenModel.orgid = orgId;
  }

final url = AppConstant().leaverequest;
 //final url = Uri.parse('http://192.168.29.232:8080/leaverequest'); // Replace with your API URL
 // final url = Uri.parse('http://3.110.95.121:8080/leaverequest'); // Replace with your API URL

  try {
    var request = http.MultipartRequest('POST', Uri.parse(url));


    request.fields['orgid'] = _tokenModel.orgid!;
    request.fields['leave_type_id'] = leaverequestModel.leave_type_id!;
    request.fields['start_date'] = leaverequestModel.start_date!;
    request.fields['end_date'] = leaverequestModel.end_date!;
    request.fields['reason'] = leaverequestModel.reason!;
    request.fields['leave_duration'] = leaverequestModel.leave_duration!;
   // request.fields['behalf'] = leaverequestModel.behalf!;
    request.headers['Access-Token'] = accessToken;
    request.headers['Refresh-Token'] = refreshToken;


    var response = await request.send();


    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');


    if (response.statusCode == 202) {
      final Map<String,dynamic> message = json.decode(responseBody);
      await Fluttertoast.showToast(
        msg: message['message'] ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        timeInSecForIosWeb: 5

      );
      Navigator.push(context,MaterialPageRoute(builder: (context) =>SelfLeaveRequest()));




      print('Request successful');
      return responseBody;

    }
    else {
      final Map<String,dynamic> message = json.decode(responseBody);
      String? errormessage = message.values.firstWhere((value) => value is String,);
      await Fluttertoast.showToast(
        msg: errormessage ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      print('Request failed with status: ${response.statusCode}');

      return responseBody;
    }


  } catch (e) {
    print('Error posting leave request: $e');
    return '{"error": "Please fill All Details "}'; // Return an error message
  }
}
Future<String> editdata(LeaveRequestModel leaverequestModel, String id,BuildContext context) async {
  print(leaverequestModel.leave_duration);

  TokenModel _tokenModel = TokenModel();
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';
  int noofdays(DateTime from , DateTime to){
    from = DateTime.tryParse(leaverequestModel.start_date!)!;
    print(from);
    print(to);
    to = DateTime.tryParse(leaverequestModel.end_date!)!;
    return (to.difference(from).inHours/24).round();
  }
  print(' no of days : ${noofdays(DateTime.tryParse(leaverequestModel.start_date!)!, DateTime.tryParse(leaverequestModel.end_date!)!)}');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');
  if (rawString != null) {
    String orgId = rawString.split(': ')[1].replaceAll('}', '').trim();
    _tokenModel.orgid = orgId;
  }


 // final url = Uri.parse('http://192.168.29.232:8080/leaverequest'); // Replace with your API URL
 // final url = Uri.parse('http://3.110.95.121:8080/leaverequest'); // Replace with your API URL
  final url = AppConstant().editleaverequest;

  try {
    var request = http.MultipartRequest('PATCH', Uri.parse(url));


    request.fields['orgid'] = _tokenModel.orgid!;
    request.fields['leave_type_id'] = leaverequestModel.leave_type_id!;
    request.fields['start_date'] = leaverequestModel.start_date!;
    request.fields['end_date'] = leaverequestModel.end_date!;
    request.fields['reason'] = leaverequestModel.reason!;
    request.fields['id'] = id;
    request.fields['leave_duration'] = leaverequestModel.leave_duration!;
    request.headers['Access-Token'] = accessToken;
    request.headers['Refresh-Token'] = refreshToken;
    request.fields['no_of_days'] = noofdays(DateTime.tryParse(leaverequestModel.start_date!)!, DateTime.tryParse(leaverequestModel.end_date!)!).toString();


    var response = await request.send();


    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    print(response.statusCode);


    if (response.statusCode == 202) {
      final Map<String,dynamic> message = json.decode(responseBody);
      await Fluttertoast.showToast(
          msg: message['message'] ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          timeInSecForIosWeb: 5

      );
      Navigator.push(context,MaterialPageRoute(builder: (context) =>SelfLeaveRequest()));

      print('Request successful');
      return responseBody;

    } else {
      // final Map<String,dynamic> message = json.decode(responseBody);
      // String? errormessage = message.values.firstWhere((value) => value is String,);
      await Fluttertoast.showToast(
        msg:  responseBody,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );


      print('Request failed with status: ${response.statusCode}');

      return responseBody;
    }


  } catch (e) {
    print('Error posting leave request: $e');
    return '{"error": "Please fill All Details "}'; // Return an error message
  }
}
Future<void> deletedata( String id,BuildContext context) async {
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
      'id':id,


    };
//final url = Uri.parse('http://192.168.29.232:8080/leaverequest');
//    final url = Uri.parse('http://3.110.95.121:8080/leaverequest');
    final url = AppConstant().deleteleaverequest;
    print(json.encode(body));


    // Make HTTP POST request
    final response = await http.delete(
      Uri.parse(url),
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
Navigator.push(context, MaterialPageRoute(builder: (context) => SelfLeaveRequest()));

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


