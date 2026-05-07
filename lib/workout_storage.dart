import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutStorage {

  static const String key = "workout_history";

  static Future<void> saveWorkoutProgress(double progress) async {

    final prefs = await SharedPreferences.getInstance();

    Map<String, double> history = await getWorkoutHistory();

    final now = DateTime.now();

    String today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    history[today] = progress;

    Map<String, dynamic> jsonMap =
    history.map((k, v) => MapEntry(k, v));

    await prefs.setString(key, jsonEncode(jsonMap));
  }

  static Future<Map<String, double>> getWorkoutHistory() async {

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    if (data == null) return {};

    Map<String, dynamic> decoded = jsonDecode(data);

    return decoded.map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
    );
  }
}