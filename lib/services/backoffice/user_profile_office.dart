import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response?> getUserProfile() async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);

  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/user/profile'),
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

Future<http.Response?> getUserPublicProfile(String username) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);

  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/v2/user/public/profile/$username'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(seconds: 30));

    //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

//###################
Future<http.Response?> getUserPublicPost(
    String username, int pageNumber, int numberOfPostPerRequest) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);

  try {
    emitter(
        '$baseUrl/public/api/v2/user/public/user/posts/$username?page=$pageNumber');
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v2/user/public/user/posts/$username?page=$pageNumber'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(seconds: 30));

    //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> deletePubProfile() async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);

  try {
    response = await http.delete(
      Uri.parse('$baseUrl/public/api/user/account/delete'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(seconds: 30));

    log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}
