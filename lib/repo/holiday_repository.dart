import 'dart:convert';

import 'package:sampleaura/controller/holiday.dart';
import 'package:sampleaura/helper/app_constant.dart';
import 'package:sampleaura/model/response/holidaymodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/tokenmodel.dart';
import 'package:http/http.dart'as http;

List<HolidayModel> holidaylist = [];

Future<List<HolidayModel>?> fetchHoliday() async {
  try {
    // Load tokens from preferences
    TokenModel? tokenModel = await TokenModel.loadFromPrefs();
    if (tokenModel == null) {
      print('Error: No token found');
      return []; // Return an empty list if token is missing
    }

    String accessToken = tokenModel.accessToken ?? '';
    String refreshToken = tokenModel.refreshToken ?? '';

    // Get orgId from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawString = prefs.getString('orgid');

    if (rawString == null) {
      print('Error: orgid not found in preferences');
      return []; // Return an empty list if orgid is missing
    }

    // Extract orgId from the raw string
    String orgId = rawString.split(': ')[1].replaceAll('}', '').trim();

    // Prepare request body
    final body = {
      'orgid': orgId,
    };
    final url = AppConstant().getholiday;

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

      // Ensure the response is a list before mapping
      if (jsonData is List) {
        List<HolidayModel> holidays = jsonData.map((json) => HolidayModel.fromJson(json)).toList();
        print('Holidays Count: ${holidays.length}');
        return holidays;
      } else {
        print('Error: Unexpected response format');
        return [];
      }
    } else {
      print('Error: Unexpected status code ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return []; // Return an empty list in case of any exception
  }
}
