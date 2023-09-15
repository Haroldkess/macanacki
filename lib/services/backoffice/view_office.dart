import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:macanacki/model/otp_model.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response?> viewPost(int postId) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/post/view/$postId'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(const Duration(seconds: 20));

    //  log(response.body);
  } catch (e) {
    response = null;
  }
  return response;
}
