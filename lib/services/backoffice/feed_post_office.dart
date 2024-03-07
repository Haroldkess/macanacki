import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/create_post_model.dart';
import '../temps/temps_id.dart';

Future<http.Response?> getFeedPost(int pageNum, [String? filter]) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  // emitter(filter!);
  ///  emitter("test 4 +> $filter");
  try {
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v3/post/latest?page=$pageNum&type=${filter ?? "verified"}'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(minutes: 1));
    //  log(response.statusCode.toString());
    emitter(response.body.toString());
    // log(token.toString());
  } catch (e) {
    print("000000000000000000000000000000000000 Errorrrrrrrrrr");
    response = null;
  }
  return response;
}

Future<http.Response?> getKingOrQueen(String type) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  // emitter(filter!);
  ///  emitter("test 4 +> $filter");
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/v3/macanacki/$type'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(minutes: 1));
    //  log(response.statusCode.toString());
    log(response.body.toString());
    // log(token.toString());
  } catch (e) {
    print("000000000000000000000000000000000000 Errorrrrrrrrrr");
    response = null;
  }
  return response;
}

Future<http.Response?> dethroneKingOrQueenNG() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  // emitter(filter!);
  ///  emitter("test 4 +> $filter");
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/v3/kingqueen/ng/dethrone'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(minutes: 1));
    log(response.statusCode.toString());
    log(response.body.toString());
    // log(token.toString());
  } catch (e) {
    print("000000000000000000000000000000000000 Errorrrrrrrrrr");
    response = null;
  }
  return response;
}

Future<http.Response?> dethroneKingOrQueen(String type) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  emitter(type);

  ///  emitter("test 4 +> $filter");
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/v3/macanacki/$type'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(minutes: 1));
    //  log(response.statusCode.toString());
    log(response.body.toString());
    // log(token.toString());
  } catch (e) {
    print("000000000000000000000000000000000000 Errorrrrrrrrrr");
    response = null;
  }
  return response;
}

Future<http.Response?> getSinglePostPost(String id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/v3/post/view/$id'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    ).timeout(Duration(minutes: 1));
    //  log(response.statusCode.toString());
    //  log(response.body.toString());
    //log(token.toString());
  } catch (e) {
    emitter("000000000000000000000000000000000000 Errorrrrrrrrrr");
    response = null;
  }
  return response;
}

Future<http.Response?> getVideoPost(int pageNum) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/v2/post/videos/list?page=$pageNum'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    // log(response.statusCode.toString());
    //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getAudioPost(int pageNum) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/v2/post/audio/list?page=$pageNum'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    // log(response.statusCode.toString());
    // log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getFriendsPost(int pageNum) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/v2/post/followings/list?page=$pageNum'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    // log(response.statusCode.toString());
    //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getVideo(int id) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/v2/post/videos/list?post_id=$id'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    //  log(response.statusCode.toString());
    // log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getUserFeedPost(
    int pageNumber, int numberOfPostPerRequest, String filter) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  String? userName = pref.getString(userNameKey);
  http.Response? response;

  // print(
  //     "$baseUrl/public/api/v2/user/public/user/posts/$userName?type=$filter&page=$pageNumber");
  try {
    response = await http.get(
      Uri.parse(
          '$baseUrl/public/api/v2/user/public/user/posts/$userName?type=$filter&page=$pageNumber'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );
    //  log("for $filter");
    // if (filter == "audios") {
    // log(token.toString());
    // }
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
