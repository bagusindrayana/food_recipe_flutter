import 'dart:ui';

// import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/screens/home/widgets/list_card_widget.dart';
import 'package:food_recipe/screens/search_result/search_result_screen.dart';
// import 'package:food_recipe/config/custom_color.dart';
// import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_recipe/utility/utility_helper.dart';
import 'package:food_recipe/widgets/search_navbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> _filters = {};

  void startSearch(query) {
    if (query.isEmpty && _filters.isEmpty) {
      UtilityHelper.showSnackBar(
          context, "Please enter a search query or select a filter");
      return;
    }
    ;

    //open SearchResultScreen with searchController.text as query
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SearchResultScreen(query: query, filters: _filters)))
        .then((value) {
      searchController.clear();
      _filters = {};
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 60) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      child: Column(
        children: [
          SearchNavbarWidget(
            inputHint: "${AppLocalizations.of(context)?.searchRecipe}...",
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
            searchController: searchController,
            onFilter: (filters) {
              _filters = filters;
            },
            startSearch: startSearch,
            defaultFilters: _filters,
          ),

          // Container(
          //   decoration: BoxDecoration(
          //     color: CustomColor.customyellow,
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.only(
          //         left: 10, right: 10, top: 40, bottom: 10),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.max,
          //       children: [
          //         Expanded(
          //             child: TextField(
          //           controller: searchController,
          //           onSubmitted: (v) {
          //             startSearch(v);
          //           },
          //           decoration: InputDecoration(
          //               isDense: true,
          //               contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          //               border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(16),
          //               ),
          //               enabledBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(16),
          //                 borderSide: BorderSide(
          //                     width: 3, color: CustomColor.customred),
          //               ),
          //               focusedBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(16),
          //                 borderSide: BorderSide(
          //                     width: 3, color: CustomColor.customred),
          //               ),
          //               errorBorder: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(16),
          //                 borderSide: BorderSide(
          //                     width: 3, color: CustomColor.customred),
          //               ),
          //               filled: true,
          //               hintStyle: TextStyle(
          //                   color: CustomColor.customred[500],
          //                   fontFamily: "Lilita One"),
          //               hintText:
          //                   "${AppLocalizations.of(context)?.searchRecipe}...",
          //               fillColor: Colors.white70),
          //         )),
          //         IconButton(
          //             padding: EdgeInsets.all(0),
          //             onPressed: () {},
          //             icon: Icon(
          //               Icons.more_vert,
          //               color: CustomColor.customred,
          //               size: 40,
          //             )),
          //         IconButton(
          //           padding: EdgeInsets.all(0),
          //           icon: const Icon(
          //             Icons.search,
          //             color: CustomColor.customred,
          //             size: 40,
          //           ),
          //           onPressed: () {
          //             startSearch(searchController.text);
          //           },
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
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
                  title: "${AppLocalizations.of(context)?.chicken}",
                  image: Image.asset(
                    'assets/images/food_shichimenchou.png',
                    width: itemWidth / 1.25,
                  )),
              ListCardWidget(
                  onTap: () {
                    startSearch("vegetable");
                  },
                  title: "${AppLocalizations.of(context)?.vegetable}",
                  image: Image.asset(
                    'assets/images/vegetable.png',
                    width: itemWidth / 1.25,
                  )),
              ListCardWidget(
                  onTap: () {
                    startSearch("meat");
                  },
                  title: "${AppLocalizations.of(context)?.meat}",
                  image: Image.asset(
                    'assets/images/food_niku_buta_ro-su.png',
                    width: itemWidth / 1.25,
                  )),
              ListCardWidget(
                  onTap: () {
                    startSearch("soup");
                  },
                  title: "${AppLocalizations.of(context)?.soup}",
                  image: Image.asset(
                    'assets/images/soup_vegetable.png',
                    height: itemWidth / 1.25,
                  )),
              ListCardWidget(
                  onTap: () {
                    startSearch("fruit");
                  },
                  title: "${AppLocalizations.of(context)?.fruit}",
                  image: Image.asset(
                    'assets/images/fruits_basket.png',
                    height: itemWidth / 1.25,
                  )),
              ListCardWidget(
                  onTap: () {
                    startSearch("drink");
                  },
                  title: "${AppLocalizations.of(context)?.drink}",
                  image: Image.asset(
                    'assets/images/juice_orange.png',
                    height: itemWidth / 1.25,
                  ))
            ],
          ))
        ],
      ),
    );
  }
}
