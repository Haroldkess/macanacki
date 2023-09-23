import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/create_post_model.dart';
import '../temps/temps_id.dart';

Future<http.Response?> getFeedPost(int pageNum) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/post/latest?page=$pageNum'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(minutes: 1));

    // log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getUserFeedPost(
    int pageNumber, int numberOfPostPerRequest) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  String? userName = pref!.getString(userNameKey);
  http.Response? response;

  print(
      "$baseUrl/public/api/v2/user/public/user/posts/$userName/?page=$pageNumber");
  try {
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v2/user/public/user/posts/$userName/?page=$pageNumber'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    //log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

// Future<http.Response?> getUserFeedPost() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   String? token = pref.getString(tokenKey);
//   String? userName = pref!.getString(userNameKey);
//
//   http.Response? response;
//   try {
//     //$baseUrl/public/api/v2/user/public/user/posts/$userName
//     response = await http.get(
//       Uri.parse('$baseUrl/public/api/v2/user/public/user/posts/$userName'),
//       headers: {
//         HttpHeaders.contentTypeHeader: "application/json",
//         HttpHeaders.authorizationHeader: "Bearer $token",
//       },
//     );
//
//     log(response.body.toString());
//   } catch (e) {
//     response = null;
//   }
//   return response;
// }

//       final response = await Dio().post(
//         "https://api.macanacki.com/api/test/upload",
//         //"http://localhost:8000/api/tester",
//         data: formData,
//         options: Options(
//           headers: {
//             'Accept': 'application/json'
//             //'Authorization': 'Bearer $token',
//           },
//         ),
//       );
