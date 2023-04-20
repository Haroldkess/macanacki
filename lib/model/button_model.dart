// To parse this JSON data, do
//
//     final buttonModel = buttonModelFromJson(jsonString);

import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';

ButtonModel buttonModelFromJson(String str) =>
    ButtonModel.fromJson(json.decode(str));

String buttonModelToJson(ButtonModel data) => json.encode(data.toJson());

class ButtonModel {
  ButtonModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<ButtonData>? data;

  factory ButtonModel.fromJson(Map<String, dynamic> json) => ButtonModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ButtonData>.from(
                json["data"]!.map((x) => ButtonData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ButtonData {
  ButtonData({
    this.id,
    this.name,
    this.urlPhone,
    this.link,
    this.apendLink,
    this.createdAt,
    this.updatedAt,
    this.key,
  });

  int? id;
  String? name;
  String? urlPhone;
  int? link;
  String? apendLink;
  DateTime? createdAt;
  DateTime? updatedAt;
   GlobalKey<ExpansionTileCardState>? key = GlobalKey();
  

  factory ButtonData.fromJson(Map<String, dynamic> json) => ButtonData(
        id: json["id"],
        name: json["name"],
        urlPhone: json["url_phone"],
        link: json["link"],
        apendLink: json["apend_link"],
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
        "url_phone": urlPhone,
        "link": link,
        "apend_link": apendLink,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
