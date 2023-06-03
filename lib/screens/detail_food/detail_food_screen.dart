import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_bloc.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_event.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_state.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void translateDetail() async {
    _foodDetailBloc =
        FoodDetailBloc(httpClient: http.Client(), foodList: widget.foodList);
    _foodDetailBloc!.add(FetchFoodDetails());
  }

  Future<void> openWebSource() async {
    final Uri _url = Uri.parse(widget.foodList.sourceUrl);
    if (!await launchUrl(_url)) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodList.title),
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
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CachedNetworkImage(
                    imageUrl: widget.foodList.thumb,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error),
                  ),
                )),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 0, right: 20),
              child: Text(
                "Bahan-Bahan",
                style: TextStyle(
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
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is FoodDetailLoaded) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: min(state.ingredientTexts.length,
                              widget.foodList.ingredients.length),
                          itemBuilder: (context, index) {
                            final item = state.ingredientTexts[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: Color.fromRGBO(255, 217, 102, 1),
                              ),
                              // padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                leading:
                                    (widget.foodList.ingredients[index].image !=
                                            null)
                                        ? CachedNetworkImage(
                                            imageUrl: widget.foodList
                                                .ingredients[index].image!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 45,
                                              width: 45,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(67.5)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Icon(Icons.error),
                                            ),
                                          )
                                        : Icon(Icons.circle),
                                title: Text(
                                  item,
                                  style: TextStyle(
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
                        return Center(
                          child: Text("Ops resep tidak ditemukan"),
                        );
                      }
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, bottom: 0, right: 20),
              child: Text(
                "Langkah-Langkah",
                style: TextStyle(
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
                  child: Text("Lihat Langkah-langkahnya",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Lilita One',
                        color: CustomColor.customyellow,
                      )),
                  onPressed: openWebSource),
            ),
          ],
        ),
      ),
    );
  }
}
