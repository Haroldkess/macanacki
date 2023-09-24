import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../temps/temps_id.dart';

class GiftCalls {
  static Future<http.Response?> walletBalance() async {
    http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString(tokenKey);
    try {
      response = await http.get(
        Uri.parse('$baseUrl/public/api/v2/user/wallet/fund/balance'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      emitter(response.body.toString());
    } catch (e) {
      response = null;
    }
    return response;
  }

  static Future<http.Response?> giftBalance() async {
    http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString(tokenKey);
    try {
      response = await http.get(
        Uri.parse('$baseUrl/public/api/v2/user/wallet/gift/balance'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      emitter(response.body.toString());
    } catch (e) {
      response = null;
    }
    return response;
  }

  static Future<http.Response?> fundWalletHistory() async {
    http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString(tokenKey);
    try {
      response = await http.get(
        Uri.parse('$baseUrl/public/api/v2/user/wallet/fund/history'),
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

  static Future<http.Response?> myRecievedDiamondsHistory() async {
    http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString(tokenKey);
    try {
      response = await http.get(
        Uri.parse(
            '$baseUrl/public/api/v2/user/wallet/received/diamond/history'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      emitter(response.body.toString());
    } catch (e) {
      response = null;
    }
    return response;
  }

  static Future<http.Response?> transferDiamonds(data) async {
    http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString(tokenKey);
 
    try {
      response = await http.post(
          Uri.parse('$baseUrl/public/api/v2/user/wallet/transfer/diamonds'),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          body: jsonEncode(data));
      emitter(response.statusCode.toString());

      emitter(response.body.toString());
    } catch (e) {
      response = null;
    }
    return response;
  }

  static Future<http.Response?> exchangeRate() async {
    http.Response? response;
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString(tokenKey);
    try {
      response = await http.get(
        Uri.parse('$baseUrl/public/api/exchange/rate/NGN'),
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
}
