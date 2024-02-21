import 'package:bordered_text/bordered_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ListFoodWidget extends StatefulWidget {
  final FoodList foodList;
  final Function? onTap;
  const ListFoodWidget({super.key, required this.foodList, this.onTap});

  @override
  State<ListFoodWidget> createState() => _ListFoodWidgetState();
}

class _ListFoodWidgetState extends State<ListFoodWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Color.fromRGBO(255, 217, 102, 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                  tag: widget.foodList.sourceUrl,
                  child: CachedNetworkImage(
                    imageUrl: widget.foodList.img,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 125,
                      width: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(67.5)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                        height: 125,
                        width: 125,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: CustomColor.customred,
                          ),
                        )),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error),
                    ),
                  )),
            ),
            Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      widget.foodList.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Lilita One',
                        color: CustomColor.customred,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.foodList.source,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lilita One',
                        color: CustomColor.customred[300],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
