import 'dart:convert';

import 'package:sampleaura/model/response/manageagedistribution.dart';
import 'package:sampleaura/model/response/manageattendancedata.dart';
import 'package:sampleaura/model/response/manageleavereport.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/app_constant.dart';
import '../model/response/managesatisfaction.dart';
import '../model/response/managetenure.dart';
import '../model/tokenmodel.dart';
import 'package:http/http.dart'as http;
List<AttendanceData> attendancedata = [];

Future<List<AttendanceData>?> fetchattandancedata() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');



  String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,

  };
  final url = AppConstant().attendancereport;
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
    print(json.encode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => AttendanceData.fromJson(data)).toList();
    }
    else {
      print('Error: No valid data found in response');

    }

  } catch (e) {
    print('Error fetching roles: $e');

  }
}
Future<List<AgeDistribution>?> fetchageDistributiondata() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');



  String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,

  };
  final url = AppConstant().agedistribution;
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
    print(json.encode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => AgeDistribution.fromJson(data)).toList();
    }
    else {
      print('Error: No valid data found in response');

    }

  } catch (e) {
    print('Error fetching roles: $e');

  }
}
Future<List<LeaveReport>?> fetchLeaveReportdata() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');



  String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,

  };
  final url = AppConstant().leavereport;
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
    print(json.encode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => LeaveReport.fromJson(data)).toList();
    }
    else {
      print('Error: No valid data found in response');

    }

  } catch (e) {
    print('Error fetching roles: $e');

  }
}
Future<List<EmployeeTenure>?> fetchEmployeeTenuredata() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');



  String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,

  };
  final url = AppConstant().employeetenure;
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
    print(json.encode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => EmployeeTenure.fromJson(data)).toList();
    }
    else {
      print('Error: No valid data found in response');

    }

  } catch (e) {
    print('Error fetching roles: $e');

  }
}
Future<List<EmployeeSatisfaction>?> fetchEmployeeSatisfactiondata() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');



  String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,

  };
  final url = AppConstant().employeesatisfaction;
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
    print(json.encode(body));
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => EmployeeSatisfaction.fromJson(data)).toList();
    }
    else {
      print('Error: No valid data found in response');

    }

  } catch (e) {
    print('Error fetching roles: $e');

  }
}