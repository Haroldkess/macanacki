import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:macanacki/model/otp_model.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/services/api_url.dart';

Future<http.Response?> verifyOtp(OtpModel data) async {
  http.Response? response;
  try {
    response =
        await http.post(Uri.parse('$baseUrl/public/api/user/email/verify'),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
            body: jsonEncode(data.toJson()));

//    log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}

Future<http.Response?> resendOtp(OtpModel data) async {
  http.Response? response;
  try {
    response = await http.post(
      Uri.parse('$baseUrl/public/api/resend/otp/${data.email}'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    // log(response.body.toString());
    // log(response.statusCode.toString());
  } catch (e) {
    response = null;
  }
  return response;
}
