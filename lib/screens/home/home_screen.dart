import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/screens/home/widgets/list_card_widget.dart';
import 'package:food_recipe/screens/search_result/search_result_screen.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:simple_shadow/simple_shadow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void startSearch(query) {
    //open SearchResultScreen with searchController.text as query
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchResultScreen(
                  query: query,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 60) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: <Widget>[
          ListCardWidget(
              onTap: () {
                startSearch("chicken");
              },
              title: "Ayam",
              image: Image.asset(
                'assets/images/food_shichimenchou.png',
                width: itemWidth / 1.25,
              )),
          ListCardWidget(
              onTap: () {
                startSearch("vegetable");
              },
              title: "Sayuran",
              image: Image.asset(
                'assets/images/vegetable.png',
                width: itemWidth / 1.25,
              )),
          ListCardWidget(
              onTap: () {
                startSearch("meat");
              },
              title: "Daging",
              image: Image.asset(
                'assets/images/food_niku_buta_ro-su.png',
                width: itemWidth / 1.25,
              )),
          ListCardWidget(
              onTap: () {
                startSearch("soup");
              },
              title: "Sup",
              image: Image.asset(
                'assets/images/soup_vegetable.png',
                height: 100,
              )),
          ListCardWidget(
              onTap: () {
                startSearch("fruit");
              },
              title: "Buah",
              image: Image.asset(
                'assets/images/fruits_basket.png',
                height: 100,
              )),
          ListCardWidget(
              onTap: () {
                startSearch("drink");
              },
              title: "Minuman",
              image: Image.asset(
                'assets/images/juice_orange.png',
                height: 100,
              ))
        ],
      ),
    );
  }
}
