import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:makanaki/model/create_post_model.dart';
import 'package:makanaki/services/api_url.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response?> followAndUnfollow(String username) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  try {
    response = await http.post(
        Uri.parse(
            '$baseUrl/public/api/user/follow_unfollow/$username'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
     //   body: jsonEncode(data.toJson())
        
        );

  //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getAllFollowing() async {
  http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  try {
    response = await http.get(
        Uri.parse('$baseUrl/public/api/user/following'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
           HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

   // log(response.body.toString());
  } catch (e) {
    response = null;

  }
  return response;
}

Future<http.Response?> getAllFollowers() async {
  http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  try {
    response = await http.get(
        Uri.parse('$baseUrl/public/api/user/followers'),
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


Future<http.Response?> likeOrDislike(int postId, ) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  try {
    response = await http.post(
        Uri.parse(
            '$baseUrl/public/api/post/$postId/like_unlike'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
     //   body: jsonEncode(data.toJson())
        
        );

  //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> getAllLikedPost() async {
  http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  try {
    response = await http.get(
        Uri.parse('$baseUrl/public/api/user/liked/posts'),
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

Future<http.Response?> likeComment(int postId,int commentId) async {
  http.Response? response;
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  try {
    response = await http.post(
        Uri.parse(
            '$baseUrl/public/api/post/comment/$commentId/like_unlike'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
     //   body: jsonEncode(data.toJson())
        
        );

  //  log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}


Future<http.Response?> getAllLikedComment() async {
  http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString(tokenKey);
  try {
    response = await http.get(
        Uri.parse('$baseUrl/public/api/user/liked/comments'),
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