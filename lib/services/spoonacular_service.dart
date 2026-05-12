import 'dart:convert';
import 'package:http/http.dart' as http;


class SpoonacularService {
  static const String apiKey = "b5b4e8492a8545cb83f6c34deddc4109";

  static Future<Map<String, dynamic>?> fetchNutrition(String query) async {
    final url = Uri.parse(
        "https://api.spoonacular.com/recipes/parseIngredients?apiKey=$apiKey"
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "ingredientList": query,
        "includeNutrition": "true",
      },
    );

    print("API STATUS: ${response.statusCode}");
    print("API RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isEmpty) return null;

      final nutrients = data[0]["nutrition"]["nutrients"];

      double calories = 0, protein = 0, carbs = 0, fats = 0;

      //Extract required macronutrients from API response
      for (var n in nutrients) {
        switch (n["name"]) {
          case "Calories":
            calories = n["amount"];
            break;
          case "Protein":
            protein = n["amount"];
            break;
          case "Carbohydrates":
            carbs = n["amount"];
            break;
          case "Fat":
            fats = n["amount"];
            break;
        }
      }

      return {
        "calories": calories,
        "protein": protein,
        "carbs": carbs,
        "fats": fats,
      };
    }

    return null;
  }

  //Searches food ingredient suggestions from Spoonacular API
  static Future<List<String>> searchFoods(String query) async {
    final url = Uri.https(
      "api.spoonacular.com",
      "/food/ingredients/search",
      {
        "apiKey": apiKey,
        "query": query,
        "number": "5",
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return List<String>.from(
        data["results"].map((item) => item["name"]),
      );
    }

    return [];
  }
}