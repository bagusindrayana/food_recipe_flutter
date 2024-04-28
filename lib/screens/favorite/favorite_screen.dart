import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_favorite/food_favorite_bloc.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/models/food_favorite.dart';
import 'package:food_recipe/repositories/food_favorite_repository.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FoodFavoriteBloc _foodFavoriteBloc = FoodFavoriteBloc(limit: 10);
  TextEditingController searchController = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialLoadStatus: LoadStatus.loading);
  List<FoodFavorite> datas = [];

  void startSearch(q) {
    _foodFavoriteBloc.page = 1;
    datas = [];
    _foodFavoriteBloc.add(FetchFoodFavorites(query: searchController.text));
  }

  getData() async {
    datas = [];
    _foodFavoriteBloc.page = 1;
    _foodFavoriteBloc.add(FetchFoodFavorites(query: searchController.text));
  }

  deleteFavorite(int id) async {
    print("Delete Data : " + id.toString());
    _foodFavoriteBloc.add(DeleteFoodFavorite(id: id));
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
        Container(
          decoration: const BoxDecoration(
            color: CustomColor.customyellow,
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      onSubmitted: (v) {
                        if (startSearch != null && searchController != null) {
                          startSearch!(v);
                        }
                      },
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                width: 3, color: CustomColor.customred),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                width: 3, color: CustomColor.customred),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                width: 3, color: CustomColor.customred),
                          ),
                          filled: true,
                          hintStyle: TextStyle(
                              color: CustomColor.customred[500],
                              fontFamily: "Lilita One"),
                          hintText: "Search...",
                          fillColor: Colors.white70),
                    )),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.search,
                        color: CustomColor.customred,
                        size: 40,
                      ),
                      onPressed: () {
                        if (startSearch != null && searchController != null) {
                          startSearch!(searchController!.text);
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: BlocBuilder<FoodFavoriteBloc, FoodFavoriteState>(
          bloc: _foodFavoriteBloc,
          builder: (context, state) {
            if (state is FoodFavoriteLoading && datas.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (datas.isEmpty) {
              return const Center(
                child: Text("No Data"),
              );
            } else if (state is FoodFavoriteError) {
              _refreshController.loadFailed();
            } else if (state is FoodFavoriteLoaded) {
              datas = state.foodFavorites;
              _refreshController.refreshCompleted();
              if (datas.isEmpty) {
                _refreshController.loadNoData();
              } else {
                _refreshController.loadComplete();
              }
            }

            return SmartRefresher(
                controller: _refreshController,
                onRefresh: () {
                  getData();
                },
                onLoading: () async {
                  _foodFavoriteBloc.add(const LoadMoreFoodFavorites());
                  print("Loadmore : " + datas.length.toString());
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
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    var format =
                        DateFormat('HH:mm').format(datas[index].dateTime);

                    return Container(
                      key: ValueKey(datas[index].id),
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
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
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text("${datas[index].label}")),
                            IconButton(
                              onPressed: () async {
                                await deleteFavorite(datas[index].id);
                              },
                              icon: Icon(Icons.delete),
                            )
                          ],
                        ),
                        subtitle: Text(format.toString()),
                      ),
                    );
                  },
                ));
          },
        ))
      ],
    );
  }
}
