import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_event.dart';
import 'package:food_recipe/bloc/food_detail/food_detail_state.dart';
import 'package:food_recipe/config/api_config.dart';
import 'package:food_recipe/models/food_list.dart';
import 'package:food_recipe/utility/utility_helper.dart';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class FoodDetailBloc extends Bloc<FoodDetailEvent, FoodDetailState> {
  final http.Client httpClient;
  final FoodList foodList;

  FoodDetailBloc({required this.httpClient, required this.foodList})
      : super(FoodDetailInitial()) {
    on<FetchFoodDetails>(mapEventToState);
  }

  //konversi imperial ke metrik
  String convertImperialToMetric(String unit, double amount) {
    if (unit == "tsp" || unit == "teaspoon") {
      return removeTrailingZeros(amount.toStringAsFixed(2)) + " teaspoon";
    } else if (unit == "tbsp" || unit == "tablespoon") {
      return removeTrailingZeros(amount.toStringAsFixed(2)) + " tablespoon";
    } else if (unit == "fl oz") {
      return (amount * 29.5735).toStringAsFixed(2) + " ml";
    }
    // else if (unit == "cup") {
    //   return removeTrailingZeros(amount.toStringAsFixed(2)) + " gelas/cangkir";
    // }
    else if (unit == "pint") {
      return (amount * 473.176).toStringAsFixed(2) + " ml";
    } else if (unit == "quart") {
      return (amount * 946.353).toStringAsFixed(2) + " ml";
    } else if (unit == "gallon") {
      return (amount * 3785.41).toStringAsFixed(2) + " ml";
    } else if (unit == "pound") {
      return (amount * 453.592).toStringAsFixed(2) + " g";
    } else if (unit == "ounce") {
      return (amount * 28.3495).toStringAsFixed(2) + " g";
    } else if (unit == "oz") {
      return (amount * 28.3495).toStringAsFixed(2) + " g";
    } else if (unit == "ml") {
      return removeTrailingZeros(amount.toStringAsFixed(2)) + " ml";
    } else if (unit == "l") {
      return (amount * 1000).toStringAsFixed(2) + " ml";
    } else if (unit == "mg") {
      return removeTrailingZeros(amount.toStringAsFixed(2)) + " mg";
    } else if (unit == "g" || unit == "gram") {
      return removeTrailingZeros(amount.toStringAsFixed(2)) + " g";
    } else if (unit == "g") {
      return removeTrailingZeros(amount.toStringAsFixed(2)) + " g";
    } else if (unit == "kg") {
      return (amount * 1000).toStringAsFixed(2) + " g";
    } else if (unit == "inch") {
      return (amount * 2.54).toStringAsFixed(2) + " cm";
    } else if (unit == "cm") {
      return removeTrailingZeros(amount.toStringAsFixed(2)) + " cm";
    } else {
      return amount.toString() + " " + unit;
    }
  }

  String removeTrailingZeros(String n) {
    return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }

  //pembagian stirng yang ada / nya
  String pembagian(String str) {
    var r = str.split("/");
    if (r.length > 1) {
      var a = double.parse(r[0]);
      var b = double.parse(r[1]);
      var c = a / b;
      return c.toString();
    } else {
      return str;
    }
  }

  //pemisahan nilai jika ada tanda "-"
  String rangeString(String str, String m) {
    var r = str.split("-");
    String text = "";
    for (var e in r) {
      var amount = double.parse(pembagian(e.trim()));
      var m_r = convertImperialToMetric(m, amount);
      text += m_r + " ";
    }
    return text;
  }

  mapEventToState(FoodDetailEvent event, Emitter<FoodDetailState> emit) async {
    emit(FoodDetailLoading());
    try {
      var listText = "";
      foodList.ingredients.forEach((element) {
        //cek jika memiliki unit/takaran atau tidak
        if (element.measure != "<unit>" && element.measure != null) {
          var measure = element.measure!;
          if (measure == "gram") {
            measure = "g";
          }
          //memisahkan nilai dan unit/takaran
          var r = element.text.split(measure);
          if (r.length > 1) {
            try {
              var m_r = rangeString(r[0].toString(), measure);
              var r_t = element.text
                  .replaceAll(r[0].toString() + measure.toString() + "s", m_r);
              listText += r_t + "\n";
            } catch (e) {
              //jika tidak berhasil mengubah unit/takaran
              listText += element.text + "\n";
            }
          } else {
            //jika tidak berhasil memisahkan unit/takaran atau tidak ada unit/takaran
            listText += element.text + "\n";
          }
        } else {
          //jika tidak mempunyai unit/takaran
          listText += element.text + "\n";
        }
      });

      final List<Locale> systemLocales =
          WidgetsBinding.instance.platformDispatcher.locales;
      // print(systemLocales.first.languageCode);
      var query = listText;
      if (systemLocales.isNotEmpty &&
          systemLocales.first.languageCode != "en") {
        await UtilityHelper()
            .translate(query, "en", systemLocales.first.languageCode)
            .then((value) {
          if (!value.success) {
            print(value.message);
          }
          emit(FoodDetailLoaded("${value.result}".split("\n")));
        });
      } else {
        emit(FoodDetailLoaded("${query}".split("\n")));
      }

      //persiapan menerjemahkan resep makanan
      //   final queryParameters = {
      //     'api-version': "3.0",
      //     'to': 'id',
      //     'textType': 'plain',
      //     'profanityAction': 'NoAction'
      //   };
      //   Uri uri = Uri.https('microsoft-translator-text.p.rapidapi.com',
      //       '/translate', queryParameters);
      //   var response = await httpClient.post(uri,
      //       headers: {
      //         "Content-Type": "application/json",
      //         "X-RapidAPI-Key": ApiConfig.RAPID_API_KEY,
      //         "X-RapidAPI-Host": "microsoft-translator-text.p.rapidapi.com"
      //       },
      //       body: jsonEncode([
      //         {"Text": listText}
      //       ]));
      //   if (response.statusCode == 200) {
      //     var jsonData = jsonDecode(response.body);

      //     var results = jsonData[0]['translations'][0]['text'];

      //     emit(FoodDetailLoaded(results.split("\n")));
      //   } else {
      //     print(response.body);
      //     emit(FoodDetailError('Gagal memuat resep makanan'));
      //   }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(FoodDetailError('Failed to load data'));
    }
  }
}
