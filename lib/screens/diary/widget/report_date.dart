import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:food_recipe/repositories/food_diary_repository.dart';
import 'package:food_recipe/config/custom_color.dart';

class ReportDate extends StatefulWidget {
  const ReportDate({super.key});

  @override
  State<ReportDate> createState() => _ReportDateState();
}

class _ReportDateState extends State<ReportDate> {
  FoodDiaryRepository _foodDiaryRepository = FoodDiaryRepository();
  List<Map<String, dynamic>> datas = [];
  double maxCalories = 0;

  void getData() async {
    DateTime now = DateTime.now();
    //7 day ago
    DateTime start = now.subtract(Duration(days: 7));

    //loop 7 days
    for (var i = 0; i < 7; i++) {
      var date = start.add(Duration(days: i + 1));
      var formattedDate = DateFormat('yyyy-MM-dd').format(date);
      var data = await _foodDiaryRepository.sumCaloriesInDate(date);

      datas.add({
        'date': formattedDate,
        'calories': data['calories'] ?? 0,
      });
    }

    setState(() {});
    var max = datas.fold<double>(0, (previousValue, element) {
      return previousValue > (element['calories'] as num).toDouble()
          ? previousValue.toDouble()
          : (element['calories'] as num).toDouble();
    });
    maxCalories = max.toDouble() + 1000;

    //rounded up to the nearest 1000
    maxCalories = ((maxCalories / 1000).ceil() * 1000).toDouble();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  List<FlSpot> generateFlSpot() {
    var spots = <FlSpot>[];
    for (var i = 0; i < datas.length; i++) {
      spots.add(FlSpot(i.toDouble(), (datas[i]['calories'] as num).toDouble()));
    }
    return spots;
  }

  List<Color> gradientColors = [
    Color.fromARGB(255, 230, 35, 35),
    Color.fromARGB(255, 211, 2, 2),
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 16,
    );

    var data = datas[value.toInt()];
    //convert date string to date and get short day name
    var date = DateTime.parse(data['date'] as String);
    var day = DateFormat('E').format(date);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        day.toString(),
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: 1000,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        // leftTitles: AxisTitles(
        //   sideTitles: SideTitles(
        //     showTitles: true,
        //     interval: 1,
        //     getTitlesWidget: leftTitleWidgets,
        //     reservedSize: 42,
        //   ),
        // ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: datas.length.toDouble() - 1,
      minY: 0,
      maxY: maxCalories,
      lineBarsData: [
        LineChartBarData(
          spots: generateFlSpot(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
            color: CustomColor.customyellow,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          margin: const EdgeInsets.all(10),
          child: AspectRatio(
            aspectRatio: 1.8,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 24,
                left: 0,
                top: 24,
                bottom: 12,
              ),
              child: (datas.length > 0) ? LineChart(mainData()) : SizedBox(),
            ),
          )),
    );
  }
}
