import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

//###################
Future<http.Response?> getUserPublicFollowers(String username, int pageNumber,
    int numberOfPostPerRequest, String search) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);
  emitter(
      "$baseUrl/public/api/v2/user/public/user/followers/$username?page=$pageNumber&search=$search");

  try {
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v2/user/public/user/followers/$username?page=$pageNumber&search=$search'),
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

Future<http.Response?> getUserPublicFollowings(String username, int pageNumber,
    int numberOfPostPerRequest, String search) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();

  String? token = pref.getString(tokenKey);

  emitter(
      "'$baseUrl/public/api/v2/user/public/user/following/$username?page=$pageNumber&search=$search'");

  try {
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v2/user/public/user/following/$username?page=$pageNumber&search=$search'),
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
