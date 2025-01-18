import 'dart:convert';

import 'package:sampleaura/model/response/checkintime.dart';
import 'package:sampleaura/model/response/employeepermission.dart';
import 'package:sampleaura/model/response/personaldeatils.dart';
import 'package:sampleaura/model/response/upcomingbirthday.dart';
import 'package:sampleaura/model/response/upcomingholiday.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/app_constant.dart';
import '../model/response/leavetypeself.dart';
import '../model/tokenmodel.dart';
import 'package:http/http.dart'as http;

Future<AttendanceCheckin?> fetchcheckin() async {
  try {

    TokenModel? tokenModel = await TokenModel.loadFromPrefs();


    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');




    String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();


    final body = {
      'orgid': orgId,
    };
    final url = AppConstant().getaggtime;

    // Make the API call
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      dynamic jsonData = jsonDecode(response.body);

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return AttendanceCheckin.fromJson(jsonResponse);

      }

  } catch (e) {
    print('Error: $e');
     // Return an empty list in case of any exception
  }
  return null;

}
Future<List<UpcomingHoliday>?> fetchupcomingholiday() async {
  try {
    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();
    final body = {
      'orgid': orgId,
    };
    final url = AppConstant().upcomingholiday;

    // Make the API call
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
     List<dynamic> jsonData = json.decode(response.body);
     List<UpcomingHoliday> homedata = jsonData.map((data) => UpcomingHoliday.fromJson(data)).toList();

     return homedata;
    }

  } catch (e) {
    print('Error: $e');

  }
  return null;

}
Future<List<UpcomingBirthday>?> fetchupcomingbirthday() async {
  try {
    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();
    final body = {
      'orgid': orgId,
    };
    final url = AppConstant().upcomingbirthday;

    // Make the API call
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<UpcomingBirthday> homebirthdaydata = jsonData.map((data) => UpcomingBirthday.fromJson(data)).toList();


      return homebirthdaydata;
    }

  } catch (e) {
    print('Error: $e');

  }
  return null;

}
Future<List<LeaveData>?> fetchleavetype() async {
  try {
    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();
    final body = {
      'orgid': orgId,
    };
    final url = AppConstant().leavetypebalance;

    // Make the API call
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 202) {
      List<dynamic> jsonData = json.decode(response.body);
      List<LeaveData> homeleavedata = jsonData.map((data) => LeaveData.fromJson(data)).toList();
      return homeleavedata;
    }

  } catch (e) {
    print('Error: $e');

  }
  return null;

}
Future<RolePermission?> fetchpermission() async {
  try {
    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    String accessToken = tokenModel?.accessToken ?? '';
    String refreshToken = tokenModel?.refreshToken ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');
    String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();
    final body = {
      'orgid': orgId,
    };
    final url = AppConstant().rolepermission;

    // Make the API call
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken,
      },
      body: json.encode(body),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      dynamic jsonData = jsonDecode(response.body);

      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return RolePermission.fromJson(jsonResponse);

    }

  } catch (e) {
    print('Error: $e');
    // Return an empty list in case of any exception
  }
  return null;

}
Future<PersonalDetails?> fetchEmployeePersonalDetails() async {
  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');



  String? orgId = rawString?.split(': ')[1].replaceAll('}', '').trim();

  final body = {
    'orgid': orgId,


  };
  final url = AppConstant().personaldeatils;
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

      // List<dynamic> jsonData = json.decode(response.body);
      // return jsonData.map((data) => Presenttodaycount.fromJson(data)).toList();
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return PersonalDetails.fromJson(jsonResponse);
    }
    else {
      print('Error: No valid data found in response');

    }
    return null;

  } catch (e) {
    print('Error fetching roles: $e');

  }
}

