import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitnova/nutrition_storage.dart';
import 'package:flutter/material.dart';
import 'package:fitnova/glass_card.dart';
import 'package:fitnova/workout_storage.dart';


class OverviewTab extends StatefulWidget {
  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {

  Map<String, dynamic> history = {};
  bool isLoading = true;

  Map<String, double> workoutHistory = {};

  String selectedMacro = "calories";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {

    history = await NutritionStorage.getHistory();

    workoutHistory = await WorkoutStorage.getWorkoutHistory();

    setState(() {
      isLoading = false;
    });
  }

  List<FlSpot> getSpots(String macro) {
    List<FlSpot> spots = List.generate(7, (index) => FlSpot(index.toDouble(), 0));

    final entries = history.entries.toList();

    for (var entry in entries) {
      String date = entry.key; // format: YYYY-MM-DD

      DateTime parsed = DateTime.parse(date);
      int dayIndex = parsed.weekday % 7;
      // 🔥 converts:
      // Mon=1 → 1
      // Tue=2 → 2
      // ...
      // Sun=7 → 0

      double value = (entry.value[macro] ?? 0).toDouble();

      spots[dayIndex] = FlSpot(dayIndex.toDouble(), value);
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
      
          // 🔹 Workout Graph (TOP HALF)
          Expanded(
            child: glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Workout Progress",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: _buildWorkoutGraph(),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10),

          Expanded(
            child: glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nutrition Trends",
                        style: TextStyle(color: Colors.white),
                      ),

                      DropdownButton<String>(
                        value: selectedMacro,
                        dropdownColor: Colors.grey[900],
                        underline: SizedBox(), // 🔥 removes ugly line
                        style: TextStyle(color: Colors.white),
                        items: ["calories", "protein", "carbs", "fats"]
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toUpperCase()),
                        ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedMacro = val!;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Expanded(
                    child: _buildNutritionGraph(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGraph() {

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final spots = getSpots(selectedMacro);

    double maxY = selectedMacro == "calories" ? 3000 : 300;
    double interval = selectedMacro == "calories" ? 500 : 50;



    return Padding(
      padding: EdgeInsets.all(8),
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white10,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

                        int index = value.toInt() % 7; // 🔥 wraps every week

                        return Text(
                          days[index],
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    barWidth: 3,
                    color: Colors.greenAccent,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildWorkoutGraph() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: buildWorkoutGraph(workoutHistory),
    );
  }

  Widget buildWorkoutGraph(Map<String, double> history) {
    List<FlSpot> spots = [];

    spots = List.generate(7, (index) => FlSpot(index.toDouble(), 0));

    history.forEach((date, value) {

      DateTime parsed = DateTime.parse(date);

      int dayIndex = parsed.weekday % 7;
      // Sun = 0
      // Mon = 1
      // Tue = 2
      // ...
      // Sat = 6

      spots[dayIndex] = FlSpot(
        dayIndex.toDouble(),
        value * 100,
      );
    });

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100, // since it's %
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

                int index = value.toInt();

                if (index >= 0 && index < 7) {
                  return Text(
                    days[index],
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  );
                }

                return SizedBox();
              },
            ),
          ),

          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            dotData: FlDotData(show: true),
            barWidth: 3,
            color: Colors.orangeAccent, // 🔥 nice contrast
          )
        ],
      ),
    );
  }
}