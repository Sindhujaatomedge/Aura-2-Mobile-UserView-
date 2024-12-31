import 'dart:convert';

import 'package:sampleaura/model/response/checkintime.dart';
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
