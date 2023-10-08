// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
  bool? status;
  String? message;
  List<Bank>? data;

  BankModel({
    this.status,
    this.message,
    this.data,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Bank>.from(json["data"]!.map((x) => Bank.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Bank {
  int? id;
  String? name;
  String? shortName;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Bank({
    this.id,
    this.name,
    this.shortName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["id"],
        name: json["name"],
        shortName: json["short_name"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_name": shortName,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class LocalBankModel {
  String? id;
  String? name;
  String? accountNumber;
  String? bankName;

  LocalBankModel({this.id, this.name, this.accountNumber, this.bankName});

  factory LocalBankModel.fromJson(Map<String, dynamic> json) => LocalBankModel(
        id: json["bank_id"],
        name: json["account_name"],
        accountNumber: json["account_number"],
        bankName: json["bank_name"],
      
      );

  Map<String, dynamic> toJson() => {
        "bank_id": id,
        "account_name": name,
        "account_number": accountNumber,
        "bank_name": bankName,
      };
}
