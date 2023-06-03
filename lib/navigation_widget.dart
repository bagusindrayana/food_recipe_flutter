import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:food_recipe/screens/favorite/favorite_screen.dart';
import 'package:food_recipe/screens/home/home_screen.dart';
import 'package:food_recipe/screens/search_result/search_result_screen.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/screens/world/world_screen.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  List<Widget> screens = [
    WorldScreen(),
    HomeScreen(),
    FavoriteScreen(),
  ];
  int selectedIndex = 1;

  TextEditingController searchController = TextEditingController();

  void startSearch() {
    //open SearchResultScreen with searchController.text as query
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchResultScreen(
                  query: searchController.text,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: TextField(
              controller: searchController,
              onSubmitted: (v) {
                startSearch();
              },
              decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(width: 3, color: CustomColor.customred),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(width: 3, color: CustomColor.customred),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(width: 3, color: CustomColor.customred),
                  ),
                  filled: true,
                  hintStyle: TextStyle(
                      color: CustomColor.customred[500],
                      fontFamily: "Lilita One"),
                  hintText: "Cari Resep...",
                  fillColor: Colors.white70),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: CustomColor.customred,
                  size: 40,
                ),
                onPressed: () {
                  startSearch();
                },
              ),
            )
          ],
        ),
        body: screens[selectedIndex],
        bottomNavigationBar: SnakeNavigationBar.color(
          backgroundColor: CustomColor.customred,
          snakeViewColor: CustomColor.customyellow,
          unselectedItemColor: CustomColor.customyellow,
          selectedItemColor: CustomColor.customred,
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'world'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'favorit'),
          ],
        ));
  }
}
