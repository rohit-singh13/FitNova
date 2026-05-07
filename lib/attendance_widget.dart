import 'package:flutter/material.dart';

class AttendanceWidget extends StatelessWidget {
  final Map<String, bool> attendance;

  const AttendanceWidget({required this.attendance});

  String _getDayName(int weekday) {
    const days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();


    int daysFromSunday = now.weekday % 7;
    DateTime startOfWeek = now.subtract(Duration(days: daysFromSunday));

    List<DateTime> weekDays = List.generate(7, (index) {
      return startOfWeek.add(Duration(days: index));
    });



    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weekly Progress",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays.map((date) {
            bool isFuture = date.isAfter(now);
            String key =
                "${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";

            bool isDone = attendance[key] ?? false;

            final today = DateTime.now();

            bool isToday =
                date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;

            return Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    // ✅ clean fill
                    color: isDone
                        ? Color(0xFF6C5CE7)
                        : isFuture
                        ? Colors.white.withOpacity(0.04)
                        : Colors.white.withOpacity(0.08),

                    // ✅ subtle highlight for today (no glow)
                    border: isToday
                        ? Border.all(
                      color: Colors.white.withOpacity(0.6),
                      width: 1.5,
                    )
                        : null,
                  ),
                  child: Center(
                    child: isDone
                        ? Icon(Icons.local_fire_department, color: Colors.orange)
                        : Text(
                      "${date.day}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  _getDayName(date.weekday),
                  style: TextStyle(
                    color: Colors.white54, // 👈 slightly dimmer
                    fontSize: 12,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

