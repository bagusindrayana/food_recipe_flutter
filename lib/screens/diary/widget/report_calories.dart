import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/models/food_diary.dart';
import 'package:food_recipe/repositories/food_diary_repository.dart';
import 'package:intl/intl.dart';

enum Gender { male, female }

enum ActivityLevel { sedentary, lightlyActive, moderatelyActive, veryActive }

class ReportCalories extends StatefulWidget {
  const ReportCalories({super.key});

  @override
  State<ReportCalories> createState() => _ReportCaloriesState();
}

class _ReportCaloriesState extends State<ReportCalories> {
  FoodDiaryRepository _foodDiaryRepository = FoodDiaryRepository();
  List<Map<String, dynamic>> datas = [];
  double maxCalories = 0;

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  Gender _gender = Gender.male;
  ActivityLevel _activityLevel = ActivityLevel.sedentary;
  double _bmr = 0.0;

  Widget _buildAgeInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child:
          //text field with border radius, background CustomColor.customyellowAccent, and border CustomColor.customred
          TextField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.grey[800]),
        decoration: InputDecoration(
          fillColor: Colors.white70,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: 'Usia',
          labelStyle: TextStyle(color: Colors.grey[800]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(width: 3, color: CustomColor.customred),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(width: 3, color: CustomColor.customred),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(width: 3, color: CustomColor.customred),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightInput() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextField(
            controller: _weightController,
            style: TextStyle(color: Colors.grey[800]),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              focusColor: Colors.grey[800],
              labelText: 'Berat badan (kg)',
              labelStyle: TextStyle(color: Colors.grey[800]),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(width: 3, color: CustomColor.customred),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(width: 3, color: CustomColor.customred),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(width: 3, color: CustomColor.customred),
              ),
            )));
  }

  Widget _buildHeightInput() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextField(
          controller: _heightController,
          style: TextStyle(color: Colors.grey[800]),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Tinggi badan (cm)',
            labelStyle: TextStyle(color: Colors.grey[800]),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(width: 3, color: CustomColor.customred),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(width: 3, color: CustomColor.customred),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(width: 3, color: CustomColor.customred),
            ),
          ),
        ));
  }

  Widget _buildGenderRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis kelamin:',
          style: TextStyle(color: Colors.grey[800], fontSize: 16),
        ),
        Row(
          children: [
            Radio<Gender>(
              value: Gender.male,
              groupValue: _gender,
              fillColor: MaterialStateProperty.all(CustomColor.customred),
              onChanged: (value) => setState(() => _gender = value!),
            ),
            const Text(
              'Pria',
              style: TextStyle(color: CustomColor.customred),
            ),
            Radio<Gender>(
              value: Gender.female,
              fillColor: MaterialStateProperty.all(CustomColor.customred),
              groupValue: _gender,
              onChanged: (value) => setState(() => _gender = value!),
            ),
            const Text('Wanita'),
          ],
        )
      ],
    );
  }

  Widget _buildActivityLevelRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tingkat aktivitas:',
            style: TextStyle(color: Colors.grey[800], fontSize: 16)),
        Row(
          children: [
            Radio<ActivityLevel>(
              value: ActivityLevel.sedentary,
              groupValue: _activityLevel,
              fillColor: MaterialStateProperty.all(CustomColor.customred),
              onChanged: (value) => setState(() => _activityLevel = value!),
            ),
            const Text('Sedentary'),
            Radio<ActivityLevel>(
              value: ActivityLevel.lightlyActive,
              groupValue: _activityLevel,
              fillColor: MaterialStateProperty.all(CustomColor.customred),
              onChanged: (value) => setState(() => _activityLevel = value!),
            ),
            const Text('Lightly active'),
          ],
        ),
        Row(children: [
          Radio<ActivityLevel>(
            value: ActivityLevel.moderatelyActive,
            groupValue: _activityLevel,
            fillColor: MaterialStateProperty.all(CustomColor.customred),
            onChanged: (value) => setState(() => _activityLevel = value!),
          ),
          const Text('Moderately active'),
          Radio<ActivityLevel>(
            value: ActivityLevel.veryActive,
            groupValue: _activityLevel,
            fillColor: MaterialStateProperty.all(CustomColor.customred),
            onChanged: (value) => setState(() => _activityLevel = value!),
          ),
          const Text('Very active'),
        ]),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: CustomColor.customred,
            minimumSize: const Size.fromHeight(50), // NEW
          ),
          onPressed: _calculateBMR,
          child: Text("Calculate BMR",
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Lilita One',
                color: CustomColor.customyellow,
              ))),
    );
  }

  Widget _buildBMRResult() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        'BMR Anda: ${_bmr.toStringAsFixed(2)} kkal/hari',
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  void _calculateBMR() {
    final age = int.parse(_ageController.text);
    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);

    double bmr = 0.0;

    if (_gender == Gender.male) {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else if (_gender == Gender.female) {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    switch (_activityLevel) {
      case ActivityLevel.sedentary:
        bmr *= 1.2;
        break;
      case ActivityLevel.lightlyActive:
        bmr *= 1.375;
        break;
      case ActivityLevel.moderatelyActive:
        bmr *= 1.55;
        break;
      case ActivityLevel.veryActive:
        bmr *= 1.725;
        break;
    }

    setState(() {
      _bmr = bmr;
    });
  }

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

  bool showAvg = false;

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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
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
                  child:
                      (datas.length > 0) ? LineChart(mainData()) : SizedBox(),
                ),
              )),
          //calculator mbr
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Column(
                children: [
                  _buildAgeInput(),
                  _buildWeightInput(),
                  _buildHeightInput(),
                  _buildGenderRadioButtons(),
                  _buildActivityLevelRadioButtons(),
                  _buildCalculateButton(),
                  _buildBMRResult(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
