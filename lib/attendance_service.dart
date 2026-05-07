import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  static String getTodayDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  static Future<void> markTodayAttendance({
    required String uid,
    required Map<String, bool> attendance,
  }) async {
    DateTime today = DateTime.now();

    String key =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    attendance[key] = true;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "attendance": attendance,
    });
  }

  static int calculateStreak(Map<String, bool> attendance) {
    int streak = 0;

    DateTime today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      DateTime date = today.subtract(Duration(days: i));

      String key =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      if (attendance[key] == true) {
        streak++;
      } else {
        break; // ❌ stop when a day is missed
      }
    }

    return streak;
  }

  static int calculateLongestStreak(Map<String, bool> attendance) {
    if (attendance.isEmpty) return 0;

    List<DateTime> dates = attendance.entries
        .where((e) => e.value == true)
        .map((e) {
      final parts = e.key.split("-");
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    })
        .toList();

    dates.sort();

    int longest = 1;
    int current = 1;

    for (int i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;

      if (diff == 1) {
        current++;
      } else {
        current = 1;
      }

      if (current > longest) {
        longest = current;
      }
    }

    return longest;
  }
}