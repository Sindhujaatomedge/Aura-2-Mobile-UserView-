import 'package:shared_preferences/shared_preferences.dart';

class TokenModel {
  String? accessToken;
  String? refreshToken;
  String? orgid;


  TokenModel({this.accessToken, this.refreshToken,this.orgid});


  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'orgid':orgid

    };
  }


  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      orgid:json['org_id']

    );
  }


  static Future<TokenModel?> loadFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    String? refreshToken = prefs.getString('refresh_token');
    String? orgid = prefs.getString('orgid');

    if (accessToken != null && refreshToken != null) {
      return TokenModel(accessToken: accessToken, refreshToken: refreshToken,orgid: orgid);
    }

    return null;
  }


  Future<void> saveToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken ?? '');
    await prefs.setString('refresh_token', refreshToken ?? '');
    await prefs.setString('orgid', orgid ?? '');

  }


  static Future<void> clearPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('orgid');
  }
}
