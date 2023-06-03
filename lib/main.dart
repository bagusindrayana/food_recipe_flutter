import 'package:flutter/material.dart';
import 'package:food_recipe/navigation_widget.dart';
import 'package:food_recipe/config/custom_color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep Masakan',
      theme: ThemeData(
          primarySwatch: CustomColor.customyellow,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: CustomColor.customred, size: 30),
            titleTextStyle: TextStyle(
                color: CustomColor.customred,
                fontSize: 24,
                fontFamily: "Lilita One"),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(),
            bodyText2: TextStyle(),
          ).apply(
            bodyColor: CustomColor.customred,
            displayColor: CustomColor.customred,
          )),
      home: const NavigationWidget(),
    );
  }
}
