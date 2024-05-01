import 'dart:math';

import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_bloc.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_event.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_state.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/models/food_diary.dart';
import 'package:food_recipe/models/food_favorite.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:food_recipe/models/nutrition.dart';
import 'package:food_recipe/repositories/food_diary_repository.dart';
import 'package:food_recipe/repositories/food_favorite_repository.dart';
import 'package:food_recipe/utility/utility_helper.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailFoodScreen extends StatefulWidget {
  final FoodList foodList;
  const DetailFoodScreen({super.key, required this.foodList});

  @override
  State<DetailFoodScreen> createState() => _DetailFoodScreenState();
}

class _DetailFoodScreenState extends State<DetailFoodScreen> {
  FoodDetailBloc? _foodDetailBloc;
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();
  FoodDiaryRepository foodDiaryRepository = FoodDiaryRepository();
  FoodFavorite? foodFavorite;
  FoodFavoriteRepository foodFavoriteRepository = FoodFavoriteRepository();

  void eatFood() async {
    FoodDiary foodDiary = FoodDiary(
      url: widget.foodList.sourceUrl,
      label: widget.foodList.title,
      quantity: 1,
      calories: widget.foodList.calories,
      dateTime: DateTime.now(),
      mealType: widget.foodList.mealType?.join(", "),
    );
    await foodDiaryRepository.create(foodDiary);
    UtilityHelper.showSnackBar(context, "Food added to diary");
    Navigator.pop(context);
  }

  void favoriteFood() async {
    // FoodDiary foodDiary = FoodDiary(
    //   url: widget.foodList.sourceUrl,
    //   label: widget.foodList.title,
    //   quantity: 1,
    //   calories: widget.foodList.calories,
    //   dateTime: DateTime.now(),
    //   mealType: widget.foodList.mealType?.join(", "),
    // );
    // await foodDiaryRepository.create(foodDiary);
    // Navigator.pop(context);
    if (foodFavorite != null) {
      await foodFavoriteRepository.delete(foodFavorite!.id);
      setState(() {
        foodFavorite = null;
      });
    } else {
      FoodFavorite foodFavorite = FoodFavorite(
        url: widget.foodList.sourceUrl,
        label: widget.foodList.title,
        dateTime: DateTime.now(),
        mealType: widget.foodList.mealType?.join(", "),
      );
      await foodFavoriteRepository.create(foodFavorite);
      setState(() {
        this.foodFavorite = foodFavorite;
      });
    }
  }

  void translateDetail() async {
    _foodDetailBloc =
        FoodDetailBloc(httpClient: http.Client(), foodList: widget.foodList);
    _foodDetailBloc!.add(FetchFoodDetails());
    foodFavorite = await foodFavoriteRepository
        .readFoodFavoriteByUrl(widget.foodList.sourceUrl);
    setState(() {});
  }

  Future<void> openWebSource() async {
    final Uri _url = Uri.parse(widget.foodList.sourceUrl);
    if (!await launchUrl(_url,
        mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    translateDetail();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 60) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodList.title),
        actions: [
          IconButton(
              onPressed: favoriteFood,
              icon: (foodFavorite != null)
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.customred,
        onPressed: eatFood,
        child: const Icon(
          Icons.add_circle_outline_rounded,
          color: CustomColor.customyellow,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
                tag: widget.foodList.sourceUrl,
                child: CachedNetworkImage(
                  imageUrl: widget.foodList.img,
                  imageBuilder: (context, imageProvider) => Container(
                    height: itemHeight / 1.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CachedNetworkImage(
                    imageUrl: widget.foodList.thumb,
                    imageBuilder: (context, imageProvider) => Container(
                      height: itemHeight / 1.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                )),
            const SizedBox(
              height: 16,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: const Color.fromRGBO(255, 217, 102, 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //heading text with underline
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: BorderedText(
                          strokeWidth: 5,
                          strokeColor: Colors.orange,
                          child: Text(
                            "${widget.foodList.title}",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Lilita One',
                              color: CustomColor.customred,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )
                      // Text(
                      //   "${widget.foodList.title}",
                      //   style: const TextStyle(
                      //       fontSize: 24,
                      //       fontFamily: 'Lilita One',
                      //       color: CustomColor.customred,
                      //       decoration: TextDecoration.underline),
                      // ),
                      ),
                  //bullet list
                  Text(
                    '• Calories : ${widget.foodList.calories.toStringAsFixed(2)} Kcal',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lilita One',
                    ),
                  ),
                  Text(
                    '• Meal Type : ${widget.foodList.mealType?.join(", ")}',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lilita One',
                    ),
                  ),
                  Text(
                    '• Diet : ${widget.foodList.dietLabels?.join(", ")}',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lilita One',
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 0, right: 20),
              child: Text(
                "${AppLocalizations.of(context)?.ingredients}",
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lilita One',
                  color: CustomColor.customred,
                ),
              ),
            ),
            (_foodDetailBloc != null)
                ? BlocBuilder<FoodDetailBloc, FoodDetailState>(
                    bloc: _foodDetailBloc,
                    builder: (context, state) {
                      if (state is FoodDetailLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is FoodDetailLoaded) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: min(state.ingredientTexts.length,
                              widget.foodList.ingredients.length),
                          itemBuilder: (context, index) {
                            final item = state.ingredientTexts[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: const Color.fromRGBO(255, 217, 102, 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              // padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                leading: (widget.foodList.ingredients[index]
                                            .image !=
                                        null)
                                    ? CachedNetworkImage(
                                        imageUrl: widget
                                            .foodList.ingredients[index].image!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 45,
                                          width: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(67.5)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Icon(Icons.error),
                                        ),
                                      )
                                    : const Icon(Icons.circle),
                                title: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Lilita One',
                                    color: CustomColor.customred,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is FoodDetailError) {
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
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 0, right: 20),
              child: Text(
                "${AppLocalizations.of(context)?.steps}",
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lilita One',
                  color: CustomColor.customred,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 20, right: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: CustomColor.customred,
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: openWebSource,
                  child: Text("${AppLocalizations.of(context)?.seeSteps}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Lilita One',
                        color: CustomColor.customyellow,
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 0, right: 20),
              child: Text(
                "${AppLocalizations.of(context)?.nutritionalInformation}",
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Lilita One',
                  color: CustomColor.customred,
                ),
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color.fromRGBO(255, 217, 102, 1),
                ),
                margin: const EdgeInsets.all(20),
                //generate table from widget.foodList.totalNutrients
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(
                      color: CustomColor.customred,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Nutrition",
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Lilita One',
                            color: CustomColor.customred,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Qty",
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Lilita One',
                            color: CustomColor.customred,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Unit",
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Lilita One',
                            color: CustomColor.customred,
                          ),
                        ),
                      ),
                    ]),
                    for (var nutrient in widget.foodList.totalNutrients ?? [])
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${nutrient.label}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lilita One',
                              color: CustomColor.customred,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${nutrient.quantity?.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lilita One',
                              color: CustomColor.customred,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${nutrient.unit}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lilita One',
                              color: CustomColor.customred,
                            ),
                          ),
                        ),
                      ]),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
