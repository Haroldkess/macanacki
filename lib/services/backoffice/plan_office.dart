import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/widgets/debug_emitter.dart';
import '../temps/temps_id.dart';

Future<http.Response?> getPlan() async {
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/plan/list'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    // log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getVerificationLink() async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/v3/ng/verification/purchase'),
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

Future<http.Response?> getPurchaseDiamondLink(String amount) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/v3/ng/diamond/purchase/$amount'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(seconds: 30));

    emitter(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getPromotePostLink(postId, planId) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/v3/ng/post/promotion/$postId/$planId'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    emitter(response.body.toString());
    emitter(response.statusCode.toString());
  } catch (e) {
    response = null;
  }
  return response;
}
