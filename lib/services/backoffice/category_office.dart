import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/api_url.dart';

Future<http.Response?> getCategory() async {
  http.Response? response;
  try {
    response = await http.get(
      Uri.parse('$baseUrl/public/api/category/list'),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );

    //   log(response.body.toString());
  } catch (e) {
    response = null;
  }
  return response;
}
