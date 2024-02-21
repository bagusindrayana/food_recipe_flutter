import 'package:animated_number/animated_number.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_diary/food_diary_bloc.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/models/food_diary.dart';
import 'package:food_recipe/repositories/food_diary_repository.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:simple_shadow/simple_shadow.dart';

class TodayFood extends StatefulWidget {
  const TodayFood({super.key});

  @override
  State<TodayFood> createState() => _TodayFoodState();
}

class _TodayFoodState extends State<TodayFood> {
  FoodDiaryRepository _foodDiaryRepository = FoodDiaryRepository();
  List<FoodDiary> datas = [];
  final FoodDiaryBloc _foodDiaryBloc = FoodDiaryBloc(limit: 10);
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;
  bool _canLoadMore = false;
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  double caloriesToday = 0;
  DateTime today = DateTime.now();

  void getData() async {
    _isLoadingMore = false;
    currentPage = 1;
    datas = [];
    await _foodDiaryRepository.sumCaloriesInDate(DateTime.now()).then((value) {
      setState(() {
        caloriesToday = value['calories'] ?? 0;
      });
    });
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
    return SingleChildScrollView(
        child: Column(
      children: [
        //make rounded container widget for show total calories today
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CustomColor.customyellow,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${DateFormat('EEEE').format(today)}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("${DateFormat('d MMMM yyyy').format(today)}"),
                    ],
                  ),
                  // Icon(
                  //   Icons.fastfood,
                  //   color: CustomColor.customred,
                  //   size: 30,
                  // )
                  SimpleShadow(
                    child: Image.asset(
                      'assets/images/hamburger.png',
                      width: 100,
                    ),
                    opacity: 0.4, // Default: 0.5
                    color: Colors.black, // Default: Black
                    offset: Offset(0, 4), // Default: Offset(2, 2)
                    sigma: 4, // Default: 2
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Calories Today",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  (caloriesToday > 0)
                      ? AnimatedNumber(
                          startValue: 0,
                          endValue: caloriesToday,
                          duration: Duration(seconds: 1),
                          isFloatingPoint: true,
                          decimalPoint: 2,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text("0.0 Kcal")
                ],
              )
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              //dash border
              margin: const EdgeInsets.all(10),

              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                color: CustomColor.customred,
                dashPattern: [6, 3],
                strokeWidth: 3,
                padding: EdgeInsets.only(top: 10, left: 5, right: 5, bottom: 5),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text("Add Meal"),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_circle_rounded,
                            size: 50,
                            color: CustomColor.customred,
                          ))
                    ])),
              ),
            )
          ],
        ),
        BlocBuilder<FoodDiaryBloc, FoodDiaryState>(
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
                return const Center(
                  child: Text("Ops data tidak ditemukan"),
                );
              }
              //var size = MediaQuery.of(context).size;

              /*24 is for notification bar on Android*/
              // final double itemHeight = (size.height - (kToolbarHeight * 2)) / 2;
              // final double itemWidth = size.width / 2;

              return Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: datas.length,
                    itemBuilder: (context, index) {
                      var format =
                          DateFormat('HH:mm').format(datas[index].dateTime);
                      double totalCalories =
                          datas[index].calories * datas[index].quantity;
                      return Container(
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
                              Expanded(
                                child: Text(
                                    "${datas[index].label} x ${datas[index].quantity}"),
                              ),
                              Expanded(
                                  child: Text(
                                "${totalCalories.toStringAsFixed(2)} Kcal",
                                textAlign: TextAlign.end,
                              ))
                            ],
                          ),
                          subtitle: Text(format.toString()),
                        ),
                      );
                    },
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
              );
            } else if (state is FoodDiaryError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text("Ops resep tidak ditemukan"),
              );
            }
          },
        )
      ],
    ));
  }
}
