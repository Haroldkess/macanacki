import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

class RegisterBusinessModel {
  File? evidence;
  String? busName;
  int? genderId;
  String? phone;
  String? email;
  String? description;
  String? address;
  String? businessAddress;
  String? regNo;
  String? country;
  String? isReg;
  File? photo;
  String? name;
  String? idType;
  String? idNumb;

  RegisterBusinessModel(
      {this.busName,
      this.genderId,
      this.address,
      this.email,
      this.country,
      this.evidence,
      this.description,
      this.isReg,
      this.phone,
      this.regNo,
      this.businessAddress,
      this.idNumb,
      this.idType,
      this.name,
      this.photo});

  Future<Map<String, dynamic>> toJson() async => {
        "name": name,
        "business_name": busName,
        "business_email": email,
        "phone": phone,
        "description": description,
        "is_registered": isReg,
        "country": country,
        "registration_no": regNo,
        "address": address,
        "id_type": idType,
        "id_no": idNumb,
        "photo": phone,
        "evidence": evidence,
        "business_address": businessAddress,
      };
}
