import 'package:shared_preferences/shared_preferences.dart';

class InterestsApi {
  static Future<Set<String>> getInterests() async {
    final prefs = await SharedPreferences.getInstance();
    return Set.from(prefs.getStringList("interests") ?? []);
  }

  static Future<void> setInterests(Set<String> interests) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("interests", interests.toList());
  }
}