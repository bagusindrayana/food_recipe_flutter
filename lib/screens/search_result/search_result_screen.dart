import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_list/food_list_bloc.dart';
import 'package:food_recipe/bloc/food_list/food_list_event.dart';
import 'package:food_recipe/bloc/food_list/food_list_state.dart';
import 'package:food_recipe/screens/detail_food/detail_food_screen.dart';
import 'package:food_recipe/screens/search_result/widget/list_food_widget.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<dynamic> datas = [];

  final FoodListBloc _foodListBloc = FoodListBloc(httpClient: http.Client());
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;
  TextEditingController searchController = TextEditingController();

  void getData() async {
    _isLoadingMore = false;
    _foodListBloc.nextPageUrl = null;
    searchController.text = widget.query;
    _foodListBloc.add(FetchFoodLists(query: widget.query));
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
    _foodListBloc.add(FetchFoodLists(query: q));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
          child: TextField(
            controller: searchController,
            onSubmitted: (v) {
              startSearch(v);
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
                startSearch(searchController.text);
              },
            ),
          )
        ],
      ),
      body: Container(
        //listview builder
        child: BlocBuilder<FoodListBloc, FoodListState>(
          bloc: _foodListBloc,
          builder: (context, state) {
            if (state is FoodListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FoodListLoaded ||
                state is FoodListLoadingMore) {
              _isLoadingMore = false;
              if (state is FoodListLoaded) {
                datas.addAll(state.foodLists);
              }
              if (datas.length == 0) {
                return SmartRefresher(
                    controller: _refreshController,
                    onRefresh: () {
                      getData();
                      _refreshController.refreshCompleted();
                    },
                    child: Center(
                      child: Text("Ops resep tidak ditemukan"),
                    ));
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
                  _refreshController.refreshCompleted();
                },
                child: ListView(
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: (itemWidth / itemHeight),
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: datas.length,
                        itemBuilder: (context, index) {
                          final item = datas[index];
                          return ListFoodWidget(
                              foodList: item,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailFoodScreen(
                                              foodList: item,
                                            )));
                              });
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      child: (state is FoodListLoadingMore)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              );
            } else if (state is FoodListError) {
              return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    getData();
                    _refreshController.refreshCompleted();
                  },
                  child: Center(
                    child: Text(state.message),
                  ));
            } else {
              return SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    getData();
                    _refreshController.refreshCompleted();
                  },
                  child: Center(
                    child: Text("Ops resep tidak ditemukan"),
                  ));
            }
          },
        ),
      ),
    );
  }
}
