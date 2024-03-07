import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'dart:developer';
import 'dart:io';

import '../../presentation/widgets/debug_emitter.dart';

class BuyFollwersOffice {
  static Future<http.Response?> buyFollwers(String value) async {
    http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString(tokenKey);
    var map = {"diamond_value": "$value"};
    try {
      response = await http.post(
          Uri.parse('$baseUrl/public/api/v2/followers/promotion/buy'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          body: jsonEncode(map));

      emitter(response.body.toString());
    } catch (e) {
      response = null;
    }
    return response;
  }
}
