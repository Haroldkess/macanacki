import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../temps/temps_id.dart';

Future<http.Response?> getSwipedUsers(String type,
    [String? country, state, city]) async {
  http.Response? response;

  SharedPreferences pref = await SharedPreferences.getInstance();

  // print("$country " + "$state " + "$city ");
  String? token = pref.getString(tokenKey);
  try {
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v3/user/filter/$type?country=${country ?? ""}&state=${state ?? ""}&city=${city ?? ""}'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}
