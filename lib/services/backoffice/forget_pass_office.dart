import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/ads_price_model.dart';
import '../temps/temps_id.dart';

Future<http.Response?> forgetSendOtp(String email) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);

  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/forgot/password/init/$email'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    // log(response.body);
    // log(response.statusCode.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> forgeetPasswordSend(String email, otp, password) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  Map map = {
    "otp": otp,
    "new_password": password,
  };

  try {
    response = await http.post(
        Uri.parse('$baseUrl/public/api/forgot/password/final/$email'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
         body: jsonEncode(map));
    // log(response.body);
  } catch (e) {
    response = null;
  }
  return response;
}
