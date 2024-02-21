import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:simple_shadow/simple_shadow.dart';

class ListCardWidget extends StatefulWidget {
  final String title;
  final Widget image;
  final Function? onTap;
  const ListCardWidget(
      {super.key, required this.title, required this.image, this.onTap});

  @override
  State<ListCardWidget> createState() => _ListCardWidgetState();
}

class _ListCardWidgetState extends State<ListCardWidget> {
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
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
        padding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 6,
                left: 0,
                right: 0,
                child: BorderedText(
                  strokeWidth: 5,
                  strokeColor: Colors.orange,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Lilita One',
                      color: CustomColor.customred,
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: SimpleShadow(
                child: widget.image,
                opacity: 0.4, // Default: 0.5
                color: Colors.black, // Default: Black
                offset: Offset(0, 4), // Default: Offset(2, 2)
                sigma: 4, // Default: 2
              ),
            ),
          ],
        ),
      ),
    );
  }
}
