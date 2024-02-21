import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_recipe/navigation_widget.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('id'), // Indonesian
      ],
      title: "${AppLocalizations.of(context)?.title}",
      theme: ThemeData(
          fontFamily: 'Lilita One',
          primarySwatch: CustomColor.customyellow,
          appBarTheme: const AppBarTheme(
            backgroundColor: CustomColor.customyellow,
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
