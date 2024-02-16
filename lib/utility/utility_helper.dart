import 'dart:convert';

import 'package:food_recipe/config/api_config.dart';
import 'package:http/http.dart' as http;

class TranslateResult {
  final bool success;
  final String? message;
  final String? result;

  TranslateResult({required this.success, this.message, this.result});
}

class UtilityHelper {
  Future<TranslateResult> translate(String word, String from, String to) async {
    try {
      final queryParameters = {
        'api-version': "3.0",
        'from': from,
        'to': to,
        'textType': 'plain',
        'profanityAction': 'NoAction'
      };
      Uri uri = Uri.https('microsoft-translator-text.p.rapidapi.com',
          '/translate', queryParameters);
      var httpClient = http.Client();
      var response = await httpClient.post(uri,
          headers: {
            "Content-Type": "application/json",
            "X-RapidAPI-Key": ApiConfig.RAPID_API_KEY,
            "X-RapidAPI-Host": "microsoft-translator-text.p.rapidapi.com"
          },
          body: jsonEncode([
            {"Text": word}
          ]));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData);
        var results = jsonData[0]['translations'][0]['text'];

        return new TranslateResult(success: true, result: results);
      } else {
        print(response.body);
        return new TranslateResult(
            success: false, message: 'Failed to translate', result: word);
      }
    } catch (e, t) {
      print(e);
      print(t);
      return new TranslateResult(
          success: false, message: e.toString(), result: word);
    }
  }
}
