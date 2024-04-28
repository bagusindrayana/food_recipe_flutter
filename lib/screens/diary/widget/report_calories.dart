import 'package:flutter/material.dart';
import 'package:food_recipe/config/custom_color.dart';

enum Gender { male, female }

enum ActivityLevel { sedentary, lightlyActive, moderatelyActive, veryActive }

class ReportCalories extends StatefulWidget {
  const ReportCalories({super.key});

  @override
  State<ReportCalories> createState() => _ReportCaloriesState();
}

class _ReportCaloriesState extends State<ReportCalories> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
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
