import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/create_post_model.dart';
import '../temps/temps_id.dart';

Future<http.Response?> getFeedPost() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/post/latest'),
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


Future<http.Response?> getUserFeedPost() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/post/myposts'),
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

