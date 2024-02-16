import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_diary/food_diary_bloc.dart';
import 'package:food_recipe/models/food_diary.dart';
import 'package:food_recipe/utility/database.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<FoodDiary> datas = [];
  final FoodDiaryBloc _foodDiaryBloc = FoodDiaryBloc(limit: 10);
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;
  bool _canLoadMore = false;
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;

  void getData() async {
    _isLoadingMore = false;
    currentPage = 1;
    datas = [];
    _foodDiaryBloc.page = 1;
    _foodDiaryBloc.add(FetchFoodDiaries(query: searchController.text, page: 1));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && _canLoadMore) {
        _isLoadingMore = true;
        _foodDiaryBloc.add(const LoadMoreFoodDiaries());
        currentPage += 1;
        print("currentPage: $currentPage");
      }
    }
  }

  void startSearch(q) {
    _isLoadingMore = false;
    _foodDiaryBloc.page = 1;
    datas = [];
    _foodDiaryBloc.add(FetchFoodDiaries(query: searchController.text, page: 1));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<FoodDiaryBloc, FoodDiaryState>(
            bloc: _foodDiaryBloc,
            builder: (context, state) {
              if (state is FoodDiaryLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FoodDiaryLoaded ||
                  state is FoodDiaryLoadingMore) {
                _isLoadingMore = false;
                if (state is FoodDiaryLoaded) {
                  _canLoadMore = state.nextData;
                  if (state.nextData) {
                    datas.addAll(state.foodDiaries);
                  } else if (currentPage == 1) {
                    datas = state.foodDiaries;
                  }
                } else if (datas.isEmpty) {
                  return SmartRefresher(
                      controller: _refreshController,
                      onRefresh: () {
                        getData();
                        _refreshController.refreshCompleted();
                      },
                      child: const Center(
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
                    physics: const ScrollPhysics(),
                    controller: _scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: datas.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(datas[index].label),
                              subtitle: Text(datas[index].dateTime.toString()),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: (state is FoodDiaryLoadingMore)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                );
              } else if (state is FoodDiaryError) {
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
                    child: const Center(
                      child: Text("Ops resep tidak ditemukan"),
                    ));
              }
            },
          ),
        )
      ],
    );
  }
}
