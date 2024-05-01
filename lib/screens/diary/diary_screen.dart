import 'package:flutter/material.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/screens/diary/widget/report_calories.dart';
import 'package:food_recipe/screens/diary/widget/report_date.dart';
import 'package:food_recipe/screens/diary/widget/today_food.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TabBar(
                splashFactory: NoSplash.splashFactory,
                indicator: BoxDecoration(
                    color: CustomColor.customred,
                    borderRadius: BorderRadius.circular(25.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(
                    text: 'Today',
                  ),
                  Tab(
                    text: 'Calories',
                  ),
                  Tab(
                    text: 'Report',
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                child: TabBarView(
                  children: [
                    Container(
                      child: TodayFood(),
                    ),
                    Container(
                      child: ReportCalories(),
                    ),
                    Container(
                      child: ReportDate(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
