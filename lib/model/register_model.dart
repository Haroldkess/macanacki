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
  String? country;
  String? state;
  String? city;
  String? catId;

  RegisterUserModel({
    this.username,
    this.genderId,
    this.dob,
    this.email,
    this.password,
    this.photo,
    this.catId,
    this.country,
    this.state,
    this.city
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

class VerifyUserModel {
  File? photo;
  String? name;
  String? idType;
  String? idNumb;
  String? address;

  VerifyUserModel({
    this.name,
    this.idNumb,
    this.idType,
    this.photo,
    this.address,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "name": name,
        "id_type": idType,
        "id_no": idNumb,
        "photo": await MultipartFile.fromPath('photo', photo!.path,
            filename: basename(photo!.path)),
      };
}
