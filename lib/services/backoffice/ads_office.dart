import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ads_price_model.dart';
import '../temps/temps_id.dart';

Future<http.Response?> getAdsPrice() async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/adspricing/list'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> sendAd(SendAdModel data) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  Map map = {
    "country": data.country,
    "duration": data.duration,
  };

  try {
    response = await http
        .post(
            Uri.parse(
                '$baseUrl/public/api/post/promote/${data.postId}/${data.planId}'),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: "Bearer $token",
            },
            body: jsonEncode(map))
        .timeout(const Duration(seconds: 10));
    log(response.body);
  } catch (e) {
    response = null;
  }
  return response;
}
