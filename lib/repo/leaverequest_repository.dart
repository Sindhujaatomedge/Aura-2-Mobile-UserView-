import 'dart:convert';

import 'package:sampleaura/model/response/leaverequestbyorgid.dart';
import 'package:sampleaura/model/tokenmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

List<LeaveModel> leaverequest = [];
String errorMessage ='';

Future<List<LeaveModel>?> fetchResponseData() async {

  TokenModel? tokenModel = await TokenModel.loadFromPrefs();
  TokenModel _tokenModel = TokenModel();

  String accessToken = tokenModel?.accessToken ?? '';
  String refreshToken = tokenModel?.refreshToken ?? '';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? rawString = prefs.getString('orgid');

  if (rawString != null) {
    String orgId = rawString.split(': ')[1].replaceAll('}', '').trim();

    _tokenModel.orgid = orgId;
  }

  final body = {
    'orgid' : _tokenModel.orgid,
  };
  final url = Uri.parse('http://192.168.29.232:8080/getallleaverequestbyorgid');
  try{
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Access-Token': accessToken,
        'Refresh-Token': refreshToken

      },
      body: json.encode(body),

    );
   print(response.body);
    if(response.statusCode == 202){

      List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((data) => LeaveModel.fromJson(data)).toList();
    }

  }
  catch (e){
    throw Exception('Failed to Data ');


  }



}