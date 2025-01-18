import 'package:shared_preferences/shared_preferences.dart';

class InterestsApi {
  static Future<List<String>> getInterests() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("interests") ?? [];
  }

  static Future<void> setInterests(List<String> interests) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("interests", interests);
  }
}