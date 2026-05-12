import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NutritionStorage {
  static const String key = "nutrition_history";

  //for the current day
  static Future<void> saveToday({
    required int calories,
    required int protein,
    required int carbs,
    required int fats,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now().toIso8601String().split("T")[0];

    Map<String, dynamic> data = {};

    final existing = prefs.getString(key);
    if (existing != null) {
      data = jsonDecode(existing);
    }

    data[today] = {
      "calories": calories,
      "protein": protein,
      "carbs": carbs,
      "fats": fats,
    };

    await prefs.setString(key, jsonEncode(data));
  }

  //for history
  static Future<Map<String, dynamic>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) return {};

    return jsonDecode(data);
  }
}