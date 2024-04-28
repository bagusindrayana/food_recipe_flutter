import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_favorite/food_favorite_bloc.dart';
import 'package:food_recipe/bloc/food_list/food_list_bloc.dart';
import 'package:food_recipe/bloc/food_list/food_list_event.dart';
import 'package:food_recipe/bloc/food_list/food_list_state.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:food_recipe/screens/detail_food/detail_food_screen.dart';
import 'package:food_recipe/screens/search_result/widget/list_food_widget.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/widgets/search_navbar_widget.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:developer' as dev;

class SearchResultScreen extends StatefulWidget {
  final String query;
  Map<String, dynamic>? filters = {};
  SearchResultScreen({super.key, required this.query, this.filters});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<dynamic> datas = [];

  final FoodListBloc _foodListBloc = FoodListBloc();
  final RefreshController _refreshController =
      RefreshController(initialLoadStatus: LoadStatus.loading);
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = true;
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> _filters = {};

  void getData() async {
    _isLoadingMore = false;
    _foodListBloc.nextPageUrl = null;
    searchController.text = widget.query;
    _foodListBloc.add(FetchFoodLists(
        query: widget.query,
        mealType: _filters['mealType'],
        dishType: _filters['dishType'],
        diet: _filters['diet']));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && _foodListBloc.nextPageUrl != null) {
        _isLoadingMore = true;
        _foodListBloc.add(FetchFoodLists(query: widget.query));
      }
    }
  }

  void startSearch(q) {
    _isLoadingMore = false;
    _foodListBloc.nextPageUrl = null;
    datas = [];
    _foodListBloc.add(FetchFoodLists(
        query: q,
        mealType: _filters['mealType'],
        dishType: _filters['dishType'],
        diet: _filters['diet']));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      if (widget.filters != null) {
        print(widget.filters);
        setState(() {
          _filters = widget.filters!;
        });
      }
      getData();
    });
  }

  @override
  void dispose() {
    _foodListBloc.close();
    _refreshController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchNavbarWidget(
            inputHint: "${AppLocalizations.of(context)?.searchRecipe}...",
            onBack: () {
              Navigator.pop(context);
            },
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
            searchController: searchController,
            onFilter: (filters) {
              _filters = filters;
            },
            startSearch: startSearch,
            defaultFilters: _filters,
          ),
          Expanded(
              child: BlocBuilder<FoodListBloc, FoodListState>(
            bloc: _foodListBloc,
            builder: (context, state) {
              if (state is FoodListLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FoodListLoaded ||
                  state is FoodListLoadingMore) {
                _isLoadingMore = false;
                _refreshController.refreshCompleted();
                if (state is FoodListLoaded) {
                  datas.addAll(state.foodLists);
                  if (datas.isEmpty) {
                    _refreshController.loadNoData();
                  } else {
                    _refreshController.loadComplete();
                  }
                }
              } else if (state is FoodListError) {
                _refreshController.loadFailed();
              }

              var size = MediaQuery.of(context).size;

              /*24 is for notification bar on Android*/
              final double itemHeight =
                  (size.height - (kToolbarHeight * 2)) / 2;
              final double itemWidth = size.width / 2;

              return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    getData();
                  },
                  onLoading: () async {
                    _foodListBloc.add(FetchFoodLists(query: widget.query));
                  },
                  enablePullDown: true,
                  enablePullUp: true,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = Text("pull up load");
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.canLoading) {
                        body = Text("release to load more");
                      } else if (mode == LoadStatus.noMore) {
                        body = Text("No more Data");
                      } else {
                        body = CircularProgressIndicator();
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  child: ListView(
                    physics: ScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: datas.length,
                          itemBuilder: (context, index) {
                            FoodList item = datas[index];

                            return ListFoodWidget(
                                foodList: item,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailFoodScreen(
                                                foodList: item,
                                              )));
                                });
                          },
                        ),
                      ),
                    ],
                  ));
            },
          ))
        ],
      ),
    );
  }
}
