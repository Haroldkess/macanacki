import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

class RegisterUserModel {
  File? photo;
  String? username;
  int? genderId;
  String? dob;
  String? email;
  String? password;

  RegisterUserModel({
    this.username,
    this.genderId,
    this.dob,
    this.email,
    this.password,
    this.photo,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "email": email,
        "gender_id": genderId,
        "dob": dob,
        "photo": await MultipartFile.fromPath('photo', photo!.path,
            filename: basename(photo!.path)),
        "password": password,
      };
}


