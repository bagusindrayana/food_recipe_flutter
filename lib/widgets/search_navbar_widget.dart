import 'package:flutter/material.dart';
import 'package:food_recipe/config/custom_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SearchNavbarWidget extends StatefulWidget {
  String? inputHint = "Search";
  EdgeInsetsGeometry? padding;
  TextEditingController? searchController;
  Function(String)? startSearch;
  Function? onBack;
  Function(Map<String, dynamic>)? onFilter;
  Map<String, dynamic>? defaultFilters;

  SearchNavbarWidget(
      {super.key,
      this.inputHint,
      this.padding,
      this.searchController,
      this.startSearch,
      this.onBack,
      this.onFilter,
      this.defaultFilters});

  @override
  State<SearchNavbarWidget> createState() => _SearchNavbarWidgetState();
}

class _SearchNavbarWidgetState extends State<SearchNavbarWidget>
    with TickerProviderStateMixin {
  bool expanded = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  final List<String> _mealType = [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Snack",
    "Teatime"
  ];
  List<String> _selectedMealType = [];

  final List<String> _dishType = [
    "Biscuit and cookies",
    "Bread",
    "Cereals",
    "Condiments and sauces",
    "Drinks",
    "Desserts",
    "Main course",
    "Pancake",
    "Preps",
    "Preserve",
    "Salad",
    "Sandwiches",
    "Side dish",
    "Smoothie",
    "Snacks",
    "Soup",
    "Starter",
    "Sweets"
  ];
  List<String> _selectedDishType = [];

  final List<String> _diet = [
    "balanced",
    "high-fiber",
    "high-protein",
    "low-carb",
    "low-fat",
    "low-sodium"
  ];
  List<String> _selectedDiet = [];

  Map<String, dynamic> _filter = {};

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void clickExpand() {
    if (expanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    expanded = !expanded;
  }

  void selectMealType(String meal) {
    if (_selectedMealType.contains(meal)) {
      _selectedMealType.remove(meal);
    } else {
      _selectedMealType.add(meal);
    }
    generateFilter();
    setState(() {});
  }

  void selectDishType(String dish) {
    if (_selectedDishType.contains(dish)) {
      _selectedDishType.remove(dish);
    } else {
      _selectedDishType.add(dish);
    }
    generateFilter();
    setState(() {});
  }

  void selectDiet(String diet) {
    if (_selectedDiet.contains(diet)) {
      _selectedDiet.remove(diet);
    } else {
      _selectedDiet.add(diet);
    }
    generateFilter();
    setState(() {});
  }

  void generateFilter() {
    _filter = {
      "mealType": _selectedMealType,
      "dishType": _selectedDishType,
      "diet": _selectedDiet
    };
    if (widget.onFilter != null) {
      widget.onFilter!(_filter);
    }
  }

  void openFilter() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        List<String> localSelectedMealType = _selectedMealType;
        List<String> localSelectedDishType = _selectedDishType;
        List<String> localSelectedDiet = _selectedDiet;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: 200,
            padding: EdgeInsets.only(top: 16, left: 16),
            color: Colors.amber,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Meal Type',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        itemCount: _mealType.length,
                        itemBuilder: (BuildContext context, int index) {
                          final meal = _mealType[index];
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    localSelectedMealType.contains(meal)
                                        ? CustomColor.customredAccent
                                        : CustomColor.customyellowAccent),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.only(right: 10, left: 10)),
                              ),
                              onPressed: () {
                                selectMealType(meal);
                                setState(() {
                                  localSelectedMealType = _selectedMealType;
                                });
                              },
                              child: Text(meal,
                                  style: const TextStyle(
                                      color: CustomColor.customred,
                                      fontFamily: "Lilita One")),
                            ),
                          );
                        },
                      )),
                  const Text(
                    'Dish Type',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        itemCount: _dishType.length,
                        itemBuilder: (BuildContext context, int index) {
                          final dish = _dishType[index];
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    localSelectedDishType.contains(dish)
                                        ? CustomColor.customredAccent
                                        : CustomColor.customyellowAccent),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.only(right: 10, left: 10)),
                              ),
                              onPressed: () {
                                selectDishType(dish);
                                setState(() {
                                  localSelectedDishType = _selectedDishType;
                                });
                              },
                              child: Text(dish,
                                  style: const TextStyle(
                                      color: CustomColor.customred,
                                      fontFamily: "Lilita One")),
                            ),
                          );
                        },
                      )),
                  const Text(
                    'Diet',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        itemCount: _diet.length,
                        itemBuilder: (BuildContext context, int index) {
                          final diet = _diet[index];
                          return Padding(
                            padding: const EdgeInsets.all(6),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    localSelectedDiet.contains(diet)
                                        ? CustomColor.customredAccent
                                        : CustomColor.customyellowAccent),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.only(right: 10, left: 10)),
                              ),
                              onPressed: () {
                                selectDiet(diet);
                                setState(() {
                                  localSelectedDiet = _selectedDiet;
                                });
                              },
                              child: Text(diet,
                                  style: const TextStyle(
                                      color: CustomColor.customred,
                                      fontFamily: "Lilita One")),
                            ),
                          );
                        },
                      )),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      if (widget.defaultFilters != null) {
        if (widget.defaultFilters!["mealType"] != null) {
          _selectedMealType =
              List<String>.from(widget.defaultFilters!["mealType"]);
        }
        if (widget.defaultFilters!["dishType"] != null) {
          _selectedDishType =
              List<String>.from(widget.defaultFilters!["dishType"]);
        }

        if (widget.defaultFilters!["diet"] != null) {
          _selectedDiet = List<String>.from(widget.defaultFilters!["diet"]);
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CustomColor.customyellow,
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(0),
        child: Column(
          children: [
            Row(
              children: [
                (widget.onBack != null)
                    ? IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: CustomColor.customred,
                          size: 40,
                        ),
                        onPressed: () {
                          if (widget.onBack != null) {
                            widget.onBack!();
                          }
                        },
                      )
                    : Container(),
                Expanded(
                    child: TextField(
                  controller: widget.searchController,
                  onSubmitted: (v) {
                    if (widget.startSearch != null &&
                        widget.searchController != null) {
                      widget.startSearch!(v);
                    }
                  },
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                      hintText: widget.inputHint,
                      fillColor: Colors.white70),
                )),
                IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      clickExpand();
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: CustomColor.customred,
                      size: 40,
                    )),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.search,
                    color: CustomColor.customred,
                    size: 40,
                  ),
                  onPressed: () {
                    if (widget.startSearch != null &&
                        widget.searchController != null) {
                      widget.startSearch!(widget.searchController!.text);
                    }
                  },
                )
              ],
            ),
            SizeTransition(
                sizeFactor: _animation,
                axis: Axis.vertical,
                axisAlignment: 1.0,
                child: SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.only(right: 20, left: 10)),
                            ),
                            onPressed: () {
                              openFilter();
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.more_vert,
                                  color: CustomColor.customred,
                                ),
                                Text("Filter",
                                    style: TextStyle(
                                        color: CustomColor.customred,
                                        fontFamily: "Lilita One"))
                              ],
                            ),
                          ),
                        ),
                        for (var meal in _mealType)
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    _selectedMealType.contains(meal)
                                        ? CustomColor.customredAccent
                                        : CustomColor.customyellowAccent),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.only(right: 10, left: 10)),
                              ),
                              onPressed: () {
                                selectMealType(meal);
                              },
                              child: Text(meal,
                                  style: const TextStyle(
                                      color: CustomColor.customred,
                                      fontFamily: "Lilita One")),
                            ),
                          )
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
