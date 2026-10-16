import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static late SharedPreferences _prefs;
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    await _prefs.setString('token', token);
  }

  String? getToken() {
    return _prefs.getString('token');
  }

  static Future<void> setBoolOtp(bool otp) async {
    await _prefs.setBool('boolOtp', otp);
  }

  static bool getBoolOtp() {
    return _prefs.getBool('boolOtp') ?? false;
  }
}
