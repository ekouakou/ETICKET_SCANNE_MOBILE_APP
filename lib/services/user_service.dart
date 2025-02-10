import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<Map<String, String>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'UTIID': prefs.getString('UTIID') ?? '',
      'UTITOKEN': prefs.getString('UTITOKEN') ?? '',
      'UTINAME': prefs.getString('UTINAME') ?? '',
      'UTIPRENOM': prefs.getString('UTIPRENOM') ?? '',
      'UTIPHOTO': prefs.getString('UTIPHOTO') ?? '',
      'UTISTATUT': prefs.getString('UTISTATUT') ?? '',
    };
  }
}